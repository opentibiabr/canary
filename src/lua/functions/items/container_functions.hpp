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

#ifndef SRC_LUA_FUNCTIONS_ITEMS_CONTAINER_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_ITEMS_CONTAINER_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class ContainerFunctions final : LuaScriptInterface {
	public:

	private:
			static void init(lua_State* L) {
				registerClass(L, "Container", "Item", ContainerFunctions::luaContainerCreate);
				registerMetaMethod(L, "Container", "__eq", ContainerFunctions::luaUserdataCompare);

				registerMethod(L, "Container", "getSize", ContainerFunctions::luaContainerGetSize);
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

#endif  // SRC_LUA_FUNCTIONS_ITEMS_CONTAINER_FUNCTIONS_HPP_
