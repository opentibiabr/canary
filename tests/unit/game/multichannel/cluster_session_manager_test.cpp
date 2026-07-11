/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/cluster_session_manager.hpp"

#include "../../../shared/game/multichannel/fake_redis_client.hpp"

#include <atomic>
#include <gtest/gtest.h>
#include <set>
#include <thread>
#include <vector>

class ClusterSessionManagerTest : public ::testing::Test {
protected:
	FakeRedisClient redisClient;
	ClusterSessionManager manager { redisClient };
};

TEST_F(ClusterSessionManagerTest, FirstAcquireSucceedsWithFencingTokenOne) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	EXPECT_TRUE(handle.acquired);
	EXPECT_EQ(ClusterSessionStatus::Online, handle.status);
	EXPECT_EQ(1u, handle.fencingToken);
	EXPECT_FALSE(handle.sessionId.empty());
}

TEST_F(ClusterSessionManagerTest, SecondAcquireWhileHeldIsRejected) {
	const auto first = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(first.acquired);

	const auto second = manager.acquire(42, 2, "instance-2", 30000, 1500);
	EXPECT_FALSE(second.acquired);
	EXPECT_EQ(first.sessionId, second.currentHolderSessionId);
	EXPECT_EQ(first.fencingToken, second.currentHolderFencingToken);
}

TEST_F(ClusterSessionManagerTest, DifferentAccountsDoNotContend) {
	const auto accountA = manager.acquire(1, 1, "instance-1", 30000, 1000);
	const auto accountB = manager.acquire(2, 1, "instance-1", 30000, 1000);
	EXPECT_TRUE(accountA.acquired);
	EXPECT_TRUE(accountB.acquired);
}

TEST_F(ClusterSessionManagerTest, RenewByOwnerSucceedsAndKeepsSameFencingToken) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(handle.acquired);

	EXPECT_TRUE(manager.renew(42, handle.sessionId, 30000, 5000));
	EXPECT_TRUE(manager.isFencingTokenCurrent(42, handle.fencingToken));
}

TEST_F(ClusterSessionManagerTest, RenewByNonOwnerFails) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(handle.acquired);

	EXPECT_FALSE(manager.renew(42, "not-the-real-session-id", 30000, 5000));
}

TEST_F(ClusterSessionManagerTest, RenewAfterExpiryFailsAndDoesNotResurrectLease) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(handle.acquired);

	// now = 1000 + 30000 + 1 -> past expiry
	EXPECT_FALSE(manager.renew(42, handle.sessionId, 30000, 31001));
}

TEST_F(ClusterSessionManagerTest, ReleaseByOwnerSucceeds) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(handle.acquired);
	EXPECT_TRUE(manager.release(42, handle.sessionId));

	// Lease is free again immediately.
	const auto reacquired = manager.acquire(42, 2, "instance-2", 30000, 1001);
	EXPECT_TRUE(reacquired.acquired);
}

TEST_F(ClusterSessionManagerTest, ReleaseByNonOwnerFails) {
	const auto handle = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(handle.acquired);
	EXPECT_FALSE(manager.release(42, "not-the-real-session-id"));
}

TEST_F(ClusterSessionManagerTest, FencingTokenIsMonotonicAcrossReleaseReacquireCycles) {
	const auto first = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(first.acquired);
	ASSERT_TRUE(manager.release(42, first.sessionId));

	const auto second = manager.acquire(42, 1, "instance-1", 30000, 2000);
	ASSERT_TRUE(second.acquired);
	ASSERT_TRUE(manager.release(42, second.sessionId));

	const auto third = manager.acquire(42, 1, "instance-1", 30000, 3000);
	ASSERT_TRUE(third.acquired);

	EXPECT_EQ(1u, first.fencingToken);
	EXPECT_EQ(2u, second.fencingToken);
	EXPECT_EQ(3u, third.fencingToken);
}

TEST_F(ClusterSessionManagerTest, ExpiredLeaseCanBeReacquiredWithHigherFencingToken) {
	const auto first = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(first.acquired);

	// Never released - simulates a crashed zombie process (THREAT_MODEL T2).
	const auto second = manager.acquire(42, 2, "instance-2", 30000, 31001);
	EXPECT_TRUE(second.acquired);
	EXPECT_GT(second.fencingToken, first.fencingToken);
}

