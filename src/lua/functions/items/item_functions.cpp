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
#include "items/item.h"
#include "lua/functions/items/item_functions.hpp"
#include "items/decay/decay.h"

class Imbuement;

// Item
int ItemFunctions::luaItemCreate(lua_State* L) {
	// Item(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Item* item = getScriptEnv()->getItemByUID(id);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemIsItem(lua_State* L) {
	// item:isItem()
	pushBoolean(L, getUserdata<const Item>(L, 1) != nullptr);
	return 1;
}

int ItemFunctions::luaItemGetParent(lua_State* L) {
	// item:getParent()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* parent = item->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, parent);
	return 1;
}

int ItemFunctions::luaItemGetTopParent(lua_State* L) {
	// item:getTopParent()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* topParent = item->getTopParent();
	if (!topParent) {
		lua_pushnil(L);
		return 1;
	}

	pushCylinder(L, topParent);
	return 1;
}

int ItemFunctions::luaItemGetId(lua_State* L) {
	// item:getId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemClone(lua_State* L) {
	// item:clone()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Item* clone = item->clone();
	if (!clone) {
		lua_pushnil(L);
		return 1;
	}

	getScriptEnv()->addTempItem(clone);
	clone->setParent(VirtualCylinder::virtualCylinder);

	pushUserdata<Item>(L, clone);
	setItemMetatable(L, -1, clone);
	return 1;
}

