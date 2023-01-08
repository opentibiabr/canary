/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_H_
#define SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_H_

#include "game/movement/position.h"
#include "items/tile.h"

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
		bool setStarted(bool setStarted) {
			return started = setStarted;
		}
		
		bool isLoaded() const {
			return loaded;
		}
		bool setLoaded(bool setLoaded) {
			return loaded = setLoaded;
		}

		std::string setFileName(std::string setName) {
			return fileName = setName;
		}

		std::forward_list<SpawnNpc>& getSpawnNpcList() {
			return spawnNpcList;
		}

	private:
		std::forward_list<SpawnNpc> spawnNpcList;
		std::string fileName;
		bool loaded = false;
		bool started = false;
};

static constexpr int32_t NONBLOCKABLE_SPAWN_NPC_INTERVAL = 1400;

#endif  // SRC_CREATURES_NPCS_SPAWNS_SPAWN_NPC_H_
