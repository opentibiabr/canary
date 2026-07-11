/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "game/scheduling/monster_compute_service.hpp"
#include "lib/thread/thread_pool.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <limits>
#endif

thread_local DispatcherContext Dispatcher::dispacherContext;

namespace {
	constexpr auto DISPATCHER_QUEUE_LATENCY_LOG_THRESHOLD = std::chrono::milliseconds(250);
	constexpr auto DISPATCHER_TELEMETRY_LOG_INTERVAL = std::chrono::seconds(5);
	constexpr auto DISPATCHER_ADAPTIVE_BUDGET_INTERVAL = std::chrono::milliseconds(250);
	constexpr auto DISPATCHER_TELEMETRY_WARMUP = std::chrono::seconds(1);

	const DispatcherBudgetSet defaultDispatcherBudgets;
	constexpr auto DEFAULT_DISPATCHER_SLO = std::chrono::milliseconds(50);
	constexpr auto DEFAULT_DISPATCHER_EMERGENCY = std::chrono::milliseconds(100);

	size_t getPositiveConfig(const ConfigKey_t key, size_t defaultValue) {
		if (!g_configManager().isLoaded()) {
			return defaultValue;
		}

		return static_cast<size_t>(std::max<int32_t>(1, g_configManager().getNumber(key)));
	}

	DispatcherBudgetSet getConfiguredDispatcherBudgets() {
		const auto defaultSliceDuration = std::chrono::duration_cast<std::chrono::milliseconds>(defaultDispatcherBudgets.sliceRuntime);
		return {
			.creatureWalkTasks = getPositiveConfig(CREATURE_WALK_TASKS_PER_PASS, defaultDispatcherBudgets.creatureWalkTasks),
			.walkParallelTasks = getPositiveConfig(WALK_PARALLEL_TASKS_PER_PASS, defaultDispatcherBudgets.walkParallelTasks),
			.creatureAsyncTasksPerBucket = getPositiveConfig(CREATURE_ASYNC_TASKS_PER_BUCKET, defaultDispatcherBudgets.creatureAsyncTasksPerBucket),
			.deferredGameplayTasks = getPositiveConfig(DEFERRED_GAMEPLAY_TASKS_PER_PASS, defaultDispatcherBudgets.deferredGameplayTasks),
			.workerCompletions = getPositiveConfig(WORKER_COMPLETIONS_PER_PASS, defaultDispatcherBudgets.workerCompletions),
			.sliceRuntime = std::chrono::milliseconds(getPositiveConfig(DISPATCHER_SLICE_DURATION_MS, static_cast<size_t>(defaultSliceDuration.count()))),
		};
	}

	std::string_view getDispatcherLoadStateName(DispatcherLoadState state) {
		switch (state) {
			case DispatcherLoadState::Normal:
				return "normal";
			case DispatcherLoadState::Constrained:
				return "constrained";
			case DispatcherLoadState::Emergency:
				return "emergency";
		}
		return "unknown";
	}

	std::string_view getDispatcherLaneName(const DispatcherLane lane) {
		switch (lane) {
			case DispatcherLane::ProtocolInput:
				return "ProtocolInput";
			case DispatcherLane::PlayerWalk:
				return "PlayerWalk";
			case DispatcherLane::PlayerAction:
				return "PlayerAction";
			case DispatcherLane::WorldCommit:
				return "WorldCommit";
			case DispatcherLane::WorkerCompletion:
				return "WorkerCompletion";
			case DispatcherLane::VisibleMonster:
				return "VisibleMonster";
			case DispatcherLane::BackgroundMonster:
				return "BackgroundMonster";
			case DispatcherLane::VisibleMonsterAI:
				return "VisibleMonsterAI";
			case DispatcherLane::MonsterAI:
				return "MonsterAI";
			case DispatcherLane::Deferred:
				return "Deferred";
			case DispatcherLane::Maintenance:
				return "Maintenance";
			case DispatcherLane::GenericParallel:
				return "GenericParallel";
			case DispatcherLane::Last:
				break;
		}
		return "Unknown";
	}

	std::string_view getInternalWorkName(const uint8_t workId) {
		switch (static_cast<DispatcherInternalWork>(workId)) {
			case DispatcherInternalWork::CreatureAsyncBucket:
				return "CreatureAsyncBucket";
			case DispatcherInternalWork::CreatureAsyncRequeue:
				return "CreatureAsyncRequeue";
			case DispatcherInternalWork::MonsterMovementRefreshLateness:
				return "MonsterMovementRefreshLateness";
			case DispatcherInternalWork::MonsterPostThinkLateness:
				return "MonsterPostThinkLateness";
			case DispatcherInternalWork::WorkerCompletionBatch:
				return "WorkerCompletionBatch";
			case DispatcherInternalWork::DispatcherPass:
				return "DispatcherPass";
			case DispatcherInternalWork::DispatcherIdle:
				return "DispatcherIdle";
			default:
				return "Unknown";
		}
	}
}

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::init() {
	UPDATE_OTSYS_TIME();
	g_monsterComputeService().setCompletionNotifier([this] { notify(); });
	g_configManager().deferUntilLoaded([this] { notify(); });

	auto dispatcherStarted = std::make_shared<std::promise<void>>();
	auto futureStarted = dispatcherStarted->get_future();

	threadPool.detach_task([this, dispatcherStarted]() mutable {
		std::unique_lock asyncLock(dummyMutex);

		dispatcherStarted->set_value();

		while (!threadPool.isStopped() && !shuttingDown.load(std::memory_order_acquire)) {
			UPDATE_OTSYS_TIME();
			const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
			const auto passStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};

			mergeEvents();
			promoteScheduledEvents();
			refreshAdaptiveBudgets();
			executeReadyEvents();
			mergeEvents();
			promoteScheduledEvents();
			checkPendingTasks();
			if (telemetryEnabled) {
				observeInternalWork(DispatcherInternalWork::DispatcherPass, 1, policy.elapsedSince(passStartedAt));
			}
			logRuntimeTelemetry();

			if (!hasPendingTasks) {
				const auto idleStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
				signalSchedule.wait_for(asyncLock, timeUntilNextScheduledTask(), [this] {
					return hasPendingTasks.load(std::memory_order_acquire) || shuttingDown.load(std::memory_order_acquire) || threadPool.isStopped();
				});
				if (telemetryEnabled) {
					observeInternalWork(DispatcherInternalWork::DispatcherIdle, 1, policy.elapsedSince(idleStartedAt));
				}
			}
		}
	});

	if (futureStarted.wait_for(std::chrono::seconds(5)) != std::future_status::ready) {
		throw std::logic_error("Failed to initialize dispatcher: timeout waiting for thread start");
	}
}

