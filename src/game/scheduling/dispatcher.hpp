/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "task.hpp"
#include "dispatcher_budget.hpp"
#include "dispatcher_policy.hpp"
#include "dispatcher_telemetry.hpp"
#include "lib/thread/thread_pool.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <atomic>
	#include <span>
#endif

static constexpr uint16_t DISPATCHER_TASK_EXPIRATION = 2000;
static constexpr uint16_t SCHEDULER_MINTICKS = 50;

enum class TaskGroup : int8_t {
	ThreadPool = -1,
	Walk,
	CreatureWalk,
	WalkParallel,
	Serial,
	DeferredGameplay,
	GenericParallel,
	Last
};

[[nodiscard]] constexpr DispatcherLane getDispatcherLane(const TaskGroup group) {
	switch (group) {
		case TaskGroup::Walk:
			return DispatcherLane::PlayerWalk;
		case TaskGroup::CreatureWalk:
			return DispatcherLane::VisibleMonster;
		case TaskGroup::WalkParallel:
			return DispatcherLane::MonsterAI;
		case TaskGroup::Serial:
			return DispatcherLane::WorldCommit;
		case TaskGroup::DeferredGameplay:
			return DispatcherLane::Deferred;
		case TaskGroup::GenericParallel:
			return DispatcherLane::GenericParallel;
		default:
			return DispatcherLane::Maintenance;
	}
}

[[nodiscard]] constexpr ExecutionMode getExecutionMode(const TaskGroup group) {
	return group == TaskGroup::WalkParallel || group == TaskGroup::GenericParallel ? ExecutionMode::BarrierParallel : ExecutionMode::Serial;
}

[[nodiscard]] constexpr bool isMovementCommit(const TaskGroup group) {
	return ::isMovementCommit(getDispatcherLane(group));
}

[[nodiscard]] constexpr bool isBarrierParallel(const TaskGroup group) {
	return getExecutionMode(group) == ExecutionMode::BarrierParallel;
}

[[nodiscard]] constexpr bool isPlayerVisible(const TaskGroup group) {
	return ::isPlayerVisible(getDispatcherLane(group));
}

enum class DispatcherType : uint8_t {
	None,
	Event,
	AsyncEvent,
	ScheduledEvent,
	CycleEvent,
	WorkerCompletion
};

enum class DispatcherInternalWork : uint8_t {
	CreatureAsyncBucket,
	CreatureAsyncRequeue,
	MonsterMovementRefreshLateness,
	MonsterPostThinkLateness,
	WorkerCompletionBatch,
	DispatcherPass,
	DispatcherIdle,
	Last
};

struct CreatureAsyncSliceLimits {
	size_t tasksPerBucket = 16;
	std::chrono::microseconds maxRuntime { 2000 };
};

struct DispatcherContext {
	static bool isOn();

	bool isGroup(const TaskGroup _group) const {
		return group == _group;
	}

	bool isMovementCommit() const {
		return ::isMovementCommit(lane);
	}

	bool isBarrierParallel() const {
		return type == DispatcherType::AsyncEvent && executionMode == ExecutionMode::BarrierParallel;
	}

	bool isPlayerVisible() const {
		return ::isPlayerVisible(lane);
	}

	bool isAsync() const {
		return isBarrierParallel();
	}

	auto getGroup() const {
		return group;
	}

	auto getLane() const {
		return lane;
	}

	auto getExecutionMode() const {
		return executionMode;
	}

	auto getName() const {
		return taskName;
	}

	auto getType() const {
		return type;
	}

private:
	inline static constexpr std::string_view defaultTaskName { "ThreadPool::call" };

	void reset() {
		group = TaskGroup::ThreadPool;
		type = DispatcherType::None;
		lane = DispatcherLane::Maintenance;
		executionMode = ExecutionMode::Serial;
		taskName = defaultTaskName;
	}

	DispatcherType type = DispatcherType::None;
	TaskGroup group = TaskGroup::ThreadPool;
	DispatcherLane lane = DispatcherLane::Maintenance;
	ExecutionMode executionMode = ExecutionMode::Serial;
	std::string_view taskName = defaultTaskName;

	friend class Dispatcher;
};

/**
 * Dispatcher allow you to dispatch a task async to be executed
 * in the dispatching thread. You can dispatch with an expiration
 * time, after which the task will be ignored.
 */
