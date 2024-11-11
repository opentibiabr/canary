/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/monster/monster_spell_functions.hpp"

#include "creatures/monsters/monsters.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void MonsterSpellFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "MonsterSpell", "", MonsterSpellFunctions::luaCreateMonsterSpell);

	Lua::registerMethod(L, "MonsterSpell", "setType", MonsterSpellFunctions::luaMonsterSpellSetType);
	Lua::registerMethod(L, "MonsterSpell", "setScriptName", MonsterSpellFunctions::luaMonsterSpellSetScriptName);
	Lua::registerMethod(L, "MonsterSpell", "setChance", MonsterSpellFunctions::luaMonsterSpellSetChance);
	Lua::registerMethod(L, "MonsterSpell", "setInterval", MonsterSpellFunctions::luaMonsterSpellSetInterval);
	Lua::registerMethod(L, "MonsterSpell", "setRange", MonsterSpellFunctions::luaMonsterSpellSetRange);
	Lua::registerMethod(L, "MonsterSpell", "setCombatValue", MonsterSpellFunctions::luaMonsterSpellSetCombatValue);
	Lua::registerMethod(L, "MonsterSpell", "setCombatType", MonsterSpellFunctions::luaMonsterSpellSetCombatType);
	Lua::registerMethod(L, "MonsterSpell", "setAttackValue", MonsterSpellFunctions::luaMonsterSpellSetAttackValue);
	Lua::registerMethod(L, "MonsterSpell", "setNeedTarget", MonsterSpellFunctions::luaMonsterSpellSetNeedTarget);
	Lua::registerMethod(L, "MonsterSpell", "setCombatLength", MonsterSpellFunctions::luaMonsterSpellSetCombatLength);
	Lua::registerMethod(L, "MonsterSpell", "setCombatSpread", MonsterSpellFunctions::luaMonsterSpellSetCombatSpread);
	Lua::registerMethod(L, "MonsterSpell", "setCombatRadius", MonsterSpellFunctions::luaMonsterSpellSetCombatRadius);
	Lua::registerMethod(L, "MonsterSpell", "setConditionType", MonsterSpellFunctions::luaMonsterSpellSetConditionType);
	Lua::registerMethod(L, "MonsterSpell", "setConditionDamage", MonsterSpellFunctions::luaMonsterSpellSetConditionDamage);
	Lua::registerMethod(L, "MonsterSpell", "setConditionSpeedChange", MonsterSpellFunctions::luaMonsterSpellSetConditionSpeedChange);
	Lua::registerMethod(L, "MonsterSpell", "setConditionDuration", MonsterSpellFunctions::luaMonsterSpellSetConditionDuration);
	Lua::registerMethod(L, "MonsterSpell", "setConditionTickInterval", MonsterSpellFunctions::luaMonsterSpellSetConditionTickInterval);
	Lua::registerMethod(L, "MonsterSpell", "setCombatShootEffect", MonsterSpellFunctions::luaMonsterSpellSetCombatShootEffect);
	Lua::registerMethod(L, "MonsterSpell", "setCombatEffect", MonsterSpellFunctions::luaMonsterSpellSetCombatEffect);
	Lua::registerMethod(L, "MonsterSpell", "setOutfitMonster", MonsterSpellFunctions::luaMonsterSpellSetOutfitMonster);
	Lua::registerMethod(L, "MonsterSpell", "setOutfitItem", MonsterSpellFunctions::luaMonsterSpellSetOutfitItem);
	Lua::registerMethod(L, "MonsterSpell", "castSound", MonsterSpellFunctions::luaMonsterSpellCastSound);
	Lua::registerMethod(L, "MonsterSpell", "impactSound", MonsterSpellFunctions::luaMonsterSpellImpactSound);
}