Dispatcher::LaneExecutionResult Dispatcher::executeSerialLane(DispatcherLane lane, size_t maxTasks, uint32_t maxCost, std::chrono::microseconds maxRuntime) {
	const auto laneId = static_cast<size_t>(lane);
	auto &tasks = m_tasks[laneId];
	LaneExecutionResult result;
	if (tasks.empty() || maxTasks == 0 || maxCost == 0) {
		return result;
	}

	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	const auto hasRuntimeBudget = maxRuntime != std::chrono::microseconds::max();
	const auto laneStartedAt = telemetryEnabled || hasRuntimeBudget ? policy.now() : Task::Clock::time_point {};
	const auto deadline = hasRuntimeBudget ? laneStartedAt + maxRuntime : Task::Clock::time_point::max();
	logQueueLatency(lane);
	dispacherContext.type = DispatcherType::Event;

	while (!tasks.empty() && result.tasks < maxTasks) {
		if (result.tasks > 0 && hasRuntimeBudget && policy.deadlineReached(deadline)) {
			break;
		}

		const size_t taskIndex = usesProducerFairness(lane) ? DispatcherPolicy::selectProducerFairIndex(tasks, lastProducerTokens[laneId]) : 0;
		const auto taskCost = std::clamp<uint32_t>(tasks[taskIndex].getMeta().estimatedCost, 1, DISPATCHER_MAX_TASK_COST);
		if (taskCost > maxCost - result.cost) {
			break;
		}

		dispacherContext.taskName = tasks[taskIndex].getContext();
		dispacherContext.type = DispatcherType::Event;
		lastProducerTokens[laneId] = tasks[taskIndex].getMeta().producerToken;
		releaseDispatcherSlot(tasks[taskIndex]);
		if (executeTask(tasks[taskIndex], lane)) {
			++dispatcherCycle;
		}
		if (taskIndex == 0) {
			tasks.pop_front();
		} else {
			tasks.erase(tasks.begin() + static_cast<std::ptrdiff_t>(taskIndex));
		}
		++result.tasks;
		result.cost += taskCost;
	}

	if (telemetryEnabled) {
		laneTelemetry[laneId].groupRuntime.observe(policy.elapsedSince(laneStartedAt), result.tasks);
	}
	if (hasRuntimeBudget) {
		result.runtime = policy.elapsedSince(laneStartedAt);
	}
	dispacherContext.reset();
	return result;
}

Dispatcher::LaneExecutionResult Dispatcher::executeBarrierLane(DispatcherLane lane, size_t maxTasks, uint32_t maxCost) {
	const auto laneId = static_cast<size_t>(lane);
	auto &tasks = m_tasks[laneId];
	LaneExecutionResult result;
	if (tasks.empty() || maxTasks == 0 || maxCost == 0) {
		return result;
	}

	while (result.tasks < tasks.size() && result.tasks < maxTasks) {
		const auto taskCost = std::clamp<uint32_t>(tasks[result.tasks].getMeta().estimatedCost, 1, DISPATCHER_MAX_TASK_COST);
		if (taskCost > maxCost - result.cost) {
			break;
		}
		result.cost += taskCost;
		++result.tasks;
	}
	if (result.tasks == 0) {
		return result;
	}

	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	const auto laneStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
	logQueueLatency(lane);
	const auto barrierStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
	for (size_t index = 0; index < result.tasks; ++index) {
		releaseDispatcherSlot(tasks[index]);
	}
	asyncWait(result.tasks, [this, lane, &tasks](size_t index) {
		dispacherContext.type = DispatcherType::AsyncEvent;
		dispacherContext.taskName = tasks[index].getContext();
		executeTask(tasks[index], lane);
		dispacherContext.reset();
	});
	if (telemetryEnabled) {
		laneTelemetry[laneId].barrierRuntime.observe(policy.elapsedSince(barrierStartedAt), result.tasks);
		laneTelemetry[laneId].groupRuntime.observe(policy.elapsedSince(laneStartedAt), result.tasks);
	}
	tasks.erase(tasks.begin(), tasks.begin() + static_cast<std::ptrdiff_t>(result.tasks));
	return result;
}

Dispatcher::LaneExecutionResult Dispatcher::executeWorkerCompletionLane(size_t maxTasks, uint32_t maxCost) {
	LaneExecutionResult result;
	if (maxTasks == 0 || maxCost == 0) {
		return result;
	}

	auto &computeService = g_monsterComputeService();
	dispacherContext.type = DispatcherType::WorkerCompletion;
	dispacherContext.lane = DispatcherLane::WorkerCompletion;
	dispacherContext.executionMode = ExecutionMode::BackgroundCompletion;
	const auto startedAt = policy.now();
	const auto taskLimit = std::min<size_t>({ maxTasks, maxCost, computeService.getCompletionCount() });
	result.tasks = computeService.drainCompletions(
		taskLimit,
		[](std::string_view context, MonsterComputeService::Completion &completion) {
			dispacherContext.taskName = context;
			if (completion) {
				completion();
			}
		}
	);
	result.cost = static_cast<uint32_t>(result.tasks);
	observeInternalWork(DispatcherInternalWork::WorkerCompletionBatch, result.tasks, policy.elapsedSince(startedAt));
	dispatcherCycle += result.tasks;
	dispacherContext.reset();
	return result;
}