class Dispatcher {
public:
	explicit Dispatcher(ThreadPool &threadPool) :
		threadPool(threadPool) {
		threads.reserve(threadPool.get_thread_count() + 1);
		for (uint_fast16_t i = 0; i < threads.capacity(); ++i) {
			threads.emplace_back(std::make_unique<ThreadTask>());
		}

		scheduledTasksRef.reserve(2000);
	}

	// Ensures that we don't accidentally copy it
	Dispatcher(const Dispatcher &) = delete;
	Dispatcher operator=(const Dispatcher &) = delete;

	static Dispatcher &getInstance();

	void addEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs = 0);
	void addWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs = 0); // No need context name
	void addCreatureWalkEvent(std::function<void(void)> &&f, uint32_t expiresAfterMs = 0); // No need context name
	void addDeferredGameplayEvent(std::function<void(void)> &&f, std::string_view context, uint32_t expiresAfterMs = 0);

	uint64_t cycleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context) {
		return scheduleEvent(delay, std::move(f), context, true);
	}

	uint64_t scheduleEvent(const std::shared_ptr<Task> &task);
	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context) {
		return scheduleEvent(delay, std::move(f), context, false);
	}

	void asyncEvent(std::function<void(void)> &&f, TaskGroup group = TaskGroup::GenericParallel);
	void asyncWait(size_t size, std::function<void(size_t i)> &&f);
	void observeInternalWork(DispatcherInternalWork work, uint64_t units, std::chrono::microseconds runtime, std::string_view context = {}) noexcept;

	[[nodiscard]] CreatureAsyncSliceLimits getCreatureAsyncSliceLimits() const noexcept {
		const auto packed = creatureAsyncSliceLimits.load(std::memory_order_relaxed);
		return { static_cast<size_t>(packed >> 32), std::chrono::microseconds(static_cast<uint32_t>(packed)) };
	}

	uint64_t asyncCycleEvent(uint32_t delay, std::function<void(void)> &&f, TaskGroup group = TaskGroup::GenericParallel) {
		return scheduleEvent(
			delay, [this, f = std::move(f), group] { asyncEvent([f] { f(); }, group); }, dispacherContext.taskName, true, false
		);
	}

	uint64_t asyncScheduleEvent(uint32_t delay, std::function<void(void)> &&f, TaskGroup group = TaskGroup::GenericParallel) {
		return scheduleEvent(
			delay, [this, f = std::move(f), group] { asyncEvent([f] { f(); }, group); }, dispacherContext.taskName, false, false
		);
	}

	/**
	 * @brief Executes an action wrapped in a std::function safely on the dispatcher thread.
	 *
	 * This method ensures that the given function is executed on the correct thread (the dispatcher thread).
	 * If this method is called from a different thread, it will redirect execution to the dispatcher thread,
	 * using appropriate mechanisms (such as message queues or event loops).
	 * If called directly from the dispatcher thread, it will execute the function immediately.
	 *
	 * @param action The function wrapped in a std::function<void(void)> that should be executed.
	 *
	 * @note This method is useful in multi-threaded applications to avoid race conditions or thread context violations.
	 */
	void safeCall(std::function<void(void)> &&f);

	[[nodiscard]] uint64_t getDispatcherCycle() const {
		return dispatcherCycle;
	}

	void stopEvent(uint64_t eventId);

	const auto &context() const {
		return dispacherContext;
	}

