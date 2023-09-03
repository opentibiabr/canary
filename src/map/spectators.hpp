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

class Creature;
class Player;
class Monster;
class Npc;
struct Position;

#ifdef SPECTATORS_USE_HASHSET
// it is slower by 51~99% in certain cases
using SpectatorList = phmap::flat_hash_set<Creature*>;
#else
using SpectatorList = std::vector<Creature*>;
#endif

class Spectators {
public:
	static void clearCache();

	template <typename T, typename std::enable_if_t<std::is_same_v<Creature, T> || std::is_same_v<Player, T>>* = nullptr>
	Spectators find(const Position &centerPos, bool multifloor = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0) {
		constexpr bool onlyPlayers = std::is_same_v<T, Player>;
		return find(centerPos, multifloor, onlyPlayers, minRangeX, maxRangeX, minRangeY, maxRangeY);
	}

	template <typename T, typename std::enable_if_t<std::is_base_of_v<Creature, T>>* = nullptr>
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

template <typename T, typename std::enable_if<std::is_base_of_v<Creature, T>>::type*>
Spectators Spectators::filter() {
	update();
	auto specs = Spectators();
	for (const auto &c : creatures) {
		bool insert = false;
		if constexpr (std::is_same_v<T, Player>) {
			insert = c->getPlayer() != nullptr;
		} else if constexpr (std::is_same_v<T, Monster>) {
			insert = c->getMonster() != nullptr;
		} else if constexpr (std::is_same_v<T, Npc>) {
			insert = c->getNpc() != nullptr;
		}

		if (insert) {
#ifdef SPECTATORS_USE_HASHSET
			specs.creatures.emplace(c);
#else
			specs.creatures.emplace_back(c);
#endif
		}
	}

	return specs;
}
