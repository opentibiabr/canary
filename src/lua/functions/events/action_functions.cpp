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

#include "otpch.h"

#include "lua/creature/actions.h"
#include "lua/functions/events/action_functions.hpp"

extern Actions* g_actions;

int ActionFunctions::luaCreateAction(lua_State* L) {
	// Action()
	Action* action = new Action(getScriptEnv()->getScriptInterface());
	if (action) {
		action->fromLua = true;
		pushUserdata<Action>(L, action);
		setMetatable(L, -1, "Action");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionOnUse(lua_State* L) {
	// action:onUse(callback)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		if (!action->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		action->scripted = true;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionRegister(lua_State* L) {
	// action:register()
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		if (!action->isScripted()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_actions->registerLuaEvent(action));
		action->getActionIdRange().clear();
		action->getItemIdRange().clear();
		action->getUniqueIdRange().clear();
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionItemId(lua_State* L) {
	// action:id(ids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->addItemId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			action->addItemId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionActionId(lua_State* L) {
	// action:aid(aids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->addActionId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			action->addActionId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionUniqueId(lua_State* L) {
	// action:uid(uids)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->addUniqueId(getNumber<uint32_t>(L, 2 + i));
			}
		} else {
			action->addUniqueId(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionAllowFarUse(lua_State* L) {
	// action:allowFarUse(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setAllowFarUse(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionBlockWalls(lua_State* L) {
	// action:blockWalls(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setCheckLineOfSight(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int ActionFunctions::luaActionCheckFloor(lua_State* L) {
	// action:checkFloor(bool)
	Action* action = getUserdata<Action>(L, 1);
	if (action) {
		action->setCheckFloor(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