bool Dispatcher::executeTask(const Task &task, DispatcherLane lane) {
	dispacherContext.lane = task.getMeta().lane;
	dispacherContext.executionMode = task.getMeta().executionMode;
	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	if (!telemetryEnabled) {
		return task.execute();
	}

	const auto startedAt = policy.now();
	observeTaskStart(task, lane, startedAt);
	const auto executed = task.execute();
	if (telemetryEnabled) {
		laneTelemetry[static_cast<size_t>(lane)].taskRuntime.observe(policy.elapsedSince(startedAt), 1, task.getContext());
	}
	return executed;
}

void Dispatcher::observeTaskStart(const Task &task, DispatcherLane lane, Task::Clock::time_point startedAt) {
	const auto queueWait = DispatcherPolicy::elapsed(task.getReadyAt(), startedAt);
	const auto loggingStartedAt = DispatcherPolicy::fromTimestamp(queueLatencyLoggingStartedAt.load(std::memory_order_relaxed));
	if (isPlayerVisible(task.getMeta().lane) && task.getEnqueuedAt() >= loggingStartedAt) {
		playerVisibleReadyLatency.observe(queueWait);
	}

	if (queueLatencyLoggingEnabled.load(std::memory_order_relaxed)) {
		laneTelemetry[static_cast<size_t>(lane)].queueWait.observe(queueWait, 1, task.getContext());
	}
}

void Dispatcher::logQueueLatency(DispatcherLane lane) const {
	static std::array<Task::Clock::time_point, static_cast<size_t>(DispatcherLane::Last)> nextLogAt {};
	static std::array<Task::Clock::time_point, static_cast<size_t>(DispatcherLane::Last)> nextProbeAt {};
	const auto laneId = static_cast<size_t>(lane);

	const auto &tasks = m_tasks[laneId];
	if (tasks.empty()) {
		return;
	}

	if (!queueLatencyLoggingEnabled.load(std::memory_order_acquire)) {
		return;
	}

	const auto gameState = g_game().getGameState();
	if (gameState != GAME_STATE_NORMAL) {
		return;
	}

	const auto now = policy.now();
	if (now < nextLogAt[laneId] || now < nextProbeAt[laneId]) {
		return;
	}
	nextProbeAt[laneId] = now + DISPATCHER_ADAPTIVE_BUDGET_INTERVAL;

	const auto loggingStartedAt = DispatcherPolicy::fromTimestamp(queueLatencyLoggingStartedAt.load(std::memory_order_relaxed));
	const auto snapshot = DispatcherPolicy::inspectQueueAt(tasks, now, loggingStartedAt);
	if (snapshot.queued == 0 || snapshot.oldestReadyAge < DISPATCHER_QUEUE_LATENCY_LOG_THRESHOLD) {
		return;
	}

	nextLogAt[laneId] = now + DISPATCHER_TELEMETRY_LOG_INTERVAL;
	g_logger().warn(
		"Dispatcher queue latency: lane={}, queued={}, oldest={} ms, oldestContext={}",
		getDispatcherLaneName(lane),
		snapshot.queued,
		std::chrono::duration_cast<std::chrono::milliseconds>(snapshot.oldestReadyAge).count(),
		snapshot.oldestContext
	);
}

void Dispatcher::setQueueLatencyLoggingEnabled(const bool enabled) {
	if (!enabled) {
		queueLatencyLoggingEnabled.store(false, std::memory_order_release);
		queueLatencyLoggingStartedAt.store(0, std::memory_order_relaxed);
		resetRuntimeTelemetry();
		return;
	}

	resetRuntimeTelemetry();
	queueLatencyLoggingStartedAt.store(DispatcherPolicy::timestamp(policy.now() + DISPATCHER_TELEMETRY_WARMUP), std::memory_order_relaxed);
	queueLatencyLoggingEnabled.store(true, std::memory_order_release);
}

void Dispatcher::observeInternalWork(DispatcherInternalWork work, uint64_t units, std::chrono::microseconds runtime, std::string_view context) noexcept {
	if (!queueLatencyLoggingEnabled.load(std::memory_order_relaxed)) {
		return;
	}

	const auto workId = static_cast<uint8_t>(work);
	if (workId >= internalWorkTelemetry.size()) {
		return;
	}
	internalWorkTelemetry[workId].observe(runtime, units, context);
}

