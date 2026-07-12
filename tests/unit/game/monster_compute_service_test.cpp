/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/monster_compute_service.hpp"

#include <future>

using namespace std::chrono_literals;

TEST(MonsterComputeServiceTest, ResolvesHardwareAwareWorkerCounts) {
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(0, 2), 0);
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(4, 2), 0);
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(0, 4), 1);
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(0, 8), 3);
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(0, 16), 4);
	EXPECT_EQ(MonsterComputeService::resolveWorkerCount(20, 16), 4);
}

TEST(MonsterComputeServiceTest, SelectsVisibleAndBackgroundWorkAtAThreeToOneRatio) {
	uint8_t visibleStreak = 0;
	EXPECT_EQ(MonsterComputeService::selectNextPriority(true, true, visibleStreak), MonsterComputePriority::Visible);
	EXPECT_EQ(MonsterComputeService::selectNextPriority(true, true, visibleStreak), MonsterComputePriority::Visible);
	EXPECT_EQ(MonsterComputeService::selectNextPriority(true, true, visibleStreak), MonsterComputePriority::Visible);
	EXPECT_EQ(MonsterComputeService::selectNextPriority(true, true, visibleStreak), MonsterComputePriority::Background);
	EXPECT_EQ(MonsterComputeService::selectNextPriority(true, true, visibleStreak), MonsterComputePriority::Visible);
	EXPECT_EQ(MonsterComputeService::selectNextPriority(false, true, visibleStreak), MonsterComputePriority::Background);
	EXPECT_FALSE(MonsterComputeService::selectNextPriority(false, false, visibleStreak).has_value());
}

TEST(MonsterComputeServiceTest, PreservesVisibleCapacityUnderBackgroundSaturation) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.capacity = 8;
	config.hardwareConcurrency = 2;
	service.start(config);

	const auto submit = [&service](MonsterComputePriority priority) {
		return service.submit(
			priority, [](MonsterComputeToken, std::stop_token) { return MonsterComputeService::Completion {}; }, "MonsterComputeServiceTest::reserve"
		);
	};

	for (size_t index = 0; index < 6; ++index) {
		EXPECT_TRUE(submit(MonsterComputePriority::Background).accepted());
	}
	EXPECT_EQ(submit(MonsterComputePriority::Background).status, MonsterComputeSubmitStatus::QueueFull);
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_EQ(submit(MonsterComputePriority::Visible).status, MonsterComputeSubmitStatus::QueueFull);

	const auto saturated = service.getStats();
	EXPECT_EQ(saturated.visibleReserve, 2);
	EXPECT_EQ(saturated.visibleOutstanding, 2);
	EXPECT_EQ(saturated.backgroundOutstanding, 6);
	EXPECT_EQ(saturated.outstanding, 8);
	EXPECT_EQ(service.drainCompletions(8), 8);
	service.shutdown();
}

TEST(MonsterComputeServiceTest, DrainsVisibleCompletionsAtAThreeToOneRatio) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.capacity = 8;
	config.hardwareConcurrency = 2;
	service.start(config);

	std::vector<MonsterComputePriority> drained;
	const auto submit = [&service, &drained](MonsterComputePriority priority) {
		return service.submit(
			priority, [&drained, priority](MonsterComputeToken, std::stop_token) {
				return [&drained, priority] { drained.emplace_back(priority); };
			},
			"MonsterComputeServiceTest::completionPriority"
		);
	};

	EXPECT_TRUE(submit(MonsterComputePriority::Background).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Visible).accepted());
	EXPECT_TRUE(submit(MonsterComputePriority::Background).accepted());

	EXPECT_EQ(service.drainCompletions(6), 6);
	EXPECT_EQ(drained, (std::vector {
						   MonsterComputePriority::Visible,
						   MonsterComputePriority::Visible,
						   MonsterComputePriority::Visible,
						   MonsterComputePriority::Background,
						   MonsterComputePriority::Visible,
						   MonsterComputePriority::Background,
					   }));
	service.shutdown();
}

