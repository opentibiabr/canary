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

#include "pch.hpp"

#include "creatures/npcs/npcs.h"
#include "lua/functions/creatures/npc/shop_functions.hpp"

int ShopFunctions::luaCreateShop(lua_State* L) {
	// Shop() will create a new shop item
	Shop* shop = new Shop();
	if (shop) {
		pushUserdata<Shop>(L, shop);
		setMetatable(L, -1, "Shop");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaDeleteShop(lua_State* L) {
	// shop:delete() shop:__gc()
	Shop** shopPtr = getRawUserdata<Shop>(L, 1);
	if (shopPtr && *shopPtr) {
		delete *shopPtr;
		*shopPtr = nullptr;
	}
	return 0;
}

int ShopFunctions::luaShopSetId(lua_State* L) {
	// shop:setId(id)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		if (isNumber(L, 2)) {
			shop->shopBlock.itemId = getNumber<uint16_t>(L, 2);
			pushBoolean(L, true);
		} else {
			SPDLOG_WARN("[ShopFunctions::luaShopSetId] - "
						"Unknown shop item shop, int value expected");
			lua_pushnil(L);
		}
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetIdFromName(lua_State* L) {
	// shop:setIdFromName(name)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop && isString(L, 2)) {
		auto name = getString(L, 2);
		auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			SPDLOG_WARN("[ShopFunctions::luaShopSetIdFromName] - "
						"Unknown shop item {}", name);
			lua_pushnil(L);
			return 1;
		}

		if (std::next(ids.first) != ids.second) {
			SPDLOG_WARN("[ShopFunctions::luaShopSetIdFromName] - "
						"Non-unique shop item {}", name);
			lua_pushnil(L);
			return 1;
		}

		shop->shopBlock.itemId = ids.first->second;
		pushBoolean(L, true);
	} else {
		SPDLOG_WARN("[ShopFunctions::luaShopSetIdFromName] - "
					"Unknown shop item shop, string value expected");
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetNameItem(lua_State* L) {
	// shop:setNameItem(name)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemName = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetCount(lua_State* L) {
	// shop:setCount(count)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemSubType = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetBuyPrice(lua_State* L) {
	// shop:setBuyPrice(price)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemBuyPrice = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetSellPrice(lua_State* L) {
	// shop:setSellPrice(chance)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemSellPrice = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetStorageKey(lua_State* L) {
	// shop:setStorageKey(storage)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemStorageKey = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetStorageValue(lua_State* L) {
	// shop:setStorageValue(value)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.itemStorageValue = getNumber<uint32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopAddChildShop(lua_State* L) {
	// shop:addChildShop(shop)
	Shop* shop = getUserdata<Shop>(L, 1);
	if (shop) {
		shop->shopBlock.childShop.push_back(getUserdata<Shop>(L, 2)->shopBlock);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
