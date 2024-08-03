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

class VariantFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerClass(L, "Variant", "", VariantFunctions::luaVariantCreate);

		registerMethod(L, "Variant", "getNumber", VariantFunctions::luaVariantGetNumber);
		registerMethod(L, "Variant", "getString", VariantFunctions::luaVariantGetString);
		registerMethod(L, "Variant", "getPosition", VariantFunctions::luaVariantGetPosition);
	}

private:
	static int luaVariantCreate(lua_State* L);

	static int luaVariantGetNumber(lua_State* L);
	static int luaVariantGetString(lua_State* L);
	static int luaVariantGetPosition(lua_State* L);
};
