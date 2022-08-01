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

#ifndef SRC_LUA_FUNCTIONS_MAP_TILE_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_MAP_TILE_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class TileFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Tile", "", TileFunctions::luaTileCreate);
			registerMetaMethod(L, "Tile", "__eq", TileFunctions::luaUserdataCompare);

			registerMethod(L, "Tile", "getPosition", TileFunctions::luaTileGetPosition);
			registerMethod(L, "Tile", "getGround", TileFunctions::luaTileGetGround);
			registerMethod(L, "Tile", "getThing", TileFunctions::luaTileGetThing);
			registerMethod(L, "Tile", "getThingCount", TileFunctions::luaTileGetThingCount);
			registerMethod(L, "Tile", "getTopVisibleThing", TileFunctions::luaTileGetTopVisibleThing);

			registerMethod(L, "Tile", "getTopTopItem", TileFunctions::luaTileGetTopTopItem);
			registerMethod(L, "Tile", "getTopDownItem", TileFunctions::luaTileGetTopDownItem);
			registerMethod(L, "Tile", "getFieldItem", TileFunctions::luaTileGetFieldItem);

			registerMethod(L, "Tile", "getItemById", TileFunctions::luaTileGetItemById);
			registerMethod(L, "Tile", "getItemByType", TileFunctions::luaTileGetItemByType);
			registerMethod(L, "Tile", "getItemByTopOrder", TileFunctions::luaTileGetItemByTopOrder);
			registerMethod(L, "Tile", "getItemCountById", TileFunctions::luaTileGetItemCountById);

			registerMethod(L, "Tile", "getBottomCreature", TileFunctions::luaTileGetBottomCreature);
			registerMethod(L, "Tile", "getTopCreature", TileFunctions::luaTileGetTopCreature);
			registerMethod(L, "Tile", "getBottomVisibleCreature", TileFunctions::luaTileGetBottomVisibleCreature);
			registerMethod(L, "Tile", "getTopVisibleCreature", TileFunctions::luaTileGetTopVisibleCreature);

			registerMethod(L, "Tile", "getItems", TileFunctions::luaTileGetItems);
			registerMethod(L, "Tile", "getItemCount", TileFunctions::luaTileGetItemCount);
			registerMethod(L, "Tile", "getDownItemCount", TileFunctions::luaTileGetDownItemCount);
			registerMethod(L, "Tile", "getTopItemCount", TileFunctions::luaTileGetTopItemCount);

			registerMethod(L, "Tile", "getCreatures", TileFunctions::luaTileGetCreatures);
			registerMethod(L, "Tile", "getCreatureCount", TileFunctions::luaTileGetCreatureCount);

			registerMethod(L, "Tile", "getThingIndex", TileFunctions::luaTileGetThingIndex);

			registerMethod(L, "Tile", "hasProperty", TileFunctions::luaTileHasProperty);
			registerMethod(L, "Tile", "hasFlag", TileFunctions::luaTileHasFlag);

			registerMethod(L, "Tile", "queryAdd", TileFunctions::luaTileQueryAdd);
			registerMethod(L, "Tile", "addItem", TileFunctions::luaTileAddItem);
			registerMethod(L, "Tile", "addItemEx", TileFunctions::luaTileAddItemEx);

			registerMethod(L, "Tile", "getHouse", TileFunctions::luaTileGetHouse);
		}

	private:
		static int luaTileCreate(lua_State* L);

		static int luaTileGetPosition(lua_State* L);
		static int luaTileGetGround(lua_State* L);
		static int luaTileGetThing(lua_State* L);
		static int luaTileGetThingCount(lua_State* L);
		static int luaTileGetTopVisibleThing(lua_State* L);

		static int luaTileGetTopTopItem(lua_State* L);
		static int luaTileGetTopDownItem(lua_State* L);
		static int luaTileGetFieldItem(lua_State* L);

		static int luaTileGetItemById(lua_State* L);
		static int luaTileGetItemByType(lua_State* L);
		static int luaTileGetItemByTopOrder(lua_State* L);
		static int luaTileGetItemCountById(lua_State* L);

		static int luaTileGetBottomCreature(lua_State* L);
		static int luaTileGetTopCreature(lua_State* L);
		static int luaTileGetBottomVisibleCreature(lua_State* L);
		static int luaTileGetTopVisibleCreature(lua_State* L);

		static int luaTileGetItems(lua_State* L);
		static int luaTileGetItemCount(lua_State* L);
		static int luaTileGetDownItemCount(lua_State* L);
		static int luaTileGetTopItemCount(lua_State* L);

		static int luaTileGetCreatures(lua_State* L);
		static int luaTileGetCreatureCount(lua_State* L);

		static int luaTileHasProperty(lua_State* L);
		static int luaTileHasFlag(lua_State* L);

		static int luaTileGetThingIndex(lua_State* L);

		static int luaTileQueryAdd(lua_State* L);
		static int luaTileAddItem(lua_State* L);
		static int luaTileAddItemEx(lua_State* L);

		static int luaTileGetHouse(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_MAP_TILE_FUNCTIONS_HPP_
