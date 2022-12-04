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

#include "pch.hpp"

#include "game/scheduling/events_scheduler.hpp"
#include "lua/functions/events/events_scheduler_functions.hpp"

int EventsSchedulerFunctions::luaEventsSchedulergetEventSLoot(lua_State* L) {
	// EventsScheduler.getEventSLoot
	lua_pushnumber(L, g_eventsScheduler().getLootSchedule());
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
