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

#ifndef SRC_LUA_GLOBAL_GLOBALEVENT_H_
#define SRC_LUA_GLOBAL_GLOBALEVENT_H_

#include "utils/utils_definitions.hpp"
#include "lua/scripts/scripts.h"

class GlobalEvent;
using GlobalEvent_ptr = std::unique_ptr<GlobalEvent>;
using GlobalEventMap = std::map<std::string, GlobalEvent>;

class GlobalEvents final : public Scripts {
	public:
		GlobalEvents() = default;

		// non-copyable
		GlobalEvents(const GlobalEvents&) = delete;
		GlobalEvents& operator=(const GlobalEvents&) = delete;

		static GlobalEvents& getInstance() {
			// Guaranteed to be destroyed
			static GlobalEvents instance;
			// Instantiated on first use
			return instance;
		}

		void startup() const;

		void timer();
		void think();
		void execute(GlobalEvent_t type) const;

		GlobalEventMap getEventMap(GlobalEvent_t type);

		bool registerLuaEvent(GlobalEvent* event);
		void clear();

	private:
		GlobalEventMap thinkMap, serverMap, timerMap;
		int32_t thinkEventId = 0, timerEventId = 0;
};

constexpr auto g_globalEvents = &GlobalEvents::getInstance;

class GlobalEvent final : public Script {
	public:
		explicit GlobalEvent(LuaScriptInterface* interface);

		bool executePeriodChange(LightState_t lightState, LightInfo lightInfo);
		bool executeRecord(uint32_t current, uint32_t old);
		bool executeEvent() const;

		GlobalEvent_t getEventType() const {
			return eventType;
		}
		void setEventType(GlobalEvent_t type) {
			eventType = type;
		}

		const std::string& getName() const {
			return name;
		}
		void setName(std::string eventName) {
			name = eventName;
		}
		const std::string& getFileName() const {
			return fileName;
		}
		void setFileName(const std::string& scriptName) {
			fileName = scriptName;
		}

		uint32_t getInterval() const {
			return interval;
		}
		void setInterval(uint32_t eventInterval) {
			interval |= eventInterval;
		}

		int64_t getNextExecution() const {
			return nextExecution;
		}
		void setNextExecution(int64_t time) {
			nextExecution = time;
		}

	private:
		GlobalEvent_t eventType = GLOBALEVENT_NONE;

		std::string getScriptTypeName() const override;

		std::string name;
		std::string fileName;
		int64_t nextExecution = 0;
		uint32_t interval = 0;
};

#endif  // SRC_LUA_GLOBAL_GLOBALEVENT_H_
