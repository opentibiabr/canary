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
#include "lua/scripts/luascript.hpp"

class CreatureFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Creature", "", CreatureFunctions::luaCreatureCreate);
		registerMetaMethod(L, "Creature", "__eq", CreatureFunctions::luaUserdataCompare);
		registerMethod(L, "Creature", "getEvents", CreatureFunctions::luaCreatureGetEvents);
		registerMethod(L, "Creature", "registerEvent", CreatureFunctions::luaCreatureRegisterEvent);
		registerMethod(L, "Creature", "unregisterEvent", CreatureFunctions::luaCreatureUnregisterEvent);
		registerMethod(L, "Creature", "isRemoved", CreatureFunctions::luaCreatureIsRemoved);
		registerMethod(L, "Creature", "isCreature", CreatureFunctions::luaCreatureIsCreature);
		registerMethod(L, "Creature", "isInGhostMode", CreatureFunctions::luaCreatureIsInGhostMode);
		registerMethod(L, "Creature", "isHealthHidden", CreatureFunctions::luaCreatureIsHealthHidden);
		registerMethod(L, "Creature", "isImmune", CreatureFunctions::luaCreatureIsImmune);
		registerMethod(L, "Creature", "canSee", CreatureFunctions::luaCreatureCanSee);
		registerMethod(L, "Creature", "canSeeCreature", CreatureFunctions::luaCreatureCanSeeCreature);
		registerMethod(L, "Creature", "getParent", CreatureFunctions::luaCreatureGetParent);
		registerMethod(L, "Creature", "getId", CreatureFunctions::luaCreatureGetId);
		registerMethod(L, "Creature", "getName", CreatureFunctions::luaCreatureGetName);
		registerMethod(L, "Creature", "getTypeName", CreatureFunctions::luaCreatureGetTypeName);
		registerMethod(L, "Creature", "getTarget", CreatureFunctions::luaCreatureGetTarget);
		registerMethod(L, "Creature", "setTarget", CreatureFunctions::luaCreatureSetTarget);
		registerMethod(L, "Creature", "getFollowCreature", CreatureFunctions::luaCreatureGetFollowCreature);
		registerMethod(L, "Creature", "setFollowCreature", CreatureFunctions::luaCreatureSetFollowCreature);
		registerMethod(L, "Creature", "reload", CreatureFunctions::luaCreatureReload);
		registerMethod(L, "Creature", "getMaster", CreatureFunctions::luaCreatureGetMaster);
		registerMethod(L, "Creature", "setMaster", CreatureFunctions::luaCreatureSetMaster);
		registerMethod(L, "Creature", "getLight", CreatureFunctions::luaCreatureGetLight);
		registerMethod(L, "Creature", "setLight", CreatureFunctions::luaCreatureSetLight);
		registerMethod(L, "Creature", "getSpeed", CreatureFunctions::luaCreatureGetSpeed);
		registerMethod(L, "Creature", "setSpeed", CreatureFunctions::luaCreatureSetSpeed);
		registerMethod(L, "Creature", "getBaseSpeed", CreatureFunctions::luaCreatureGetBaseSpeed);
		registerMethod(L, "Creature", "changeSpeed", CreatureFunctions::luaCreatureChangeSpeed);
		registerMethod(L, "Creature", "setDropLoot", CreatureFunctions::luaCreatureSetDropLoot);
		registerMethod(L, "Creature", "setSkillLoss", CreatureFunctions::luaCreatureSetSkillLoss);
		registerMethod(L, "Creature", "getPosition", CreatureFunctions::luaCreatureGetPosition);
		registerMethod(L, "Creature", "getTile", CreatureFunctions::luaCreatureGetTile);
		registerMethod(L, "Creature", "getDirection", CreatureFunctions::luaCreatureGetDirection);
		registerMethod(L, "Creature", "setDirection", CreatureFunctions::luaCreatureSetDirection);
		registerMethod(L, "Creature", "getHealth", CreatureFunctions::luaCreatureGetHealth);
		registerMethod(L, "Creature", "setHealth", CreatureFunctions::luaCreatureSetHealth);
		registerMethod(L, "Creature", "addHealth", CreatureFunctions::luaCreatureAddHealth);
		registerMethod(L, "Creature", "getMaxHealth", CreatureFunctions::luaCreatureGetMaxHealth);
		registerMethod(L, "Creature", "setMaxHealth", CreatureFunctions::luaCreatureSetMaxHealth);
		registerMethod(L, "Creature", "setHiddenHealth", CreatureFunctions::luaCreatureSetHiddenHealth);
		registerMethod(L, "Creature", "isMoveLocked", CreatureFunctions::luaCreatureIsMoveLocked);
		registerMethod(L, "Creature", "isDirectionLocked", CreatureFunctions::luaCreatureIsDirectionLocked);
		registerMethod(L, "Creature", "setMoveLocked", CreatureFunctions::luaCreatureSetMoveLocked);
		registerMethod(L, "Creature", "setDirectionLocked", CreatureFunctions::luaCreatureSetDirectionLocked);
		registerMethod(L, "Creature", "getSkull", CreatureFunctions::luaCreatureGetSkull);
		registerMethod(L, "Creature", "setSkull", CreatureFunctions::luaCreatureSetSkull);
		registerMethod(L, "Creature", "getOutfit", CreatureFunctions::luaCreatureGetOutfit);
		registerMethod(L, "Creature", "setOutfit", CreatureFunctions::luaCreatureSetOutfit);
		registerMethod(L, "Creature", "getCondition", CreatureFunctions::luaCreatureGetCondition);
		registerMethod(L, "Creature", "addCondition", CreatureFunctions::luaCreatureAddCondition);
		registerMethod(L, "Creature", "removeCondition", CreatureFunctions::luaCreatureRemoveCondition);
		registerMethod(L, "Creature", "hasCondition", CreatureFunctions::luaCreatureHasCondition);
		registerMethod(L, "Creature", "remove", CreatureFunctions::luaCreatureRemove);
		registerMethod(L, "Creature", "teleportTo", CreatureFunctions::luaCreatureTeleportTo);
		registerMethod(L, "Creature", "say", CreatureFunctions::luaCreatureSay);
		registerMethod(L, "Creature", "getDamageMap", CreatureFunctions::luaCreatureGetDamageMap);
		registerMethod(L, "Creature", "getSummons", CreatureFunctions::luaCreatureGetSummons);
		registerMethod(L, "Creature", "hasBeenSummoned", CreatureFunctions::luaCreatureHasBeenSummoned);
		registerMethod(L, "Creature", "getDescription", CreatureFunctions::luaCreatureGetDescription);
		registerMethod(L, "Creature", "getPathTo", CreatureFunctions::luaCreatureGetPathTo);
		registerMethod(L, "Creature", "move", CreatureFunctions::luaCreatureMove);
		registerMethod(L, "Creature", "getZoneType", CreatureFunctions::luaCreatureGetZoneType);
		registerMethod(L, "Creature", "getZones", CreatureFunctions::luaCreatureGetZones);
		registerMethod(L, "Creature", "setIcon", CreatureFunctions::luaCreatureSetIcon);
		registerMethod(L, "Creature", "getIcon", CreatureFunctions::luaCreatureGetIcon);
		registerMethod(L, "Creature", "getIcons", CreatureFunctions::luaCreatureGetIcons);
		registerMethod(L, "Creature", "removeIcon", CreatureFunctions::luaCreatureRemoveIcon);
		registerMethod(L, "Creature", "clearIcons", CreatureFunctions::luaCreatureClearIcons);

		CombatFunctions::init(L);
		MonsterFunctions::init(L);
		NpcFunctions::init(L);
		PlayerFunctions::init(L);
	}

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
