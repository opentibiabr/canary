/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class MonsterSpellFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerClass(L, "MonsterSpell", "", MonsterSpellFunctions::luaCreateMonsterSpell);

		registerMethod(L, "MonsterSpell", "setType", MonsterSpellFunctions::luaMonsterSpellSetType);
		registerMethod(L, "MonsterSpell", "setScriptName", MonsterSpellFunctions::luaMonsterSpellSetScriptName);
		registerMethod(L, "MonsterSpell", "setChance", MonsterSpellFunctions::luaMonsterSpellSetChance);
		registerMethod(L, "MonsterSpell", "setInterval", MonsterSpellFunctions::luaMonsterSpellSetInterval);
		registerMethod(L, "MonsterSpell", "setRange", MonsterSpellFunctions::luaMonsterSpellSetRange);
		registerMethod(L, "MonsterSpell", "setCombatValue", MonsterSpellFunctions::luaMonsterSpellSetCombatValue);
		registerMethod(L, "MonsterSpell", "setCombatType", MonsterSpellFunctions::luaMonsterSpellSetCombatType);
		registerMethod(L, "MonsterSpell", "setAttackValue", MonsterSpellFunctions::luaMonsterSpellSetAttackValue);
		registerMethod(L, "MonsterSpell", "setNeedTarget", MonsterSpellFunctions::luaMonsterSpellSetNeedTarget);
		registerMethod(L, "MonsterSpell", "setCombatLength", MonsterSpellFunctions::luaMonsterSpellSetCombatLength);
		registerMethod(L, "MonsterSpell", "setCombatSpread", MonsterSpellFunctions::luaMonsterSpellSetCombatSpread);
		registerMethod(L, "MonsterSpell", "setCombatRadius", MonsterSpellFunctions::luaMonsterSpellSetCombatRadius);
		registerMethod(L, "MonsterSpell", "setConditionType", MonsterSpellFunctions::luaMonsterSpellSetConditionType);
		registerMethod(L, "MonsterSpell", "setConditionDamage", MonsterSpellFunctions::luaMonsterSpellSetConditionDamage);
		registerMethod(L, "MonsterSpell", "setConditionSpeedChange", MonsterSpellFunctions::luaMonsterSpellSetConditionSpeedChange);
		registerMethod(L, "MonsterSpell", "setConditionDuration", MonsterSpellFunctions::luaMonsterSpellSetConditionDuration);
		registerMethod(L, "MonsterSpell", "setConditionTickInterval", MonsterSpellFunctions::luaMonsterSpellSetConditionTickInterval);
		registerMethod(L, "MonsterSpell", "setCombatShootEffect", MonsterSpellFunctions::luaMonsterSpellSetCombatShootEffect);
		registerMethod(L, "MonsterSpell", "setCombatEffect", MonsterSpellFunctions::luaMonsterSpellSetCombatEffect);
		registerMethod(L, "MonsterSpell", "setOutfitMonster", MonsterSpellFunctions::luaMonsterSpellSetOutfitMonster);
		registerMethod(L, "MonsterSpell", "setOutfitItem", MonsterSpellFunctions::luaMonsterSpellSetOutfitItem);
		registerMethod(L, "MonsterSpell", "castSound", MonsterSpellFunctions::luaMonsterSpellCastSound);
		registerMethod(L, "MonsterSpell", "impactSound", MonsterSpellFunctions::luaMonsterSpellImpactSound);
	}

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
