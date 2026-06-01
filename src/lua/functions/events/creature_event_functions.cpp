/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
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
	Lua::registerSharedClass<CreatureEvent>(L, "", CreatureEventFunctions::luaCreateCreatureEvent);
	Lua::registerMethod(L, "CreatureEvent", "type", CreatureEventFunctions::luaCreatureEventType);
	Lua::registerMethod(L, "CreatureEvent", "register", CreatureEventFunctions::luaCreatureEventRegister);
	/***
	 * @function CreatureEvent:onLogin
	 * @param callback fun(player: Player): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onLogin", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onLogout
	 * @param callback fun(player: Player): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onLogout", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onThink
	 * @param callback fun(creature: Creature, interval: integer): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onThink", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onPrepareDeath
	 * @param callback fun(creature: Creature, killer: Creature|nil, realDamage: integer): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onPrepareDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onDeath
	 * @param callback fun(creature: Creature, corpse: Item, lastHitKiller: Creature|nil, mostDamageKiller: Creature|nil, lastHitUnjustified: boolean, mostDamageUnjustified: boolean): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onKill
	 * @param callback fun(creature: Creature, target: Creature, lastHit: boolean)
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onKill", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onAdvance
	 * @param callback fun(player: Player, skill: integer, oldLevel: integer, newLevel: integer): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onAdvance", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onModalWindow
	 * @param callback fun(player: Player, modalWindowId: integer, buttonId: integer, choiceId: integer)
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onModalWindow", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onTextEdit
	 * @param callback fun(player: Player, item: Item, text: string): boolean
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onTextEdit", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onHealthChange
	 * @param callback fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onHealthChange", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onManaChange
	 * @param callback fun(creature: Creature, attacker: Creature|nil, primaryDamage: integer, primaryType: CombatType, secondaryDamage: integer, secondaryType: CombatType, origin: integer): integer, CombatType, integer, CombatType
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onManaChange", CreatureEventFunctions::luaCreatureEventOnCallback);
	/***
	 * @function CreatureEvent:onExtendedOpcode
	 * @param callback fun(player: Player, opcode: integer, buffer: string)
	 * @return boolean
	 */
	Lua::registerMethod(L, "CreatureEvent", "onExtendedOpcode", CreatureEventFunctions::luaCreatureEventOnCallback);
}

/***
 * @class CreatureEvent
 * @overload fun(eventName: string): CreatureEvent
 */
int CreatureEventFunctions::luaCreateCreatureEvent(lua_State* L) {
	// CreatureEvent(eventName)
	const auto creatureEvent = std::make_shared<CreatureEvent>();
	creatureEvent->setName(Lua::getString(L, 2));
	Lua::pushSharedUserdata<CreatureEvent>(L, creatureEvent);
	return 1;
}

int CreatureEventFunctions::luaCreatureEventType(lua_State* L) {
	// creatureevent:type(callback)
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1, "CreatureEvent");
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
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1, "CreatureEvent");
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
	const auto &creatureEvent = Lua::getUserdataShared<CreatureEvent>(L, 1, "CreatureEvent");
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