TEST(MonsterComputeServiceTest, HoldsCapacityTokensUntilInlineCompletionsAreConsumed) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.configuredThreads = 0;
	config.capacity = 2;
	config.hardwareConcurrency = 2;
	service.start(config);

	int committed = 0;
	const auto submit = [&service, &committed] {
		return service.submit(
			MonsterComputePriority::Visible,
			[&committed](MonsterComputeToken token, std::stop_token) {
				EXPECT_NE(token, 0);
				return [&committed] { ++committed; };
			},
			"MonsterComputeServiceTest::inline"
		);
	};

	const auto first = submit();
	const auto second = submit();
	EXPECT_EQ(first.status, MonsterComputeSubmitStatus::RanInline);
	EXPECT_EQ(second.status, MonsterComputeSubmitStatus::RanInline);
	EXPECT_NE(first.token, second.token);
	EXPECT_EQ(submit().status, MonsterComputeSubmitStatus::QueueFull);
	EXPECT_EQ(service.getStats().outstanding, 2);
	EXPECT_EQ(service.getCompletionCount(), 2);

	EXPECT_EQ(service.drainCompletions(1), 1);
	EXPECT_EQ(committed, 1);
	EXPECT_EQ(service.getStats().outstanding, 1);
	EXPECT_TRUE(submit().accepted());

	EXPECT_EQ(service.drainCompletions(8), 2);
	EXPECT_EQ(committed, 3);
	EXPECT_EQ(service.getStats().outstanding, 0);
	service.shutdown();
}

TEST(MonsterComputeServiceTest, ReleasesTokensForFailedAndEmptyCompletions) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.capacity = 2;
	config.hardwareConcurrency = 1;
	service.start(config);

	EXPECT_TRUE(service.submit(
						   MonsterComputePriority::Background, [](MonsterComputeToken, std::stop_token) -> MonsterComputeService::Completion { throw std::runtime_error("expected"); }, "MonsterComputeServiceTest::failure"
	)
	                .accepted());
	EXPECT_TRUE(service.submit(
						   MonsterComputePriority::Background, [](MonsterComputeToken, std::stop_token) { return MonsterComputeService::Completion {}; }, "MonsterComputeServiceTest::empty"
	)
	                .accepted());

	EXPECT_EQ(service.drainCompletions(2), 2);
	const auto stats = service.getStats();
	EXPECT_EQ(stats.outstanding, 0);
	EXPECT_EQ(stats.failed, 1);
	EXPECT_EQ(stats.completed, 2);
	service.shutdown();
}

TEST(MonsterComputeServiceTest, RunsFailureCompletionOnTheCompletionConsumer) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.capacity = 1;
	config.hardwareConcurrency = 1;
	service.start(config);

	bool recovered = false;
	const auto submission = service.submit(
		MonsterComputePriority::Visible,
		[](MonsterComputeToken, std::stop_token) -> MonsterComputeService::Completion {
			throw std::runtime_error("expected");
		},
		"MonsterComputeServiceTest::failureCompletion",
		[&recovered] { recovered = true; }
	);
	ASSERT_TRUE(submission.accepted());
	EXPECT_FALSE(recovered);

	EXPECT_EQ(service.drainCompletions(1), 1);
	EXPECT_TRUE(recovered);
	EXPECT_EQ(service.getStats().outstanding, 0);
	service.shutdown();
}

TEST(MonsterComputeServiceTest, CancelsQueuedAndRunningTokensDuringShutdown) {
	MonsterComputeService service;
	MonsterComputeConfig config;
	config.configuredThreads = 1;
	config.capacity = 4;
	config.hardwareConcurrency = 4;
	service.start(config);

	auto started = std::make_shared<std::promise<void>>();
	auto startedFuture = started->get_future();
	EXPECT_TRUE(service.submit(
						   MonsterComputePriority::Visible, [started](MonsterComputeToken, std::stop_token stopToken) {
		started->set_value();
		while (!stopToken.stop_requested()) {
			std::this_thread::yield();
		}
		return MonsterComputeService::Completion {}; }, "MonsterComputeServiceTest::running"
	)
	                .accepted());
	ASSERT_EQ(startedFuture.wait_for(2s), std::future_status::ready);
	EXPECT_TRUE(service.submit(
						   MonsterComputePriority::Background, [](MonsterComputeToken, std::stop_token) { return MonsterComputeService::Completion {}; }, "MonsterComputeServiceTest::queued"
	)
	                .accepted());

	service.shutdown();
	const auto stats = service.getStats();
	EXPECT_FALSE(stats.running);
	EXPECT_EQ(stats.outstanding, 0);
	EXPECT_EQ(stats.canceled, 2);
}