void Dispatcher::logRuntimeTelemetry() {
	static Task::Clock::time_point nextLogAt {};

	if (!queueLatencyLoggingEnabled.load(std::memory_order_acquire) || g_game().getGameState() != GAME_STATE_NORMAL) {
		return;
	}

	const auto now = policy.now();
	if (now < nextLogAt) {
		return;
	}
	nextLogAt = now + DISPATCHER_TELEMETRY_LOG_INTERVAL;

	for (size_t laneId = 0; laneId < laneTelemetry.size(); ++laneId) {
		auto &telemetry = laneTelemetry[laneId];
		const auto queue = telemetry.queueWait.snapshotAndReset();
		const auto task = telemetry.taskRuntime.snapshotAndReset();
		const auto group = telemetry.groupRuntime.snapshotAndReset();
		const auto barrier = telemetry.barrierRuntime.snapshotAndReset();
		if (queue.empty() && task.empty() && group.empty() && barrier.empty()) {
			continue;
		}
		const auto longestTaskContext = task.longestContext.empty() ? std::string_view { "none" } : std::string_view { task.longestContext };

		g_logger().debug(
			"Dispatcher telemetry: lane={}, queued={}, rejected={}, queueSamples={}, queueP50={} us, queueP95={} us, queueP99={} us, taskSamples={}, taskP50={} us, taskP95={} us, taskP99={} us, laneP99={} us, barrierP99={} us, longestTask={} us, longestTaskContext={}",
			getDispatcherLaneName(static_cast<DispatcherLane>(laneId)),
			reservedLaneSlots[laneId].size(),
			rejectedLaneTasks[laneId].load(std::memory_order_relaxed),
			queue.latency.samples,
			queue.latency.percentile(0.50).count(),
			queue.latency.percentile(0.95).count(),
			queue.latency.percentile(0.99).count(),
			task.latency.samples,
			task.latency.percentile(0.50).count(),
			task.latency.percentile(0.95).count(),
			task.latency.percentile(0.99).count(),
			group.latency.percentile(0.99).count(),
			barrier.latency.percentile(0.99).count(),
			task.longestDuration.count(),
			longestTaskContext
		);
	}

	const auto scheduled = scheduledLatenessTelemetry.snapshotAndReset();
	if (!scheduled.empty()) {
		const auto latestContext = scheduled.longestContext.empty() ? std::string_view { "none" } : std::string_view { scheduled.longestContext };
		g_logger().debug(
			"Dispatcher scheduled telemetry: samples={}, latenessP50={} us, latenessP95={} us, latenessP99={} us, maxLateness={} us, latestContext={}",
			scheduled.latency.samples,
			scheduled.latency.percentile(0.50).count(),
			scheduled.latency.percentile(0.95).count(),
			scheduled.latency.percentile(0.99).count(),
			scheduled.latency.maxUs,
			latestContext
		);
	}

	for (uint8_t workId = 0; workId < internalWorkTelemetry.size(); ++workId) {
		const auto work = internalWorkTelemetry[workId].snapshotAndReset();
		if (work.empty()) {
			continue;
		}

		g_logger().debug(
			"Dispatcher internal telemetry: work={}, samples={}, units={}, runtimeP50={} us, runtimeP95={} us, runtimeP99={} us, maxRuntime={} us",
			getInternalWorkName(workId),
			work.latency.samples,
			work.workUnits,
			work.latency.percentile(0.50).count(),
			work.latency.percentile(0.95).count(),
			work.latency.percentile(0.99).count(),
			work.latency.maxUs
		);
	}

	const auto computeStats = g_monsterComputeService().getStats();
	if (computeStats.running) {
		g_logger().debug(
			"Monster compute telemetry: visibleQueued={}, backgroundQueued={}, visibleCompletions={}, backgroundCompletions={}, oldestVisibleCompletion={} us, oldestBackgroundCompletion={} us, visibleOutstanding={}, backgroundOutstanding={}, outstanding={}, active={}, completionsInFlight={}, capacity={}, visibleReserve={}, accepted={}, rejected={}, completed={}, failed={}, canceled={}",
			computeStats.visibleQueued,
			computeStats.backgroundQueued,
			computeStats.visibleCompletionsQueued,
			computeStats.backgroundCompletionsQueued,
			computeStats.oldestVisibleCompletionReadyAge.count(),
			computeStats.oldestBackgroundCompletionReadyAge.count(),
			computeStats.visibleOutstanding,
			computeStats.backgroundOutstanding,
			computeStats.outstanding,
			computeStats.active,
			computeStats.completionsInFlight,
			computeStats.capacity,
			computeStats.visibleReserve,
			computeStats.accepted,
			computeStats.rejected,
			computeStats.completed,
			computeStats.failed,
			computeStats.canceled
		);
	}
}

void Dispatcher::resetRuntimeTelemetry() {
	for (auto &telemetry : laneTelemetry) {
		telemetry.queueWait.reset();
		telemetry.taskRuntime.reset();
		telemetry.groupRuntime.reset();
		telemetry.barrierRuntime.reset();
	}

	for (auto &telemetry : internalWorkTelemetry) {
		telemetry.reset();
	}
	scheduledLatenessTelemetry.reset();
	playerVisibleReadyLatency.reset();
}

std::chrono::microseconds Dispatcher::oldestPlayerVisibleReadyAge(Task::Clock::time_point now) const {
	const auto loggingStartedAt = DispatcherPolicy::fromTimestamp(queueLatencyLoggingStartedAt.load(std::memory_order_relaxed));
	std::chrono::microseconds oldest = std::chrono::microseconds::zero();
	for (const auto &tasks : m_tasks) {
		oldest = std::max(oldest, DispatcherPolicy::inspectPlayerVisibleQueueAt(tasks, now, loggingStartedAt).oldestReadyAge);
	}
	for (const auto &task : scheduledTasks) {
		if (task && task->getEnqueuedAt() >= loggingStartedAt && isPlayerVisible(task->getMeta().lane)) {
			oldest = std::max(oldest, DispatcherPolicy::elapsed(task->getReadyAt(), now));
		}
	}
	oldest = std::max(oldest, g_monsterComputeService().getStats().oldestVisibleCompletionReadyAge);
	return oldest;
}

