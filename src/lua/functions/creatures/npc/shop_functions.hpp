/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class ShopFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateShop(lua_State* L);
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
