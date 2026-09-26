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

extern int64_t OTSYSTIME;

namespace {
	constexpr uint64_t T = 10'000'000'000;
	constexpr uint32_t OLD_IP = 0x0A000001;
	constexpr uint32_t RECENT_IP = 0x0A000002;
	constexpr uint32_t OTHER_IP = 0x0A000003;
}

class IpThrottlePruneTest : public ::testing::Test {
protected:
	void TearDown() override {
		ProtocolStatus::ipConnectMap.clear();
		ProtocolStatus::lastPrune = 0;
	}
};

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
	ban.lastPrune = T;

	OTSYSTIME = static_cast<int64_t>(T - 3'600'000);
	ban.acceptConnection(OTHER_IP);

	EXPECT_TRUE(ban.ipConnectMap.contains(RECENT_IP));
}

// After a backward step the status sweep restarts its schedule instead of
// waiting for the clock to catch up with the last sweep.
TEST_F(IpThrottlePruneTest, StatusSweepRestartsAfterABackwardClockStep) {
	const auto now = static_cast<int64_t>(T);
	ProtocolStatus::lastPrune = now + 3'600'000;
	ProtocolStatus::ipConnectMap[OLD_IP] = now - 3'600'000;

	ProtocolStatus::pruneStaleEntries(now);

	EXPECT_FALSE(ProtocolStatus::ipConnectMap.contains(OLD_IP));
	EXPECT_EQ(ProtocolStatus::lastPrune, now);
}
