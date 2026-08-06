/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/scheduling/dispatcher_types.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <chrono>
	#include <cstddef>
	#include <cstdint>
	#include <optional>
#endif

class DispatcherWeightedDeficitRoundRobin final {
public:
	static constexpr size_t LANE_COUNT = static_cast<size_t>(DispatcherLane::Last);
	using ReadySet = std::array<bool, LANE_COUNT>;
	using ValueSet = std::array<uint32_t, LANE_COUNT>;

	[[nodiscard]] std::optional<DispatcherLane> selectLane(const ReadySet &ready, const ValueSet &quantums, const ValueSet &nextCosts);
	void consume(DispatcherLane lane, uint32_t cost);
	void resetLane(DispatcherLane lane);

	[[nodiscard]] uint32_t getDeficit(DispatcherLane lane) const {
		return deficits[static_cast<size_t>(lane)];
	}

	[[nodiscard]] static uint32_t agedQuantum(uint32_t baseQuantum, std::chrono::microseconds oldestReadyAge, std::chrono::microseconds slo);

private:
	static constexpr uint32_t MAX_TASK_COST = DISPATCHER_MAX_TASK_COST;
	static constexpr uint32_t MAX_DEFICIT = MAX_TASK_COST * 4;
	std::array<uint32_t, LANE_COUNT> deficits {};
	size_t cursor = 0;
	bool currentLaneActive = false;
};
