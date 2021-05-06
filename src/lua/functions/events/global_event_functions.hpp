/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#ifndef SRC_LUA_FUNCTIONS_EVENTS_GLOBAL_EVENT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_EVENTS_GLOBAL_EVENT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class GlobalEventFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "GlobalEvent", "", GlobalEventFunctions::luaCreateGlobalEvent);
			registerMethod(L, "GlobalEvent", "type", GlobalEventFunctions::luaGlobalEventType);
			registerMethod(L, "GlobalEvent", "register", GlobalEventFunctions::luaGlobalEventRegister);
			registerMethod(L, "GlobalEvent", "time", GlobalEventFunctions::luaGlobalEventTime);
			registerMethod(L, "GlobalEvent", "interval", GlobalEventFunctions::luaGlobalEventInterval);
			registerMethod(L, "GlobalEvent", "onThink", GlobalEventFunctions::luaGlobalEventOnCallback);
			registerMethod(L, "GlobalEvent", "onTime", GlobalEventFunctions::luaGlobalEventOnCallback);
			registerMethod(L, "GlobalEvent", "onStartup", GlobalEventFunctions::luaGlobalEventOnCallback);
			registerMethod(L, "GlobalEvent", "onShutdown", GlobalEventFunctions::luaGlobalEventOnCallback);
			registerMethod(L, "GlobalEvent", "onRecord", GlobalEventFunctions::luaGlobalEventOnCallback);
			registerMethod(L, "GlobalEvent", "onPeriodChange", GlobalEventFunctions::luaGlobalEventOnCallback);
		}

	private:
		static int luaCreateGlobalEvent(lua_State* L);
		static int luaGlobalEventType(lua_State* L);
		static int luaGlobalEventRegister(lua_State* L);
		static int luaGlobalEventOnCallback(lua_State* L);
		static int luaGlobalEventTime(lua_State* L);
		static int luaGlobalEventInterval(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_EVENTS_GLOBAL_EVENT_FUNCTIONS_HPP_