int MonsterSpellFunctions::luaCreateMonsterSpell(lua_State* L) {
	const auto spell = std::make_shared<MonsterSpell>();
	Lua::pushUserdata<MonsterSpell>(L, spell);
	Lua::setMetatable(L, -1, "MonsterSpell");
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetType(lua_State* L) {
	// monsterSpell:setType(type)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->name = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetScriptName(lua_State* L) {
	// monsterSpell:setScriptName(name)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->scriptName = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetChance(lua_State* L) {
	// monsterSpell:setChance(chance)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->chance = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetInterval(lua_State* L) {
	// monsterSpell:setInterval(interval)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->interval = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetRange(lua_State* L) {
	// monsterSpell:setRange(range)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->range = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatValue(lua_State* L) {
	// monsterSpell:setCombatValue(min, max)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->minCombatValue = Lua::getNumber<int32_t>(L, 2);
		spell->maxCombatValue = Lua::getNumber<int32_t>(L, 3);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatType(lua_State* L) {
	// monsterSpell:setCombatType(combatType_t)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->combatType = Lua::getNumber<CombatType_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetAttackValue(lua_State* L) {
	// monsterSpell:setAttackValue(attack, skill)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->attack = Lua::getNumber<int32_t>(L, 2);
		spell->skill = Lua::getNumber<int32_t>(L, 3);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetNeedTarget(lua_State* L) {
	// monsterSpell:setNeedTarget(bool)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->needTarget = Lua::getBoolean(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatLength(lua_State* L) {
	// monsterSpell:setCombatLength(length)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->length = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatSpread(lua_State* L) {
	// monsterSpell:setCombatSpread(spread)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->spread = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatRadius(lua_State* L) {
	// monsterSpell:setCombatRadius(radius)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->radius = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionType(lua_State* L) {
	// monsterSpell:setConditionType(type)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		auto conditionType = Lua::getNumber<uint8_t>(L, 2);
		if (conditionType == 254) {
			g_logger().error("[{}] trying to register condition type none for monster: {}", __FUNCTION__, spell->name);
			Lua::reportErrorFunc(fmt::format("trying to register condition type none for monster: {}", spell->name));
			Lua::pushBoolean(L, false);
			return 1;
		}

		spell->conditionType = static_cast<ConditionType_t>(conditionType);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionDamage(lua_State* L) {
	// monsterSpell:setConditionDamage(min, max, start)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->conditionMinDamage = Lua::getNumber<int32_t>(L, 2);
		spell->conditionMaxDamage = Lua::getNumber<int32_t>(L, 3);
		spell->conditionStartDamage = Lua::getNumber<int32_t>(L, 4);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionSpeedChange(lua_State* L) {
	// monsterSpell:setConditionSpeedChange(speed)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->speedChange = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionDuration(lua_State* L) {
	// monsterSpell:setConditionDuration(duration)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->duration = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetConditionTickInterval(lua_State* L) {
	// monsterSpell:setConditionTickInterval(interval)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->tickInterval = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatShootEffect(lua_State* L) {
	// monsterSpell:setCombatShootEffect(effect)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->shoot = Lua::getNumber<ShootType_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetCombatEffect(lua_State* L) {
	// monsterSpell:setCombatEffect(effect)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->effect = Lua::getNumber<MagicEffectClasses>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetOutfitMonster(lua_State* L) {
	// monsterSpell:setOutfitMonster(effect)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->outfitMonster = Lua::getString(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellSetOutfitItem(lua_State* L) {
	// monsterSpell:setOutfitItem(effect)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (spell) {
		spell->outfitItem = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellCastSound(lua_State* L) {
	// get: monsterSpell:castSound() set: monsterSpell:castSound(sound)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(spell->soundCastEffect));
	} else {
		spell->soundCastEffect = Lua::getNumber<SoundEffect_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}

int MonsterSpellFunctions::luaMonsterSpellImpactSound(lua_State* L) {
	// get: monsterSpell:impactSound() set: monsterSpell:impactSound(sound)
	const auto &spell = Lua::getUserdataShared<MonsterSpell>(L, 1);
	if (lua_gettop(L) == 1) {
		lua_pushnumber(L, static_cast<lua_Number>(spell->soundImpactEffect));
	} else {
		spell->soundImpactEffect = Lua::getNumber<SoundEffect_t>(L, 2);
		Lua::pushBoolean(L, true);
	}
	return 1;
}