void Dispatcher::refreshAdaptiveBudgets() {
	if (!queueLatencyLoggingEnabled.load(std::memory_order_acquire) || g_game().getGameState() != GAME_STATE_NORMAL) {
		return;
	}

	const auto now = policy.now();
	if (now < nextAdaptiveBudgetUpdateAt) {
		return;
	}
	nextAdaptiveBudgetUpdateAt = now + DISPATCHER_ADAPTIVE_BUDGET_INTERVAL;

	const auto visibleWindow = playerVisibleReadyLatency.snapshotAndReset();
	const auto configured = getConfiguredDispatcherBudgets();
	configuredBudgets = configured;
	const auto visibleP99 = visibleWindow.percentile(0.99);
	const auto oldestVisibleReadyAge = oldestPlayerVisibleReadyAge(now);
	const auto decision = adaptiveBudgetController.update(
		configured,
		visibleP99,
		oldestVisibleReadyAge,
		std::chrono::milliseconds(getPositiveConfig(DISPATCHER_SLO_MS, DEFAULT_DISPATCHER_SLO.count())),
		std::chrono::milliseconds(getPositiveConfig(DISPATCHER_EMERGENCY_MS, DEFAULT_DISPATCHER_EMERGENCY.count()))
	);
	activeBudgets = decision.budgets;

	const auto packCreatureLimits = [](const DispatcherBudgetSet &budgets) {
		const auto tasksPerBucket = std::min<size_t>(budgets.creatureAsyncTasksPerBucket, std::numeric_limits<uint32_t>::max());
		const auto maxRuntimeUs = std::min<int64_t>(budgets.sliceRuntime.count(), std::numeric_limits<uint32_t>::max());
		return (static_cast<uint64_t>(tasksPerBucket) << 32) | static_cast<uint32_t>(maxRuntimeUs);
	};
	visibleCreatureAsyncSliceLimits.store(packCreatureLimits(configuredBudgets), std::memory_order_relaxed);
	backgroundCreatureAsyncSliceLimits.store(packCreatureLimits(activeBudgets), std::memory_order_relaxed);

	if (!decision.stateChanged) {
		return;
	}
	const auto stateName = getDispatcherLoadStateName(decision.state);
	if (decision.state == DispatcherLoadState::Emergency) {
		g_logger().warn(
			"Dispatcher adaptive budgets: state={}, controlLatency={} us, visibleP99={} us, oldestVisible={} us, backgroundCreatureWalk={}, backgroundParallel={}, backgroundCreatureBucket={}, deferred={}, completions={}, slice={} us",
			stateName,
			decision.controlLatency.count(),
			visibleP99.count(),
			oldestVisibleReadyAge.count(),
			activeBudgets.creatureWalkTasks,
			activeBudgets.walkParallelTasks,
			activeBudgets.creatureAsyncTasksPerBucket,
			activeBudgets.deferredGameplayTasks,
			activeBudgets.workerCompletions,
			activeBudgets.sliceRuntime.count()
		);
	} else {
		g_logger().debug(
			"Dispatcher adaptive budgets: state={}, controlLatency={} us, visibleP99={} us, oldestVisible={} us, backgroundCreatureWalk={}, backgroundParallel={}, backgroundCreatureBucket={}, deferred={}, completions={}, slice={} us",
			stateName,
			decision.controlLatency.count(),
			visibleP99.count(),
			oldestVisibleReadyAge.count(),
			activeBudgets.creatureWalkTasks,
			activeBudgets.walkParallelTasks,
			activeBudgets.creatureAsyncTasksPerBucket,
			activeBudgets.deferredGameplayTasks,
			activeBudgets.workerCompletions,
			activeBudgets.sliceRuntime.count()
		);
	}
}

void Dispatcher::asyncWait(size_t requestSize, std::function<void(size_t i)> &&f) {
	if (requestSize == 0) {
		return;
	}

	// This prevents an async call from running inside another async call.
	if (asyncWaitDisabled) {
		for (uint_fast64_t i = 0; i < requestSize; ++i) {
			f(i);
		}
		return;
	}

	const auto &partitions = generatePartition(requestSize);
	const auto pSize = partitions.size();

	BS::multi_future<void> retFuture;

	if (pSize > 1) {
		asyncWaitDisabled = true;
		const auto min = partitions[1].first;
		const auto max = partitions[partitions.size() - 1].second;
		retFuture = threadPool.submit_loop(min, max, [&f](const unsigned int i) { f(i); });
	}

	const auto &[min, max] = partitions[0];
	for (uint_fast64_t i = min; i < max; ++i) {
		f(i);
	}

	if (pSize > 1) {
		retFuture.wait();
		asyncWaitDisabled = false;
	}
}

size_t Dispatcher::laneTaskBudget(DispatcherLane lane) const {
	switch (lane) {
		case DispatcherLane::ProtocolInput:
		case DispatcherLane::PlayerWalk:
		case DispatcherLane::PlayerAction:
		case DispatcherLane::WorldCommit:
			return 256;
		case DispatcherLane::WorkerCompletion:
			return activeBudgets.workerCompletions;
		case DispatcherLane::VisibleMonster:
			return configuredBudgets.creatureWalkTasks;
		case DispatcherLane::BackgroundMonster:
			return activeBudgets.creatureWalkTasks;
		case DispatcherLane::VisibleMonsterAI:
			return configuredBudgets.walkParallelTasks;
		case DispatcherLane::MonsterAI:
		case DispatcherLane::GenericParallel:
			return activeBudgets.walkParallelTasks;
		case DispatcherLane::Deferred:
			return activeBudgets.deferredGameplayTasks;
		case DispatcherLane::Maintenance:
			return 16;
		case DispatcherLane::Last:
			return 0;
	}
	return 1;
}

uint32_t Dispatcher::laneQuantum(DispatcherLane lane) const {
	switch (lane) {
		case DispatcherLane::ProtocolInput:
		case DispatcherLane::PlayerWalk:
			return 8;
		case DispatcherLane::PlayerAction:
		case DispatcherLane::WorldCommit:
			return 6;
		case DispatcherLane::WorkerCompletion:
		case DispatcherLane::VisibleMonster:
		case DispatcherLane::VisibleMonsterAI:
			return 4;
		case DispatcherLane::BackgroundMonster:
			return 1;
		case DispatcherLane::MonsterAI:
		case DispatcherLane::Deferred:
			return 2;
		case DispatcherLane::Maintenance:
		case DispatcherLane::GenericParallel:
			return 1;
		case DispatcherLane::Last:
			return 0;
	}
	return 1;
}

bool Dispatcher::tryReserveLaneSlot(DispatcherLane lane, size_t capacity) {
	const auto laneId = static_cast<size_t>(lane);
	if (laneId >= reservedLaneSlots.size() || lane == DispatcherLane::WorkerCompletion) {
		observeLaneRejection(laneId < reservedLaneSlots.size() ? lane : DispatcherLane::Maintenance, capacity);
		return false;
	}

	if (reservedLaneSlots[laneId].tryReserve(capacity)) {
		return true;
	}

	observeLaneRejection(lane, capacity);
	return false;
}

void Dispatcher::adoptReservedLaneSlot(Task &task, DispatcherLane lane) {
	task.dispatcherSlotReserved = true;
	task.reservedLane = lane;
}

