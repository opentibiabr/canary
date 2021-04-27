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

#ifndef FS_SPAWN_NPC_H_
#define FS_SPAWN_NPC_H_

#include "../../../items/tile.h"
#include "../../../game/movement/position.h"

class Npc;
class NpcType;

struct spawnBlockNpc_t {
	Position pos;
	NpcType* npcType;
	int64_t lastSpawnNpc;
	uint32_t interval;
	Direction direction;
};

class SpawnNpc
{
	public:
		SpawnNpc(Position initPos, int32_t initRadius) : centerPos(std::move(initPos)), radius(initRadius) {}
		~SpawnNpc();

		// non-copyable
		SpawnNpc(const SpawnNpc&) = delete;
		SpawnNpc& operator=(const SpawnNpc&) = delete;

		bool addNpc(const std::string& name, const Position& pos, Direction dir, uint32_t interval);
		void removeNpc(Npc* npc);

		uint32_t getInterval() const {
			return interval;
		}
		void startup();

		void startSpawnNpcCheck();
		void stopEvent();

		bool isInSpawnNpcZone(const Position& pos);
		void cleanup();

	private:
		//map of the spawned npcs
		using SpawnedNpcMap = std::multimap<uint32_t, Npc*>;
		using spawned_pair = SpawnedNpcMap::value_type;
		SpawnedNpcMap spawnedNpcMap;

		//map of npcs in the spawn
		std::map<uint32_t, spawnBlockNpc_t> spawnNpcMap;

		Position centerPos;
		int32_t radius;

		uint32_t interval = 60000;
		uint32_t checkSpawnNpcEvent = 0;

		static bool findPlayer(const Position& pos);
		bool spawnNpc(uint32_t spawnId, NpcType* npcType, const Position& pos, Direction dir, bool startup = false);
		void checkSpawnNpc();
		void scheduleSpawnNpc(uint32_t spawnId, spawnBlockNpc_t& sb, uint16_t interval);
};

class SpawnsNpc
{
	public:
		static bool isInZone(const Position& centerPos, int32_t radius, const Position& pos);

		bool loadFromXml(const std::string& filenpcname);
		void startup();
		void clear();

		bool isStarted() const {
			return started;
		}
		bool isLoaded() const {
			return loaded;
		}
		std::forward_list<SpawnNpc>& getSpawnNpcList() {
			return spawnNpcList;
		}

	private:
		std::forward_list<SpawnNpc> spawnNpcList;
		std::string filenpcname;
		bool loaded = false;
		bool started = false;
};

static constexpr int32_t NONBLOCKABLE_SPAWN_NPC_INTERVAL = 1400;

#endif
