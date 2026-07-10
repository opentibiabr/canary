/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/dispatcher_telemetry.hpp"

using namespace std::chrono_literals;

TEST(DispatcherContextTest, SeparatesMovementBarrierAndVisibilitySemantics) {
	EXPECT_TRUE(isMovementCommit(DispatcherLane::PlayerWalk));
	EXPECT_TRUE(isMovementCommit(DispatcherLane::VisibleMonster));
	EXPECT_FALSE(isMovementCommit(DispatcherLane::WorldCommit));
	EXPECT_FALSE(isMovementCommit(DispatcherLane::MonsterAI));

	EXPECT_EQ(defaultExecutionMode(DispatcherLane::MonsterAI), ExecutionMode::BarrierParallel);
	EXPECT_EQ(defaultExecutionMode(DispatcherLane::GenericParallel), ExecutionMode::BarrierParallel);
	EXPECT_EQ(defaultExecutionMode(DispatcherLane::PlayerWalk), ExecutionMode::Serial);
	EXPECT_EQ(defaultExecutionMode(DispatcherLane::WorkerCompletion), ExecutionMode::BackgroundCompletion);

	EXPECT_TRUE(isPlayerVisible(DispatcherLane::PlayerWalk));
	EXPECT_TRUE(isPlayerVisible(DispatcherLane::WorldCommit));
	EXPECT_TRUE(isPlayerVisible(DispatcherLane::VisibleMonster));
	EXPECT_FALSE(isPlayerVisible(DispatcherLane::Deferred));
	EXPECT_FALSE(isPlayerVisible(DispatcherLane::MonsterAI));

	EXPECT_TRUE(usesProducerFairness(DispatcherLane::ProtocolInput));
	EXPECT_TRUE(usesProducerFairness(DispatcherLane::PlayerAction));
	EXPECT_FALSE(usesProducerFairness(DispatcherLane::WorldCommit));
}

TEST(DispatcherPolicyTest, TracksMonotonicReadyTimesWithoutChangingWallClockScheduling) {
	const auto enqueuedAt = Task::Clock::time_point(10s);
	Task immediate(0, [] { }, "immediate", enqueuedAt);
	Task scheduled([] { }, "scheduled", 75, false, false, enqueuedAt);

	EXPECT_EQ(immediate.getEnqueuedAt(), enqueuedAt);
	EXPECT_EQ(immediate.getReadyAt(), enqueuedAt);
	EXPECT_EQ(immediate.getMeta().lane, DispatcherLane::WorldCommit);
	EXPECT_EQ(immediate.getMeta().estimatedCost, 1);
	EXPECT_EQ(scheduled.getEnqueuedAt(), enqueuedAt);
	EXPECT_EQ(scheduled.getReadyAt(), enqueuedAt + 75ms);
}

TEST(DispatcherPolicyTest, InspectsQueueWithAnInjectedMonotonicClock) {
	const auto base = Task::Clock::time_point(10s);
	auto currentTime = base + 100ms;
	DispatcherPolicy policy([&currentTime] { return currentTime; });

	std::vector<Task> tasks;
	tasks.emplace_back(0, [] { }, "oldest", base + 10ms);
	tasks.emplace_back(0, [] { }, "newest", base + 20ms);

	const auto allTasks = policy.inspectQueue(tasks);
	EXPECT_EQ(allTasks.queued, 2);
	EXPECT_EQ(allTasks.oldestReadyAge, 90ms);
	EXPECT_EQ(allTasks.oldestContext, "oldest");

	const auto afterStartup = policy.inspectQueue(tasks, base + 15ms);
	EXPECT_EQ(afterStartup.queued, 1);
	EXPECT_EQ(afterStartup.oldestReadyAge, 80ms);
	EXPECT_EQ(afterStartup.oldestContext, "newest");
}

TEST(DispatcherPolicyTest, InspectsOnlyPlayerVisibleLanesForSloControl) {
	const auto base = Task::Clock::time_point(10s);
	std::vector<Task> tasks;
	tasks.emplace_back(0, [] { }, "visible", base);
	tasks.back().setLane(DispatcherLane::PlayerAction);
	tasks.emplace_back(0, [] { }, "background", base - 1s);
	tasks.back().setLane(DispatcherLane::MonsterAI);

	const auto snapshot = DispatcherPolicy::inspectPlayerVisibleQueueAt(tasks, base + 100ms);
	EXPECT_EQ(snapshot.queued, 1);
	EXPECT_EQ(snapshot.oldestReadyAge, 100ms);
	EXPECT_EQ(snapshot.oldestContext, "visible");
}

