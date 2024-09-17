/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class EventsSchedulerFunctions final : private LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "EventsScheduler");

		registerMethod(L, "EventsScheduler", "getEventSLoot", EventsSchedulerFunctions::luaEventsSchedulergetEventSLoot);
		registerMethod(L, "EventsScheduler", "getEventSBossLoot", EventsSchedulerFunctions::luaEventsSchedulergetEventSBossLoot);
		registerMethod(L, "EventsScheduler", "getEventSSkill", EventsSchedulerFunctions::luaEventsSchedulergetEventSSkill);
		registerMethod(L, "EventsScheduler", "getEventSExp", EventsSchedulerFunctions::luaEventsSchedulergetEventSExp);
		registerMethod(L, "EventsScheduler", "getSpawnMonsterSchedule", EventsSchedulerFunctions::luaEventsSchedulergetSpawnMonsterSchedule);
	}

private:
	static int luaEventsSchedulergetEventSLoot(lua_State* L);
	static int luaEventsSchedulergetEventSBossLoot(lua_State* L);
	static int luaEventsSchedulergetEventSSkill(lua_State* L);
	static int luaEventsSchedulergetEventSExp(lua_State* L);
	static int luaEventsSchedulergetSpawnMonsterSchedule(lua_State* L);
};
