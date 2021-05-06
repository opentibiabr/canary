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

#ifndef SRC_LUA_FUNCTIONS_CORE_GAME_GLOBAL_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_GAME_GLOBAL_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class GlobalFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			lua_register(L, "addEvent", GlobalFunctions::luaAddEvent);
			lua_register(L, "cleanMap", GlobalFunctions::luaCleanMap);
			lua_register(L, "createCombatArea", GlobalFunctions::luaCreateCombatArea);
			lua_register(L, "debugPrint", GlobalFunctions::luaDebugPrint);
			lua_register(L, "doAddContainerItem", GlobalFunctions::luaDoAddContainerItem);
			lua_register(L, "doAreaCombatCondition", GlobalFunctions::luaDoAreaCombatCondition);
			lua_register(L, "doAreaCombatDispel", GlobalFunctions::luaDoAreaCombatDispel);
			lua_register(L, "doAreaCombatHealth", GlobalFunctions::luaDoAreaCombatHealth);
			lua_register(L, "doAreaCombatMana", GlobalFunctions::luaDoAreaCombatMana);
			lua_register(L, "doChallengeCreature", GlobalFunctions::luaDoChallengeCreature);
			lua_register(L, "doPlayerAddItem", GlobalFunctions::luaDoPlayerAddItem);
			lua_register(L, "doSetCreatureLight", GlobalFunctions::luaDoSetCreatureLight);
			lua_register(L, "doTargetCombatCondition", GlobalFunctions::luaDoTargetCombatCondition);
			lua_register(L, "doTargetCombatDispel", GlobalFunctions::luaDoTargetCombatDispel);
			lua_register(L, "doTargetCombatHealth", GlobalFunctions::luaDoTargetCombatHealth);
			lua_register(L, "doTargetCombatMana", GlobalFunctions::luaDoTargetCombatMana);
			lua_register(L, "getDepotId", GlobalFunctions::luaGetDepotId);
			lua_register(L, "getWaypointPositionByName", GlobalFunctions::luaGetWaypointPositionByName);
			lua_register(L, "getWorldLight", GlobalFunctions::luaGetWorldLight);
			lua_register(L, "getWorldTime", GlobalFunctions::luaGetWorldTime);
			lua_register(L, "getWorldUpTime", GlobalFunctions::luaGetWorldUpTime);
			lua_register(L, "isDepot", GlobalFunctions::luaIsDepot);
			lua_register(L, "isInWar", GlobalFunctions::luaIsInWar);
			lua_register(L, "isMovable", GlobalFunctions::luaIsMoveable);
			lua_register(L, "isValidUID", GlobalFunctions::luaIsValidUID);
			lua_register(L, "saveServer", GlobalFunctions::luaSaveServer);
			lua_register(L, "sendChannelMessage", GlobalFunctions::luaSendChannelMessage);
			lua_register(L, "sendGuildChannelMessage", GlobalFunctions::luaSendGuildChannelMessage);
			lua_register(L, "stopEvent", GlobalFunctions::luaStopEvent);

			registerGlobalVariable(L, "INDEX_WHEREEVER", INDEX_WHEREEVER);
			registerGlobalBoolean(L, "VIRTUAL_PARENT", true);
			registerGlobalMethod(L, "isType", GlobalFunctions::luaIsType);
			registerGlobalMethod(L, "rawgetmetatable", GlobalFunctions::luaRawGetMetatable);
			registerGlobalMethod(L, "createTable", GlobalFunctions::luaCreateTable);
			registerGlobalMethod(L, "systemTime", GlobalFunctions::luaSystemTime);
		}

	private:
		static int luaAddEvent(lua_State* L);
		static int luaCleanMap(lua_State* L);
		static int luaCreateCombatArea(lua_State* L);
		static int luaDebugPrint(lua_State* L);
		static int luaDoAddContainerItem(lua_State* L);
		static int luaDoAreaCombatCondition(lua_State* L);
		static int luaDoAreaCombatDispel(lua_State* L);
		static int luaDoAreaCombatHealth(lua_State* L);
		static int luaDoAreaCombatMana(lua_State* L);
		static int luaDoChallengeCreature(lua_State* L);
		static int luaDoPlayerAddItem(lua_State* L);
		static int luaDoSetCreatureLight(lua_State* L);
		static int luaDoTargetCombatCondition(lua_State* L);
		static int luaDoTargetCombatDispel(lua_State* L);
		static int luaDoTargetCombatHealth(lua_State* L);
		static int luaDoTargetCombatMana(lua_State* L);
		static int luaGetDepotId(lua_State* L);
		static int luaGetWaypointPositionByName(lua_State* L);
		static int luaGetWorldLight(lua_State* L);
		static int luaGetWorldTime(lua_State* L);
		static int luaGetWorldUpTime(lua_State* L);
		static int luaIsDepot(lua_State* L);
		static int luaIsInWar(lua_State* L);
		static int luaIsMoveable(lua_State* L);
		static int luaIsValidUID(lua_State* L);
		static int luaSaveServer(lua_State* L);
		static int luaSendChannelMessage(lua_State* L);
		static int luaSendGuildChannelMessage(lua_State* L);
		static int luaStopEvent(lua_State* L);
		static int luaIsType(lua_State* L);
		static int luaRawGetMetatable(lua_State* L);
		static int luaCreateTable(lua_State* L);
		static int luaSystemTime(lua_State* L);

		static bool getArea(lua_State* L, std::list<uint32_t>& list, uint32_t& rows);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_GAME_GLOBAL_FUNCTIONS_HPP_