TEST(DispatcherPolicyTest, ClampsNegativeDurationsAndAppliesDeterministicBudgets) {
	const auto now = Task::Clock::time_point(10s);
	DispatcherPolicy policy([now] { return now; });

	EXPECT_EQ(DispatcherPolicy::elapsed(now + 1ms, now), 0us);
	EXPECT_EQ(DispatcherPolicy::elapsed(now, now + 2ms), 2000us);
	EXPECT_EQ(DispatcherPolicy::selectTaskCount(17, 8), 8);
	EXPECT_EQ(DispatcherPolicy::selectTaskCount(3, 8), 3);
	EXPECT_TRUE(policy.deadlineReached(now));
	EXPECT_FALSE(policy.deadlineReached(now + 1us));
}

TEST(DispatcherPolicyTest, RequeuesAnUnprocessedSliceWithoutChangingFifoOrder) {
	std::deque<int> queue { 4, 5 };
	std::vector<int> slice { 1, 2, 3 };

	EXPECT_EQ(DispatcherPolicy::requeueUnprocessed(queue, slice, 1), 2);
	EXPECT_EQ(queue, (std::deque<int> { 2, 3, 4, 5 }));
	EXPECT_EQ(DispatcherPolicy::requeueUnprocessed(queue, slice, slice.size()), 0);
}

TEST(DispatcherPolicyTest, RotatesProducersWhilePreservingEachProducerFifo) {
	std::vector<Task> tasks;
	for (const auto producerToken : { 10, 10, 20, 20, 30 }) {
		tasks.emplace_back(0, [] { }, "producer-task");
		tasks.back().setProducerToken(producerToken);
	}

	EXPECT_EQ(DispatcherPolicy::selectProducerFairIndex(tasks, 10), 2);
	EXPECT_EQ(DispatcherPolicy::selectProducerFairIndex(tasks, 20), 4);
	EXPECT_EQ(DispatcherPolicy::selectProducerFairIndex(tasks, 30), 0);
	EXPECT_EQ(DispatcherPolicy::selectProducerFairIndex(tasks, 15), 2);
}

TEST(DispatcherPolicyTest, CoalescesPendingTicksAndPreservesTheOldestReadyTime) {
	const auto firstReadyAt = CoalescedTaskState::TimePoint(10s);
	const auto replacementReadyAt = firstReadyAt + 5s;
	CoalescedTaskState state;

	EXPECT_TRUE(state.tryEnqueue(firstReadyAt));
	EXPECT_FALSE(state.tryEnqueue(replacementReadyAt));
	EXPECT_TRUE(state.isPending());
	EXPECT_EQ(state.getOldestReadyAt(), firstReadyAt);

	const auto consumed = state.consume();
	ASSERT_TRUE(consumed.has_value());
	EXPECT_EQ(*consumed, firstReadyAt);
	EXPECT_FALSE(state.isPending());
	EXPECT_FALSE(state.consume().has_value());
	EXPECT_TRUE(state.tryEnqueue(replacementReadyAt));
}

TEST(DispatcherTelemetryTest, ReportsBoundedPercentilesAndResetsTheWindow) {
	dispatcher::telemetry::ConcurrentLatencyHistogram histogram;
	histogram.observe(25us);
	histogram.observe(75us);
	histogram.observe(3ms);
	histogram.observe(40s);

	const auto snapshot = histogram.snapshotAndReset();
	EXPECT_EQ(snapshot.samples, 4);
	EXPECT_EQ(snapshot.mean(), 10000775us);
	EXPECT_EQ(snapshot.percentile(0.50), 100us);
	EXPECT_EQ(snapshot.percentile(0.95), 40s);
	EXPECT_EQ(snapshot.percentile(0.99), 40s);
	EXPECT_EQ(snapshot.maxUs, 40000000);
	EXPECT_TRUE(histogram.snapshotAndReset().empty());
}

TEST(DispatcherTelemetryTest, PreservesOnlyTheLongestLowCardinalityContext) {
	dispatcher::telemetry::ConcurrentTimedWork telemetry;
	telemetry.observe(100us, 2, "first");
	telemetry.observe(500us, 3, "slowest");
	telemetry.observe(250us, 1, "middle");

	const auto snapshot = telemetry.snapshotAndReset();
	EXPECT_EQ(snapshot.latency.samples, 3);
	EXPECT_EQ(snapshot.workUnits, 6);
	EXPECT_EQ(snapshot.longestDuration, 500us);
	EXPECT_EQ(snapshot.longestContext, "slowest");
	EXPECT_TRUE(telemetry.snapshotAndReset().empty());
}
