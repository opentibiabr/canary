/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/global_event_functions.hpp"

#include "game/game.hpp"
#include "lua/global/globalevent.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void GlobalEventFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "GlobalEvent", "", GlobalEventFunctions::luaCreateGlobalEvent);
	Lua::registerMethod(L, "GlobalEvent", "type", GlobalEventFunctions::luaGlobalEventType);
	Lua::registerMethod(L, "GlobalEvent", "register", GlobalEventFunctions::luaGlobalEventRegister);
	Lua::registerMethod(L, "GlobalEvent", "time", GlobalEventFunctions::luaGlobalEventTime);
	Lua::registerMethod(L, "GlobalEvent", "interval", GlobalEventFunctions::luaGlobalEventInterval);
	Lua::registerMethod(L, "GlobalEvent", "onThink", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onTime", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onStartup", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onShutdown", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onRecord", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onPeriodChange", GlobalEventFunctions::luaGlobalEventOnCallback);
	Lua::registerMethod(L, "GlobalEvent", "onSave", GlobalEventFunctions::luaGlobalEventOnCallback);
}

int GlobalEventFunctions::luaCreateGlobalEvent(lua_State* L) {
	const auto global = std::make_shared<GlobalEvent>();
	global->setName(Lua::getString(L, 2));
	global->setEventType(GLOBALEVENT_NONE);
	Lua::pushUserdata<GlobalEvent>(L, global);
	Lua::setMetatable(L, -1, "GlobalEvent");
	return 1;
}

int GlobalEventFunctions::luaGlobalEventType(lua_State* L) {
	// globalevent:type(callback)
	const auto &global = Lua::getUserdataShared<GlobalEvent>(L, 1);
	if (global) {
		const std::string typeName = Lua::getString(L, 2);
		const std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "startup") {
			global->setEventType(GLOBALEVENT_STARTUP);
		} else if (tmpStr == "shutdown") {
			global->setEventType(GLOBALEVENT_SHUTDOWN);
		} else if (tmpStr == "record") {
			global->setEventType(GLOBALEVENT_RECORD);
		} else if (tmpStr == "periodchange") {
			global->setEventType(GLOBALEVENT_PERIODCHANGE);
		} else if (tmpStr == "onthink") {
			global->setEventType(GLOBALEVENT_ON_THINK);
		} else if (tmpStr == "save") {
			global->setEventType(GLOBALEVENT_SAVE);
		} else {
			g_logger().error("[GlobalEventFunctions::luaGlobalEventType] - "
			                 "Invalid type for global event: {}");
			Lua::pushBoolean(L, false);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GlobalEventFunctions::luaGlobalEventRegister(lua_State* L) {
	// globalevent:register()
	const auto &globalevent = Lua::getUserdataShared<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->isLoadedScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		if (globalevent->getEventType() == GLOBALEVENT_NONE && globalevent->getInterval() == 0) {
			g_logger().error("{} - No interval for globalevent with name {}", __FUNCTION__, globalevent->getName());
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, g_globalEvents().registerLuaEvent(globalevent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GlobalEventFunctions::luaGlobalEventOnCallback(lua_State* L) {
	// globalevent:onThink / record / etc. (callback)
	const auto &globalevent = Lua::getUserdataShared<GlobalEvent>(L, 1);
	if (globalevent) {
		if (!globalevent->loadScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GlobalEventFunctions::luaGlobalEventTime(lua_State* L) {
	// globalevent:time(time)
	const auto &globalevent = Lua::getUserdataShared<GlobalEvent>(L, 1);
	if (globalevent) {
		std::string timer = Lua::getString(L, 2);
		const std::vector<int32_t> params = vectorAtoi(explodeString(timer, ":"));

		const int32_t hour = params.front();
		if (hour < 0 || hour > 23) {
			g_logger().error("[GlobalEventFunctions::luaGlobalEventTime] - "
			                 "Invalid hour {} for globalevent with name: {}",
			                 timer, globalevent->getName());
			Lua::pushBoolean(L, false);
			return 1;
		}

		globalevent->setInterval(hour << 16);

		int32_t min = 0;
		int32_t sec = 0;
		if (params.size() > 1) {
			min = params[1];
			if (min < 0 || min > 59) {
				g_logger().error("[GlobalEventFunctions::luaGlobalEventTime] - "
				                 "Invalid minute: {} for globalevent with name: {}",
				                 timer, globalevent->getName());
				Lua::pushBoolean(L, false);
				return 1;
			}

			if (params.size() > 2) {
				sec = params[2];
				if (sec < 0 || sec > 59) {
					g_logger().error("[GlobalEventFunctions::luaGlobalEventTime] - "
					                 "Invalid minute: {} for globalevent with name: {}",
					                 timer, globalevent->getName());
					Lua::pushBoolean(L, false);
					return 1;
				}
			}
		}

		const time_t current_time = time(nullptr);
		tm* timeinfo = localtime(&current_time);
		timeinfo->tm_hour = hour;
		timeinfo->tm_min = min;
		timeinfo->tm_sec = sec;

		auto difference = static_cast<time_t>(difftime(mktime(timeinfo), current_time));
		// If the difference is negative, add 86400 seconds (1 day) to it
		if (difference < 0) {
			difference += 86400;
		}

		globalevent->setNextExecution(current_time + difference);
		globalevent->setEventType(GLOBALEVENT_TIMER);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GlobalEventFunctions::luaGlobalEventInterval(lua_State* L) {
	// globalevent:interval(interval)
	const auto &globalevent = Lua::getUserdataShared<GlobalEvent>(L, 1);
	if (globalevent) {
		globalevent->setInterval(Lua::getNumber<uint32_t>(L, 2));
		globalevent->setNextExecution(OTSYS_TIME() + Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
