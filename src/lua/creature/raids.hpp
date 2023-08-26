/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "game/movement/position.hpp"
#include "lua/global/baseevents.hpp"

struct MonsterSpawn {
	MonsterSpawn(std::string initName, uint32_t initMinAmount, uint32_t initMaxAmount) :
		name(std::move(initName)), minAmount(initMinAmount), maxAmount(initMaxAmount) { }

	std::string name;
	uint32_t minAmount;
	uint32_t maxAmount;
};

// How many times it will try to find a tile to add the monster to before giving up
static constexpr int32_t MAXIMUM_TRIES_PER_MONSTER = 10;
static constexpr int32_t CHECK_RAIDS_INTERVAL = 60;
static constexpr int32_t RAID_MINTICKS = 1000;

class Raid;
class RaidEvent;

class Raids {
public:
	Raids();
	~Raids() = default;

	// non-copyable
	Raids(const Raids &) = delete;
	Raids &operator=(const Raids &) = delete;

	bool loadFromXml();
	bool startup();

	void clear();
	bool reload();

	bool isLoaded() const {
		return loaded;
	}
	bool isStarted() const {
		return started;
	}

	std::shared_ptr<Raid> getRunning() {
		return running;
	}
	void setRunning(const std::shared_ptr<Raid> newRunning) {
		running = newRunning;
	}

	std::shared_ptr<Raid> getRaidByName(const std::string &name);

	uint64_t getLastRaidEnd() const {
		return lastRaidEnd;
	}
	void setLastRaidEnd(uint64_t newLastRaidEnd) {
		lastRaidEnd = newLastRaidEnd;
	}

	void checkRaids();

	LuaScriptInterface &getScriptInterface() {
		return scriptInterface;
	}

private:
	LuaScriptInterface scriptInterface { "Raid Interface" };

	std::list<std::shared_ptr<Raid>> raidList;
	std::shared_ptr<Raid> running = nullptr;
	uint64_t lastRaidEnd = 0;
	uint32_t checkRaidsEvent = 0;
	bool loaded = false;
	bool started = false;
};

class Raid {
public:
	Raid(std::string initName, uint32_t initInterval, uint32_t initMarginTime, bool initRepeat) :
		name(std::move(initName)), interval(initInterval), margin(initMarginTime), repeat(initRepeat) { }
	~Raid() = default;

	// non-copyable
	Raid(const Raid &) = delete;
	Raid &operator=(const Raid &) = delete;

	bool loadFromXml(const std::string &filename);

	void startRaid();

	void executeRaidEvent(const std::shared_ptr<RaidEvent> raidEvent);
	void resetRaid();

	std::shared_ptr<RaidEvent> getNextRaidEvent();
	void setState(RaidState_t newState) {
		state = newState;
	}
	const std::string &getName() const {
		return name;
	}

	bool isLoaded() const {
		return loaded;
	}
	uint64_t getMargin() const {
		return margin;
	}
	uint32_t getInterval() const {
		return interval;
	}
	bool canBeRepeated() const {
		return repeat;
	}

	void stopEvents();

private:
	std::vector<std::shared_ptr<RaidEvent>> raidEvents;
	std::string name;
	uint32_t interval;
	uint32_t nextEvent = 0;
	uint64_t margin;
	RaidState_t state = RAIDSTATE_IDLE;
	uint32_t nextEventEvent = 0;
	bool loaded = false;
	bool repeat;
};

class RaidEvent {
public:
	virtual ~RaidEvent() = default;

	virtual bool configureRaidEvent(const pugi::xml_node &eventNode);

	virtual bool executeEvent() = 0;
	uint32_t getDelay() const {
		return delay;
	}

private:
	uint32_t delay;
};

class AnnounceEvent final : public RaidEvent {
public:
	AnnounceEvent() = default;

	bool configureRaidEvent(const pugi::xml_node &eventNode) override;

	bool executeEvent() override;

private:
	std::string message;
	MessageClasses messageType = MESSAGE_EVENT_ADVANCE;
};

class SingleSpawnEvent final : public RaidEvent {
public:
	bool configureRaidEvent(const pugi::xml_node &eventNode) override;

	bool executeEvent() override;

private:
	std::string monsterName;
	Position position;
};

class AreaSpawnEvent final : public RaidEvent {
public:
	bool configureRaidEvent(const pugi::xml_node &eventNode) override;

	bool executeEvent() override;

private:
	std::list<MonsterSpawn> spawnMonsterList;
	Position fromPos, toPos;
};

class ScriptEvent final : public RaidEvent, public Event {
public:
	explicit ScriptEvent(LuaScriptInterface* interface) :
		Event(interface) { }

	bool configureRaidEvent(const pugi::xml_node &eventNode) override;
	bool configureEvent(const pugi::xml_node &) override {
		return false;
	}

	std::string &getScriptName() {
		return scriptName;
	}
	void setScriptName(std::string name) {
		scriptName = name;
	}

	bool executeEvent() override;

private:
	std::string getScriptEventName() const override;
	std::string scriptName;
};
