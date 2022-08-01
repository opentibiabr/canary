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

#include "items/item.h"
#include "items/items.h"
#include "lua/functions/items/item_type_functions.hpp"

int ItemTypeFunctions::luaItemTypeCreate(lua_State* L) {
	// ItemType(id or name)
	uint32_t id;
	if (isNumber(L, 2)) {
		id = getNumber<uint32_t>(L, 2);
	} else {
		id = Item::items.getItemIdByName(getString(L, 2));
	}

	const ItemType& itemType = Item::items[id];
	pushUserdata<const ItemType>(L, &itemType);
	setMetatable(L, -1, "ItemType");
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsCorpse(lua_State* L) {
	// itemType:isCorpse()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isCorpse);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsDoor(lua_State* L) {
	// itemType:isDoor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isDoor());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsContainer(lua_State* L) {
	// itemType:isContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsFluidContainer(lua_State* L) {
	// itemType:isFluidContainer()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isFluidContainer());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsMovable(lua_State* L) {
	// itemType:isMovable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->moveable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsRune(lua_State* L) {
	// itemType:isRune()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isRune());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsStackable(lua_State* L) {
	// itemType:isStackable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->stackable);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsReadable(lua_State* L) {
	// itemType:isReadable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canReadText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsWritable(lua_State* L) {
	// itemType:isWritable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->canWriteText);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsBlocking(lua_State* L) {
	// itemType:isBlocking()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->blockProjectile || itemType->blockSolid);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsGroundTile(lua_State* L) {
	// itemType:isGroundTile()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isGroundTile());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsMagicField(lua_State* L) {
	// itemType:isMagicField()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isMagicField());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsMultiUse(lua_State* L) {
	// itemType:isMultiUse()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isMultiUse());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsPickupable(lua_State* L) {
	// itemType:isPickupable()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isPickupable());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsKey(lua_State* L) {
	// itemType:isKey()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isKey());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeIsQuiver(lua_State* L) {
	// itemType:isQuiver()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->isQuiver());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetType(lua_State* L) {
	// itemType:getType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->type);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetId(lua_State* L) {
	// itemType:getId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->id);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetName(lua_State* L) {
	// itemType:getName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->name);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetPluralName(lua_State* L) {
	// itemType:getPluralName()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetArticle(lua_State* L) {
	// itemType:getArticle()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->article);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetDescription(lua_State* L) {
	// itemType:getDescription()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushString(L, itemType->description);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetSlotPosition(lua_State *L) {
	// itemType:getSlotPosition()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->slotPosition);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetCharges(lua_State* L) {
	// itemType:getCharges()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->charges);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetFluidSource(lua_State* L) {
	// itemType:getFluidSource()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->fluidSource);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetCapacity(lua_State* L) {
	// itemType:getCapacity()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->maxItems);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetWeight(lua_State* L) {
	// itemType:getWeight([count = 1])
	uint16_t count = getNumber<uint16_t>(L, 2, 1);

	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	uint64_t weight = static_cast<uint64_t>(itemType->weight) * std::max<int32_t>(1, count);
	lua_pushnumber(L, weight);
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetHitChance(lua_State* L) {
	// itemType:getHitChance()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->hitChance);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetShootRange(lua_State* L) {
	// itemType:getShootRange()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->shootRange);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetAttack(lua_State* L) {
	// itemType:getAttack()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->attack);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetDefense(lua_State* L) {
	// itemType:getDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->defense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetExtraDefense(lua_State* L) {
	// itemType:getExtraDefense()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->extraDefense);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetImbuementSlot(lua_State* L) {
	// itemType:getImbuementSlot()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->imbuementSlot);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetArmor(lua_State* L) {
	// itemType:getArmor()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->armor);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetWeaponType(lua_State* L) {
	// itemType:getWeaponType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->weaponType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetAmmoType(lua_State* L) {
	// itemType:getAmmoType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->ammoType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetElementType(lua_State* L) {
	// itemType:getElementType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementType);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetElementDamage(lua_State* L) {
	// itemType:getElementDamage()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->elementDamage);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetTransformEquipId(lua_State* L) {
	// itemType:getTransformEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetTransformDeEquipId(lua_State* L) {
	// itemType:getTransformDeEquipId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->transformDeEquipTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetDestroyId(lua_State* L) {
	// itemType:getDestroyId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->destroyTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetDecayId(lua_State* L) {
	// itemType:getDecayId()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->decayTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetRequiredLevel(lua_State* L) {
	// itemType:getRequiredLevel()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->minReqLevel);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetSpeed(lua_State* L) {
	// itemType:getSpeed()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (!itemType) {
		lua_pushnil(L);
		return 1;
	}

	auto& abilities = itemType->abilities;
	if (abilities) {
		lua_pushnumber(L, abilities->speed);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetBaseSpeed(lua_State* L) {
	// itemType:getBaseSpeed()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->speed);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetDecayTime(lua_State* L) {
	// itemType:getDecayTime()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->decayTime);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeGetShowDuration(lua_State* L) {
	// itemType:getShowDuration()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushboolean(L, itemType->showDuration);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
int ItemTypeFunctions::luaItemTypeGetWrapableTo(lua_State* L) {
	// itemType:getWrapableTo()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		lua_pushnumber(L, itemType->wrapableTo);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemTypeFunctions::luaItemTypeHasSubType(lua_State* L) {
	// itemType:hasSubType()
	const ItemType* itemType = getUserdata<const ItemType>(L, 1);
	if (itemType) {
		pushBoolean(L, itemType->hasSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}
