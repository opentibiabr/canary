/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/creatures/monster/monster_spell_functions.hpp"
#include "creatures/monsters/monsters.hpp"

int MonsterSpellFunctions::luaCreateMonsterSpell(lua_State* L) {
	const auto spell = std::make_shared<MonsterSpell>();
	pushUserdata<MonsterSpell>(L, spell);
	setMetatable(L, -1, "MonsterSpell");
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetType(lua_State* L) {
	// monsterSpell:setType(type)
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		auto conditionType = getNumber<uint8_t>(L, 2);
		if (conditionType == 254) {
			g_logger().error("[{}] trying to register condition type none for monster: {}", __FUNCTION__, spell->name);
			reportErrorFunc(fmt::format("trying to register condition type none for monster: {}", spell->name));
			pushBoolean(L, false);
			return 1;
		}

		spell->conditionType = static_cast<ConditionType_t>(conditionType);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionDamage(lua_State* L) {
	// monsterSpell:setConditionDamage(min, max, start)
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
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
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(spell->soundCastEffect));
	} else {
		spell->soundCastEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellImpactSound(lua_State* L) {
	// get: monsterSpell:impactSound() set: monsterSpell:impactSound(sound)
	const auto spell = getUserdataShared<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(spell->soundImpactEffect));
	} else {
		spell->soundImpactEffect = getNumber<SoundEffect_t>(L, 2);
		pushBoolean(L, true);
	}
	return 1;
}
