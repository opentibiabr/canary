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

#ifndef SRC_LUA_FUNCTIONS_EVENTS_MOVE_EVENT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_EVENTS_MOVE_EVENT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class MoveEventFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "MoveEvent", "", MoveEventFunctions::luaCreateMoveEvent);
			registerMethod(L, "MoveEvent", "type", MoveEventFunctions::luaMoveEventType);
			registerMethod(L, "MoveEvent", "register", MoveEventFunctions::luaMoveEventRegister);
			registerMethod(L, "MoveEvent", "level", MoveEventFunctions::luaMoveEventLevel);
			registerMethod(L, "MoveEvent", "magicLevel", MoveEventFunctions::luaMoveEventMagLevel);
			registerMethod(L, "MoveEvent", "slot", MoveEventFunctions::luaMoveEventSlot);
			registerMethod(L, "MoveEvent", "id", MoveEventFunctions::luaMoveEventItemId);
			registerMethod(L, "MoveEvent", "aid", MoveEventFunctions::luaMoveEventActionId);
			registerMethod(L, "MoveEvent", "uid", MoveEventFunctions::luaMoveEventUniqueId);
			registerMethod(L, "MoveEvent", "position", MoveEventFunctions::luaMoveEventPosition);
			registerMethod(L, "MoveEvent", "premium", MoveEventFunctions::luaMoveEventPremium);
			registerMethod(L, "MoveEvent", "vocation", MoveEventFunctions::luaMoveEventVocation);
			registerMethod(L, "MoveEvent", "onEquip", MoveEventFunctions::luaMoveEventOnCallback);
			registerMethod(L, "MoveEvent", "onDeEquip", MoveEventFunctions::luaMoveEventOnCallback);
			registerMethod(L, "MoveEvent", "onStepIn", MoveEventFunctions::luaMoveEventOnCallback);
			registerMethod(L, "MoveEvent", "onStepOut", MoveEventFunctions::luaMoveEventOnCallback);
			registerMethod(L, "MoveEvent", "onAddItem", MoveEventFunctions::luaMoveEventOnCallback);
			registerMethod(L, "MoveEvent", "onRemoveItem", MoveEventFunctions::luaMoveEventOnCallback);
		}

	private:
		static int luaCreateMoveEvent(lua_State* L);
		static int luaMoveEventType(lua_State* L);
		static int luaMoveEventRegister(lua_State* L);
		static int luaMoveEventOnCallback(lua_State* L);
		static int luaMoveEventLevel(lua_State* L);
		static int luaMoveEventSlot(lua_State* L);
		static int luaMoveEventMagLevel(lua_State* L);
		static int luaMoveEventPremium(lua_State* L);
		static int luaMoveEventVocation(lua_State* L);
		static int luaMoveEventItemId(lua_State* L);
		static int luaMoveEventActionId(lua_State* L);
		static int luaMoveEventUniqueId(lua_State* L);
		static int luaMoveEventPosition(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_EVENTS_MOVE_EVENT_FUNCTIONS_HPP_
