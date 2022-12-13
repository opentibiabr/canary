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

#include "pch.hpp"

#include "lua/functions/creatures/monster/monster_spell_functions.hpp"
#include "creatures/monsters/monsters.h"

int MonsterSpellFunctions::luaCreateMonsterSpell(lua_State* L) {
	// MonsterSpell() will create a new Monster Spell
	MonsterSpell* spell = new MonsterSpell();
	if (spell) {
		pushUserdata<MonsterSpell>(L, spell);
		setMetatable(L, -1, "MonsterSpell");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaDeleteMonsterSpell(lua_State* L) {
	// monsterSpell:delete() monsterSpell:__gc()
	MonsterSpell** monsterSpellPtr = getRawUserdata<MonsterSpell>(L, 1);
	if (monsterSpellPtr && *monsterSpellPtr) {
		delete *monsterSpellPtr;
		*monsterSpellPtr = nullptr;
	}
	return 0;
}

int MonsterSpellFunctions::luaMonsterSpellSetType(lua_State* L) {
	// monsterSpell:setType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->name = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetScriptName(lua_State* L) {
	// monsterSpell:setScriptName(name)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->scriptName = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetChance(lua_State* L) {
	// monsterSpell:setChance(chance)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->chance = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetInterval(lua_State* L) {
	// monsterSpell:setInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->interval = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetRange(lua_State* L) {
	// monsterSpell:setRange(range)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->range = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatValue(lua_State* L) {
	// monsterSpell:setCombatValue(min, max)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->minCombatValue = getNumber<int32_t>(L, 2);
		spell->maxCombatValue = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatType(lua_State* L) {
	// monsterSpell:setCombatType(combatType_t)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->combatType = getNumber<CombatType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetAttackValue(lua_State* L) {
	// monsterSpell:setAttackValue(attack, skill)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->attack = getNumber<int32_t>(L, 2);
		spell->skill = getNumber<int32_t>(L, 3);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetNeedTarget(lua_State* L) {
	// monsterSpell:setNeedTarget(bool)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->needTarget = getBoolean(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatLength(lua_State* L) {
	// monsterSpell:setCombatLength(length)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->length = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatSpread(lua_State* L) {
	// monsterSpell:setCombatSpread(spread)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->spread = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatRadius(lua_State* L) {
	// monsterSpell:setCombatRadius(radius)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->radius = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionType(lua_State* L) {
	// monsterSpell:setConditionType(type)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionType = getNumber<ConditionType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionDamage(lua_State* L) {
	// monsterSpell:setConditionDamage(min, max, start)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionMinDamage = getNumber<int32_t>(L, 2);
		spell->conditionMaxDamage = getNumber<int32_t>(L, 3);
		spell->conditionStartDamage = getNumber<int32_t>(L, 4);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionSpeedChange(lua_State* L) {
	// monsterSpell:setConditionSpeedChange(speed)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->speedChange = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionDuration(lua_State* L) {
	// monsterSpell:setConditionDuration(duration)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->duration = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionTickInterval(lua_State* L) {
	// monsterSpell:setConditionTickInterval(interval)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->tickInterval = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatShootEffect(lua_State* L) {
	// monsterSpell:setCombatShootEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->shoot = getNumber<ShootType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatEffect(lua_State* L) {
	// monsterSpell:setCombatEffect(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->effect = getNumber<MagicEffectClasses>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetOutfitMonster(lua_State* L) {
	// monsterSpell:setOutfitMonster(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->outfitMonster = getString(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetOutfitItem(lua_State* L) {
	// monsterSpell:setOutfitItem(effect)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (spell) {
		spell->outfitItem = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellCastSound(lua_State* L) {
	// get: monsterSpell:castSound() set: monsterSpell:castSound(sound)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, spell->soundCastEffect);
	} else {
		spell->soundCastEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellImpactSound(lua_State* L) {
	// get: monsterSpell:impactSound() set: monsterSpell:impactSound(sound)
	MonsterSpell* spell = getUserdata<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, spell->soundImpactEffect);
	} else {
		spell->soundImpactEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}
