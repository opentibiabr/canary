/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_CREATURES_NPC_SHOP_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_NPC_SHOP_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class ShopFunctions final : LuaScriptInterface {
	public:
			static void init(lua_State* L) {
				registerClass(L, "Shop", "", ShopFunctions::luaCreateShop);
				registerMetaMethod(L, "Shop", "__gc", ShopFunctions::luaDeleteShop);
				registerMethod(L, "Shop", "delete", ShopFunctions::luaDeleteShop);

				registerMethod(L, "Shop", "setId", ShopFunctions::luaShopSetId);
				registerMethod(L, "Shop", "setIdFromName", ShopFunctions::luaShopSetIdFromName);
				registerMethod(L, "Shop", "setNameItem", ShopFunctions::luaShopSetNameItem);
				registerMethod(L, "Shop", "setCount", ShopFunctions::luaShopSetCount);
				registerMethod(L, "Shop", "setBuyPrice", ShopFunctions::luaShopSetBuyPrice);
				registerMethod(L, "Shop", "setSellPrice", ShopFunctions::luaShopSetSellPrice);
				registerMethod(L, "Shop", "setStorageKey", ShopFunctions::luaShopSetStorageKey);
				registerMethod(L, "Shop", "setStorageValue", ShopFunctions::luaShopSetStorageValue);
				registerMethod(L, "Shop", "addChildShop", ShopFunctions::luaShopAddChildShop);
		}

	private:
		static int luaCreateShop(lua_State* L);
		static int luaDeleteShop(lua_State* L);
		static int luaShopSetId(lua_State* L);
		static int luaShopSetIdFromName(lua_State* L);
		static int luaShopSetNameItem(lua_State* L);
		static int luaShopSetCount(lua_State* L);
		static int luaShopSetBuyPrice(lua_State* L);
		static int luaShopSetSellPrice(lua_State* L);
		static int luaShopSetStorageKey(lua_State* L);
		static int luaShopSetStorageValue(lua_State* L);
		static int luaShopAddChildShop(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_NPC_SHOP_FUNCTIONS_HPP_
