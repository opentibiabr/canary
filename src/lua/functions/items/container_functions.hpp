/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class ContainerFunctions final : LuaScriptInterface {
public:
private:
	static void init(lua_State* L) {
		registerSharedClass(L, "Container", "Item", ContainerFunctions::luaContainerCreate);
		registerMetaMethod(L, "Container", "__eq", ContainerFunctions::luaUserdataCompare);

		registerMethod(L, "Container", "getSize", ContainerFunctions::luaContainerGetSize);
		registerMethod(L, "Container", "getMaxCapacity", ContainerFunctions::luaContainerGetMaxCapacity);
		registerMethod(L, "Container", "getCapacity", ContainerFunctions::luaContainerGetCapacity);
		registerMethod(L, "Container", "getEmptySlots", ContainerFunctions::luaContainerGetEmptySlots);
		registerMethod(L, "Container", "getContentDescription", ContainerFunctions::luaContainerGetContentDescription);
		registerMethod(L, "Container", "getItems", ContainerFunctions::luaContainerGetItems);
		registerMethod(L, "Container", "getItemHoldingCount", ContainerFunctions::luaContainerGetItemHoldingCount);
		registerMethod(L, "Container", "getItemCountById", ContainerFunctions::luaContainerGetItemCountById);

		registerMethod(L, "Container", "getItem", ContainerFunctions::luaContainerGetItem);
		registerMethod(L, "Container", "hasItem", ContainerFunctions::luaContainerHasItem);
		registerMethod(L, "Container", "addItem", ContainerFunctions::luaContainerAddItem);
		registerMethod(L, "Container", "addItemEx", ContainerFunctions::luaContainerAddItemEx);
		registerMethod(L, "Container", "getCorpseOwner", ContainerFunctions::luaContainerGetCorpseOwner);
		registerMethod(L, "Container", "registerReward", ContainerFunctions::luaContainerRegisterReward);
	}

	static int luaContainerCreate(lua_State* L);

	static int luaContainerGetSize(lua_State* L);
	static int luaContainerGetMaxCapacity(lua_State* L);
	static int luaContainerGetCapacity(lua_State* L);
	static int luaContainerGetEmptySlots(lua_State* L);

	static int luaContainerGetContentDescription(lua_State* L);
	static int luaContainerGetItems(lua_State* L);
	static int luaContainerGetItemHoldingCount(lua_State* L);
	static int luaContainerGetItemCountById(lua_State* L);

	static int luaContainerGetItem(lua_State* L);
	static int luaContainerHasItem(lua_State* L);
	static int luaContainerAddItem(lua_State* L);
	static int luaContainerAddItemEx(lua_State* L);

	static int luaContainerGetCorpseOwner(lua_State* L);
	static int luaContainerRegisterReward(lua_State* L);

	friend class ItemFunctions;
};
