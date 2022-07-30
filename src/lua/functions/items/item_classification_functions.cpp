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

#include "game/game.h"
#include "lua/functions/items/item_classification_functions.hpp"

int ItemClassificationFunctions::luaItemClassificationCreate(lua_State* L) {
	// ItemClassification(id)
	if (isNumber(L, 2)) {
		ItemClassification* itemClassification = g_game().getItemsClassification(getNumber<uint8_t>(L, 2), false);
		if (itemClassification)
		{
			pushUserdata<ItemClassification>(L, itemClassification);
			setMetatable(L, -1, "ItemClassification");
			pushBoolean(L, true);
		}
	}

	lua_pushnil(L);
	return 1;
}

int ItemClassificationFunctions::luaItemClassificationAddTier(lua_State* L) {
	// itemClassification:addTier(id, price)
	ItemClassification* itemClassification = getUserdata<ItemClassification>(L, 1);
	if (itemClassification) {
		itemClassification->addTier(getNumber<uint8_t>(L, 2), getNumber<uint64_t>(L, 3));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}

	return 1;
}
