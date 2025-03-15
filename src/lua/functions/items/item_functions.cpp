/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/items/item_functions.hpp"

#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/save_manager.hpp"
#include "items/decay/decay.hpp"
#include "items/item.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ItemFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Item", "", ItemFunctions::luaItemCreate);
	Lua::registerMetaMethod(L, "Item", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Item", "isItem", ItemFunctions::luaItemIsItem);

	Lua::registerMethod(L, "Item", "getContainer", ItemFunctions::luaItemGetContainer);
	Lua::registerMethod(L, "Item", "getParent", ItemFunctions::luaItemGetParent);
	Lua::registerMethod(L, "Item", "getTopParent", ItemFunctions::luaItemGetTopParent);

	Lua::registerMethod(L, "Item", "getId", ItemFunctions::luaItemGetId);

	Lua::registerMethod(L, "Item", "clone", ItemFunctions::luaItemClone);
	Lua::registerMethod(L, "Item", "split", ItemFunctions::luaItemSplit);
	Lua::registerMethod(L, "Item", "remove", ItemFunctions::luaItemRemove);

	Lua::registerMethod(L, "Item", "getUniqueId", ItemFunctions::luaItemGetUniqueId);
	Lua::registerMethod(L, "Item", "getActionId", ItemFunctions::luaItemGetActionId);
	Lua::registerMethod(L, "Item", "setActionId", ItemFunctions::luaItemSetActionId);

	Lua::registerMethod(L, "Item", "getCount", ItemFunctions::luaItemGetCount);
	Lua::registerMethod(L, "Item", "getCharges", ItemFunctions::luaItemGetCharges);
	Lua::registerMethod(L, "Item", "getFluidType", ItemFunctions::luaItemGetFluidType);
	Lua::registerMethod(L, "Item", "getWeight", ItemFunctions::luaItemGetWeight);

	Lua::registerMethod(L, "Item", "getSubType", ItemFunctions::luaItemGetSubType);

	Lua::registerMethod(L, "Item", "getName", ItemFunctions::luaItemGetName);
	Lua::registerMethod(L, "Item", "getPluralName", ItemFunctions::luaItemGetPluralName);
	Lua::registerMethod(L, "Item", "getArticle", ItemFunctions::luaItemGetArticle);

	Lua::registerMethod(L, "Item", "getPosition", ItemFunctions::luaItemGetPosition);
	Lua::registerMethod(L, "Item", "getTile", ItemFunctions::luaItemGetTile);

	Lua::registerMethod(L, "Item", "hasAttribute", ItemFunctions::luaItemHasAttribute);
	Lua::registerMethod(L, "Item", "getAttribute", ItemFunctions::luaItemGetAttribute);
	Lua::registerMethod(L, "Item", "setAttribute", ItemFunctions::luaItemSetAttribute);
	Lua::registerMethod(L, "Item", "removeAttribute", ItemFunctions::luaItemRemoveAttribute);
	Lua::registerMethod(L, "Item", "getCustomAttribute", ItemFunctions::luaItemGetCustomAttribute);
	Lua::registerMethod(L, "Item", "setCustomAttribute", ItemFunctions::luaItemSetCustomAttribute);
	Lua::registerMethod(L, "Item", "removeCustomAttribute", ItemFunctions::luaItemRemoveCustomAttribute);
	Lua::registerMethod(L, "Item", "canBeMoved", ItemFunctions::luaItemCanBeMoved);

	Lua::registerMethod(L, "Item", "setOwner", ItemFunctions::luaItemSetOwner);
	Lua::registerMethod(L, "Item", "getOwnerId", ItemFunctions::luaItemGetOwnerId);
	Lua::registerMethod(L, "Item", "isOwner", ItemFunctions::luaItemIsOwner);
	Lua::registerMethod(L, "Item", "getOwnerName", ItemFunctions::luaItemGetOwnerName);
	Lua::registerMethod(L, "Item", "hasOwner", ItemFunctions::luaItemHasOwner);
	Lua::registerMethod(L, "Item", "actor", ItemFunctions::luaItemActor);

	Lua::registerMethod(L, "Item", "moveTo", ItemFunctions::luaItemMoveTo);
	Lua::registerMethod(L, "Item", "transform", ItemFunctions::luaItemTransform);
	Lua::registerMethod(L, "Item", "decay", ItemFunctions::luaItemDecay);

	Lua::registerMethod(L, "Item", "serializeAttributes", ItemFunctions::luaItemSerializeAttributes);
	Lua::registerMethod(L, "Item", "moveToSlot", ItemFunctions::luaItemMoveToSlot);

	Lua::registerMethod(L, "Item", "getDescription", ItemFunctions::luaItemGetDescription);

	Lua::registerMethod(L, "Item", "hasProperty", ItemFunctions::luaItemHasProperty);

	Lua::registerMethod(L, "Item", "getImbuementSlot", ItemFunctions::luaItemGetImbuementSlot);
	Lua::registerMethod(L, "Item", "getImbuement", ItemFunctions::luaItemGetImbuement);

	Lua::registerMethod(L, "Item", "setDuration", ItemFunctions::luaItemSetDuration);

	Lua::registerMethod(L, "Item", "isInsideDepot", ItemFunctions::luaItemIsInsideDepot);
	Lua::registerMethod(L, "Item", "isContainer", ItemFunctions::luaItemIsContainer);

	Lua::registerMethod(L, "Item", "getTier", ItemFunctions::luaItemGetTier);
	Lua::registerMethod(L, "Item", "setTier", ItemFunctions::luaItemSetTier);
	Lua::registerMethod(L, "Item", "getClassification", ItemFunctions::luaItemGetClassification);

	Lua::registerMethod(L, "Item", "canReceiveAutoCarpet", ItemFunctions::luaItemCanReceiveAutoCarpet);

	ContainerFunctions::init(L);
	ImbuementFunctions::init(L);
	ItemTypeFunctions::init(L);
	WeaponFunctions::init(L);
}

