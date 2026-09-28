/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#define private public
#include "creatures/players/management/ban.hpp"
#include "server/network/protocol/protocolstatus.hpp"
#undef private
#include "config/configmanager.hpp"

extern int64_t OTSYSTIME;

namespace {
	constexpr uint64_t T = 10'000'000'000;
	constexpr uint32_t OLD_IP = 0x0A000001;
	constexpr uint32_t RECENT_IP = 0x0A000002;
	constexpr uint32_t OTHER_IP = 0x0A000003;
}

class IpThrottlePruneTest : public ::testing::Test {
protected:
	int64_t originalSystemTime {};

	void SetUp() override {
		originalSystemTime = OTSYSTIME;
	}

	void TearDown() override {
		ProtocolStatus::ipConnectMap.clear();
		OTSYSTIME = originalSystemTime;
	}
};

namespace {
	// Large enough that a full sweep and a bounded step are clearly different.
	constexpr uint32_t STALE_ENTRIES = 10'000;
	// Upper bound the tests accept for one callback. The implementation's budget
	// must stay at or below it.
	constexpr size_t MAX_ENTRIES_PER_CALL = 64;
}

TEST_F(IpThrottlePruneTest, BanDropsEntriesThatCanNoLongerAffectADecision) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	ban.ipConnectMap.emplace(OLD_IP, ConnectBlock(T - 60'000, 0, 1));
	ban.ipConnectMap.emplace(RECENT_IP, ConnectBlock(T - 1'000, 0, 3));

	ban.acceptConnection(OTHER_IP);

	EXPECT_FALSE(ban.ipConnectMap.contains(OLD_IP));
	EXPECT_TRUE(ban.ipConnectMap.contains(RECENT_IP));
	EXPECT_TRUE(ban.ipConnectMap.contains(OTHER_IP));
}

TEST_F(IpThrottlePruneTest, BanKeepsActiveBlocks) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	ban.ipConnectMap.emplace(OLD_IP, ConnectBlock(T - 60'000, T + 3'000, 0));

	ban.acceptConnection(OTHER_IP);

	EXPECT_TRUE(ban.ipConnectMap.contains(OLD_IP));
}

// The system clock can step backward. An attempt recorded before the step is
// still recent for acceptConnection() (its signed difference is negative, so it
// counts inside the burst window), so pruning must not drop it.
TEST_F(IpThrottlePruneTest, BanKeepsAttemptsRecordedBeforeABackwardClockStep) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	ban.acceptConnection(RECENT_IP);

	OTSYSTIME = static_cast<int64_t>(T - 3'600'000);
	ban.acceptConnection(OTHER_IP);

	EXPECT_TRUE(ban.ipConnectMap.contains(RECENT_IP));
}

// The status throttle uses a signed difference, so a query recorded before a
// backward clock step still throttles until its timeout elapses: it must stay.
TEST_F(IpThrottlePruneTest, StatusKeepsQueriesRecordedBeforeABackwardClockStep) {
	const auto now = static_cast<int64_t>(T);
	ProtocolStatus::ipConnectMap[RECENT_IP] = now + 3'600'000;

	ProtocolStatus::pruneStaleEntries(now);

	EXPECT_TRUE(ProtocolStatus::ipConnectMap.contains(RECENT_IP));
}

// The maintainer's point on the first version: the 60 s interval limited how often
// a sweep started, not how long it ran, and a full sweep of a large map ran inside
// a network callback (the Ban one while holding its mutex). One call may only
// examine a bounded number of entries.
TEST_F(IpThrottlePruneTest, BanExaminesABoundedNumberOfEntriesPerCall) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	for (uint32_t ip = 1; ip <= STALE_ENTRIES; ++ip) {
		ban.ipConnectMap.emplace(ip, ConnectBlock(T - 60'000, 0, 1));
	}

	ban.acceptConnection(0xFFFFFFF0);

	EXPECT_GE(ban.ipConnectMap.size(), STALE_ENTRIES + 1 - MAX_ENTRIES_PER_CALL);
}

TEST_F(IpThrottlePruneTest, StatusExaminesABoundedNumberOfEntriesPerCall) {
	const auto now = static_cast<int64_t>(T);
	for (uint32_t ip = 1; ip <= STALE_ENTRIES; ++ip) {
		ProtocolStatus::ipConnectMap[ip] = now - 3'600'000;
	}

	ProtocolStatus::pruneStaleEntries(now);

	EXPECT_GE(ProtocolStatus::ipConnectMap.size(), STALE_ENTRIES - MAX_ENTRIES_PER_CALL);
}

// Bounded steps must still reclaim everything: each call resumes where the last
// one stopped and wraps at the end of the map, so every stale entry is reached,
// including those with keys below the resume point. Fresh entries survive.
TEST_F(IpThrottlePruneTest, BanStepsReclaimTheWholeMapAndKeepFreshEntries) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	for (uint32_t ip = 1; ip <= STALE_ENTRIES; ++ip) {
		ban.ipConnectMap.emplace(ip, ConnectBlock(T - 60'000, 0, 1));
	}
	ban.ipConnectMap.emplace(STALE_ENTRIES / 2 + 1'000'000, ConnectBlock(T - 1'000, 0, 3));

	for (uint32_t call = 0; call < STALE_ENTRIES; ++call) {
		ban.acceptConnection(0xFFFFFFF0);
	}

	EXPECT_EQ(ban.ipConnectMap.size(), 2U); // the fresh entry and the caller's own
	EXPECT_TRUE(ban.ipConnectMap.contains(STALE_ENTRIES / 2 + 1'000'000));
	EXPECT_TRUE(ban.ipConnectMap.contains(0xFFFFFFF0));
}

TEST_F(IpThrottlePruneTest, StatusStepsReclaimTheWholeMapAndKeepFreshEntries) {
	const auto now = static_cast<int64_t>(T);
	// Built around whatever timeout is configured (unit tests run without
	// config.lua, so it is not the 5000 ms default): the fresh query is 1 ms
	// inside its window, the stale ones are well past it.
	const int64_t timeout = g_configManager().getNumber(STATUSQUERY_TIMEOUT);
	for (uint32_t ip = 1; ip <= STALE_ENTRIES; ++ip) {
		ProtocolStatus::ipConnectMap[ip] = now - timeout - 3'600'000;
	}
	ProtocolStatus::ipConnectMap[OTHER_IP] = now - timeout + 1;

	for (uint32_t call = 0; call < STALE_ENTRIES; ++call) {
		ProtocolStatus::pruneStaleEntries(now);
	}

	EXPECT_EQ(ProtocolStatus::ipConnectMap.size(), 1U);
	EXPECT_TRUE(ProtocolStatus::ipConnectMap.contains(OTHER_IP));
}

// A step that restarted from the beginning every time would keep examining the
// same live entries at the low end and never reach the stale ones behind them.
// The resume point is what guarantees progress: more live entries than one call
// examines, all stale entries after them.
TEST_F(IpThrottlePruneTest, BanStepsResumeInsteadOfRestartingAtTheBeginning) {
	Ban ban;
	OTSYSTIME = static_cast<int64_t>(T);
	constexpr uint32_t LIVE = MAX_ENTRIES_PER_CALL * 4;
	for (uint32_t ip = 1; ip <= LIVE; ++ip) {
		ban.ipConnectMap.emplace(ip, ConnectBlock(T - 60'000, T + 3'600'000, 0)); // active block
	}
	for (uint32_t ip = LIVE + 1; ip <= LIVE + 1'000; ++ip) {
		ban.ipConnectMap.emplace(ip, ConnectBlock(T - 60'000, 0, 1));
	}

	for (uint32_t call = 0; call < 1'000; ++call) {
		ban.acceptConnection(0xFFFFFFF0);
	}

	EXPECT_EQ(ban.ipConnectMap.size(), LIVE + 1U);
}

TEST_F(IpThrottlePruneTest, StatusStepsResumeInsteadOfRestartingAtTheBeginning) {
	const auto now = static_cast<int64_t>(T);
	const int64_t timeout = g_configManager().getNumber(STATUSQUERY_TIMEOUT);
	constexpr uint32_t LIVE = MAX_ENTRIES_PER_CALL * 4;
	for (uint32_t ip = 1; ip <= LIVE; ++ip) {
		ProtocolStatus::ipConnectMap[ip] = now - timeout + 1;
	}
	for (uint32_t ip = LIVE + 1; ip <= LIVE + 1'000; ++ip) {
		ProtocolStatus::ipConnectMap[ip] = now - timeout - 3'600'000;
	}

	for (uint32_t call = 0; call < 1'000; ++call) {
		ProtocolStatus::pruneStaleEntries(now);
	}

	EXPECT_EQ(ProtocolStatus::ipConnectMap.size(), LIVE);
}
