/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <chrono>
	#include <cstdint>
	#include <limits>
#endif

enum class MonsterRelevanceTier : uint8_t {
	Background,
	Visible
};

struct MonsterRelevanceSnapshot {
	uint16_t playerSpectators = 0;
	uint16_t nearestPlayerDistance = std::numeric_limits<uint16_t>::max();
	bool engagedWithPlayer = false;
};

struct MonsterRelevanceState {
	MonsterRelevanceTier tier = MonsterRelevanceTier::Background;
	std::chrono::steady_clock::time_point visibleUntil {};
};

class MonsterRelevancePolicy final {
public:
	using Clock = std::chrono::steady_clock;

	[[nodiscard]] static MonsterRelevanceState update(
		const MonsterRelevanceState &current,
		const MonsterRelevanceSnapshot &snapshot,
		Clock::time_point now,
		std::chrono::milliseconds visibleHold = std::chrono::seconds(3)
	);
};
