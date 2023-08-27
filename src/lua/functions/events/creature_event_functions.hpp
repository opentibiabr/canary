/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class CreatureEventFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "CreatureEvent", "", CreatureEventFunctions::luaCreateCreatureEvent);
		registerMethod(L, "CreatureEvent", "type", CreatureEventFunctions::luaCreatureEventType);
		registerMethod(L, "CreatureEvent", "register", CreatureEventFunctions::luaCreatureEventRegister);
		registerMethod(L, "CreatureEvent", "onLogin", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onLogout", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onThink", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onPrepareDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onDeath", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onKill", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onAdvance", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onModalWindow", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onTextEdit", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onHealthChange", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onManaChange", CreatureEventFunctions::luaCreatureEventOnCallback);
		registerMethod(L, "CreatureEvent", "onExtendedOpcode", CreatureEventFunctions::luaCreatureEventOnCallback);
	}

private:
	static int luaCreateCreatureEvent(lua_State* L);
	static int luaCreatureEventType(lua_State* L);
	static int luaCreatureEventRegister(lua_State* L);
	static int luaCreatureEventOnCallback(lua_State* L);
};
