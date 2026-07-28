/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher_wdrr.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

std::optional<DispatcherLane> DispatcherWeightedDeficitRoundRobin::selectLane(const ReadySet &ready, const ValueSet &quantums, const ValueSet &nextCosts) {
	for (size_t attempt = 0; attempt < LANE_COUNT * MAX_TASK_COST; ++attempt) {
		const size_t index = cursor;
		const auto cost = std::clamp<uint32_t>(nextCosts[index], 1, MAX_TASK_COST);
		if (!ready[index]) {
			deficits[index] = 0;
			currentLaneActive = false;
			cursor = (cursor + 1) % LANE_COUNT;
			continue;
		}

		if (!currentLaneActive) {
			const uint32_t quantum = std::clamp<uint32_t>(quantums[index], 1, MAX_TASK_COST);
			deficits[index] = std::min(deficits[index], MAX_DEFICIT);
			deficits[index] += std::min(quantum, MAX_DEFICIT - deficits[index]);
			currentLaneActive = true;
		}

		if (deficits[index] >= cost) {
			return static_cast<DispatcherLane>(index);
		}

		currentLaneActive = false;
		cursor = (cursor + 1) % LANE_COUNT;
	}
	return std::nullopt;
}

void DispatcherWeightedDeficitRoundRobin::consume(DispatcherLane lane, uint32_t cost) {
	auto &deficit = deficits[static_cast<size_t>(lane)];
	deficit -= std::min(deficit, std::clamp<uint32_t>(cost, 1, MAX_TASK_COST));
}

void DispatcherWeightedDeficitRoundRobin::resetLane(DispatcherLane lane) {
	const auto laneId = static_cast<size_t>(lane);
	deficits[laneId] = 0;
	if (laneId == cursor) {
		currentLaneActive = false;
		cursor = (cursor + 1) % LANE_COUNT;
	}
}

uint32_t DispatcherWeightedDeficitRoundRobin::agedQuantum(uint32_t baseQuantum, std::chrono::microseconds oldestReadyAge, std::chrono::microseconds slo) {
	baseQuantum = std::clamp<uint32_t>(baseQuantum, 1, MAX_TASK_COST);
	slo = std::max(std::chrono::microseconds(1), slo);
	if (oldestReadyAge < slo) {
		return baseQuantum;
	}
	return std::min<uint32_t>(MAX_TASK_COST, baseQuantum * 2);
}
