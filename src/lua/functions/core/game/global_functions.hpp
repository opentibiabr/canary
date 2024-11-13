/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class GlobalFunctions {
public:
	static void init(lua_State* L);

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
	static int luaIsMovable(lua_State* L);
	static int luaIsValidUID(lua_State* L);
	static int luaSaveServer(lua_State* L);
	static int luaSendChannelMessage(lua_State* L);
	static int luaSendGuildChannelMessage(lua_State* L);
	static int luaStopEvent(lua_State* L);
	static int luaIsType(lua_State* L);
	static int luaRawGetMetatable(lua_State* L);
	static int luaCreateTable(lua_State* L);
	static int luaSystemTime(lua_State* L);
	static int luaGetFormattedTimeRemaining(lua_State* L);
	static int luaReportError(lua_State* L);

	static bool getArea(lua_State* L, std::list<uint32_t> &list, uint32_t &rows);
};
