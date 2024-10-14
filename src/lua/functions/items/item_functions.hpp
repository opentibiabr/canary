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
#include "lua/scripts/luascript.hpp"

class ItemFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Item", "", ItemFunctions::luaItemCreate);
		registerMetaMethod(L, "Item", "__eq", ItemFunctions::luaUserdataCompare);

		registerMethod(L, "Item", "isItem", ItemFunctions::luaItemIsItem);

		registerMethod(L, "Item", "getContainer", ItemFunctions::luaItemGetContainer);
		registerMethod(L, "Item", "getParent", ItemFunctions::luaItemGetParent);
		registerMethod(L, "Item", "getTopParent", ItemFunctions::luaItemGetTopParent);

		registerMethod(L, "Item", "getId", ItemFunctions::luaItemGetId);

		registerMethod(L, "Item", "clone", ItemFunctions::luaItemClone);
		registerMethod(L, "Item", "split", ItemFunctions::luaItemSplit);
		registerMethod(L, "Item", "remove", ItemFunctions::luaItemRemove);

		registerMethod(L, "Item", "getUniqueId", ItemFunctions::luaItemGetUniqueId);
		registerMethod(L, "Item", "getActionId", ItemFunctions::luaItemGetActionId);
		registerMethod(L, "Item", "setActionId", ItemFunctions::luaItemSetActionId);

		registerMethod(L, "Item", "getCount", ItemFunctions::luaItemGetCount);
		registerMethod(L, "Item", "getCharges", ItemFunctions::luaItemGetCharges);
		registerMethod(L, "Item", "getFluidType", ItemFunctions::luaItemGetFluidType);
		registerMethod(L, "Item", "getWeight", ItemFunctions::luaItemGetWeight);

		registerMethod(L, "Item", "getSubType", ItemFunctions::luaItemGetSubType);

		registerMethod(L, "Item", "getName", ItemFunctions::luaItemGetName);
		registerMethod(L, "Item", "getPluralName", ItemFunctions::luaItemGetPluralName);
		registerMethod(L, "Item", "getArticle", ItemFunctions::luaItemGetArticle);

		registerMethod(L, "Item", "getPosition", ItemFunctions::luaItemGetPosition);
		registerMethod(L, "Item", "getTile", ItemFunctions::luaItemGetTile);

		registerMethod(L, "Item", "hasAttribute", ItemFunctions::luaItemHasAttribute);
		registerMethod(L, "Item", "getAttribute", ItemFunctions::luaItemGetAttribute);
		registerMethod(L, "Item", "setAttribute", ItemFunctions::luaItemSetAttribute);
		registerMethod(L, "Item", "removeAttribute", ItemFunctions::luaItemRemoveAttribute);
		registerMethod(L, "Item", "getCustomAttribute", ItemFunctions::luaItemGetCustomAttribute);
		registerMethod(L, "Item", "setCustomAttribute", ItemFunctions::luaItemSetCustomAttribute);
		registerMethod(L, "Item", "removeCustomAttribute", ItemFunctions::luaItemRemoveCustomAttribute);
		registerMethod(L, "Item", "canBeMoved", ItemFunctions::luaItemCanBeMoved);

		registerMethod(L, "Item", "setOwner", ItemFunctions::luaItemSetOwner);
		registerMethod(L, "Item", "getOwnerId", ItemFunctions::luaItemGetOwnerId);
		registerMethod(L, "Item", "isOwner", ItemFunctions::luaItemIsOwner);
		registerMethod(L, "Item", "getOwnerName", ItemFunctions::luaItemGetOwnerName);
		registerMethod(L, "Item", "hasOwner", ItemFunctions::luaItemHasOwner);

		registerMethod(L, "Item", "moveTo", ItemFunctions::luaItemMoveTo);
		registerMethod(L, "Item", "transform", ItemFunctions::luaItemTransform);
		registerMethod(L, "Item", "decay", ItemFunctions::luaItemDecay);

		registerMethod(L, "Item", "serializeAttributes", ItemFunctions::luaItemSerializeAttributes);
		registerMethod(L, "Item", "moveToSlot", ItemFunctions::luaItemMoveToSlot);

		registerMethod(L, "Item", "getDescription", ItemFunctions::luaItemGetDescription);

		registerMethod(L, "Item", "hasProperty", ItemFunctions::luaItemHasProperty);

		registerMethod(L, "Item", "getImbuementSlot", ItemFunctions::luaItemGetImbuementSlot);
		registerMethod(L, "Item", "getImbuement", ItemFunctions::luaItemGetImbuement);

		registerMethod(L, "Item", "setDuration", ItemFunctions::luaItemSetDuration);

		registerMethod(L, "Item", "isInsideDepot", ItemFunctions::luaItemIsInsideDepot);
		registerMethod(L, "Item", "isContainer", ItemFunctions::luaItemIsContainer);

		registerMethod(L, "Item", "getTier", ItemFunctions::luaItemGetTier);
		registerMethod(L, "Item", "setTier", ItemFunctions::luaItemSetTier);
		registerMethod(L, "Item", "getClassification", ItemFunctions::luaItemGetClassification);

		registerMethod(L, "Item", "canReceiveAutoCarpet", ItemFunctions::luaItemCanReceiveAutoCarpet);

		ContainerFunctions::init(L);
		ImbuementFunctions::init(L);
		ItemTypeFunctions::init(L);
		WeaponFunctions::init(L);
	}

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
};
