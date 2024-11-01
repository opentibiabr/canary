/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/creature_event_functions.hpp"

#include "lua/creature/creatureevent.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void CreatureEventFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "CreatureEvent", "", CreatureEventFunctions::luaCreateCreatureEvent);
	Lua::registerMethod(L, "CreatureEvent", "type", CreatureEventFunctions::luaCreatureEventType);
	Lua::registerMethod(L, "CreatureEvent", "register", CreatureEventFunctions::luaCreatureEventRegister);
	Lua::registerMethod(L, "CreatureEvent", "onLogin", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onLogout", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onThink", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onPrepareDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onKill", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onAdvance", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onModalWindow", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onTextEdit", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onHealthChange", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onManaChange", CreatureEventFunctions::luaCreatureEventOnCallback);
	Lua::registerMethod(L, "CreatureEvent", "onExtendedOpcode", CreatureEventFunctions::luaCreatureEventOnCallback);
}

int CreatureEventFunctions::luaCreateCreatureEvent(lua_State* L) {
	// CreatureEvent(eventName)
	const auto creatureEvent = std::make_shared<CreatureEvent>();
	creatureEvent->setName(Lua::getString(L, 2));
	Lua::pushUserdata<CreatureEvent>(L, creatureEvent);
	Lua::setMetatable(L, -1, "CreatureEvent");
	return 1;
}

int CreatureEventFunctions::luaCreatureEventType(lua_State* L) {
	// creatureevent:type(callback)
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		std::string typeName = Lua::getString(L, 2);
		const std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "login") {
			creatureEvent->setEventType(CREATURE_EVENT_LOGIN);
		} else if (tmpStr == "logout") {
			creatureEvent->setEventType(CREATURE_EVENT_LOGOUT);
		} else if (tmpStr == "think") {
			creatureEvent->setEventType(CREATURE_EVENT_THINK);
		} else if (tmpStr == "preparedeath") {
			creatureEvent->setEventType(CREATURE_EVENT_PREPAREDEATH);
		} else if (tmpStr == "death") {
			creatureEvent->setEventType(CREATURE_EVENT_DEATH);
		} else if (tmpStr == "kill") {
			creatureEvent->setEventType(CREATURE_EVENT_KILL);
		} else if (tmpStr == "advance") {
			creatureEvent->setEventType(CREATURE_EVENT_ADVANCE);
		} else if (tmpStr == "modalwindow") {
			creatureEvent->setEventType(CREATURE_EVENT_MODALWINDOW);
		} else if (tmpStr == "textedit") {
			creatureEvent->setEventType(CREATURE_EVENT_TEXTEDIT);
		} else if (tmpStr == "healthchange") {
			creatureEvent->setEventType(CREATURE_EVENT_HEALTHCHANGE);
		} else if (tmpStr == "manachange") {
			creatureEvent->setEventType(CREATURE_EVENT_MANACHANGE);
		} else if (tmpStr == "extendedopcode") {
			creatureEvent->setEventType(CREATURE_EVENT_EXTENDED_OPCODE);
		} else {
			g_logger().error("[CreatureEventFunctions::luaCreatureEventType] - "
			                 "Invalid type for creature event: {}",
			                 typeName);
			Lua::pushBoolean(L, false);
		}
		creatureEvent->setLoaded(true);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventRegister(lua_State* L) {
	// creatureevent:register()
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		if (!creatureEvent->isLoadedScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, g_creatureEvents().registerLuaEvent(creatureEvent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventOnCallback(lua_State* L) {
	// creatureevent:onLogin / logout / etc. (callback)
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		if (!creatureEvent->loadScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
