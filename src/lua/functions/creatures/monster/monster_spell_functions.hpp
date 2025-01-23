/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class MonsterSpellFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateMonsterSpell(lua_State* L);
	static int luaMonsterSpellSetType(lua_State* L);
	static int luaMonsterSpellSetScriptName(lua_State* L);
	static int luaMonsterSpellSetChance(lua_State* L);
	static int luaMonsterSpellSetInterval(lua_State* L);
	static int luaMonsterSpellSetRange(lua_State* L);
	static int luaMonsterSpellSetCombatValue(lua_State* L);
	static int luaMonsterSpellSetCombatType(lua_State* L);
	static int luaMonsterSpellSetAttackValue(lua_State* L);
	static int luaMonsterSpellSetNeedTarget(lua_State* L);
	static int luaMonsterSpellSetCombatLength(lua_State* L);
	static int luaMonsterSpellSetCombatSpread(lua_State* L);
	static int luaMonsterSpellSetCombatRadius(lua_State* L);
	static int luaMonsterSpellSetConditionType(lua_State* L);
	static int luaMonsterSpellSetConditionDamage(lua_State* L);
	static int luaMonsterSpellSetConditionSpeedChange(lua_State* L);
	static int luaMonsterSpellSetConditionDuration(lua_State* L);
	static int luaMonsterSpellSetConditionTickInterval(lua_State* L);
	static int luaMonsterSpellSetCombatShootEffect(lua_State* L);
	static int luaMonsterSpellSetCombatEffect(lua_State* L);
	static int luaMonsterSpellSetOutfitMonster(lua_State* L);
	static int luaMonsterSpellSetOutfitItem(lua_State* L);
	static int luaMonsterSpellCastSound(lua_State* L);
	static int luaMonsterSpellImpactSound(lua_State* L);
};
