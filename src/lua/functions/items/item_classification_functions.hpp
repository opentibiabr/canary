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

class ItemClassificationFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerClass(L, "ItemClassification", "", ItemClassificationFunctions::luaItemClassificationCreate);
		registerMetaMethod(L, "ItemClassification", "__eq", ItemClassificationFunctions::luaUserdataCompare);

		registerMethod(L, "ItemClassification", "addTier", ItemClassificationFunctions::luaItemClassificationAddTier);
	}

private:
	static int luaItemClassificationCreate(lua_State* L);
	static int luaItemClassificationAddTier(lua_State* L);
};
