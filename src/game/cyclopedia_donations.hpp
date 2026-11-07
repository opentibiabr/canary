/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "game/movement/position.hpp"
#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <map>
	#include <memory>
	#include <string>
#endif

class Player;

// World-owned state. No timers, retained players or cross-world mutable cache.
class CyclopediaDonations {
public:
	CyclopediaDonations() = default;
	static constexpr uint64_t threshold = 10000000;
	struct Entry {
		uint64_t amount = 0;
		bool active = false;
	};
	bool load();
	const std::map<uint16_t, Entry> &entries();
	std::string donate(const std::shared_ptr<Player> &player, uint16_t area, uint32_t amount);
	bool advance();
	bool improved(const Position &position);
	bool hasActive() const;
	void broadcast();

private:
	bool loaded = false;
	uint64_t retryAfter = 0;
	std::map<uint16_t, Entry> state;
};
