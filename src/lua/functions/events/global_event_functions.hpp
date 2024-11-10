/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class GlobalEventFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateGlobalEvent(lua_State* L);
	static int luaGlobalEventType(lua_State* L);
	static int luaGlobalEventRegister(lua_State* L);
	static int luaGlobalEventOnCallback(lua_State* L);
	static int luaGlobalEventTime(lua_State* L);
	static int luaGlobalEventInterval(lua_State* L);
};
