/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/di/container.hpp"
#include "utils/tools.hpp"

struct EventScheduler {
	std::string name;
	int startDays;
	int endDays;
};

struct EventRates {
	uint16_t exprate = 100;
	uint32_t lootrate = 100;
	uint32_t bosslootrate = 100;
	uint32_t spawnrate = 100;
	uint16_t skillrate = 100;
	uint8_t forgeChance = 100;
	uint8_t bosscooldown = 100;
	bool doubleBestiary {};
	bool doubleBossTiary {};
	bool fastExercise {};
};

class EventsScheduler {
public:
	EventsScheduler() = default;

	// Singleton - ensures we don't accidentally copy it.
	EventsScheduler(const EventsScheduler &) = delete;
	EventsScheduler &operator=(const EventsScheduler &) = delete;

	static EventsScheduler &getInstance() {
		return inject<EventsScheduler>();
	}

	bool loadScheduleEventFromJson();

	// Event schedule xml load
	bool loadScheduleEventFromXml();

	// Event schedule
	uint16_t getExpSchedule() const {
		return expSchedule;
	}
	void setExpSchedule(uint16_t exprate) {
		expSchedule = (expSchedule * exprate) / 100;
	}

	uint32_t getLootSchedule() const {
		return lootSchedule;
	}
	void setLootSchedule(uint32_t lootrate) {
		lootSchedule = (lootSchedule * lootrate) / 100;
	}

	uint32_t getBossLootSchedule() const {
		return bossLootSchedule;
	}
	void setBossLootSchedule(uint32_t bosslootrate) {
		bossLootSchedule = (bossLootSchedule * bosslootrate) / 100;
	}

	uint32_t getSpawnMonsterSchedule() const {
		return spawnMonsterSchedule;
	}
	void setSpawnMonsterSchedule(uint32_t spawnrate) {
		spawnMonsterSchedule = (spawnMonsterSchedule * spawnrate) / 100;
	}

	uint16_t getSkillSchedule() const {
		return skillSchedule;
	}
	void setSkillSchedule(uint16_t skillrate) {
		skillSchedule = (skillSchedule * skillrate) / 100;
	}

private:
	// Event schedule
	uint16_t expSchedule = 100;
	uint32_t lootSchedule = 100;
	uint32_t bossLootSchedule = 100;
	uint16_t skillSchedule = 100;
	uint32_t spawnMonsterSchedule = 100;

	std::vector<EventScheduler> eventScheduler;

	static std::string join(const std::vector<std::string> &vec, const std::string &delim);
};

constexpr auto g_eventsScheduler = EventsScheduler::getInstance;
