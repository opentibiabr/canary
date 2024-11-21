/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/items/item_classification_functions.hpp"

#include "game/game.hpp"
#include "items/items_classification.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ItemClassificationFunctions::init(lua_State* L) {
	Lua::registerClass(L, "ItemClassification", "", ItemClassificationFunctions::luaItemClassificationCreate);
	Lua::registerMetaMethod(L, "ItemClassification", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "ItemClassification", "addTier", ItemClassificationFunctions::luaItemClassificationAddTier);
}

int ItemClassificationFunctions::luaItemClassificationCreate(lua_State* L) {
	// ItemClassification(id)
	if (Lua::isNumber(L, 2)) {
		const ItemClassification* itemClassification = g_game().getItemsClassification(Lua::getNumber<uint8_t>(L, 2), false);
		if (itemClassification) {
			Lua::pushUserdata<const ItemClassification>(L, itemClassification);
			Lua::setMetatable(L, -1, "ItemClassification");
			Lua::pushBoolean(L, true);
		}
	}

	lua_pushnil(L);
	return 1;
}

int ItemClassificationFunctions::luaItemClassificationAddTier(lua_State* L) {
	// itemClassification:addTier(id, core, regularPrice, convergenceFusionPrice, convergenceTransferPrice)
	auto* itemClassification = Lua::getUserdata<ItemClassification>(L, 1);
	if (itemClassification) {
		itemClassification->addTier(
			Lua::getNumber<uint8_t>(L, 2),
			Lua::getNumber<uint8_t>(L, 3),
			Lua::getNumber<uint64_t>(L, 4),
			Lua::getNumber<uint64_t>(L, 5),
			Lua::getNumber<uint64_t>(L, 6)
		);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}

	return 1;
}