// Item
int ItemFunctions::luaItemCreate(lua_State* L) {
	// Item(uid)
	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);

	const auto &item = Lua::getScriptEnv()->getItemByUID(id);
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemIsItem(lua_State* L) {
	// item:isItem()
	Lua::pushBoolean(L, Lua::getUserdataShared<Item>(L, 1, "Item") != nullptr);
	return 1;
}

int ItemFunctions::luaItemGetContainer(lua_State* L) {
	// item:getContainer()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = item->getContainer();
	if (!container) {
		g_logger().trace("Item {} is not a container", item->getName());
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushUserdata(L, container);
	return 1;
}

int ItemFunctions::luaItemGetParent(lua_State* L) {
	// item:getParent()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &parent = item->getParent();
	if (!parent) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushCylinder(L, parent);
	return 1;
}

int ItemFunctions::luaItemGetTopParent(lua_State* L) {
	// item:getTopParent()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &topParent = item->getTopParent();
	if (!topParent) {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushCylinder(L, topParent);
	return 1;
}

int ItemFunctions::luaItemGetId(lua_State* L) {
	// item:getId()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, item->getID());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemClone(lua_State* L) {
	// item:clone()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &clone = item->clone();
	if (!clone) {
		lua_pushnil(L);
		return 1;
	}

	Lua::getScriptEnv()->addTempItem(clone);
	clone->setParent(VirtualCylinder::virtualCylinder);

	Lua::pushUserdata<Item>(L, clone);
	Lua::setItemMetatable(L, -1, clone);
	return 1;
}

int ItemFunctions::luaItemSplit(lua_State* L) {
	// item:split([count = 1])
	const auto &itemPtr = Lua::getRawUserDataShared<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = *itemPtr;
	if (!item || !item->isStackable() || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	const uint16_t count = std::min<uint16_t>(Lua::getNumber<uint16_t>(L, 2, 1), item->getItemCount());
	const uint16_t diff = item->getItemCount() - count;

	const auto &splitItem = item->clone();
	if (!splitItem) {
		lua_pushnil(L);
		return 1;
	}

	splitItem->setItemCount(count);

	ScriptEnvironment* env = Lua::getScriptEnv();
	const uint32_t uid = env->addThing(item);

	const auto &newItem = g_game().transformItem(item, item->getID(), diff);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	*itemPtr = newItem;

	splitItem->setParent(VirtualCylinder::virtualCylinder);
	env->addTempItem(splitItem);

	Lua::pushUserdata<Item>(L, splitItem);
	Lua::setItemMetatable(L, -1, splitItem);
	return 1;
}

int ItemFunctions::luaItemRemove(lua_State* L) {
	// item:remove([count = -1])
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		const auto count = Lua::getNumber<int32_t>(L, 2, -1);
		Lua::pushBoolean(L, g_game().internalRemoveItem(item, count) == RETURNVALUE_NOERROR);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetUniqueId(lua_State* L) {
	// item:getUniqueId()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		uint32_t uniqueId = item->getAttribute<uint16_t>(ItemAttribute_t::UNIQUEID);
		if (uniqueId == 0) {
			uniqueId = Lua::getScriptEnv()->addThing(item);
		}
		lua_pushnumber(L, static_cast<lua_Number>(uniqueId));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetActionId(lua_State* L) {
	// item:getActionId()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		const auto actionId = item->getAttribute<uint16_t>(ItemAttribute_t::ACTIONID);
		lua_pushnumber(L, actionId);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetActionId(lua_State* L) {
	// item:setActionId(actionId)
	const uint16_t actionId = Lua::getNumber<uint16_t>(L, 2);
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		item->setAttribute(ItemAttribute_t::ACTIONID, actionId);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetCount(lua_State* L) {
	// item:getCount()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, item->getItemCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetCharges(lua_State* L) {
	// item:getCharges()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, item->getCharges());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetFluidType(lua_State* L) {
	// item:getFluidType()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, static_cast<lua_Number>(item->getAttribute<uint16_t>(ItemAttribute_t::FLUIDTYPE)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetWeight(lua_State* L) {
	// item:getWeight()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, item->getWeight());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetSubType(lua_State* L) {
	// item:getSubType()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		lua_pushnumber(L, item->getSubType());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetName(lua_State* L) {
	// item:getName()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		Lua::pushString(L, item->getName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetPluralName(lua_State* L) {
	// item:getPluralName()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		Lua::pushString(L, item->getPluralName());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetArticle(lua_State* L) {
	// item:getArticle()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		Lua::pushString(L, item->getArticle());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetPosition(lua_State* L) {
	// item:Lua::getPosition()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		Lua::pushPosition(L, item->getPosition());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetTile(lua_State* L) {
	// item:getTile()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &tile = item->getTile();
	if (tile) {
		Lua::pushUserdata<Tile>(L, tile);
		Lua::setMetatable(L, -1, "Tile");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemHasAttribute(lua_State* L) {
	// item:hasAttribute(key)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttribute_t attribute;
	if (Lua::isNumber(L, 2)) {
		attribute = Lua::getNumber<ItemAttribute_t>(L, 2);
	} else if (Lua::isString(L, 2)) {
		attribute = stringToItemAttribute(Lua::getString(L, 2));
	} else {
		attribute = ItemAttribute_t::NONE;
	}

	Lua::pushBoolean(L, item->hasAttribute(attribute));
	return 1;
}

int ItemFunctions::luaItemGetAttribute(lua_State* L) {
	// item:getAttribute(key)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttribute_t attribute;
	if (Lua::isNumber(L, 2)) {
		attribute = Lua::getNumber<ItemAttribute_t>(L, 2);
	} else if (Lua::isString(L, 2)) {
		attribute = stringToItemAttribute(Lua::getString(L, 2));
	} else {
		attribute = ItemAttribute_t::NONE;
	}

	if (item->isAttributeInteger(attribute)) {
		if (attribute == ItemAttribute_t::DURATION) {
			lua_pushnumber(L, static_cast<lua_Number>(item->getDuration()));
			return 1;
		}

		lua_pushnumber(L, static_cast<lua_Number>(item->getAttribute<int64_t>(attribute)));
	} else if (item->isAttributeString(attribute)) {
		Lua::pushString(L, item->getAttribute<std::string>(attribute));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetAttribute(lua_State* L) {
	// item:setAttribute(key, value)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttribute_t attribute;
	if (Lua::isNumber(L, 2)) {
		attribute = Lua::getNumber<ItemAttribute_t>(L, 2);
	} else if (Lua::isString(L, 2)) {
		attribute = stringToItemAttribute(Lua::getString(L, 2));
	} else {
		attribute = ItemAttribute_t::NONE;
	}

	if (item->isAttributeInteger(attribute)) {
		switch (attribute) {
			case ItemAttribute_t::DECAYSTATE: {
				if (const auto decayState = Lua::getNumber<ItemDecayState_t>(L, 3);
				    decayState == DECAYING_FALSE || decayState == DECAYING_STOPPING) {
					g_decay().stopDecay(item);
				} else {
					g_decay().startDecay(item);
				}
				Lua::pushBoolean(L, true);
				return 1;
			}
			case ItemAttribute_t::DURATION: {
				item->setDecaying(DECAYING_PENDING);
				item->setDuration(Lua::getNumber<int32_t>(L, 3));
				g_decay().startDecay(item);
				Lua::pushBoolean(L, true);
				return 1;
			}
			case ItemAttribute_t::DURATION_TIMESTAMP: {
				Lua::reportErrorFunc("Attempt to set protected key \"duration timestamp\"");
				Lua::pushBoolean(L, false);
				return 1;
			}
			default:
				break;
		}

		item->setAttribute(attribute, Lua::getNumber<int64_t>(L, 3));
		item->updateTileFlags();
		Lua::pushBoolean(L, true);
	} else if (item->isAttributeString(attribute)) {
		const auto newAttributeString = Lua::getString(L, 3);
		item->setAttribute(attribute, newAttributeString);
		item->updateTileFlags();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemRemoveAttribute(lua_State* L) {
	// item:removeAttribute(key)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	ItemAttribute_t attribute;
	if (Lua::isNumber(L, 2)) {
		attribute = Lua::getNumber<ItemAttribute_t>(L, 2);
	} else if (Lua::isString(L, 2)) {
		attribute = stringToItemAttribute(Lua::getString(L, 2));
	} else {
		attribute = ItemAttribute_t::NONE;
	}

	bool ret = (attribute != ItemAttribute_t::UNIQUEID);
	if (ret) {
		ret = (attribute != ItemAttribute_t::DURATION_TIMESTAMP);
		if (ret) {
			item->removeAttribute(attribute);
		} else {
			Lua::reportErrorFunc("Attempt to erase protected key \"duration timestamp\"");
		}
	} else {
		Lua::reportErrorFunc("Attempt to erase protected key \"uid\"");
	}
	Lua::pushBoolean(L, ret);
	return 1;
}

int ItemFunctions::luaItemGetCustomAttribute(lua_State* L) {
	// item:getCustomAttribute(key)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const CustomAttribute* customAttribute;
	if (Lua::isNumber(L, 2)) {
		customAttribute = item->getCustomAttribute(std::to_string(Lua::getNumber<int64_t>(L, 2)));
	} else if (Lua::isString(L, 2)) {
		customAttribute = item->getCustomAttribute(Lua::getString(L, 2));
	} else {
		lua_pushnil(L);
		return 1;
	}

	if (customAttribute) {
		customAttribute->pushToLua(L);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSetCustomAttribute(lua_State* L) {
	// item:setCustomAttribute(key, value)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	std::string key;
	if (Lua::isNumber(L, 2)) {
		key = std::to_string(Lua::getNumber<int64_t>(L, 2));
	} else if (Lua::isString(L, 2)) {
		key = Lua::getString(L, 2);
	} else {
		lua_pushnil(L);
		return 1;
	}

	if (Lua::isNumber(L, 3)) {
		const double doubleValue = Lua::getNumber<double>(L, 3);
		if (std::floor(doubleValue) < doubleValue) {
			item->setCustomAttribute(key, doubleValue);
		} else {
			const int64_t int64 = Lua::getNumber<int64_t>(L, 3);
			item->setCustomAttribute(key, int64);
		}
	} else if (Lua::isString(L, 3)) {
		const std::string stringValue = Lua::getString(L, 3);
		item->setCustomAttribute(key, stringValue);
	} else if (Lua::isBoolean(L, 3)) {
		const bool boolValue = Lua::getBoolean(L, 3);
		item->setCustomAttribute(key, boolValue);
	} else {
		lua_pushnil(L);
		return 1;
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemRemoveCustomAttribute(lua_State* L) {
	// item:removeCustomAttribute(key)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	if (Lua::isNumber(L, 2)) {
		Lua::pushBoolean(L, item->removeCustomAttribute(std::to_string(Lua::getNumber<int64_t>(L, 2))));
	} else if (Lua::isString(L, 2)) {
		Lua::pushBoolean(L, item->removeCustomAttribute(Lua::getString(L, 2)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemCanBeMoved(lua_State* L) {
	// item:canBeMoved()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		Lua::pushBoolean(L, item->canBeMoved());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemSerializeAttributes(lua_State* L) {
	// item:serializeAttributes()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
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
	const auto &itemPtr = Lua::getRawUserDataShared<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	const auto &item = *itemPtr;
	if (!item || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	std::shared_ptr<Cylinder> toCylinder;
	if (Lua::isUserdata(L, 2)) {
		const LuaData_t type = Lua::getUserdataType(L, 2);
		switch (type) {
			case LuaData_t::Container:
				toCylinder = Lua::getUserdataShared<Container>(L, 2, "Container");
				break;
			case LuaData_t::Player:
				toCylinder = Lua::getUserdataShared<Player>(L, 2, "Player");
				break;
			case LuaData_t::Tile:
				toCylinder = Lua::getUserdataShared<Tile>(L, 2, "Tile");
				break;
			default:
				toCylinder = nullptr;
				break;
		}
	} else {
		toCylinder = g_game().map.getTile(Lua::getPosition(L, 2));
	}

	if (!toCylinder) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() == toCylinder) {
		Lua::pushBoolean(L, true);
		return 1;
	}

	const auto flags = Lua::getNumber<uint32_t>(L, 3, FLAG_NOLIMIT | FLAG_IGNOREBLOCKITEM | FLAG_IGNOREBLOCKCREATURE | FLAG_IGNORENOTMOVABLE);

	if (item->getParent() == VirtualCylinder::virtualCylinder) {
		Lua::pushBoolean(L, g_game().internalAddItem(toCylinder, item, INDEX_WHEREEVER, flags) == RETURNVALUE_NOERROR);
	} else {
		std::shared_ptr<Item> moveItem = nullptr;
		ReturnValue ret = g_game().internalMoveItem(item->getParent(), toCylinder, INDEX_WHEREEVER, item, item->getItemCount(), &moveItem, flags);
		if (moveItem) {
			*itemPtr = moveItem;
		}
		Lua::pushBoolean(L, ret == RETURNVALUE_NOERROR);
	}
	return 1;
}

int ItemFunctions::luaItemTransform(lua_State* L) {
	// item:transform(itemId[, count/subType = -1])
	const auto &itemPtr = Lua::getRawUserDataShared<Item>(L, 1);
	if (!itemPtr) {
		lua_pushnil(L);
		return 1;
	}

	auto &item = *itemPtr;
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			return 1;
		}
	}

	auto subType = Lua::getNumber<int32_t>(L, 3, -1);
	if (item->getID() == itemId && (subType == -1 || subType == item->getSubType())) {
		Lua::pushBoolean(L, true);
		return 1;
	}

	const ItemType &it = Item::items[itemId];
	if (it.stackable) {
		subType = std::min<int32_t>(subType, it.stackSize);
	}

	ScriptEnvironment* env = Lua::getScriptEnv();
	const uint32_t uid = env->addThing(item);

	const auto &newItem = g_game().transformItem(item, itemId, subType);
	if (item->isRemoved()) {
		env->removeItemByUID(uid);
	}

	if (newItem && newItem != item) {
		env->insertItem(uid, newItem);
	}

	item = newItem;
	Lua::pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemDecay(lua_State* L) {
	// item:decay(decayId)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		if (Lua::isNumber(L, 2)) {
			ItemType &it = Item::items.getItemType(item->getID());
			it.decayTo = Lua::getNumber<int32_t>(L, 2);
		}

		item->startDecaying();
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemMoveToSlot(lua_State* L) {
	// item:moveToSlot(player, slot)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item || item->isRemoved()) {
		lua_pushnil(L);
		return 1;
	}

	const auto &player = Lua::getUserdataShared<Player>(L, 2, "Player");
	if (!player) {
		lua_pushnil(L);
		return 1;
	}

	const auto slot = Lua::getNumber<Slots_t>(L, 3, CONST_SLOT_WHEREEVER);

	ReturnValue ret = g_game().internalMoveItem(item->getParent(), player, slot, item, item->getItemCount(), nullptr);

	Lua::pushBoolean(L, ret == RETURNVALUE_NOERROR);
	return 1;
}

int ItemFunctions::luaItemGetDescription(lua_State* L) {
	// item:getDescription(distance)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		const int32_t distance = Lua::getNumber<int32_t>(L, 2);
		Lua::pushString(L, item->getDescription(distance));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemHasProperty(lua_State* L) {
	// item:hasProperty(property)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (item) {
		const ItemProperty property = Lua::getNumber<ItemProperty>(L, 2);
		Lua::pushBoolean(L, item->hasProperty(property));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ItemFunctions::luaItemGetImbuement(lua_State* L) {
	// item:getImbuement()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	for (uint8_t slotid = 0; slotid < item->getImbuementSlot(); slotid++) {
		ImbuementInfo imbuementInfo;
		if (!item->getImbuementInfo(slotid, &imbuementInfo)) {
			continue;
		}

		Imbuement* imbuement = imbuementInfo.imbuement;
		if (!imbuement) {
			continue;
		}

		Lua::pushUserdata<Imbuement>(L, imbuement);
		Lua::setMetatable(L, -1, "Imbuement");

		lua_createtable(L, 0, 3);
		Lua::setField(L, "id", imbuement->getID());
		Lua::setField(L, "name", imbuement->getName());
		Lua::setField(L, "duration", static_cast<lua_Number>(imbuementInfo.duration));
	}
	return 1;
}

int ItemFunctions::luaItemGetImbuementSlot(lua_State* L) {
	// item:getImbuementSlot()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getImbuementSlot());
	return 1;
}

int ItemFunctions::luaItemSetDuration(lua_State* L) {
	// item:setDuration(minDuration, maxDuration = 0, decayTo = 0, showDuration = true)
	// Example: item:setDuration(10000, 20000, 2129, false) = random duration from range 10000/20000
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const uint32_t minDuration = Lua::getNumber<uint32_t>(L, 2);
	uint32_t maxDuration = 0;
	if (lua_gettop(L) > 2) {
		maxDuration = uniform_random(minDuration, Lua::getNumber<uint32_t>(L, 3));
	}

	uint16_t itemid = 0;
	if (lua_gettop(L) > 3) {
		itemid = Lua::getNumber<uint16_t>(L, 4);
	}
	bool showDuration = true;
	if (lua_gettop(L) > 4) {
		showDuration = Lua::getBoolean(L, 5);
	}

	ItemType &it = Item::items.getItemType(item->getID());
	if (maxDuration == 0) {
		it.decayTime = minDuration;
	} else {
		it.decayTime = maxDuration;
	}
	it.showDuration = showDuration;
	it.decayTo = itemid;
	item->startDecaying();
	Lua::pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemIsInsideDepot(lua_State* L) {
	// item:isInsideDepot([includeInbox = false])
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, item->isInsideDepot(Lua::getBoolean(L, 2, false)));
	return 1;
}

int ItemFunctions::luaItemIsContainer(lua_State* L) {
	// item:isContainer()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const auto &it = Item::items[item->getID()];
	Lua::pushBoolean(L, it.isContainer());
	return 1;
}

int ItemFunctions::luaItemGetTier(lua_State* L) {
	// item:getTier()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getTier());
	return 1;
}

int ItemFunctions::luaItemSetTier(lua_State* L) {
	// item:setTier(tier)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	item->setTier(Lua::getNumber<uint8_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int ItemFunctions::luaItemGetClassification(lua_State* L) {
	// item:getClassification()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, item->getClassification());
	return 1;
}

int ItemFunctions::luaItemCanReceiveAutoCarpet(lua_State* L) {
	// item:canReceiveAutoCarpet()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, item->canReceiveAutoCarpet());
	return 1;
}

int ItemFunctions::luaItemSetOwner(lua_State* L) {
	// item:setOwner(creature|creatureId)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 0;
	}

	if (Lua::isUserdata(L, 2)) {
		const auto &creature = Lua::getUserdataShared<Creature>(L, 2, "Creature");
		if (!creature) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
			return 0;
		}
		item->setOwner(creature);
		Lua::pushBoolean(L, true);
		return 1;
	}

	const auto creatureId = Lua::getNumber<uint32_t>(L, 2);
	if (creatureId != 0) {
		item->setOwner(creatureId);
		Lua::pushBoolean(L, true);
		return 1;
	}

	Lua::pushBoolean(L, false);
	return 1;
}

int ItemFunctions::luaItemGetOwnerId(lua_State* L) {
	// item:getOwner()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 0;
	}

	if (const auto ownerId = item->getOwnerId()) {
		lua_pushnumber(L, ownerId);
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int ItemFunctions::luaItemIsOwner(lua_State* L) {
	// item:isOwner(creature|creatureId)
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 0;
	}

	if (Lua::isUserdata(L, 2)) {
		const auto &creature = Lua::getUserdataShared<Creature>(L, 2, "Creature");
		if (!creature) {
			Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_PLAYER_NOT_FOUND));
			return 0;
		}
		Lua::pushBoolean(L, item->isOwner(creature));
		return 1;
	}

	const auto creatureId = Lua::getNumber<uint32_t>(L, 2);
	if (creatureId != 0) {
		Lua::pushBoolean(L, item->isOwner(creatureId));
		return 1;
	}

	Lua::pushBoolean(L, false);
	return 1;
}

int ItemFunctions::luaItemGetOwnerName(lua_State* L) {
	// item:getOwnerName()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 0;
	}

	if (const auto ownerName = item->getOwnerName(); !ownerName.empty()) {
		Lua::pushString(L, ownerName);
		return 1;
	}

	lua_pushnil(L);
	return 1;
}

int ItemFunctions::luaItemHasOwner(lua_State* L) {
	// item:hasOwner()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 1;
	}

	Lua::pushBoolean(L, item->hasOwner());
	return 1;
}

int ItemFunctions::luaItemActor(lua_State* L) {
	// item:actor()
	const auto &item = Lua::getUserdataShared<Item>(L, 1, "Item");
	if (!item) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ITEM_NOT_FOUND));
		return 1;
	}

	if (lua_gettop(L) == 1) {
		Lua::pushBoolean(L, item->hasActor());
	} else {
		item->setActor(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	}

	return 1;
}
