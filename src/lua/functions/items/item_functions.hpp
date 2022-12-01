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

#ifndef SRC_LUA_FUNCTIONS_ITEMS_ITEM_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_ITEMS_ITEM_FUNCTIONS_HPP_

#include "lua/functions/items/container_functions.hpp"
#include "lua/functions/items/imbuement_functions.hpp"
#include "lua/functions/items/item_type_functions.hpp"
#include "lua/functions/items/weapon_functions.hpp"
#include "lua/scripts/luascript.h"

class ItemFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Item", "", ItemFunctions::luaItemCreate);
			registerMetaMethod(L, "Item", "__eq", ItemFunctions::luaUserdataCompare);

			registerMethod(L, "Item", "isItem", ItemFunctions::luaItemIsItem);

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

			registerMethod(L, "Item", "getTier", ItemFunctions::luaItemGetTier);
			registerMethod(L, "Item", "setTier", ItemFunctions::luaItemSetTier);
			registerMethod(L, "Item", "getClassification", ItemFunctions::luaItemGetClassification);

			ContainerFunctions::init(L);
			ImbuementFunctions::init(L);
			ItemTypeFunctions::init(L);
			WeaponFunctions::init(L);
		}

	private:
		static int luaItemCreate(lua_State* L);

		static int luaItemIsItem(lua_State* L);

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

		static int luaItemGetTier(lua_State* L);
		static int luaItemSetTier(lua_State* L);
		static int luaItemGetClassification(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_ITEMS_ITEM_FUNCTIONS_HPP_
