/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class GlobalEventFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "GlobalEvent", "", GlobalEventFunctions::luaCreateGlobalEvent);
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