TEST_F(ClusterSessionManagerTest, StaleFencingTokenIsNoLongerCurrentAfterTakeover) {
	const auto first = manager.acquire(42, 1, "instance-1", 30000, 1000);
	ASSERT_TRUE(first.acquired);
	const auto second = manager.acquire(42, 2, "instance-2", 30000, 31001);
	ASSERT_TRUE(second.acquired);

	// The zombie process from `first` must see its token as no longer
	// current - this is the check a Phase 2 save call site would perform
	// before persisting anything (THREAT_MODEL.md T2).
	EXPECT_FALSE(manager.isFencingTokenCurrent(42, first.fencingToken));
	EXPECT_TRUE(manager.isFencingTokenCurrent(42, second.fencingToken));
}

TEST_F(ClusterSessionManagerTest, ConcurrentAcquireHasExactlyOneWinner) {
	constexpr int racerCount = 16;
	std::vector<std::thread> threads;
	std::vector<ClusterSessionHandle> results(racerCount);
	std::atomic<int> readyCount { 0 };
	std::atomic<bool> go { false };

	for (int i = 0; i < racerCount; ++i) {
		threads.emplace_back([&, i] {
			readyCount.fetch_add(1);
			while (!go.load()) {
				std::this_thread::yield();
			}
			results[static_cast<std::size_t>(i)] = manager.acquire(7, i, "instance-" + std::to_string(i), 30000, 1000);
		});
	}

	while (readyCount.load() < racerCount) {
		std::this_thread::yield();
	}
	go.store(true);

	for (auto &thread : threads) {
		thread.join();
	}

	int acquiredCount = 0;
	std::set<uint64_t> fencingTokensSeen;
	for (const auto &result : results) {
		if (result.acquired) {
			++acquiredCount;
			fencingTokensSeen.insert(result.fencingToken);
		}
	}

	EXPECT_EQ(1, acquiredCount);
	EXPECT_EQ(1u, fencingTokensSeen.size());
	EXPECT_EQ(1u, *fencingTokensSeen.begin());
}

TEST(ClusterSessionTransitionTest, HappyPathIsValid) {
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Offline, ClusterSessionStatus::Acquiring));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Acquiring, ClusterSessionStatus::Online));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Online, ClusterSessionStatus::Saving));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Saving, ClusterSessionStatus::Offline));
}

TEST(ClusterSessionTransitionTest, DirtyIsReachableFromActiveStatesButOnlyLeavesViaOffline) {
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Acquiring, ClusterSessionStatus::Dirty));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Online, ClusterSessionStatus::Dirty));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Saving, ClusterSessionStatus::Dirty));
	EXPECT_TRUE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Dirty, ClusterSessionStatus::Offline));

	// No automatic escape from Dirty other than through Offline (recovery).
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Dirty, ClusterSessionStatus::Online));
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Dirty, ClusterSessionStatus::Acquiring));
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Dirty, ClusterSessionStatus::Saving));
}

TEST(ClusterSessionTransitionTest, CleanLogoutCannotSkipSaving) {
	// A clean logout must always pass through Saving; jumping straight from
	// Online to Offline would skip the "wait for committed save" invariant
	// (spec §5.2) and is rejected.
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Online, ClusterSessionStatus::Offline));
}

TEST(ClusterSessionTransitionTest, OfflineOnlyMovesForwardToAcquiring) {
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Offline, ClusterSessionStatus::Online));
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Offline, ClusterSessionStatus::Saving));
	EXPECT_FALSE(ClusterSessionManager::isValidTransition(ClusterSessionStatus::Offline, ClusterSessionStatus::Dirty));
}

TEST(ClusterSessionKeyTest, LockKeyIsScopedPerAccount) {
	EXPECT_NE(ClusterSessionManager::makeLockKey(1), ClusterSessionManager::makeLockKey(2));
	EXPECT_EQ(ClusterSessionManager::makeLockKey(1), ClusterSessionManager::makeLockKey(1));
}

TEST(ClusterSessionKeyTest, GeneratedSessionIdsAreUnique) {
	std::set<std::string> ids;
	for (int i = 0; i < 1000; ++i) {
		ids.insert(ClusterSessionManager::generateSessionId());
	}
	EXPECT_EQ(1000u, ids.size());
}
