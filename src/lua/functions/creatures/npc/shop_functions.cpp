/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/npc/shop_functions.hpp"

#include "creatures/npcs/npcs.hpp"

#include "items/item.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ShopFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Shop", "", ShopFunctions::luaCreateShop);
	Lua::registerMethod(L, "Shop", "setId", ShopFunctions::luaShopSetId);
	Lua::registerMethod(L, "Shop", "setIdFromName", ShopFunctions::luaShopSetIdFromName);
	Lua::registerMethod(L, "Shop", "setNameItem", ShopFunctions::luaShopSetNameItem);
	Lua::registerMethod(L, "Shop", "setCount", ShopFunctions::luaShopSetCount);
	Lua::registerMethod(L, "Shop", "setBuyPrice", ShopFunctions::luaShopSetBuyPrice);
	Lua::registerMethod(L, "Shop", "setSellPrice", ShopFunctions::luaShopSetSellPrice);
	Lua::registerMethod(L, "Shop", "setStorageKey", ShopFunctions::luaShopSetStorageKey);
	Lua::registerMethod(L, "Shop", "setStorageValue", ShopFunctions::luaShopSetStorageValue);
	Lua::registerMethod(L, "Shop", "addChildShop", ShopFunctions::luaShopAddChildShop);
}

int ShopFunctions::luaCreateShop(lua_State* L) {
	// Shop() will create a new shop item
	Lua::pushUserdata<Shop>(L, std::make_shared<Shop>());
	Lua::setMetatable(L, -1, "Shop");
	return 1;
}

int ShopFunctions::luaShopSetId(lua_State* L) {
	// shop:setId(id)

	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		if (Lua::isNumber(L, 2)) {
			shop->shopBlock.itemId = Lua::getNumber<uint16_t>(L, 2);
			Lua::pushBoolean(L, true);
		} else {
			g_logger().warn("[ShopFunctions::luaShopSetId] - "
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
	const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop");
	if (shop && Lua::isString(L, 2)) {
		auto name = Lua::getString(L, 2);
		const auto ids = Item::items.nameToItems.equal_range(asLowerCaseString(name));

		if (ids.first == Item::items.nameToItems.cend()) {
			g_logger().warn("[ShopFunctions::luaShopSetIdFromName] - "
			                "Unknown shop item {}",
			                name);
			lua_pushnil(L);
			return 1;
		}

		if (std::next(ids.first) != ids.second) {
			g_logger().warn("[ShopFunctions::luaShopSetIdFromName] - "
			                "Non-unique shop item {}",
			                name);
			lua_pushnil(L);
			return 1;
		}

		shop->shopBlock.itemId = ids.first->second;
		Lua::pushBoolean(L, true);
	} else {
		g_logger().warn("[ShopFunctions::luaShopSetIdFromName] - "
		                "Unknown shop item shop, string value expected");
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetNameItem(lua_State* L) {
	// shop:setNameItem(name)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemName = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetCount(lua_State* L) {
	// shop:setCount(count)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemSubType = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetBuyPrice(lua_State* L) {
	// shop:setBuyPrice(price)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemBuyPrice = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetSellPrice(lua_State* L) {
	// shop:setSellPrice(chance)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemSellPrice = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetStorageKey(lua_State* L) {
	// shop:setStorageKey(storage)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemStorageKey = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopSetStorageValue(lua_State* L) {
	// shop:setStorageValue(value)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.itemStorageValue = Lua::getNumber<uint32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ShopFunctions::luaShopAddChildShop(lua_State* L) {
	// shop:addChildShop(shop)
	if (const auto &shop = Lua::getUserdataShared<Shop>(L, 1, "Shop")) {
		shop->shopBlock.childShop.push_back(Lua::getUserdataShared<Shop>(L, 2, "Shop")->shopBlock);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
