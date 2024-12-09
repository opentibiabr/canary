/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/creatures/combat/combat_functions.hpp"
#include "lua/functions/creatures/monster/monster_functions.hpp"
#include "lua/functions/creatures/npc/npc_functions.hpp"
#include "lua/functions/creatures/player/player_functions.hpp"
class CreatureFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreatureCreate(lua_State* L);

	static int luaCreatureGetEvents(lua_State* L);
	static int luaCreatureRegisterEvent(lua_State* L);
	static int luaCreatureUnregisterEvent(lua_State* L);

	static int luaCreatureIsRemoved(lua_State* L);
	static int luaCreatureIsCreature(lua_State* L);
	static int luaCreatureIsInGhostMode(lua_State* L);
	static int luaCreatureIsHealthHidden(lua_State* L);
	static int luaCreatureIsImmune(lua_State* L);

	static int luaCreatureCanSee(lua_State* L);
	static int luaCreatureCanSeeCreature(lua_State* L);

	static int luaCreatureGetParent(lua_State* L);

	static int luaCreatureGetId(lua_State* L);
	static int luaCreatureGetName(lua_State* L);
	static int luaCreatureGetTypeName(lua_State* L);

	static int luaCreatureGetTarget(lua_State* L);
	static int luaCreatureSetTarget(lua_State* L);

	static int luaCreatureGetFollowCreature(lua_State* L);
	static int luaCreatureSetFollowCreature(lua_State* L);

	static int luaCreatureReload(lua_State* L);

	static int luaCreatureGetMaster(lua_State* L);
	static int luaCreatureSetMaster(lua_State* L);

	static int luaCreatureGetLight(lua_State* L);
	static int luaCreatureSetLight(lua_State* L);

	static int luaCreatureGetSpeed(lua_State* L);
	static int luaCreatureSetSpeed(lua_State* L); // send speed
	static int luaCreatureGetBaseSpeed(lua_State* L);
	static int luaCreatureChangeSpeed(lua_State* L);

	static int luaCreatureSetDropLoot(lua_State* L);
	static int luaCreatureSetSkillLoss(lua_State* L);

	static int luaCreatureGetPosition(lua_State* L);
	static int luaCreatureGetTile(lua_State* L);
	static int luaCreatureGetDirection(lua_State* L);
	static int luaCreatureSetDirection(lua_State* L);

	static int luaCreatureGetHealth(lua_State* L);
	static int luaCreatureSetHealth(lua_State* L);
	static int luaCreatureAddHealth(lua_State* L);
	static int luaCreatureGetMaxHealth(lua_State* L);
	static int luaCreatureSetMaxHealth(lua_State* L);
	static int luaCreatureSetHiddenHealth(lua_State* L);

	static int luaCreatureIsMoveLocked(lua_State* L);
	static int luaCreatureSetMoveLocked(lua_State* L);

	static int luaCreatureIsDirectionLocked(lua_State* L);
	static int luaCreatureSetDirectionLocked(lua_State* L);

	static int luaCreatureGetSkull(lua_State* L);
	static int luaCreatureSetSkull(lua_State* L);

	static int luaCreatureGetOutfit(lua_State* L);
	static int luaCreatureSetOutfit(lua_State* L);

	static int luaCreatureGetCondition(lua_State* L);
	static int luaCreatureAddCondition(lua_State* L);
	static int luaCreatureHasCondition(lua_State* L);
	static int luaCreatureRemoveCondition(lua_State* L);

	static int luaCreatureRemove(lua_State* L);
	static int luaCreatureTeleportTo(lua_State* L);
	static int luaCreatureSay(lua_State* L);

	static int luaCreatureGetDamageMap(lua_State* L);

	static int luaCreatureGetSummons(lua_State* L);
	static int luaCreatureHasBeenSummoned(lua_State* L);

	static int luaCreatureGetDescription(lua_State* L);

	static int luaCreatureGetPathTo(lua_State* L);
	static int luaCreatureMove(lua_State* L);

	static int luaCreatureGetZoneType(lua_State* L);

	static int luaCreatureGetZones(lua_State* L);

	static int luaCreatureSetIcon(lua_State* L);
	static int luaCreatureGetIcons(lua_State* L);
	static int luaCreatureGetIcon(lua_State* L);
	static int luaCreatureRemoveIcon(lua_State* L);
	static int luaCreatureClearIcons(lua_State* L);
};
