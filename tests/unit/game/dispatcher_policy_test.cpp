/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher_policy.hpp"
#include "game/scheduling/dispatcher_telemetry.hpp"

using namespace std::chrono_literals;

TEST(DispatcherPolicyTest, TracksMonotonicReadyTimesWithoutChangingWallClockScheduling) {
	const auto enqueuedAt = Task::Clock::time_point(10s);
	Task immediate(0, [] { }, "immediate", enqueuedAt);
	Task scheduled([] { }, "scheduled", 75, false, false, enqueuedAt);

	EXPECT_EQ(immediate.getEnqueuedAt(), enqueuedAt);
	EXPECT_EQ(immediate.getReadyAt(), enqueuedAt);
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
