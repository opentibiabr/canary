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
#include "lua/functions/items/container_functions.hpp"

int ContainerFunctions::luaContainerCreate(lua_State* L) {
	// Container(uid)
	uint32_t id = getNumber<uint32_t>(L, 2);

	Container* container = getScriptEnv()->getContainerByUID(id);
	if (container) {
		pushUserdata(L, container);
		setMetatable(L, -1, "Container");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetSize(lua_State* L) {
	// container:getSize()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->size());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetCapacity(lua_State* L) {
	// container:getCapacity()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->capacity());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetEmptySlots(lua_State* L) {
	// container:getEmptySlots([recursive = false])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t slots = container->capacity() - container->size();
	bool recursive = getBoolean(L, 2, false);
	if (recursive) {
		for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance()) {
			if (Container* tmpContainer = (*it)->getContainer()) {
				slots += tmpContainer->capacity() - tmpContainer->size();
			}
		}
	}
	lua_pushnumber(L, slots);
	return 1;
}

int ContainerFunctions::luaContainerGetItemHoldingCount(lua_State* L) {
	// container:getItemHoldingCount()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getItemHoldingCount());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItem(lua_State* L) {
	// container:getItem(index)
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t index = getNumber<uint32_t>(L, 2);
	Item* item = container->getItemByIndex(index);
	if (item) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerHasItem(lua_State* L) {
	// container:hasItem(item)
	Item* item = getUserdata<Item>(L, 2);
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		pushBoolean(L, container->isHoldingItem(item));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerAddItem(lua_State* L) {
	// container:addItem(itemId[, count/subType = 1[, index = INDEX_WHEREEVER[, flags = 0]]])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
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

	uint32_t count = getNumber<uint32_t>(L, 3, 1);
	const ItemType& it = Item::items[itemId];
	if (it.stackable) {
		count = std::min<uint16_t>(count, 100);
	}

	Item* item = Item::CreateItem(itemId, count);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	int32_t index = getNumber<int32_t>(L, 4, INDEX_WHEREEVER);
	uint32_t flags = getNumber<uint32_t>(L, 5, 0);

	ReturnValue ret = g_game().internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		pushUserdata<Item>(L, item);
		setItemMetatable(L, -1, item);
	} else {
		delete item;
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerAddItemEx(lua_State* L) {
	// container:addItemEx(item[, index = INDEX_WHEREEVER[, flags = 0]])
	Item* item = getUserdata<Item>(L, 2);
	if (!item) {
		lua_pushnil(L);
		return 1;
	}

	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	if (item->getParent() != VirtualCylinder::virtualCylinder) {
		reportErrorFunc("Item already has a parent");
		lua_pushnil(L);
		return 1;
	}

	int32_t index = getNumber<int32_t>(L, 3, INDEX_WHEREEVER);
	uint32_t flags = getNumber<uint32_t>(L, 4, 0);
	ReturnValue ret = g_game().internalAddItem(container, item, index, flags);
	if (ret == RETURNVALUE_NOERROR) {
		ScriptEnvironment::removeTempItem(item);
	}
	lua_pushnumber(L, ret);
	return 1;
}

int ContainerFunctions::luaContainerGetCorpseOwner(lua_State* L) {
	// container:getCorpseOwner()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		lua_pushnumber(L, container->getCorpseOwner());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItemCountById(lua_State* L) {
	// container:getItemCountById(itemId[, subType = -1])
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
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
	lua_pushnumber(L, container->getItemTypeCount(itemId, subType));
	return 1;
}

int ContainerFunctions::luaContainerGetContentDescription(lua_State* L) {
	// container:getContentDescription()
	Container* container = getUserdata<Container>(L, 1);
	if (container) {
		pushString(L, container->getContentDescription());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ContainerFunctions::luaContainerGetItems(lua_State* L) {
	// container:getItems([recursive = false])
	const Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	bool recursive = getBoolean(L, 2, false);
	std::vector<Item*> items = container->getItems(recursive);

	lua_createtable(L, static_cast<int>(items.size()), 0);

	int index = 0;
	for (Item* item : items) {
		index++;
		pushUserdata(L, item);
		setItemMetatable(L, -1, item);
		lua_rawseti(L, -2, index);
	}
	return 1;
}

int ContainerFunctions::luaContainerRegisterReward(lua_State* L) {
	// container:registerReward()
	Container* container = getUserdata<Container>(L, 1);
	if (!container) {
		lua_pushnil(L);
		return 1;
	}

	auto timestamp = time(nullptr);
	Item * rewardContainer = Item::CreateItem(ITEM_REWARD_CONTAINER);
	rewardContainer->setIntAttr(ITEM_ATTRIBUTE_DATE, timestamp);
	container->setIntAttr(ITEM_ATTRIBUTE_DATE, timestamp);
	container->internalAddThing(rewardContainer);
	container->setRewardCorpse();

	pushBoolean(L, true);
	return 1;
}
