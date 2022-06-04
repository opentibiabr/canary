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

#ifndef SRC_GAME_SCHEDUNLING_EVENTS_SCHEDULER_HPP_
#define SRC_GAME_SCHEDUNLING_EVENTS_SCHEDULER_HPP_

// #include <unordered_set>

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