int ItemFunctions::luaItemSplit(lua_State* L) {
	// item:split([count = 1])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = *itemPtr;
	if (!item || !item->isStackable() || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t count = std::min<uint16_t>(getNumber<uint16_t>(L, 2, 1), item->getItemCount());
	uint16_t diff = item->getItemCount() - count;

	Item* splitItem = item->clone();
	if (!splitItem) {
		lua_pushnil(L);
		return 1;
	}

	splitItem->setItemCount(count);

	ScriptEnvironment* env = getScriptEnv();
	uint32_t uid = env->addThing(item);

	Item* newItem = g_game().transformItem(item, item->getID(), diff);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	*itemPtr = newItem;

	splitItem->setParent(VirtualCylinder::virtualCylinder);
	env->addTempItem(splitItem);

	pushUserdata<Item>(L, splitItem);
	setItemMetatable(L, -1, splitItem);
	return 1;
}

int ItemFunctions::luaItemRemove(lua_State* L) {
	// item:remove([count = -1])
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		int32_t count = getNumber<int32_t>(L, 2, -1);
		pushBoolean(L, g_game().internalRemoveItem(item, count) == RETURNVALUE_NOERROR);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetUniqueId(lua_State* L) {
	// item:getUniqueId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		uint32_t uniqueId = item->getUniqueId();
		if (uniqueId == 0) {
			uniqueId = getScriptEnv()->addThing(item);
		}
		lua_pushnumber(L, uniqueId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetActionId(lua_State* L) {
	// item:getActionId()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getActionId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetActionId(lua_State* L) {
	// item:setActionId(actionId)
	uint16_t actionId = getNumber<uint16_t>(L, 2);
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		item->setActionId(actionId);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetCount(lua_State* L) {
	// item:getCount()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetCharges(lua_State* L) {
	// item:getCharges()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getCharges());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetFluidType(lua_State* L) {
	// item:getFluidType()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getFluidType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetWeight(lua_State* L) {
	// item:getWeight()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getWeight());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetSubType(lua_State* L) {
	// item:getSubType()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		lua_pushnumber(L, item->getSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetName(lua_State* L) {
	// item:getName()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetPluralName(lua_State* L) {
	// item:getPluralName()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetArticle(lua_State* L) {
	// item:getArticle()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushString(L, item->getArticle());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetPosition(lua_State* L) {
	// item:getPosition()
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		pushPosition(L, item->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetTile(lua_State* L) {
	// item:getTile()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Tile* tile = item->getTile();
	if (tile) {
		pushUserdata<Tile>(L, tile);
		setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemHasAttribute(lua_State* L) {
	// item:hasAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<ItemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	pushBoolean(L, item->hasAttribute(attribute));
	return 1;
}

int ItemFunctions::luaItemGetAttribute(lua_State* L) {
	// item:getAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<ItemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	if (ItemAttributes::isIntAttrType(attribute)) {
		if (attribute == ITEM_ATTRIBUTE_DURATION) {
			lua_pushnumber(L, item->getDuration());
			return 1;
		}

		lua_pushnumber(L, item->getIntAttr(attribute));
	} else if (ItemAttributes::isStrAttrType(attribute)) {
		pushString(L, item->getStrAttr(attribute));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetAttribute(lua_State* L) {
	// item:setAttribute(key, value)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<ItemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	if (ItemAttributes::isIntAttrType(attribute)) {
		switch (attribute) {
			case ITEM_ATTRIBUTE_DECAYSTATE: {
				ItemDecayState_t decayState = getNumber<ItemDecayState_t>(L, 3);
				if (decayState == DECAYING_FALSE || decayState == DECAYING_STOPPING) {
					g_decay().stopDecay(item);
				} else {
					g_decay().startDecay(item);
				}
				pushBoolean(L, true);
				return 1;
			}
			case ITEM_ATTRIBUTE_DURATION: {
				item->setDecaying(DECAYING_PENDING);
				item->setDuration(getNumber<int32_t>(L, 3));
				g_decay().startDecay(item);
				pushBoolean(L, true);
				return 1;
			}
			case ITEM_ATTRIBUTE_DURATION_TIMESTAMP: {
				reportErrorFunc("Attempt to set protected key \"duration timestamp\"");
				pushBoolean(L, false);
				return 1;
			}
			default: break;
		}

		item->setIntAttr(attribute, getNumber<int64_t>(L, 3));
		pushBoolean(L, true);
	} else if (ItemAttributes::isStrAttrType(attribute)) {
		item->setStrAttr(attribute, getString(L, 3));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemRemoveAttribute(lua_State* L) {
	// item:removeAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttrTypes attribute;
	if (isNumber(L, 2)) {
		attribute = getNumber<ItemAttrTypes>(L, 2);
	} else if (isString(L, 2)) {
		attribute = stringToItemAttribute(getString(L, 2));
	} else {
		attribute = ITEM_ATTRIBUTE_NONE;
	}

	bool ret = (attribute != ITEM_ATTRIBUTE_UNIQUEID);
	if (ret) {
		ret = (attribute != ITEM_ATTRIBUTE_DURATION_TIMESTAMP);
		if (ret) {
			item->removeAttribute(attribute);
		} else {
			reportErrorFunc("Attempt to erase protected key \"duration timestamp\"");
		}
	} else {
		reportErrorFunc("Attempt to erase protected key \"uid\"");
	}
	pushBoolean(L, ret);
	return 1;
}

int ItemFunctions::luaItemGetCustomAttribute(lua_State* L) {
	// item:getCustomAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const ItemAttributes::CustomAttribute* attr;
	if (isNumber(L, 2)) {
		attr = item->getCustomAttribute(getNumber<int64_t>(L, 2));
	} else if (isString(L, 2)) {
		attr = item->getCustomAttribute(getString(L, 2));
	} else {
		lua_pushnil(L);
		return 1;
	}

	if (attr) {
		attr->pushToLua(L);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetCustomAttribute(lua_State* L) {
	// item:setCustomAttribute(key, value)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	std::string key;
	if (isNumber(L, 2)) {
		key = boost::lexical_cast<std::string>(getNumber<int64_t>(L, 2));
	} else if (isString(L, 2)) {
		key = getString(L, 2);
	} else {
		lua_pushnil(L);
		return 1;
	}

	ItemAttributes::CustomAttribute val;
	if (isNumber(L, 3)) {
		double tmp = getNumber<double>(L, 3);
		if (std::floor(tmp) < tmp) {
			val.set<double>(tmp);
		} else {
			val.set<int64_t>(tmp);
		}
	} else if (isString(L, 3)) {
		val.set<std::string>(getString(L, 3));
	} else if (isBoolean(L, 3)) {
		val.set<bool>(getBoolean(L, 3));
	} else {
		lua_pushnil(L);
		return 1;
	}

	item->setCustomAttribute(key, val);
	pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemRemoveCustomAttribute(lua_State* L) {
	// item:removeCustomAttribute(key)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	if (isNumber(L, 2)) {
		pushBoolean(L, item->removeCustomAttribute(getNumber<int64_t>(L, 2)));
	} else if (isString(L, 2)) {
		pushBoolean(L, item->removeCustomAttribute(getString(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSerializeAttributes(lua_State* L) {
	// item:serializeAttributes()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	PropWriteStream propWriteStream;
	item->serializeAttr(propWriteStream);

	size_t attributesSize;
	const char* attributes = propWriteStream.getStream(attributesSize);
	lua_pushlstring(L, attributes, attributesSize);
	return 1;
}

int ItemFunctions::luaItemMoveTo(lua_State* L) {
	// item:moveTo(position or cylinder[, flags])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item* item = *itemPtr;
	if (!item || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	Cylinder* toCylinder;
	if (isUserdata(L, 2)) {
		const LuaDataType type = getUserdataType(L, 2);
		switch (type) {
			case LuaData_Container:
				toCylinder = getUserdata<Container>(L, 2);
				break;
			case LuaData_Player:
				toCylinder = getUserdata<Player>(L, 2);
				break;
			case LuaData_Tile:
				toCylinder = getUserdata<Tile>(L, 2);
				break;
			default:
				toCylinder = nullptr;
				break;
		}
	} else {
		toCylinder = g_game().map.getTile(getPosition(L, 2));
	}

	if (!toCylinder) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() == toCylinder) {
		pushBoolean(L, true);
		return 1;
	}

	uint32_t flags = getNumber<uint32_t>(L, 3, FLAG_NOLIMIT | FLAG_IGNOREBLOCKITEM | FLAG_IGNOREBLOCKCREATURE | FLAG_IGNORENOTMOVEABLE);

	if (item->getParent() == VirtualCylinder::virtualCylinder) {
		pushBoolean(L, g_game().internalAddItem(toCylinder, item, INDEX_WHEREEVER, flags) == RETURNVALUE_NOERROR);
	} else {
		Item* moveItem = nullptr;
		ReturnValue ret = g_game().internalMoveItem(item->getParent(), toCylinder, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem, flags);
		if (moveItem) {
			*itemPtr = moveItem;
		}
		pushBoolean(L, ret == RETURNVALUE_NOERROR);
	}
	return 1;
}

int ItemFunctions::luaItemTransform(lua_State* L) {
	// item:transform(itemId[, count/subType = -1])
	Item** itemPtr = getRawUserdata<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	Item*& item = *itemPtr;
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (isNumber(L, 2)) {
		itemId = getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	int32_t subType = getNumber<int32_t>(L, 3, -1);
	if (item->getID() == itemId && (subType == -1 || subType == item->getSubType())) {
		pushBoolean(L, true);
		return 1;
	}

	const ItemType& it = Item::items[itemId];
	if (it.stackable) {
		subType = std::min<int32_t>(subType, 100);
	}

	ScriptEnvironment* env = getScriptEnv();
	uint32_t uid = env->addThing(item);

	Item* newItem = g_game().transformItem(item, itemId, subType);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	item = newItem;
	pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemDecay(lua_State* L) {
	// item:decay(decayId)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		if (isNumber(L, 2)) {
			ItemType& it = Item::items.getItemType(item->getID());
			it.decayTo = getNumber<int32_t>(L, 2);
		}

		item->startDecaying();
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemMoveToSlot(lua_State* L) {
	// item:moveToSlot(player, slot)
	Item* item = getUserdata<Item>(L, 1);
	if (!item || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	Player* player = getUserdata<Player>(L, 2);
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	Slots_t slot = getNumber<Slots_t>(L, 3, CONST_SLOT_WHEREEVER);

	Item* moveItem = nullptr;
	ReturnValue ret = g_game().internalMoveItem(item->getParent(), player, slot, item, item->getItemCount(), nullptr);
	if (moveItem) {
		item = moveItem;
	}

	pushBoolean(L, ret == RETURNVALUE_NOERROR);
	return 1;
}

int ItemFunctions::luaItemGetDescription(lua_State* L) {
	// item:getDescription(distance)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		int32_t distance = getNumber<int32_t>(L, 2);
		pushString(L, item->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemHasProperty(lua_State* L) {
	// item:hasProperty(property)
	Item* item = getUserdata<Item>(L, 1);
	if (item) {
		ItemProperty property = getNumber<ItemProperty>(L, 2);
		pushBoolean(L, item->hasProperty(property));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetImbuement(lua_State* L)
{
	// item:getImbuement()
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		Imbuement *imbuement = imbuementInfo.imbuement;
		if (!imbuement) {
			continue;
		}

		pushUserdata<Imbuement>(L, imbuement);
		setMetatable(L, -1, "Imbuement");

		lua_createtable(L, 0, 3);
		setField(L, "id", imbuement->getID());
		setField(L, "name", imbuement->getName());
		setField(L, "duration", imbuementInfo.duration);
	}
	return 1;
}

int ItemFunctions::luaItemGetImbuementSlot(lua_State* L) {
	// item:getImbuementSlot()
	const Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getImbuementSlot());
	return 1;
}

int ItemFunctions::luaItemSetDuration(lua_State* L) {
	// item:setDuration(minDuration, maxDuration = 0, decayTo = 0, showDuration = true)
	// Example: item:setDuration(10000, 20000, 2129, false) = random duration from range 10000/20000
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	uint32_t minDuration = getNumber<uint32_t>(L, 2);
	uint32_t maxDuration = 0;
	if (lua_gettop(L) > 2) {
		maxDuration = static_cast<uint32_t>(uniform_random(static_cast<int64_t>(minDuration), getNumber<int64_t>(L, 3)));
	}

	uint16_t itemid = 0;
	if (lua_gettop(L) > 3) {
		itemid = getNumber<uint16_t>(L, 4);
	}
	bool showDuration = true;
	if (lua_gettop(L) > 4) {
		showDuration = getBoolean(L, 5);
	}

	ItemType& it = Item::items.getItemType(item->getID());
	if (maxDuration == 0) {
		it.decayTime = minDuration;
	} else {
		it.decayTime = maxDuration;
	}
	it.showDuration = showDuration;
	it.decayTo = itemid;
	item->startDecaying();
	pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemIsInsideDepot(lua_State* L) {
	// item:isInsideDepot([includeInbox = false])
	const Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, item->isInsideDepot(getBoolean(L, 2, false)));
	return 1;
}

int ItemFunctions::luaItemGetTier(lua_State* L) {
	// item:getTier()
	const Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getTier());
	return 1;
}

int ItemFunctions::luaItemSetTier(lua_State* L) {
	// item:setTier(tier)
	Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	item->setTier(getNumber<uint8_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemGetClassification(lua_State* L) {
	// item:getClassification()
	const Item* item = getUserdata<Item>(L, 1);
	if (!item) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getClassification());
	return 1;
}
