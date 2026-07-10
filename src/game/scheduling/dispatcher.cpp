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

	size_t getPositiveConfig(const ConfigKey_t key) {
		return static_cast<size_t>(std::max<int32_t>(1, g_configManager().getNumber(key)));
	}

	DispatcherBudgetSet getConfiguredDispatcherBudgets() {
		return {
			.creatureWalkTasks = getPositiveConfig(CREATURE_WALK_TASKS_PER_PASS),
			.walkParallelTasks = getPositiveConfig(WALK_PARALLEL_TASKS_PER_PASS),
			.creatureAsyncTasksPerBucket = getPositiveConfig(CREATURE_ASYNC_TASKS_PER_BUCKET),
			.deferredGameplayTasks = getPositiveConfig(DEFERRED_GAMEPLAY_TASKS_PER_PASS),
			.workerCompletions = getPositiveConfig(WORKER_COMPLETIONS_PER_PASS),
			.sliceRuntime = std::chrono::milliseconds(getPositiveConfig(DISPATCHER_SLICE_DURATION_MS)),
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

	std::string_view getTaskGroupName(const uint8_t groupId) {
		switch (static_cast<TaskGroup>(groupId)) {
			case TaskGroup::Walk:
				return "Walk";
			case TaskGroup::CreatureWalk:
				return "CreatureWalk";
			case TaskGroup::WalkParallel:
				return "WalkParallel";
			case TaskGroup::Serial:
				return "Serial";
			case TaskGroup::DeferredGameplay:
				return "DeferredGameplay";
			case TaskGroup::GenericParallel:
				return "GenericParallel";
			default:
				return "Unknown";
		}
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

	auto dispatcherStarted = std::make_shared<std::promise<void>>();
	auto futureStarted = dispatcherStarted->get_future();

	threadPool.detach_task([this, dispatcherStarted]() mutable {
		std::unique_lock asyncLock(dummyMutex);

		dispatcherStarted->set_value();

		while (!threadPool.isStopped()) {
			UPDATE_OTSYS_TIME();
			const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
			const auto passStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};

			refreshAdaptiveBudgets();
			executeEvents();
			executeScheduledEvents();
			executeWorkerCompletions();
			mergeEvents();
			if (telemetryEnabled) {
				observeInternalWork(DispatcherInternalWork::DispatcherPass, 1, policy.elapsedSince(passStartedAt));
			}
			logRuntimeTelemetry();

			if (!hasPendingTasks) {
				const auto idleStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
				signalSchedule.wait_for(asyncLock, timeUntilNextScheduledTask());
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

void Dispatcher::executeSerialEvents(const uint8_t groupId) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty()) {
		return;
	}

	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	const auto groupStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
	logQueueLatency(groupId);

	dispacherContext.group = static_cast<TaskGroup>(groupId);
	dispacherContext.type = DispatcherType::Event;

	for (const auto &task : tasks) {
		dispacherContext.taskName = task.getContext();
		if (executeTask(task, groupId)) {
			++dispatcherCycle;
		}
	}
	if (telemetryEnabled) {
		taskGroupTelemetry[groupId].groupRuntime.observe(policy.elapsedSince(groupStartedAt), tasks.size());
	}
	tasks.clear();

	dispacherContext.reset();
}

void Dispatcher::executeBudgetedSerialEvents(const uint8_t groupId, size_t maxTasks, std::chrono::microseconds maxRuntime) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty() || maxTasks == 0) {
		return;
	}

	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	const auto hasRuntimeBudget = maxRuntime != std::chrono::microseconds::max();
	const auto groupStartedAt = telemetryEnabled || hasRuntimeBudget ? policy.now() : Task::Clock::time_point {};
	const auto deadline = hasRuntimeBudget ? groupStartedAt + maxRuntime : Task::Clock::time_point::max();
	logQueueLatency(groupId);

	dispacherContext.group = static_cast<TaskGroup>(groupId);
	dispacherContext.type = DispatcherType::Event;

	const auto taskLimit = DispatcherPolicy::selectTaskCount(tasks.size(), maxTasks);
	size_t tasksExecuted = 0;
	for (; tasksExecuted < taskLimit; ++tasksExecuted) {
		if (tasksExecuted > 0 && hasRuntimeBudget && policy.deadlineReached(deadline)) {
			break;
		}

		const auto &task = tasks[tasksExecuted];
		dispacherContext.taskName = task.getContext();
		if (executeTask(task, groupId)) {
			++dispatcherCycle;
		}
	}
	if (telemetryEnabled) {
		taskGroupTelemetry[groupId].groupRuntime.observe(policy.elapsedSince(groupStartedAt), tasksExecuted);
	}
	tasks.erase(tasks.begin(), tasks.begin() + static_cast<std::ptrdiff_t>(tasksExecuted));

	dispacherContext.reset();
}

void Dispatcher::executeParallelEvents(const uint8_t groupId) {
	executeBudgetedParallelEvents(groupId, m_tasks[groupId].size());
}

void Dispatcher::executeBudgetedParallelEvents(const uint8_t groupId, size_t maxTasks) {
	auto &tasks = m_tasks[groupId];
	if (tasks.empty() || maxTasks == 0) {
		return;
	}
	const auto tasksToExecute = DispatcherPolicy::selectTaskCount(tasks.size(), maxTasks);

	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	const auto groupStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
	logQueueLatency(groupId);

	const auto barrierStartedAt = telemetryEnabled ? policy.now() : Task::Clock::time_point {};
	asyncWait(tasksToExecute, [this, groupId, &tasks](size_t i) {
		dispacherContext.type = DispatcherType::AsyncEvent;
		dispacherContext.group = static_cast<TaskGroup>(groupId);
		executeTask(tasks[i], groupId);

		dispacherContext.reset();
	});
	if (telemetryEnabled) {
		taskGroupTelemetry[groupId].barrierRuntime.observe(policy.elapsedSince(barrierStartedAt), tasksToExecute);
		taskGroupTelemetry[groupId].groupRuntime.observe(policy.elapsedSince(groupStartedAt), tasksToExecute);
	}

	tasks.erase(tasks.begin(), tasks.begin() + static_cast<std::ptrdiff_t>(tasksToExecute));
}

bool Dispatcher::executeTask(const Task &task, const uint8_t groupId) {
	dispacherContext.lane = task.getMeta().lane;
	dispacherContext.executionMode = getExecutionMode(static_cast<TaskGroup>(groupId));
	const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
	if (!telemetryEnabled && !isPlayerVisible(task.getMeta().lane)) {
		return task.execute();
	}

	const auto startedAt = policy.now();
	observeTaskStart(task, groupId, startedAt);
	const auto executed = task.execute();
	if (telemetryEnabled) {
		taskGroupTelemetry[groupId].taskRuntime.observe(policy.elapsedSince(startedAt), 1, task.getContext());
	}
	return executed;
}

void Dispatcher::observeTaskStart(const Task &task, const uint8_t groupId, Task::Clock::time_point startedAt) {
	const auto queueWait = DispatcherPolicy::elapsed(task.getReadyAt(), startedAt);
	if (isPlayerVisible(task.getMeta().lane)) {
		playerVisibleReadyLatency.observe(queueWait);
	}

	if (queueLatencyLoggingEnabled.load(std::memory_order_relaxed)) {
		taskGroupTelemetry[groupId].queueWait.observe(queueWait, 1, task.getContext());
	}
}

void Dispatcher::logQueueLatency(const uint8_t groupId) const {
	static std::array<Task::Clock::time_point, static_cast<uint8_t>(TaskGroup::Last)> nextLogAt {};

	const auto &tasks = m_tasks[groupId];
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
	const auto loggingStartedAt = DispatcherPolicy::fromTimestamp(queueLatencyLoggingStartedAt.load(std::memory_order_relaxed));
	const auto snapshot = DispatcherPolicy::inspectQueueAt(tasks, now, loggingStartedAt);
	if (snapshot.queued == 0 || snapshot.oldestReadyAge < DISPATCHER_QUEUE_LATENCY_LOG_THRESHOLD || now < nextLogAt[groupId]) {
		return;
	}

	nextLogAt[groupId] = now + DISPATCHER_TELEMETRY_LOG_INTERVAL;
	g_logger().warn(
		"Dispatcher queue latency: group={}, queued={}, oldest={} ms, oldestContext={}",
		getTaskGroupName(groupId),
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
	queueLatencyLoggingStartedAt.store(DispatcherPolicy::timestamp(policy.now()), std::memory_order_relaxed);
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

	for (uint8_t groupId = 0; groupId < taskGroupTelemetry.size(); ++groupId) {
		auto &telemetry = taskGroupTelemetry[groupId];
		const auto queue = telemetry.queueWait.snapshotAndReset();
		const auto task = telemetry.taskRuntime.snapshotAndReset();
		const auto group = telemetry.groupRuntime.snapshotAndReset();
		const auto barrier = telemetry.barrierRuntime.snapshotAndReset();
		if (queue.empty() && task.empty() && group.empty() && barrier.empty()) {
			continue;
		}
		const auto longestTaskContext = task.longestContext.empty() ? std::string_view { "none" } : task.longestContext;

		g_logger().debug(
			"Dispatcher telemetry: group={}, queueSamples={}, queueP50={} us, queueP95={} us, queueP99={} us, taskSamples={}, taskP50={} us, taskP95={} us, taskP99={} us, groupP99={} us, barrierP99={} us, longestTask={} us, longestTaskContext={}",
			getTaskGroupName(groupId),
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
		const auto latestContext = scheduled.longestContext.empty() ? std::string_view { "none" } : scheduled.longestContext;
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
			"Monster compute telemetry: visibleQueued={}, backgroundQueued={}, completionsQueued={}, oldestCompletion={} us, outstanding={}, active={}, completionsInFlight={}, capacity={}, accepted={}, rejected={}, completed={}, failed={}, canceled={}",
			computeStats.visibleQueued,
			computeStats.backgroundQueued,
			computeStats.completionsQueued,
			computeStats.oldestCompletionReadyAge.count(),
			computeStats.outstanding,
			computeStats.active,
			computeStats.completionsInFlight,
			computeStats.capacity,
			computeStats.accepted,
			computeStats.rejected,
			computeStats.completed,
			computeStats.failed,
			computeStats.canceled
		);
	}
}

void Dispatcher::resetRuntimeTelemetry() {
	for (auto &telemetry : taskGroupTelemetry) {
		telemetry.queueWait.reset();
		telemetry.taskRuntime.reset();
		telemetry.groupRuntime.reset();
		telemetry.barrierRuntime.reset();
	}

	for (auto &telemetry : internalWorkTelemetry) {
		telemetry.reset();
	}
	scheduledLatenessTelemetry.reset();
}

std::chrono::microseconds Dispatcher::oldestPlayerVisibleReadyAge(Task::Clock::time_point now) const {
	std::chrono::microseconds oldest = std::chrono::microseconds::zero();
	for (const auto &tasks : m_tasks) {
		oldest = std::max(oldest, DispatcherPolicy::inspectPlayerVisibleQueueAt(tasks, now).oldestReadyAge);
	}
	for (const auto &task : scheduledTasks) {
		if (task && isPlayerVisible(task->getMeta().lane)) {
			oldest = std::max(oldest, DispatcherPolicy::elapsed(task->getReadyAt(), now));
		}
	}
	oldest = std::max(oldest, g_monsterComputeService().getStats().oldestCompletionReadyAge);
	return oldest;
}

void Dispatcher::refreshAdaptiveBudgets() {
	const auto now = policy.now();
	if (now < nextAdaptiveBudgetUpdateAt) {
		return;
	}
	nextAdaptiveBudgetUpdateAt = now + DISPATCHER_ADAPTIVE_BUDGET_INTERVAL;

	const auto visibleWindow = playerVisibleReadyLatency.snapshotAndReset();
	const auto configured = getConfiguredDispatcherBudgets();
	const auto decision = adaptiveBudgetController.update(
		configured,
		visibleWindow.percentile(0.99),
		oldestPlayerVisibleReadyAge(now),
		std::chrono::milliseconds(getPositiveConfig(DISPATCHER_SLO_MS)),
		std::chrono::milliseconds(getPositiveConfig(DISPATCHER_EMERGENCY_MS))
	);
	activeBudgets = decision.budgets;

	const auto tasksPerBucket = std::min<size_t>(activeBudgets.creatureAsyncTasksPerBucket, std::numeric_limits<uint32_t>::max());
	const auto maxRuntimeUs = std::min<int64_t>(activeBudgets.sliceRuntime.count(), std::numeric_limits<uint32_t>::max());
	creatureAsyncSliceLimits.store((static_cast<uint64_t>(tasksPerBucket) << 32) | static_cast<uint32_t>(maxRuntimeUs), std::memory_order_relaxed);

	if (!decision.stateChanged) {
		return;
	}
	const auto stateName = getDispatcherLoadStateName(decision.state);
	if (decision.state == DispatcherLoadState::Emergency) {
		g_logger().warn(
			"Dispatcher adaptive budgets: state={}, controlLatency={} us, creatureWalk={}, walkParallel={}, creatureBucket={}, deferred={}, completions={}, slice={} us",
			stateName,
			decision.controlLatency.count(),
			activeBudgets.creatureWalkTasks,
			activeBudgets.walkParallelTasks,
			activeBudgets.creatureAsyncTasksPerBucket,
			activeBudgets.deferredGameplayTasks,
			activeBudgets.workerCompletions,
			activeBudgets.sliceRuntime.count()
		);
	} else {
		g_logger().info(
			"Dispatcher adaptive budgets: state={}, controlLatency={} us, creatureWalk={}, walkParallel={}, creatureBucket={}, deferred={}, completions={}, slice={} us",
			stateName,
			decision.controlLatency.count(),
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

void Dispatcher::executeEvents(const TaskGroup startGroup) {
	bool movementQueuesMerged = false;
	for (uint_fast8_t groupId = static_cast<uint8_t>(startGroup); groupId < static_cast<uint8_t>(TaskGroup::Last); ++groupId) {
		const auto group = static_cast<TaskGroup>(groupId);
		const auto isMovement = isMovementCommit(group);
		const auto isDeferredGameplay = groupId == static_cast<uint8_t>(TaskGroup::DeferredGameplay);

		if (isMovement) {
			if (!movementQueuesMerged) {
				mergeEvents();
				movementQueuesMerged = true;
			}
			if (group == TaskGroup::CreatureWalk && !m_tasks[groupId].empty()) {
				executeBudgetedSerialEvents(
					groupId,
					activeBudgets.creatureWalkTasks,
					activeBudgets.sliceRuntime
				);
			} else {
				executeSerialEvents(groupId);
			}
			mergeAsyncEvents();
		} else if (groupId == static_cast<uint8_t>(TaskGroup::Serial)) {
			mergeEvents();
			executeSerialEvents(groupId);
			mergeAsyncEvents();
		} else if (isDeferredGameplay) {
			mergeEvents();
			if (!m_tasks[groupId].empty()) {
				executeBudgetedSerialEvents(groupId, activeBudgets.deferredGameplayTasks);
			}
			mergeAsyncEvents();
		} else if (group == TaskGroup::WalkParallel) {
			if (!m_tasks[groupId].empty()) {
				executeBudgetedParallelEvents(groupId, activeBudgets.walkParallelTasks);
			}
		} else {
			executeParallelEvents(groupId);
		}
	}
}

void Dispatcher::executeScheduledEvents() {
	auto &threadScheduledTasks = getThreadTask()->scheduledTasks;

	auto it = scheduledTasks.begin();
	while (it != scheduledTasks.end()) {
		const auto &task = *it;
		if (task->getTime() > OTSYS_TIME()) {
			break;
		}
		const auto telemetryEnabled = queueLatencyLoggingEnabled.load(std::memory_order_relaxed);
		const auto taskStartedAt = policy.now();
		const auto scheduledLateness = DispatcherPolicy::elapsed(task->getReadyAt(), taskStartedAt);
		if (isPlayerVisible(task->getMeta().lane)) {
			playerVisibleReadyLatency.observe(scheduledLateness);
		}
		if (telemetryEnabled) {
			scheduledLatenessTelemetry.observe(scheduledLateness, 1, task->getContext());
		}

		dispacherContext.type = task->isCycle() ? DispatcherType::CycleEvent : DispatcherType::ScheduledEvent;
		dispacherContext.group = TaskGroup::Serial;
		dispacherContext.lane = task->getMeta().lane;
		dispacherContext.executionMode = ExecutionMode::Serial;
		dispacherContext.taskName = task->getContext();

		const auto executed = task->execute();
		if (telemetryEnabled) {
			taskGroupTelemetry[static_cast<uint8_t>(TaskGroup::Serial)].taskRuntime.observe(policy.elapsedSince(taskStartedAt), 1, task->getContext());
		}
		if (executed && task->isCycle()) {
			task->updateTime();
			threadScheduledTasks.emplace_back(task);
		} else {
			scheduledTasksRef.erase(task->getId());
		}

		++it;
	}

	if (it != scheduledTasks.begin()) {
		scheduledTasks.erase(scheduledTasks.begin(), it);
	}

	dispacherContext.reset();

	mergeAsyncEvents(); // merge async events requested by scheduled events
	executeEvents(TaskGroup::GenericParallel); // execute async events requested by scheduled events
}

void Dispatcher::executeWorkerCompletions() {
	auto &computeService = g_monsterComputeService();
	if (computeService.getCompletionCount() == 0) {
		return;
	}

	dispacherContext.type = DispatcherType::WorkerCompletion;
	dispacherContext.group = TaskGroup::Serial;
	dispacherContext.lane = DispatcherLane::WorkerCompletion;
	dispacherContext.executionMode = ExecutionMode::BackgroundCompletion;
	const auto startedAt = policy.now();
	const auto completed = computeService.drainCompletions(
		activeBudgets.workerCompletions,
		[](std::string_view context, MonsterComputeService::Completion &completion) {
			dispacherContext.taskName = context;
			if (completion) {
				completion();
			}
		}
	);
	observeInternalWork(DispatcherInternalWork::WorkerCompletionBatch, completed, policy.elapsedSince(startedAt));
	dispatcherCycle += completed;
	dispacherContext.reset();
}

void Dispatcher::__mergeEvents(std::span<const uint8_t> groups, const bool mergeScheduledEvents) {
	for (const auto &thread : threads) {
		std::scoped_lock lock(thread->mutex);
		for (const auto group : groups) {
			auto &threadTasks = thread->tasks[group];
			auto &tasks = m_tasks[group];

			if (threadTasks.size() > tasks.size()) {
				tasks.swap(threadTasks);
			}

			if (!threadTasks.empty()) {
				tasks.insert(tasks.end(), make_move_iterator(threadTasks.begin()), make_move_iterator(threadTasks.end()));
				threadTasks.clear();
			}
		}

		if (mergeScheduledEvents && !thread->scheduledTasks.empty()) {
			scheduledTasks.insert(make_move_iterator(thread->scheduledTasks.begin()), make_move_iterator(thread->scheduledTasks.end()));
			thread->scheduledTasks.clear();
		}
	}
}

// Merge only async thread events with main dispatch events
void Dispatcher::mergeAsyncEvents() {
	static constexpr auto groups = std::to_array({ static_cast<uint8_t>(TaskGroup::WalkParallel), static_cast<uint8_t>(TaskGroup::GenericParallel) });
	__mergeEvents(groups, false);
}

// Merge thread events with main dispatch events
void Dispatcher::mergeEvents() {
	static constexpr auto groups = std::to_array({
		static_cast<uint8_t>(TaskGroup::Walk),
		static_cast<uint8_t>(TaskGroup::CreatureWalk),
		static_cast<uint8_t>(TaskGroup::Serial),
		static_cast<uint8_t>(TaskGroup::DeferredGameplay),
	});
	__mergeEvents(groups, true);
	checkPendingTasks();
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

void Dispatcher::addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	auto &task = thread->tasks[static_cast<uint8_t>(TaskGroup::Serial)].emplace_back(expiresAfterMs, std::move(f), context);
	task.setLane(DispatcherLane::WorldCommit);
	notify();
}

void Dispatcher::addWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	auto &task = thread->tasks[static_cast<uint8_t>(TaskGroup::Walk)].emplace_back(expiresAfterMs, std::move(f), this->context().taskName);
	task.setLane(DispatcherLane::PlayerWalk);
	notify();
}

void Dispatcher::addCreatureWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	auto &task = thread->tasks[static_cast<uint8_t>(TaskGroup::CreatureWalk)].emplace_back(expiresAfterMs, std::move(f), this->context().taskName);
	task.setLane(DispatcherLane::VisibleMonster);
	notify();
}

void Dispatcher::addDeferredGameplayEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	auto &task = thread->tasks[static_cast<uint8_t>(TaskGroup::DeferredGameplay)].emplace_back(expiresAfterMs, std::move(f), context);
	task.setLane(DispatcherLane::Deferred);
	notify();
}

uint64_t Dispatcher::scheduleEvent(const std::shared_ptr<Task> &task) {
	if (shuttingDown) {
		return 0;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);

	auto eventId = scheduledTasksRef
					   .emplace(task->getId(), thread->scheduledTasks.emplace_back(task))
					   .first->first;

	notify();
	return eventId;
}

void Dispatcher::asyncEvent(std::function<void(void)> &&f, TaskGroup group) {
	if (shuttingDown) {
		return;
	}

	const auto &thread = getThreadTask();
	std::scoped_lock lock(thread->mutex);
	auto &task = thread->tasks[static_cast<uint8_t>(group)].emplace_back(0, std::move(f), dispacherContext.taskName);
	task.setLane(getDispatcherLane(group));
	notify();
}

void Dispatcher::stopEvent(uint64_t eventId) {
	auto it = scheduledTasksRef.find(eventId);
	if (it != scheduledTasksRef.end()) {
		it->second->cancel();
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
