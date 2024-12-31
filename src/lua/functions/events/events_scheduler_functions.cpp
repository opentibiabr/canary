/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/events_scheduler_functions.hpp"

#include "game/scheduling/events_scheduler.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void EventsSchedulerFunctions::init(lua_State* L) {
	Lua::registerTable(L, "EventsScheduler");

	Lua::registerMethod(L, "EventsScheduler", "getEventSLoot", EventsSchedulerFunctions::luaEventsSchedulergetEventSLoot);
	Lua::registerMethod(L, "EventsScheduler", "getEventSBossLoot", EventsSchedulerFunctions::luaEventsSchedulergetEventSBossLoot);
	Lua::registerMethod(L, "EventsScheduler", "getEventSSkill", EventsSchedulerFunctions::luaEventsSchedulergetEventSSkill);
	Lua::registerMethod(L, "EventsScheduler", "getEventSExp", EventsSchedulerFunctions::luaEventsSchedulergetEventSExp);
	Lua::registerMethod(L, "EventsScheduler", "getSpawnMonsterSchedule", EventsSchedulerFunctions::luaEventsSchedulergetSpawnMonsterSchedule);
}

int EventsSchedulerFunctions::luaEventsSchedulergetEventSLoot(lua_State* L) {
	// EventsScheduler.getEventSLoot
	lua_pushnumber(L, g_eventsScheduler().getLootSchedule());
	return 1;
}

int EventsSchedulerFunctions::luaEventsSchedulergetEventSBossLoot(lua_State* L) {
	// EventsScheduler.getEventSLoot
	lua_pushnumber(L, g_eventsScheduler().getBossLootSchedule());
	return 1;
}

int EventsSchedulerFunctions::luaEventsSchedulergetEventSSkill(lua_State* L) {
	// EventsScheduler.getEventSSkill
	lua_pushnumber(L, g_eventsScheduler().getSkillSchedule());
	return 1;
}

int EventsSchedulerFunctions::luaEventsSchedulergetEventSExp(lua_State* L) {
	// EventsScheduler.getEventSExp
	lua_pushnumber(L, g_eventsScheduler().getExpSchedule());
	return 1;
}

int EventsSchedulerFunctions::luaEventsSchedulergetSpawnMonsterSchedule(lua_State* L) {
	// EventsScheduler.getSpawnMonsterSchedule
	lua_pushnumber(L, g_eventsScheduler().getSpawnMonsterSchedule());
	return 1;
}
