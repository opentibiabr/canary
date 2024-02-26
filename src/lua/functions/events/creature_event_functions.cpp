/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/creature/creatureevent.hpp"
#include "lua/functions/events/creature_event_functions.hpp"
#include "utils/tools.hpp"

int CreatureEventFunctions::luaCreateCreatureEvent(lua_State* L) {
	// CreatureEvent(eventName)
	auto creatureEvent = std::make_shared<CreatureEvent>(getScriptEnv()->getScriptInterface());
	creatureEvent->setName(getString(L, 2));
	pushUserdata<CreatureEvent>(L, creatureEvent);
	setMetatable(L, -1, "CreatureEvent");
	return 1;
}

int CreatureEventFunctions::luaCreatureEventType(lua_State* L) {
	// creatureevent:type(callback)
	const auto creatureEvent = getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "login") {
			creatureEvent->setEventType(CreatureEventType::Login);
		} else if (tmpStr == "logout") {
			creatureEvent->setEventType(CreatureEventType::Logout);
		} else if (tmpStr == "think") {
			creatureEvent->setEventType(CreatureEventType::Think);
		} else if (tmpStr == "preparedeath") {
			creatureEvent->setEventType(CreatureEventType::PrepareDeath);
		} else if (tmpStr == "death") {
			creatureEvent->setEventType(CreatureEventType::Death);
		} else if (tmpStr == "kill") {
			creatureEvent->setEventType(CreatureEventType::Kill);
		} else if (tmpStr == "advance") {
			creatureEvent->setEventType(CreatureEventType::Advance);
		} else if (tmpStr == "modalwindow") {
			creatureEvent->setEventType(CreatureEventType::ModalWindow);
		} else if (tmpStr == "textedit") {
			creatureEvent->setEventType(CreatureEventType::TextEdit);
		} else if (tmpStr == "healthchange") {
			creatureEvent->setEventType(CreatureEventType::HealthChange);
		} else if (tmpStr == "manachange") {
			creatureEvent->setEventType(CreatureEventType::ManaChange);
		} else if (tmpStr == "extendedopcode") {
			creatureEvent->setEventType(CreatureEventType::ExtendedOpcode);
		} else {
			g_logger().error("[CreatureEventFunctions::luaCreatureEventType] - "
							 "Invalid type for creature event: {}",
							 typeName);
			pushBoolean(L, false);
		}
		creatureEvent->setLoaded(true);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventRegister(lua_State* L) {
	// creatureevent:register()
	const auto creatureEvent = getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		if (!creatureEvent->isLoadedCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_creatureEvents().registerLuaEvent(creatureEvent));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int CreatureEventFunctions::luaCreatureEventOnCallback(lua_State* L) {
	// creatureevent:onLogin / logout / etc. (callback)
	const auto creatureEvent = getUserdataShared<CreatureEvent>(L, 1);
	if (creatureEvent) {
		if (!creatureEvent->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
