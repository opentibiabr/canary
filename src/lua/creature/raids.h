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

#ifndef SRC_LUA_CREATURE_RAIDS_H_
#define SRC_LUA_CREATURE_RAIDS_H_

#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "game/movement/position.h"
#include "lua/global/baseevents.h"

struct MonsterSpawn {
	MonsterSpawn(std::string initName, uint32_t initMinAmount, uint32_t initMaxAmount) :
		name(std::move(initName)), minAmount(initMinAmount), maxAmount(initMaxAmount) {}

	std::string name;
	uint32_t minAmount;
	uint32_t maxAmount;
};

//How many times it will try to find a tile to add the monster to before giving up
static constexpr int32_t MAXIMUM_TRIES_PER_MONSTER = 10;
static constexpr int32_t CHECK_RAIDS_INTERVAL = 60;
static constexpr int32_t RAID_MINTICKS = 1000;

class Raid;
class RaidEvent;

class Raids {
	public:
		Raids();
		~Raids();

		// non-copyable
		Raids(const Raids&) = delete;
		Raids& operator=(const Raids&) = delete;

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

		Raid* getRunning() {
			return running;
		}
		void setRunning(Raid* newRunning) {
			running = newRunning;
		}

		Raid* getRaidByName(const std::string& name);

		uint64_t getLastRaidEnd() const {
			return lastRaidEnd;
		}
		void setLastRaidEnd(uint64_t newLastRaidEnd) {
			lastRaidEnd = newLastRaidEnd;
		}

		void checkRaids();

		LuaScriptInterface& getScriptInterface() {
			return scriptInterface;
		}

	private:
		LuaScriptInterface scriptInterface{"Raid Interface"};

		std::list<Raid*> raidList;
		Raid* running = nullptr;
		uint64_t lastRaidEnd = 0;
		uint32_t checkRaidsEvent = 0;
		bool loaded = false;
		bool started = false;
};

class Raid {
	public:
		Raid(std::string initName, uint32_t initInterval, uint32_t initMarginTime, bool initRepeat) :
			name(std::move(initName)), interval(initInterval), margin(initMarginTime), repeat(initRepeat) {}
		~Raid();

		// non-copyable
		Raid(const Raid&) = delete;
		Raid& operator=(const Raid&) = delete;

		bool loadFromXml(const std::string& filename);

		void startRaid();

		void executeRaidEvent(RaidEvent* raidEvent);
		void resetRaid();

		RaidEvent* getNextRaidEvent();
		void setState(RaidState_t newState) {
			state = newState;
		}
		const std::string& getName() const {
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
		std::vector<RaidEvent*> raidEvents;
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

		virtual bool configureRaidEvent(const pugi::xml_node& eventNode);

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

		bool configureRaidEvent(const pugi::xml_node& eventNode) override;

		bool executeEvent() override;

	private:
		std::string message;
		MessageClasses messageType = MESSAGE_EVENT_ADVANCE;
};

class SingleSpawnEvent final : public RaidEvent {
	public:
		bool configureRaidEvent(const pugi::xml_node& eventNode) override;

		bool executeEvent() override;

	private:
		std::string monsterName;
		Position position;
};

class AreaSpawnEvent final : public RaidEvent {
	public:
		bool configureRaidEvent(const pugi::xml_node& eventNode) override;

		bool executeEvent() override;

	private:
		std::list<MonsterSpawn> spawnMonsterList;
		Position fromPos, toPos;
};

class ScriptEvent final : public RaidEvent, public Event {
	public:
		explicit ScriptEvent(LuaScriptInterface* interface) : Event(interface) {}

		bool configureRaidEvent(const pugi::xml_node& eventNode) override;
		bool configureEvent(const pugi::xml_node&) override {
			return false;
		}

		std::string& getScriptName() {
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

#endif  // SRC_LUA_CREATURE_RAIDS_H_
