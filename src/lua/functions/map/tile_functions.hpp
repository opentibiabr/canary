/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class TileFunctions {
public:
	static void init(lua_State* L);

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
	static int luaTileSweep(lua_State* L);
};
