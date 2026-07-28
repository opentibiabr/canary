/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher_wdrr.hpp"

using namespace std::chrono_literals;

TEST(DispatcherWeightedDeficitRoundRobinTest, AllocatesDeficitByLaneWeight) {
	DispatcherWeightedDeficitRoundRobin scheduler;
	DispatcherWeightedDeficitRoundRobin::ReadySet ready {};
	DispatcherWeightedDeficitRoundRobin::ValueSet quantums {};
	DispatcherWeightedDeficitRoundRobin::ValueSet costs {};
	ready[0] = true;
	ready[1] = true;
	quantums[0] = 2;
	quantums[1] = 1;
	costs.fill(1);

	EXPECT_EQ(scheduler.selectLane(ready, quantums, costs), DispatcherLane::ProtocolInput);
	EXPECT_EQ(scheduler.getDeficit(DispatcherLane::ProtocolInput), 2);
	scheduler.consume(DispatcherLane::ProtocolInput, 1);
	EXPECT_EQ(scheduler.selectLane(ready, quantums, costs), DispatcherLane::ProtocolInput);
	scheduler.consume(DispatcherLane::ProtocolInput, 1);
	EXPECT_EQ(scheduler.selectLane(ready, quantums, costs), DispatcherLane::PlayerWalk);
	EXPECT_EQ(scheduler.getDeficit(DispatcherLane::PlayerWalk), 1);
}

TEST(DispatcherWeightedDeficitRoundRobinTest, AccumulatesEnoughDeficitForCostlyTasks) {
	DispatcherWeightedDeficitRoundRobin scheduler;
	DispatcherWeightedDeficitRoundRobin::ReadySet ready {};
	DispatcherWeightedDeficitRoundRobin::ValueSet quantums {};
	DispatcherWeightedDeficitRoundRobin::ValueSet costs {};
	ready[static_cast<size_t>(DispatcherLane::Maintenance)] = true;
	quantums.fill(1);
	costs.fill(1);
	costs[static_cast<size_t>(DispatcherLane::Maintenance)] = 32;

	EXPECT_EQ(scheduler.selectLane(ready, quantums, costs), DispatcherLane::Maintenance);
	EXPECT_GE(scheduler.getDeficit(DispatcherLane::Maintenance), 32);
}

TEST(DispatcherWeightedDeficitRoundRobinTest, AgesLanesWithoutUnboundedQuantum) {
	EXPECT_EQ(DispatcherWeightedDeficitRoundRobin::agedQuantum(4, 49ms, 50ms), 4);
	EXPECT_EQ(DispatcherWeightedDeficitRoundRobin::agedQuantum(4, 50ms, 50ms), 8);
	EXPECT_EQ(DispatcherWeightedDeficitRoundRobin::agedQuantum(32, 1s, 50ms), 32);
	EXPECT_EQ(DispatcherWeightedDeficitRoundRobin::agedQuantum(100, 1s, 50ms), 32);
}
