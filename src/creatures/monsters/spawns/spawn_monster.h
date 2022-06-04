/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_CREATURES_MONSTERS_SPAWNS_SPAWN_MONSTER_H_
#define SRC_CREATURES_MONSTERS_SPAWNS_SPAWN_MONSTER_H_

#include "items/tile.h"
#include "game/movement/position.h"

class Monster;
class MonsterType;

struct spawnBlock_t {
	Position pos;
	MonsterType* monsterType;
	int64_t lastSpawn;
	uint32_t interval;
	Direction direction;
};

class SpawnMonster
{
	public:
		SpawnMonster(Position initPos, int32_t initRadius) : centerPos(std::move(initPos)), radius(initRadius) {}
		~SpawnMonster();

		// non-copyable
		SpawnMonster(const SpawnMonster&) = delete;
		SpawnMonster& operator=(const SpawnMonster&) = delete;

		bool addMonster(const std::string& name, const Position& pos, Direction dir, uint32_t interval);
		void removeMonster(Monster* monster);

		uint32_t getInterval() const {
			return interval;
		}
		void startup();

		void startSpawnMonsterCheck();
		void stopEvent();

		bool isInSpawnMonsterZone(const Position& pos);
		void cleanup();

	private:
		//map of the spawned creatures
		using SpawnedMap = std::multimap<uint32_t, Monster*>;
		using spawned_pair = SpawnedMap::value_type;
		SpawnedMap spawnedMonsterMap;

		//map of creatures in the spawn
		std::map<uint32_t, spawnBlock_t> spawnMonsterMap;

		Position centerPos;
		int32_t radius;

		uint32_t interval = 30000;
		uint32_t checkSpawnMonsterEvent = 0;

		static bool findPlayer(const Position& pos);
		bool spawnMonster(uint32_t spawnMonsterId, MonsterType* monsterType, const Position& pos, Direction dir, bool startup = false);
		void checkSpawnMonster();
		void scheduleSpawn(uint32_t spawnMonsterId, spawnBlock_t& sb, uint16_t interval);
};

class SpawnsMonster
{
	public:
		static bool isInZone(const Position& centerPos, int32_t radius, const Position& pos);

		bool loadFromXML(const std::string& filemonstername);
		void startup();
		void clear();

		bool isStarted() const {
			return started;
		}
		bool isLoaded() const {
			return loaded;
		}
		std::forward_list<SpawnMonster>& getspawnMonsterList() {
			return spawnMonsterList;
		}

	private:
		std::forward_list<SpawnMonster> spawnMonsterList;
		std::string filemonstername;
		bool loaded = false;
		bool started = false;
};

static constexpr int32_t NONBLOCKABLE_SPAWN_MONSTER_INTERVAL = 1400;

#endif  // SRC_CREATURES_MONSTERS_SPAWNS_SPAWN_MONSTER_H_
