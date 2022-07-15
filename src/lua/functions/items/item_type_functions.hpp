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

#ifndef SRC_LUA_FUNCTIONS_ITEMS_ITEM_TYPE_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_ITEMS_ITEM_TYPE_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"
#include "lua/functions/items/item_classification_functions.hpp"

class ItemTypeFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "ItemType", "", ItemTypeFunctions::luaItemTypeCreate);
			registerMetaMethod(L, "ItemType", "__eq", ItemTypeFunctions::luaUserdataCompare);

			registerMethod(L, "ItemType", "isCorpse", ItemTypeFunctions::luaItemTypeIsCorpse);
			registerMethod(L, "ItemType", "isDoor", ItemTypeFunctions::luaItemTypeIsDoor);
			registerMethod(L, "ItemType", "isContainer", ItemTypeFunctions::luaItemTypeIsContainer);
			registerMethod(L, "ItemType", "isFluidContainer", ItemTypeFunctions::luaItemTypeIsFluidContainer);
			registerMethod(L, "ItemType", "isMovable", ItemTypeFunctions::luaItemTypeIsMovable);
			registerMethod(L, "ItemType", "isRune", ItemTypeFunctions::luaItemTypeIsRune);
			registerMethod(L, "ItemType", "isStackable", ItemTypeFunctions::luaItemTypeIsStackable);
			registerMethod(L, "ItemType", "isReadable", ItemTypeFunctions::luaItemTypeIsReadable);
			registerMethod(L, "ItemType", "isWritable", ItemTypeFunctions::luaItemTypeIsWritable);
			registerMethod(L, "ItemType", "isBlocking", ItemTypeFunctions::luaItemTypeIsBlocking);
			registerMethod(L, "ItemType", "isGroundTile", ItemTypeFunctions::luaItemTypeIsGroundTile);
			registerMethod(L, "ItemType", "isMagicField", ItemTypeFunctions::luaItemTypeIsMagicField);
			registerMethod(L, "ItemType", "isMultiUse", ItemTypeFunctions::luaItemTypeIsMultiUse);
			registerMethod(L, "ItemType", "isPickupable", ItemTypeFunctions::luaItemTypeIsPickupable);
			registerMethod(L, "ItemType", "isKey", ItemTypeFunctions::luaItemTypeIsKey);
			registerMethod(L, "ItemType", "isQuiver", ItemTypeFunctions::luaItemTypeIsQuiver);

			registerMethod(L, "ItemType", "getType", ItemTypeFunctions::luaItemTypeGetType);
			registerMethod(L, "ItemType", "getId", ItemTypeFunctions::luaItemTypeGetId);
			registerMethod(L, "ItemType", "getName", ItemTypeFunctions::luaItemTypeGetName);
			registerMethod(L, "ItemType", "getPluralName", ItemTypeFunctions::luaItemTypeGetPluralName);
			registerMethod(L, "ItemType", "getArticle", ItemTypeFunctions::luaItemTypeGetArticle);
			registerMethod(L, "ItemType", "getDescription", ItemTypeFunctions::luaItemTypeGetDescription);
			registerMethod(L, "ItemType", "getSlotPosition", ItemTypeFunctions::luaItemTypeGetSlotPosition);

			registerMethod(L, "ItemType", "getCharges", ItemTypeFunctions::luaItemTypeGetCharges);
			registerMethod(L, "ItemType", "getFluidSource", ItemTypeFunctions::luaItemTypeGetFluidSource);
			registerMethod(L, "ItemType", "getCapacity", ItemTypeFunctions::luaItemTypeGetCapacity);
			registerMethod(L, "ItemType", "getWeight", ItemTypeFunctions::luaItemTypeGetWeight);

			registerMethod(L, "ItemType", "getHitChance", ItemTypeFunctions::luaItemTypeGetHitChance);
			registerMethod(L, "ItemType", "getShootRange", ItemTypeFunctions::luaItemTypeGetShootRange);

			registerMethod(L, "ItemType", "getAttack", ItemTypeFunctions::luaItemTypeGetAttack);
			registerMethod(L, "ItemType", "getDefense", ItemTypeFunctions::luaItemTypeGetDefense);
			registerMethod(L, "ItemType", "getExtraDefense", ItemTypeFunctions::luaItemTypeGetExtraDefense);
			registerMethod(L, "ItemType", "getImbuementSlot", ItemTypeFunctions::luaItemTypeGetImbuementSlot);
			registerMethod(L, "ItemType", "getArmor", ItemTypeFunctions::luaItemTypeGetArmor);
			registerMethod(L, "ItemType", "getWeaponType", ItemTypeFunctions::luaItemTypeGetWeaponType);

			registerMethod(L, "ItemType", "getElementType", ItemTypeFunctions::luaItemTypeGetElementType);
			registerMethod(L, "ItemType", "getElementDamage", ItemTypeFunctions::luaItemTypeGetElementDamage);

			registerMethod(L, "ItemType", "getTransformEquipId", ItemTypeFunctions::luaItemTypeGetTransformEquipId);
			registerMethod(L, "ItemType", "getTransformDeEquipId", ItemTypeFunctions::luaItemTypeGetTransformDeEquipId);
			registerMethod(L, "ItemType", "getDestroyId", ItemTypeFunctions::luaItemTypeGetDestroyId);
			registerMethod(L, "ItemType", "getDecayId", ItemTypeFunctions::luaItemTypeGetDecayId);
			registerMethod(L, "ItemType", "getRequiredLevel", ItemTypeFunctions::luaItemTypeGetRequiredLevel);
			registerMethod(L, "ItemType", "getAmmoType", ItemTypeFunctions::luaItemTypeGetAmmoType);

			registerMethod(L, "ItemType", "getDecayTime", ItemTypeFunctions::luaItemTypeGetDecayTime);
			registerMethod(L, "ItemType", "getShowDuration", ItemTypeFunctions::luaItemTypeGetShowDuration);
			registerMethod(L, "ItemType", "getWrapableTo", ItemTypeFunctions::luaItemTypeGetWrapableTo);
			registerMethod(L, "ItemType", "getSpeed", ItemTypeFunctions::luaItemTypeGetSpeed);
			registerMethod(L, "ItemType", "getBaseSpeed", ItemTypeFunctions::luaItemTypeGetBaseSpeed);

			registerMethod(L, "ItemType", "hasSubType", ItemTypeFunctions::luaItemTypeHasSubType);
			
			ItemClassificationFunctions::init(L);
		}

	private:
		static int luaItemTypeCreate(lua_State* L);

		static int luaItemTypeIsCorpse(lua_State* L);
		static int luaItemTypeIsDoor(lua_State* L);
		static int luaItemTypeIsContainer(lua_State* L);
		static int luaItemTypeIsFluidContainer(lua_State* L);
		static int luaItemTypeIsMovable(lua_State* L);
		static int luaItemTypeIsRune(lua_State* L);
		static int luaItemTypeIsStackable(lua_State* L);
		static int luaItemTypeIsReadable(lua_State* L);
		static int luaItemTypeIsWritable(lua_State* L);
		static int luaItemTypeIsBlocking(lua_State* L);
		static int luaItemTypeIsGroundTile(lua_State* L);
		static int luaItemTypeIsMagicField(lua_State* L);
		static int luaItemTypeIsMultiUse(lua_State* L);
		static int luaItemTypeIsPickupable(lua_State* L);
		static int luaItemTypeIsKey(lua_State* L);
		static int luaItemTypeIsQuiver(lua_State* L);

		static int luaItemTypeGetType(lua_State* L);
		static int luaItemTypeGetId(lua_State* L);
		static int luaItemTypeGetName(lua_State* L);
		static int luaItemTypeGetPluralName(lua_State* L);
		static int luaItemTypeGetArticle(lua_State* L);
		static int luaItemTypeGetDescription(lua_State* L);
		static int luaItemTypeGetSlotPosition(lua_State *L);

		static int luaItemTypeGetCharges(lua_State* L);
		static int luaItemTypeGetFluidSource(lua_State* L);
		static int luaItemTypeGetCapacity(lua_State* L);
		static int luaItemTypeGetWeight(lua_State* L);

		static int luaItemTypeGetHitChance(lua_State* L);
		static int luaItemTypeGetShootRange(lua_State* L);
		static int luaItemTypeGetAttack(lua_State* L);
		static int luaItemTypeGetDefense(lua_State* L);
		static int luaItemTypeGetExtraDefense(lua_State* L);
		static int luaItemTypeGetImbuementSlot(lua_State* L);
		static int luaItemTypeGetArmor(lua_State* L);
		static int luaItemTypeGetWeaponType(lua_State* L);

		static int luaItemTypeGetElementType(lua_State* L);
		static int luaItemTypeGetElementDamage(lua_State* L);

		static int luaItemTypeGetTransformEquipId(lua_State* L);
		static int luaItemTypeGetTransformDeEquipId(lua_State* L);
		static int luaItemTypeGetDestroyId(lua_State* L);
		static int luaItemTypeGetDecayId(lua_State* L);
		static int luaItemTypeGetRequiredLevel(lua_State* L);
		static int luaItemTypeGetAmmoType(lua_State* L);

		static int luaItemTypeGetSpeed(lua_State* L);
		static int luaItemTypeGetBaseSpeed(lua_State* L);
		static int luaItemTypeGetDecayTime(lua_State* L);
		static int luaItemTypeGetShowDuration(lua_State* L);
		static int luaItemTypeGetWrapableTo(lua_State* L);

		static int luaItemTypeHasSubType(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_ITEMS_ITEM_TYPE_FUNCTIONS_HPP_
