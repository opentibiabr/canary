/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
		GlobalEvents();
		~GlobalEvents();

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

		bool executePeriodChange(LightState_t lightState, LightInfo lightInfo) const ;
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
		int64_t nextExecution = 0;
		uint32_t interval = 0;
};

#endif  // SRC_LUA_GLOBAL_GLOBALEVENT_H_
