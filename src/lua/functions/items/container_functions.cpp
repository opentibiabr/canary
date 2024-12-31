/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/items/container_functions.hpp"

#include "game/game.hpp"
#include "items/item.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ContainerFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Container", "Item", ContainerFunctions::luaContainerCreate);
	Lua::registerMetaMethod(L, "Container", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Container", "getSize", ContainerFunctions::luaContainerGetSize);
	Lua::registerMethod(L, "Container", "getMaxCapacity", ContainerFunctions::luaContainerGetMaxCapacity);
	Lua::registerMethod(L, "Container", "getCapacity", ContainerFunctions::luaContainerGetCapacity);
	Lua::registerMethod(L, "Container", "getEmptySlots", ContainerFunctions::luaContainerGetEmptySlots);
	Lua::registerMethod(L, "Container", "getContentDescription", ContainerFunctions::luaContainerGetContentDescription);
	Lua::registerMethod(L, "Container", "getItems", ContainerFunctions::luaContainerGetItems);
	Lua::registerMethod(L, "Container", "getItemHoldingCount", ContainerFunctions::luaContainerGetItemHoldingCount);
	Lua::registerMethod(L, "Container", "getItemCountById", ContainerFunctions::luaContainerGetItemCountById);

	Lua::registerMethod(L, "Container", "getItem", ContainerFunctions::luaContainerGetItem);
	Lua::registerMethod(L, "Container", "hasItem", ContainerFunctions::luaContainerHasItem);
	Lua::registerMethod(L, "Container", "addItem", ContainerFunctions::luaContainerAddItem);
	Lua::registerMethod(L, "Container", "addItemEx", ContainerFunctions::luaContainerAddItemEx);
	Lua::registerMethod(L, "Container", "getCorpseOwner", ContainerFunctions::luaContainerGetCorpseOwner);
	Lua::registerMethod(L, "Container", "registerReward", ContainerFunctions::luaContainerRegisterReward);
}

int ContainerFunctions::luaContainerCreate(lua_State* L) {
	// Container(uid)
	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);

	const auto &container = Lua::getScriptEnv()->getContainerByUID(id);
	if (container) {
		Lua::pushUserdata(L, container);
		Lua::setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetSize(lua_State* L) {
	// container:getSize()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetMaxCapacity(lua_State* L) {
	// container:getMaxCapacity()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getMaxCapacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetCapacity(lua_State* L) {
	// container:getCapacity()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->capacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetEmptySlots(lua_State* L) {
	// container:getEmptySlots([recursive = false])
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t slots = container->capacity() - container->size();
	const bool recursive = Lua::getBoolean(L, 2, false);
	if (recursive) {
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			if (const auto &tmpContainer = (*it)->getContainer()) {
				slots += tmpContainer->capacity() - tmpContainer->size();
			}
		}
	}
	lua_pushnumber(L, slots);
	return 1;
}

int ContainerFunctions::luaContainerGetItemHoldingCount(lua_State* L) {
	// container:getItemHoldingCount()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getItemHoldingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItem(lua_State* L) {
	// container:getItem(index)
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t index = Lua::getNumber<uint32_t>(L, 2);
	const auto &item = container->getItemByIndex(index);
	if (item) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerHasItem(lua_State* L) {
	// container:hasItem(item)
	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		Lua::pushBoolean(L, container->isHoldingItem(item));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerAddItem(lua_State* L) {
	// container:addItem(itemId[, count/subType = 1[, index = INDEX_WHEREEVER[, flags = 0]]])
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		Lua::reportErrorFunc("Container is nullptr");
		return 1;
	}

	uint16_t itemId;
	if (Lua::isNumber(L, 2)) {
		itemId = Lua::getNumber<uint16_t>(L, 2);
	} else {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 2));
		if (itemId == 0) {
			lua_pushnil(L);
			Lua::reportErrorFunc("Item id is wrong");
			return 1;
		}
	}

	auto count = Lua::getNumber<uint32_t>(L, 3, 1);
	const ItemType &it = Item::items[itemId];
	if (it.stackable) {
		count = std::min<uint16_t>(count, it.stackSize);
	}

	const auto &item = Item::CreateItem(itemId, count);
	if (!item) {
		lua_pushnil(L);
		Lua::reportErrorFunc("Item is nullptr");
		return 1;
	}

	const auto index = Lua::getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
	const auto flags = Lua::getNumber<uint32_t>(L, 5, 0);

	ReturnValue ret = g_game().internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		Lua::pushUserdata<Item>(L, item);
		Lua::setItemMetatable(L, -1, item);
	} else {
		Lua::reportErrorFunc(fmt::format("Cannot add item to container, error code: '{}'", getReturnMessage(ret)));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ContainerFunctions::luaContainerAddItemEx(lua_State* L) {
	// container:addItemEx(item[, index = INDEX_WHEREEVER[, flags = 0]])
	const auto &item = Lua::getUserdataShared<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		Lua::reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	const auto index = Lua::getNumber<int32_t>(L, 3, INDEX_WHEREEVER);
	const auto flags = Lua::getNumber<uint32_t>(L, 4, 0);
	ReturnValue ret = g_game().internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int ContainerFunctions::luaContainerGetCorpseOwner(lua_State* L) {
	// container:getCorpseOwner()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getCorpseOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItemCountById(lua_State* L) {
	// container:getItemCountById(itemId[, subType = -1])
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
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

	const auto subType = Lua::getNumber<int32_t>(L, 3, -1);
	lua_pushnumber(L, container->getItemTypeCount(itemId, subType));
	return 1;
}

int ContainerFunctions::luaContainerGetContentDescription(lua_State* L) {
	// container:getContentDescription([oldProtocol])
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (container) {
		Lua::pushString(L, container->getContentDescription(Lua::getBoolean(L, 2, false)));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItems(lua_State* L) {
	// container:getItems([recursive = false])
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	const bool recursive = Lua::getBoolean(L, 2, false);
	const std::vector<std::shared_ptr<Item>> items = container->getItems(recursive);

	lua_createtable(L, static_cast<int>(items.size()), 0);

	int index = 0;
	for (const auto &item : items) {
		index++;
		Lua::pushUserdata(L, item);
		Lua::setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ContainerFunctions::luaContainerRegisterReward(lua_State* L) {
	// container:registerReward()
	const auto &container = Lua::getUserdataShared<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	const int64_t rewardId = getTimeMsNow();
	const auto &rewardContainer = Item::CreateItem(ITEM_REWARD_CONTAINER);
	rewardContainer->setAttribute(ItemAttribute_t::DATE, rewardId);
	container->setAttribute(ItemAttribute_t::DATE, rewardId);
	container->internalAddThing(rewardContainer);
	container->setRewardCorpse();

	Lua::pushBoolean(L, true);
	return 1;
}
