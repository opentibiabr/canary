/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "lua/creature/creatureevent.h"
#include "lua/functions/events/creature_event_functions.hpp"
#include "utils/tools.h"

int CreatureEventFunctions::luaCreateCreatureEvent(lua_State* L) {
	// CreatureEvent(eventName)
	CreatureEvent* creature = new CreatureEvent(getScriptEnv()->getScriptInterface());
	if (creature) {
		creature->setName(getString(L, 2));
		pushUserdata<CreatureEvent>(L, creature);
		setMetatable(L, -1, "CreatureEvent");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventType(lua_State* L) {
	// creatureevent:type(callback)
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "login") {
			creature->setEventType(CREATURE_EVENT_LOGIN);
		} else if (tmpStr == "logout") {
			creature->setEventType(CREATURE_EVENT_LOGOUT);
		} else if (tmpStr == "think") {
			creature->setEventType(CREATURE_EVENT_THINK);
		} else if (tmpStr == "preparedeath") {
			creature->setEventType(CREATURE_EVENT_PREPAREDEATH);
		} else if (tmpStr == "death") {
			creature->setEventType(CREATURE_EVENT_DEATH);
		} else if (tmpStr == "kill") {
			creature->setEventType(CREATURE_EVENT_KILL);
		} else if (tmpStr == "advance") {
			creature->setEventType(CREATURE_EVENT_ADVANCE);
		} else if (tmpStr == "modalwindow") {
			creature->setEventType(CREATURE_EVENT_MODALWINDOW);
		} else if (tmpStr == "textedit") {
			creature->setEventType(CREATURE_EVENT_TEXTEDIT);
		} else if (tmpStr == "healthchange") {
			creature->setEventType(CREATURE_EVENT_HEALTHCHANGE);
		} else if (tmpStr == "manachange") {
			creature->setEventType(CREATURE_EVENT_MANACHANGE);
		} else if (tmpStr == "extendedopcode") {
			creature->setEventType(CREATURE_EVENT_EXTENDED_OPCODE);
		} else {
			SPDLOG_ERROR("[CreatureEventFunctions::luaCreatureEventType] - "
                         "Invalid type for creature event: {}", typeName);
			pushBoolean(L, false);
		}
		creature->setLoaded(true);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventRegister(lua_State* L) {
	// creatureevent:register()
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		if (!creature->isLoadedCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_creatureEvents().registerLuaEvent(creature));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventOnCallback(lua_State* L) {
	// creatureevent:onLogin / logout / etc. (callback)
	CreatureEvent* creature = getUserdata<CreatureEvent>(L, 1);
	if (creature) {
		if (!creature->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