void Dispatcher::releaseLaneSlot(DispatcherLane lane) {
	const auto laneId = static_cast<size_t>(lane);
	if (laneId >= reservedLaneSlots.size()) {
		return;
	}

	const bool released = reservedLaneSlots[laneId].release();
	assert(released);
	(void)released;
}

bool Dispatcher::reserveDispatcherSlot(Task &task) {
	if (task.dispatcherSlotReserved) {
		observeLaneRejection(task.getMeta().lane);
		return false;
	}

	const auto lane = task.getMeta().lane;
	if (!tryReserveLaneSlot(lane)) {
		return false;
	}
	adoptReservedLaneSlot(task, lane);
	return true;
}

void Dispatcher::releaseDispatcherSlot(Task &task) {
	if (!task.dispatcherSlotReserved) {
		return;
	}

	const auto laneId = static_cast<size_t>(task.reservedLane);
	task.dispatcherSlotReserved = false;
	if (laneId >= reservedLaneSlots.size()) {
		return;
	}
	releaseLaneSlot(static_cast<DispatcherLane>(laneId));
}

void Dispatcher::observeLaneRejection(DispatcherLane lane, size_t capacity) {
	const auto laneId = static_cast<size_t>(lane);
	if (laneId >= rejectedLaneTasks.size()) {
		return;
	}

	const auto rejected = rejectedLaneTasks[laneId].fetch_add(1, std::memory_order_relaxed) + 1;
	if (rejected == 1 || (rejected & (rejected - 1)) == 0) {
		g_logger().warn(
			"Dispatcher lane admission rejected: lane={}, capacity={}, queued={}, rejected={}",
			getDispatcherLaneName(lane),
			capacity,
			reservedLaneSlots[laneId].size(),
			rejected
		);
	}
}

void Dispatcher::executeReadyEvents() {
	constexpr size_t laneCount = DispatcherWeightedDeficitRoundRobin::LANE_COUNT;
	std::array<size_t, laneCount> tasksExecuted {};
	std::array<bool, laneCount> exhausted {};
	std::array<std::chrono::microseconds, laneCount> nextReadyAge {};
	std::array<std::chrono::microseconds, laneCount> serialRuntime {};
	const auto now = policy.now();
	const auto slo = std::chrono::milliseconds(getPositiveConfig(DISPATCHER_SLO_MS, DEFAULT_DISPATCHER_SLO.count()));
	size_t remainingPassTasks = 0;
	for (size_t laneId = 0; laneId < laneCount; ++laneId) {
		const auto lane = static_cast<DispatcherLane>(laneId);
		const auto &tasks = m_tasks[laneId];
		if (!tasks.empty()) {
			const auto candidateIndex = usesProducerFairness(lane) ? DispatcherPolicy::selectProducerFairIndex(tasks, lastProducerTokens[laneId]) : 0;
			nextReadyAge[laneId] = DispatcherPolicy::elapsed(tasks[candidateIndex].getReadyAt(), now);
		}
		const auto budget = laneTaskBudget(lane);
		remainingPassTasks += std::min(budget, std::numeric_limits<size_t>::max() - remainingPassTasks);
	}
	nextReadyAge[static_cast<size_t>(DispatcherLane::WorkerCompletion)] = g_monsterComputeService().getStats().oldestCompletionReadyAge;

	while (remainingPassTasks > 0) {
		DispatcherWeightedDeficitRoundRobin::ReadySet ready {};
		DispatcherWeightedDeficitRoundRobin::ValueSet quantums {};
		DispatcherWeightedDeficitRoundRobin::ValueSet nextCosts {};
		std::array<size_t, laneCount> candidateIndices {};
		for (size_t laneId = 0; laneId < laneCount; ++laneId) {
			const auto lane = static_cast<DispatcherLane>(laneId);
			const auto budget = laneTaskBudget(lane);
			if (exhausted[laneId] || tasksExecuted[laneId] >= budget) {
				continue;
			}

			if (lane == DispatcherLane::WorkerCompletion) {
				ready[laneId] = g_monsterComputeService().getCompletionCount() > 0;
				nextCosts[laneId] = 1;
			} else if (!m_tasks[laneId].empty()) {
				candidateIndices[laneId] = usesProducerFairness(lane) ? DispatcherPolicy::selectProducerFairIndex(m_tasks[laneId], lastProducerTokens[laneId]) : 0;
				ready[laneId] = true;
				nextCosts[laneId] = std::clamp<uint32_t>(m_tasks[laneId][candidateIndices[laneId]].getMeta().estimatedCost, 1, DISPATCHER_MAX_TASK_COST);
			}
			quantums[laneId] = DispatcherWeightedDeficitRoundRobin::agedQuantum(
				laneQuantum(lane),
				nextReadyAge[laneId],
				slo
			);
		}

		const auto selectedLane = weightedScheduler.selectLane(ready, quantums, nextCosts);
		if (!selectedLane) {
			break;
		}
		const auto lane = *selectedLane;
		const auto laneId = static_cast<size_t>(lane);
		const auto remainingTasks = laneTaskBudget(lane) - tasksExecuted[laneId];
		const auto availableCost = weightedScheduler.getDeficit(lane);

		LaneExecutionResult result;
		if (lane == DispatcherLane::WorkerCompletion) {
			result = executeWorkerCompletionLane(remainingTasks, availableCost);
		} else if (m_tasks[laneId][candidateIndices[laneId]].getMeta().executionMode == ExecutionMode::BarrierParallel) {
			result = executeBarrierLane(lane, remainingTasks, availableCost);
		} else {
			const auto runtime = isPlayerVisible(lane) ? std::chrono::microseconds::max() : activeBudgets.sliceRuntime - std::min(activeBudgets.sliceRuntime, serialRuntime[laneId]);
			result = executeSerialLane(lane, remainingTasks, availableCost, runtime);
			serialRuntime[laneId] += result.runtime;
		}

		if (result.tasks == 0 || result.cost == 0) {
			exhausted[laneId] = true;
			weightedScheduler.resetLane(lane);
			continue;
		}
		tasksExecuted[laneId] += result.tasks;
		remainingPassTasks -= std::min(remainingPassTasks, result.tasks);
		weightedScheduler.consume(lane, result.cost);
		if (!isPlayerVisible(lane) && serialRuntime[laneId] >= activeBudgets.sliceRuntime) {
			exhausted[laneId] = true;
			weightedScheduler.resetLane(lane);
		}
		mergeEvents();
	}
}

