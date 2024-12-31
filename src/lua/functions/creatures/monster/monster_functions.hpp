/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/creatures/monster/charm_functions.hpp"
#include "lua/functions/creatures/monster/loot_functions.hpp"
#include "lua/functions/creatures/monster/monster_spell_functions.hpp"
#include "lua/functions/creatures/monster/monster_type_functions.hpp"

class MonsterFunctions {
private:
	static void init(lua_State* L);

	static int luaMonsterCreate(lua_State* L);

	static int luaMonsterIsMonster(lua_State* L);

	static int luaMonsterGetType(lua_State* L);
	static int luaMonsterSetType(lua_State* L);

	static int luaMonsterGetSpawnPosition(lua_State* L);
	static int luaMonsterIsInSpawnRange(lua_State* L);

	static int luaMonsterIsIdle(lua_State* L);
	static int luaMonsterSetIdle(lua_State* L);

	static int luaMonsterIsTarget(lua_State* L);
	static int luaMonsterIsOpponent(lua_State* L);
	static int luaMonsterIsFriend(lua_State* L);

	static int luaMonsterAddFriend(lua_State* L);
	static int luaMonsterRemoveFriend(lua_State* L);
	static int luaMonsterGetFriendList(lua_State* L);
	static int luaMonsterGetFriendCount(lua_State* L);

	static int luaMonsterAddTarget(lua_State* L);
	static int luaMonsterRemoveTarget(lua_State* L);
	static int luaMonsterGetTargetList(lua_State* L);
	static int luaMonsterGetTargetCount(lua_State* L);

	static int luaMonsterChangeTargetDistance(lua_State* L);
	static int luaMonsterIsChallenged(lua_State* L);

	static int luaMonsterSelectTarget(lua_State* L);
	static int luaMonsterSearchTarget(lua_State* L);

	static int luaMonsterSetSpawnPosition(lua_State* L);
	static int luaMonsterGetRespawnType(lua_State* L);

	static int luaMonsterGetTimeToChangeFiendish(lua_State* L);
	static int luaMonsterSetTimeToChangeFiendish(lua_State* L);
	static int luaMonsterGetMonsterForgeClassification(lua_State* L);
	static int luaMonsterSetMonsterForgeClassification(lua_State* L);
	static int luaMonsterGetForgeStack(lua_State* L);
	static int luaMonsterSetForgeStack(lua_State* L);
	static int luaMonsterConfigureForgeSystem(lua_State* L);
	static int luaMonsterClearFiendishStatus(lua_State* L);
	static int luaMonsterIsForgeable(lua_State* L);

	static int luaMonsterGetName(lua_State* L);
	static int luaMonsterSetName(lua_State* L);

	static int luaMonsterHazard(lua_State* L);
	static int luaMonsterHazardCrit(lua_State* L);
	static int luaMonsterHazardDodge(lua_State* L);
	static int luaMonsterHazardDamageBoost(lua_State* L);
	static int luaMonsterHazardDefenseBoost(lua_State* L);
	static int luaMonsterAddReflectElement(lua_State* L);
	static int luaMonsterAddDefense(lua_State* L);
	static int luaMonsterGetDefense(lua_State* L);

	static int luaMonsterIsDead(lua_State* L);
	static int luaMonsterImmune(lua_State* L);

	friend class CreatureFunctions;
};