private:
	thread_local static DispatcherContext dispacherContext;

	const auto &getThreadTask() const {
		return threads[ThreadPool::getThreadId()];
	}

	uint64_t scheduleEvent(uint32_t delay, std::function<void(void)> &&f, std::string_view context, bool cycle, bool log = true) {
		return scheduleEvent(std::make_shared<Task>(std::move(f), context, delay, cycle, log));
	}

	void init();
	void shutdown() {
		setQueueLatencyLoggingEnabled(false);
		signalSchedule.notify_all();
		shuttingDown = true;
	}

	void setQueueLatencyLoggingEnabled(bool enabled);

	inline void mergeAsyncEvents();
	inline void mergeEvents();
	inline void __mergeEvents(std::span<const uint8_t> groups, const bool mergeScheduledEvents);

	inline void executeEvents(const TaskGroup startGroup = TaskGroup::Walk);
	inline void executeScheduledEvents();
	inline void executeWorkerCompletions();

	inline void executeSerialEvents(const uint8_t groupId);
	inline void executeBudgetedSerialEvents(const uint8_t groupId, size_t maxTasks, std::chrono::microseconds maxRuntime = std::chrono::microseconds::max());
	inline void executeParallelEvents(const uint8_t groupId);
	inline void executeBudgetedParallelEvents(const uint8_t groupId, size_t maxTasks);
	inline bool executeTask(const Task &task, const uint8_t groupId);
	inline void observeTaskStart(const Task &task, const uint8_t groupId, Task::Clock::time_point startedAt);
	inline void logQueueLatency(const uint8_t groupId) const;
	inline void logRuntimeTelemetry();
	inline void resetRuntimeTelemetry();
	inline void refreshAdaptiveBudgets();
	inline std::chrono::microseconds oldestPlayerVisibleReadyAge(Task::Clock::time_point now) const;
	inline std::chrono::milliseconds timeUntilNextScheduledTask() const;

	inline void checkPendingTasks() {
		hasPendingTasks = false;
		for (uint_fast8_t i = 0; i < static_cast<uint8_t>(TaskGroup::Last); ++i) {
			if (!m_tasks[i].empty()) {
				hasPendingTasks = true;
				break;
			}
		}
	}

	void notify() {
		if (!hasPendingTasks) {
			hasPendingTasks = true;
			signalSchedule.notify_one();
		}
	}

	std::vector<std::pair<uint64_t, uint64_t>> generatePartition(size_t size) const {
		if (size == 0) {
			return {};
		}

		std::vector<std::pair<uint64_t, uint64_t>> list;
		list.reserve(threadPool.get_thread_count());

		const auto size_per_block = std::ceil(size / static_cast<float>(threadPool.get_thread_count()));
		for (uint_fast64_t i = 0; i < size; i += size_per_block) {
			list.emplace_back(i, std::min<uint64_t>(size, i + size_per_block));
		}

		return list;
	}

	uint_fast64_t dispatcherCycle = 0;

	ThreadPool &threadPool;
	DispatcherPolicy policy;
	DispatcherAdaptiveBudgetController adaptiveBudgetController;
	DispatcherBudgetSet activeBudgets;
	Task::Clock::time_point nextAdaptiveBudgetUpdateAt {};
	std::condition_variable signalSchedule;
	std::atomic_bool hasPendingTasks = false;
	std::atomic_uint64_t creatureAsyncSliceLimits = (uint64_t { 16 } << 32) | 2000;
	std::mutex dummyMutex; // This is only used for signaling the condition variable and not as an actual lock.

	// Thread Events
	struct ThreadTask {
		ThreadTask() {
			for (auto &task : tasks) {
				task.reserve(2000);
			}
			scheduledTasks.reserve(2000);
		}

		std::array<std::vector<Task>, static_cast<uint8_t>(TaskGroup::Last)> tasks;
		std::vector<std::shared_ptr<Task>> scheduledTasks;
		std::mutex mutex;
	};

	std::vector<std::unique_ptr<ThreadTask>> threads;

	// Main Events
	std::array<std::vector<Task>, static_cast<uint8_t>(TaskGroup::Last)> m_tasks;
	phmap::btree_multiset<std::shared_ptr<Task>, Task::Compare> scheduledTasks {};
	phmap::parallel_flat_hash_map_m<uint64_t, std::shared_ptr<Task>> scheduledTasksRef {};

	struct TaskGroupTelemetry {
		dispatcher::telemetry::ConcurrentTimedWork queueWait;
		dispatcher::telemetry::ConcurrentTimedWork taskRuntime;
		dispatcher::telemetry::ConcurrentTimedWork groupRuntime;
		dispatcher::telemetry::ConcurrentTimedWork barrierRuntime;
	};

	std::array<TaskGroupTelemetry, static_cast<uint8_t>(TaskGroup::Last)> taskGroupTelemetry;
	std::array<dispatcher::telemetry::ConcurrentTimedWork, static_cast<uint8_t>(DispatcherInternalWork::Last)> internalWorkTelemetry;
	dispatcher::telemetry::ConcurrentTimedWork scheduledLatenessTelemetry;
	dispatcher::telemetry::ConcurrentLatencyHistogram playerVisibleReadyLatency;

	bool asyncWaitDisabled = false;

	bool shuttingDown = false;
	std::atomic_bool queueLatencyLoggingEnabled = false;
	std::atomic<int64_t> queueLatencyLoggingStartedAt = 0;

	friend class CanaryServer;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;