void Dispatcher::promoteScheduledEvents() {
	auto it = scheduledTasks.begin();
	while (it != scheduledTasks.end()) {
		const auto task = *it;
		if (task->getTime() > OTSYS_TIME()) {
			break;
		}

		Task readyTask(
			0, [this, task] { executeScheduledTask(task); }, task->getContext(), task->getReadyAt()
		);
		const auto requestedLaneId = static_cast<size_t>(task->getMeta().lane);
		const auto lane = requestedLaneId < m_tasks.size() ? task->getMeta().lane : DispatcherLane::Maintenance;
		readyTask.setLane(lane);
		readyTask.setExecutionMode(task->getMeta().executionMode);
		readyTask.setProducerToken(task->getMeta().producerToken);
		readyTask.setGeneration(task->getMeta().generation);
		readyTask.setEstimatedCost(task->getMeta().estimatedCost);
		readyTask.log = task->log;
		m_tasks[static_cast<size_t>(lane)].emplace_back(std::move(readyTask));
		++it;
	}
	if (it != scheduledTasks.begin()) {
		scheduledTasks.erase(scheduledTasks.begin(), it);
	}
}

void Dispatcher::executeScheduledTask(const std::shared_ptr<Task> &task) {
	const auto startedAt = policy.now();
	const auto lateness = DispatcherPolicy::elapsed(task->getReadyAt(), startedAt);
	if (queueLatencyLoggingEnabled.load(std::memory_order_relaxed)) {
		scheduledLatenessTelemetry.observe(lateness, 1, task->getContext());
	}

	const bool cycle = task->isCycle();
	if (!cycle) {
		// A one-shot event no longer occupies admission while its callback queues
		// a successor. This lets bounded recurring chains replace themselves even
		// when their lane is exactly at capacity.
		scheduledTasksRef.erase(task->getId());
		releaseDispatcherSlot(*task);
	}

	dispacherContext.type = cycle ? DispatcherType::CycleEvent : DispatcherType::ScheduledEvent;
	bool executed = false;
	if (!task->isCanceled()) {
		if (task->hasExpired()) {
			g_logger().info("The task '{}' has expired, it has not been executed in {}.", task->getContext(), task->expiration - task->utime);
		} else {
			task->func();
			executed = true;
		}
	}

	if (executed && cycle && !task->isCanceled()) {
		task->updateTime();
		scheduledTasks.insert(task);
	} else if (cycle) {
		scheduledTasksRef.erase(task->getId());
		releaseDispatcherSlot(*task);
	}
}

void Dispatcher::mergeEvents() {
	if (!hasUnmergedEvents.exchange(false, std::memory_order_acq_rel)) {
		return;
	}

	for (const auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		for (size_t laneId = 0; laneId < m_tasks.size(); ++laneId) {
			auto &threadTasks = thread->tasks[laneId];
			auto &tasks = m_tasks[laneId];
			if (!threadTasks.empty()) {
				tasks.insert(tasks.end(), make_move_iterator(threadTasks.begin()), make_move_iterator(threadTasks.end()));
				threadTasks.clear();
			}
		}

		if (!thread->scheduledTasks.empty()) {
			scheduledTasks.insert(make_move_iterator(thread->scheduledTasks.begin()), make_move_iterator(thread->scheduledTasks.end()));
			thread->scheduledTasks.clear();
		}
	}
}

void Dispatcher::checkPendingTasks() {
	hasPendingTasks.store(false, std::memory_order_release);
	bool pending = g_monsterComputeService().getCompletionCount() > 0;
	for (const auto &tasks : m_tasks) {
		if (!tasks.empty()) {
			pending = true;
			break;
		}
	}
	if (!pending) {
		for (const auto &thread : threads) {
			std::scoped_lock lock(thread->mutex);
			const bool hasThreadTasks = std::ranges::any_of(thread->tasks, [](const auto &tasks) { return !tasks.empty(); });
			if (hasThreadTasks || !thread->scheduledTasks.empty()) {
				pending = true;
				break;
			}
		}
	}
	if (pending) {
		hasPendingTasks.store(true, std::memory_order_release);
	}
}

std::chrono::milliseconds Dispatcher::timeUntilNextScheduledTask() const {
	constexpr auto CHRONO_0 = std::chrono::milliseconds(0);
	constexpr auto CHRONO_MILI_MAX = std::chrono::milliseconds::max();

	if (scheduledTasks.empty()) {
		return CHRONO_MILI_MAX;
	}

	const auto &task = *scheduledTasks.begin();
	const auto timeRemaining = std::chrono::milliseconds(task->getTime() - OTSYS_TIME());
	return std::max<std::chrono::milliseconds>(timeRemaining, CHRONO_0);
}

bool Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs, DispatcherLane lane, uint64_t producerToken) {
	if (shuttingDown.load(std::memory_order_acquire)) {
		return false;
	}
	if (lane == DispatcherLane::Last || lane == DispatcherLane::WorkerCompletion || defaultExecutionMode(lane) != ExecutionMode::Serial) {
		lane = DispatcherLane::WorldCommit;
	}

	if (!tryReserveLaneSlot(lane)) {
		return false;
	}
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	try {
		auto &task = thread->tasks[static_cast<size_t>(lane)].emplace_back(expiresAfterMs, std::move(f), context);
		task.setLane(lane);
		task.setProducerToken(producerToken);
		adoptReservedLaneSlot(task, lane);
	} catch (...) {
		releaseLaneSlot(lane);
		throw;
	}
	notifyThreadTaskPublished();
	return true;
}

