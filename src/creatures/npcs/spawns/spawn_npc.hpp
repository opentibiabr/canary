/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"

class Npc;
class NpcType;

struct spawnBlockNpc_t {
	Position pos;
	std::shared_ptr<NpcType> npcType;
	int64_t lastSpawnNpc;
	uint32_t interval;
	Direction direction;
};

class SpawnNpc final : public SharedObject {
public:
	SpawnNpc(Position initPos, int32_t initRadius) :
		centerPos(initPos), radius(initRadius) { }
	~SpawnNpc() override;

	// non-copyable
	SpawnNpc(const SpawnNpc &) = delete;
	SpawnNpc &operator=(const SpawnNpc &) = delete;

	bool addNpc(const std::string &name, const Position &pos, Direction dir, uint32_t interval);
	void removeNpc(const std::shared_ptr<Npc> &npc);

	uint32_t getInterval() const;
	void startup();

	void startSpawnNpcCheck();
	void stopEvent();

	bool isInSpawnNpcZone(const Position &pos) const;
	void cleanup();

private:
	// map of the spawned npcs
	using SpawnedNpcMap = std::multimap<uint32_t, std::shared_ptr<Npc>>;
	using spawned_pair = SpawnedNpcMap::value_type;
	SpawnedNpcMap spawnedNpcMap;

	// map of npcs in the spawn
	std::map<uint32_t, spawnBlockNpc_t> spawnNpcMap;

	Position centerPos;
	int32_t radius;

	uint32_t interval = 60000;
	uint32_t checkSpawnNpcEvent = 0;

	static bool findPlayer(const Position &pos);
	bool spawnNpc(uint32_t spawnId, const std::shared_ptr<NpcType> &npcType, const Position &pos, Direction dir, bool startup = false);
	void checkSpawnNpc();
	void scheduleSpawnNpc(uint32_t spawnId, spawnBlockNpc_t &sb, uint16_t interval);
};

class SpawnsNpc {
public:
	static bool isInZone(const Position &centerPos, int32_t radius, const Position &pos);

	bool loadFromXml(const std::string &filenpcname);
	void startup();
	void clear();

	bool isStarted() const;
	bool setStarted(bool setStarted);

	bool isLoaded() const;
	bool setLoaded(bool setLoaded);

	std::string setFileName(std::string setName);

	std::vector<std::shared_ptr<SpawnNpc>> &getSpawnNpcList();

private:
	std::vector<std::shared_ptr<SpawnNpc>> spawnNpcList;
	std::string fileName;
	bool loaded = false;
	bool started = false;
};

static constexpr int32_t NONBLOCKABLE_SPAWN_NPC_INTERVAL = 1400;
