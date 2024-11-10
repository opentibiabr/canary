/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class MountFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateMount(lua_State* L);
	static int luaMountGetName(lua_State* L);
	static int luaMountGetId(lua_State* L);
	static int luaMountGetClientId(lua_State* L);
	static int luaMountGetSpeed(lua_State* L);
};
