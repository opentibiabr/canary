/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "pch.hpp"
#include <concepts>
#include <utility>

class Creature;
class Player;
struct Position;

// #define SPECTATORS_USE_HASHSET

#ifdef SPECTATORS_USE_HASHSET
using SpectatorList = phmap::flat_hash_set<Creature*>;
#else
using SpectatorList = std::vector<Creature*>;
#endif

class Spectators {
public:
	static void clearCache();

	template <typename T, typename std::enable_if<std::is_same<Creature, T>::value || std::is_same<Player, T>::value>::type* = nullptr>
	Spectators find(const Position &centerPos, bool multifloor = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0) {
		const bool onlyPlayers = std::is_same_v<T, Player>;
		return find(centerPos, multifloor, onlyPlayers, minRangeX, maxRangeX, minRangeY, maxRangeY);
	}

	template <typename T, typename std::enable_if<std::is_base_of<Creature, T>::value>::type* = nullptr>
	Spectators filter();

	bool contains(const Creature* creature) const;

	bool erase(const Creature* creature);

	template <class F>
	bool erase_if(F fnc) {
#ifdef SPECTATORS_USE_HASHSET
		return phmap::erase_if(creatures, std::move(fnc)) > 0;
#else
		return std::erase_if(creatures, std::move(fnc)) > 0;
#endif
	}

	void insert(Creature* creature);

	bool empty() const {
		return creatures.empty();
	}

	size_t size() const {
		return creatures.size();
	}

	auto begin() {
		update();
		return creatures.begin();
	}

	auto end() {
		return creatures.end();
	}

private:
	Spectators find(const Position &centerPos, bool multifloor = false, bool onlyPlayers = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0);
	void update();

	SpectatorList creatures;
	bool needUpdate = false;
};

template <typename T, typename std::enable_if<std::is_base_of<Creature, T>::value>::type*>
Spectators Spectators::filter() {
	update();
	auto specs = Spectators();
	for (const auto &c : creatures) {
		if (std::is_same_v<T, Player> && c->getPlayer() || std::is_same_v<T, Monster> && c->getMonster() || std::is_same_v<T, Npc> && c->getNpc()) {
#ifdef SPECTATORS_USE_HASHSET
			specs.creatures.emplace(c);
#else
			specs.creatures.emplace_back(c);
#endif
		}
	}

	return specs;
}