bool Dispatcher::addProtocolEvent(std::function<void(void)> &&f, std::string_view context, uint64_t producerToken, uint32_t expiresAfterMs) {
	return addEvent(std::move(f), context, expiresAfterMs, DispatcherLane::ProtocolInput, producerToken);
}

bool Dispatcher::addWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs, uint64_t producerToken) {
	if (shuttingDown.load(std::memory_order_acquire)) {
		return false;
	}

	constexpr auto lane = DispatcherLane::PlayerWalk;
	if (!tryReserveLaneSlot(lane)) {
		return false;
	}
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	try {
		auto &task = thread->tasks[static_cast<size_t>(lane)].emplace_back(expiresAfterMs, std::move(f), this->context().taskName);
		task.setLane(lane);
		task.setProducerToken(producerToken);
		adoptReservedLaneSlot(task, lane);
	} catch (...) {
		releaseLaneSlot(lane);
		throw;
	}
	notifyThreadTaskPublished();
	return true;
}

bool Dispatcher::addCreatureWalkEvent(std::function<void(void)> &&f, DispatcherLane lane, uint32_t expiresAfterMs) {
	if (shuttingDown.load(std::memory_order_acquire)) {
		return false;
	}
	if (lane != DispatcherLane::VisibleMonster && lane != DispatcherLane::BackgroundMonster) {
		lane = DispatcherLane::VisibleMonster;
	}

	if (!tryReserveLaneSlot(lane)) {
		return false;
	}
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	try {
		auto &task = thread->tasks[static_cast<size_t>(lane)].emplace_back(expiresAfterMs, std::move(f), this->context().taskName);
		task.setLane(lane);
		adoptReservedLaneSlot(task, lane);
	} catch (...) {
		releaseLaneSlot(lane);
		throw;
	}
	notifyThreadTaskPublished();
	return true;
}

bool Dispatcher::addDeferredGameplayEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	if (shuttingDown.load(std::memory_order_acquire)) {
		return false;
	}

	constexpr auto lane = DispatcherLane::Deferred;
	if (!tryReserveLaneSlot(lane)) {
		return false;
	}
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	try {
		auto &task = thread->tasks[static_cast<size_t>(lane)].emplace_back(expiresAfterMs, std::move(f), context);
		task.setLane(lane);
		adoptReservedLaneSlot(task, lane);
	} catch (...) {
		releaseLaneSlot(lane);
		throw;
	}
	notifyThreadTaskPublished();
	return true;
}

bool Dispatcher::addBarrierEvent(std::function<void(void)> &&f, DispatcherLane lane) {
	return addBarrierEvent(std::move(f), lane, DISPATCHER_LANE_QUEUE_CAPACITY);
}

bool Dispatcher::addCreatureAsyncEvent(std::function<void(void)> &&f, DispatcherLane lane) {
	if (lane != DispatcherLane::VisibleMonsterAI && lane != DispatcherLane::MonsterAI) {
		return false;
	}
	return addBarrierEvent(std::move(f), lane, DISPATCHER_LANE_QUEUE_CAPACITY + DISPATCHER_CREATURE_ASYNC_BUCKET_RESERVE);
}

bool Dispatcher::addBarrierEvent(std::function<void(void)> &&f, DispatcherLane lane, size_t capacity) {
	if (shuttingDown.load(std::memory_order_acquire)) {
		return false;
	}
	if (lane != DispatcherLane::VisibleMonsterAI && lane != DispatcherLane::MonsterAI && lane != DispatcherLane::GenericParallel) {
		lane = DispatcherLane::GenericParallel;
	}

	if (!tryReserveLaneSlot(lane, capacity)) {
		return false;
	}
	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	try {
		auto &task = thread->tasks[static_cast<size_t>(lane)].emplace_back(0, std::move(f), dispacherContext.taskName);
		task.setLane(lane);
		task.setExecutionMode(ExecutionMode::BarrierParallel);
		adoptReservedLaneSlot(task, lane);
	} catch (...) {
		releaseLaneSlot(lane);
		throw;
	}
	notifyThreadTaskPublished();
	return true;
}

uint64_t Dispatcher::scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context, bool cycle, bool log, DispatcherLane lane, uint64_t producerToken) {
	auto task = std::make_shared<Task>(std::move(f), context, delay, cycle, log);
	if (lane == DispatcherLane::Last || lane == DispatcherLane::WorkerCompletion || defaultExecutionMode(lane) != ExecutionMode::Serial) {
		lane = DispatcherLane::WorldCommit;
	}
	task->setLane(lane);
	task->setProducerToken(producerToken);
	return scheduleEvent(task);
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	if (shuttingDown.load(std::memory_order_acquire) || !task) {
		return 0;
	}
	const auto lane = task->getMeta().lane;
	if (lane == DispatcherLane::Last || lane == DispatcherLane::WorkerCompletion || task->getMeta().executionMode != ExecutionMode::Serial) {
		task->setLane(DispatcherLane::WorldCommit);
	}
	if (!reserveDispatcherSlot(*task)) {
		return 0;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);

	auto eventId = scheduledTasksRef
					   .emplace(task->getId(), thread->scheduledTasks.emplace_back(task))
					   .first->first;

	notifyThreadTaskPublished();
	return eventId;
}
void Dispatcher::stopEvent(uint64_t eventId) {
	auto it = scheduledTasksRef.find(eventId);
	if (it != scheduledTasksRef.end()) {
		it->second->cancel();
		releaseDispatcherSlot(*it->second);
		scheduledTasksRef.erase(it);
	}
}

void Dispatcher::safeCall(std::function<void(void)> &&f) {
	if (dispacherContext.isBarrierParallel()) {
		addEvent(std::move(f), dispacherContext.taskName);
	} else {
		f();
	}
}

bool DispatcherContext::isOn() {
	return OTSYS_TIME() != 0;
}
