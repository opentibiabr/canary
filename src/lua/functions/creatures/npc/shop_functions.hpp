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
