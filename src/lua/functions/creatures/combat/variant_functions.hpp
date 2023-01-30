/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CREATURES_COMBAT_VARIANT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_COMBAT_VARIANT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

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

#endif  // SRC_LUA_FUNCTIONS_CREATURES_COMBAT_VARIANT_FUNCTIONS_HPP_
