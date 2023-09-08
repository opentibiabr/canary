/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.hpp"
#include "lua/functions/items/item_classification_functions.hpp"

int ItemClassificationFunctions::luaItemClassificationCreate(lua_State* L) {
	// ItemClassification(id)
	if (isNumber(L, 2)) {
		const ItemClassification* itemClassification = g_game().getItemsClassification(getNumber<uint8_t>(L, 2), false);
		if (itemClassification) {
			pushUserdata<const ItemClassification>(L, itemClassification);
			setMetatable(L, -1, "ItemClassification");
			pushBoolean(L, true);
		}
	}

	lua_pushnil(L);
	return 1;
}

int ItemClassificationFunctions::luaItemClassificationAddTier(lua_State* L) {
	// itemClassification:addTier(id, gold[, core = 0])
	ItemClassification* itemClassification = getUserdata<ItemClassification>(L, 1);
	if (itemClassification) {
		itemClassification->addTier(getNumber<uint8_t>(L, 2), getNumber<uint64_t>(L, 3), getNumber<uint8_t>(L, 4, 0));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}

	return 1;
}
