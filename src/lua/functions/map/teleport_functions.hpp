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

class TeleportFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Teleport", "Item", TeleportFunctions::luaTeleportCreate);
		registerMetaMethod(L, "Teleport", "__eq", TeleportFunctions::luaUserdataCompare);

		registerMethod(L, "Teleport", "getDestination", TeleportFunctions::luaTeleportGetDestination);
		registerMethod(L, "Teleport", "setDestination", TeleportFunctions::luaTeleportSetDestination);
	}

private:
	static int luaTeleportCreate(lua_State* L);
	static int luaTeleportGetDestination(lua_State* L);
	static int luaTeleportSetDestination(lua_State* L);
};
