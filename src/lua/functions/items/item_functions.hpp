/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/items/container_functions.hpp"
#include "lua/functions/items/imbuement_functions.hpp"
#include "lua/functions/items/item_type_functions.hpp"
#include "lua/functions/items/weapon_functions.hpp"
class ItemFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaItemCreate(lua_State* L);

	static int luaItemIsItem(lua_State* L);

	static int luaItemGetContainer(lua_State* L);
	static int luaItemGetParent(lua_State* L);
	static int luaItemGetTopParent(lua_State* L);

	static int luaItemGetId(lua_State* L);

	static int luaItemClone(lua_State* L);
	static int luaItemSplit(lua_State* L);
	static int luaItemRemove(lua_State* L);

	static int luaItemGetUniqueId(lua_State* L);
	static int luaItemGetActionId(lua_State* L);
	static int luaItemSetActionId(lua_State* L);

	static int luaItemGetCount(lua_State* L);
	static int luaItemGetCharges(lua_State* L);
	static int luaItemGetFluidType(lua_State* L);
	static int luaItemGetWeight(lua_State* L);

	static int luaItemGetSubType(lua_State* L);

	static int luaItemGetName(lua_State* L);
	static int luaItemGetPluralName(lua_State* L);
	static int luaItemGetArticle(lua_State* L);

	static int luaItemGetPosition(lua_State* L);
	static int luaItemGetTile(lua_State* L);

	static int luaItemHasAttribute(lua_State* L);
	static int luaItemGetAttribute(lua_State* L);
	static int luaItemSetAttribute(lua_State* L);
	static int luaItemRemoveAttribute(lua_State* L);
	static int luaItemGetCustomAttribute(lua_State* L);
	static int luaItemSetCustomAttribute(lua_State* L);
	static int luaItemRemoveCustomAttribute(lua_State* L);
	static int luaItemCanBeMoved(lua_State* L);

	static int luaItemMoveTo(lua_State* L);
	static int luaItemTransform(lua_State* L);
	static int luaItemDecay(lua_State* L);

	static int luaItemSerializeAttributes(lua_State* L);
	static int luaItemMoveToSlot(lua_State* L);

	static int luaItemGetDescription(lua_State* L);

	static int luaItemHasProperty(lua_State* L);

	static int luaItemGetImbuementSlot(lua_State* L);
	static int luaItemGetImbuement(lua_State* L);

	static int luaItemSetDuration(lua_State* L);

	static int luaItemIsInsideDepot(lua_State* L);
	static int luaItemIsContainer(lua_State* L);

	static int luaItemGetTier(lua_State* L);
	static int luaItemSetTier(lua_State* L);
	static int luaItemGetClassification(lua_State* L);

	static int luaItemCanReceiveAutoCarpet(lua_State* L);

	static int luaItemSetOwner(lua_State* L);
	static int luaItemGetOwnerId(lua_State* L);
	static int luaItemIsOwner(lua_State* L);
	static int luaItemGetOwnerName(lua_State* L);
	static int luaItemHasOwner(lua_State* L);
	static int luaItemActor(lua_State* L);
};
