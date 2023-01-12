/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_GAME_SCHEDUNLING_EVENTS_SCHEDULER_HPP_
#define SRC_GAME_SCHEDUNLING_EVENTS_SCHEDULER_HPP_


#include "utils/tools.h"

class EventsScheduler
{
	public:
		EventsScheduler() = default;

		// Singleton - ensures we don't accidentally copy it.
		EventsScheduler(const EventsScheduler&) = delete;
		EventsScheduler& operator=(const EventsScheduler&) = delete;

		static EventsScheduler& getInstance() {
			// Guaranteed to be destroyed
			static EventsScheduler instance;
			// Instantiated on first use
			return instance;
		}

		// Event schedule xml load
		bool loadScheduleEventFromXml() const;
		
		// Event schedule
		uint16_t getExpSchedule() const {
			return expSchedule;
		}
		void setExpSchedule(uint16_t exprate) {
			expSchedule = (expSchedule * exprate)/100;
		}

		uint32_t getLootSchedule() const {
			return lootSchedule;
		}
		void setLootSchedule(uint32_t lootrate) {
			lootSchedule = (lootSchedule * lootrate)/100;
		}

		uint32_t getSpawnMonsterSchedule() const {
			return spawnMonsterSchedule;
		}
		void setSpawnMonsterSchedule(uint32_t spawnrate) {
			spawnMonsterSchedule = (spawnMonsterSchedule * spawnrate)/100;
		}

		uint16_t getSkillSchedule() const {
			return skillSchedule;
		}
		void setSkillSchedule(uint16_t skillrate) {
			skillSchedule = (skillSchedule * skillrate)/100;
		}
		
	private:
		// Event schedule
		uint16_t expSchedule = 100;
		uint32_t lootSchedule = 100;
		uint16_t skillSchedule = 100;
		uint32_t spawnMonsterSchedule = 100;

};

constexpr auto g_eventsScheduler = &EventsScheduler::getInstance;

#endif  // SRC_GAME_SCHEDUNLING_EVENTS_SCHEDULER_HPP_
