/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/action_functions.hpp"

#include "lua/creature/actions.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ActionFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Action", "", ActionFunctions::luaCreateAction);
	Lua::registerMethod(L, "Action", "onUse", ActionFunctions::luaActionOnUse);
	Lua::registerMethod(L, "Action", "register", ActionFunctions::luaActionRegister);
	Lua::registerMethod(L, "Action", "id", ActionFunctions::luaActionItemId);
	Lua::registerMethod(L, "Action", "aid", ActionFunctions::luaActionActionId);
	Lua::registerMethod(L, "Action", "uid", ActionFunctions::luaActionUniqueId);
	Lua::registerMethod(L, "Action", "position", ActionFunctions::luaActionPosition);
	Lua::registerMethod(L, "Action", "allowFarUse", ActionFunctions::luaActionAllowFarUse);
	Lua::registerMethod(L, "Action", "blockWalls", ActionFunctions::luaActionBlockWalls);
	Lua::registerMethod(L, "Action", "checkFloor", ActionFunctions::luaActionCheckFloor);
	Lua::registerMethod(L, "Action", "position", ActionFunctions::luaActionPosition);
}

int ActionFunctions::luaCreateAction(lua_State* L) {
	// Action()
	const auto action = std::make_shared<Action>();
	Lua::pushUserdata<Action>(L, action);
	Lua::setMetatable(L, -1, "Action");
	return 1;
}

int ActionFunctions::luaActionOnUse(lua_State* L) {
	// action:onUse(callback)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		if (!action->loadScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionRegister(lua_State* L) {
	// action:register()
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		if (!action->isLoadedScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, g_actions().registerLuaEvent(action));
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionItemId(lua_State* L) {
	// action:id(ids)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->setItemIdsVector(Lua::getNumber<uint16_t>(L, 2 + i));
			}
		} else {
			action->setItemIdsVector(Lua::getNumber<uint16_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionActionId(lua_State* L) {
	// action:aid(aids)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->setActionIdsVector(Lua::getNumber<uint16_t>(L, 2 + i));
			}
		} else {
			action->setActionIdsVector(Lua::getNumber<uint16_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionUniqueId(lua_State* L) {
	// action:uid(uids)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		const int parameters = lua_gettop(L) - 1; // - 1 because self is a parameter aswell, which we want to skip ofc
		if (parameters > 1) {
			for (int i = 0; i < parameters; ++i) {
				action->setUniqueIdsVector(Lua::getNumber<uint16_t>(L, 2 + i));
			}
		} else {
			action->setUniqueIdsVector(Lua::getNumber<uint16_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionPosition(lua_State* L) {
	/** @brief Create action position
	 * @param positions = position or table of positions to set a action script
	 * @param itemId or @param itemName = if item id or string name is set, the item is created on position (if not exists), this variable is nil by default
	 * action:position(positions, itemId or name)
	 */
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (!action) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	const Position position = Lua::getPosition(L, 2);
	// The parameter "- 1" because self is a parameter aswell, which we want to skip L 1 (UserData)
	// Lua::isNumber(L, 2) is for skip the itemId
	if (const int parameters = lua_gettop(L) - 1;
	    parameters > 1 && Lua::isNumber(L, 2)) {
		for (int i = 0; i < parameters; ++i) {
			action->setPositionsVector(Lua::getPosition(L, 2 + i));
		}
	} else {
		action->setPositionsVector(position);
	}

	uint16_t itemId;
	bool createItem = false;
	if (Lua::isNumber(L, 3)) {
		itemId = Lua::getNumber<uint16_t>(L, 3);
		createItem = true;
	} else if (Lua::isString(L, 3)) {
		itemId = Item::items.getItemIdByName(Lua::getString(L, 3));
		if (itemId == 0) {
			Lua::reportErrorFunc("Not found item with name: " + Lua::getString(L, 3));
			Lua::pushBoolean(L, false);
			return 1;
		}

		createItem = true;
	}

	if (createItem) {
		if (!Item::items.hasItemType(itemId)) {
			Lua::reportErrorFunc("Not found item with id: " + itemId);
			Lua::pushBoolean(L, false);
			return 1;
		}

		// If it is an item that can be removed, then it will be set as non-movable.
		ItemType &itemType = Item::items.getItemType(itemId);
		if (itemType.movable == true) {
			itemType.movable = false;
		}

		g_game().setCreateLuaItems(position, itemId);
	}

	Lua::pushBoolean(L, true);
	return 1;
}

int ActionFunctions::luaActionAllowFarUse(lua_State* L) {
	// action:allowFarUse(bool)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		action->setAllowFarUse(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionBlockWalls(lua_State* L) {
	// action:blockWalls(bool)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		action->setCheckLineOfSight(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int ActionFunctions::luaActionCheckFloor(lua_State* L) {
	// action:checkFloor(bool)
	const auto &action = Lua::getUserdataShared<Action>(L, 1);
	if (action) {
		action->setCheckFloor(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
	}
	return 1;
}
