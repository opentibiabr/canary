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

class SpellFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Spell", "", SpellFunctions::luaSpellCreate);
		registerMetaMethod(L, "Spell", "__eq", SpellFunctions::luaUserdataCompare);

		registerMethod(L, "Spell", "onCastSpell", SpellFunctions::luaSpellOnCastSpell);
		registerMethod(L, "Spell", "register", SpellFunctions::luaSpellRegister);
		registerMethod(L, "Spell", "name", SpellFunctions::luaSpellName);
		registerMethod(L, "Spell", "id", SpellFunctions::luaSpellId);
		registerMethod(L, "Spell", "group", SpellFunctions::luaSpellGroup);
		registerMethod(L, "Spell", "cooldown", SpellFunctions::luaSpellCooldown);
		registerMethod(L, "Spell", "groupCooldown", SpellFunctions::luaSpellGroupCooldown);
		registerMethod(L, "Spell", "level", SpellFunctions::luaSpellLevel);
		registerMethod(L, "Spell", "magicLevel", SpellFunctions::luaSpellMagicLevel);
		registerMethod(L, "Spell", "mana", SpellFunctions::luaSpellMana);
		registerMethod(L, "Spell", "manaPercent", SpellFunctions::luaSpellManaPercent);
		registerMethod(L, "Spell", "soul", SpellFunctions::luaSpellSoul);
		registerMethod(L, "Spell", "range", SpellFunctions::luaSpellRange);
		registerMethod(L, "Spell", "isPremium", SpellFunctions::luaSpellPremium);
		registerMethod(L, "Spell", "isEnabled", SpellFunctions::luaSpellEnabled);
		registerMethod(L, "Spell", "needTarget", SpellFunctions::luaSpellNeedTarget);
		registerMethod(L, "Spell", "needWeapon", SpellFunctions::luaSpellNeedWeapon);
		registerMethod(L, "Spell", "needLearn", SpellFunctions::luaSpellNeedLearn);
		registerMethod(L, "Spell", "allowOnSelf", SpellFunctions::luaSpellAllowOnSelf);
		registerMethod(L, "Spell", "setPzLocked", SpellFunctions::luaSpellPzLocked);
		registerMethod(L, "Spell", "isSelfTarget", SpellFunctions::luaSpellSelfTarget);
		registerMethod(L, "Spell", "isBlocking", SpellFunctions::luaSpellBlocking);
		registerMethod(L, "Spell", "isAggressive", SpellFunctions::luaSpellAggressive);
		registerMethod(L, "Spell", "vocation", SpellFunctions::luaSpellVocation);

		registerMethod(L, "Spell", "castSound", SpellFunctions::luaSpellCastSound);
		registerMethod(L, "Spell", "impactSound", SpellFunctions::luaSpellImpactSound);

		// Only for InstantSpell.
		registerMethod(L, "Spell", "words", SpellFunctions::luaSpellWords);
		registerMethod(L, "Spell", "needDirection", SpellFunctions::luaSpellNeedDirection);
		registerMethod(L, "Spell", "hasParams", SpellFunctions::luaSpellHasParams);
		registerMethod(L, "Spell", "hasPlayerNameParam", SpellFunctions::luaSpellHasPlayerNameParam);
		registerMethod(L, "Spell", "needCasterTargetOrDirection", SpellFunctions::luaSpellNeedCasterTargetOrDirection);
		registerMethod(L, "Spell", "isBlockingWalls", SpellFunctions::luaSpellIsBlockingWalls);

		// Only for RuneSpells.
		registerMethod(L, "Spell", "runeId", SpellFunctions::luaSpellRuneId);
		registerMethod(L, "Spell", "charges", SpellFunctions::luaSpellCharges);
		registerMethod(L, "Spell", "allowFarUse", SpellFunctions::luaSpellAllowFarUse);
		registerMethod(L, "Spell", "blockWalls", SpellFunctions::luaSpellBlockWalls);
		registerMethod(L, "Spell", "checkFloor", SpellFunctions::luaSpellCheckFloor);

		// Wheel of destiny
		registerMethod(L, "Spell", "manaWOD", SpellFunctions::luaSpellManaWOD);
		registerMethod(L, "Spell", "cooldownWOD", SpellFunctions::luaSpellCooldownWOD);
		registerMethod(L, "Spell", "groupCooldownWOD", SpellFunctions::luaSpellGroupCooldownWOD);
		registerMethod(L, "Spell", "secondaryGroupCooldownWOD", SpellFunctions::luaSpellSecondaryGroupCooldownWOD);
		registerMethod(L, "Spell", "increaseManaLeechWOD", SpellFunctions::luaSpellIncreaseManaLeechWOD);
		registerMethod(L, "Spell", "increaselifeLeechWOD", SpellFunctions::luaSpellIncreaselifeLeechWOD);
		registerMethod(L, "Spell", "increaseDamageWOD", SpellFunctions::luaSpellIncreaseDamageWOD);
		registerMethod(L, "Spell", "increaseDamageReductionWOD", SpellFunctions::luaSpellIncreaseDamageReductionWOD);
		registerMethod(L, "Spell", "increaseHealWOD", SpellFunctions::luaSpellIncreaseHealWOD);
		registerMethod(L, "Spell", "increaseCriticalDamageWOD", SpellFunctions::luaSpellIncreaseCriticalDamageWOD);
		registerMethod(L, "Spell", "increaseCriticalChanceWOD", SpellFunctions::luaSpellIncreaseCriticalChanceWOD);
	}

private:
	static int luaSpellCreate(lua_State* L);

	static int luaSpellOnCastSpell(lua_State* L);
	static int luaSpellRegister(lua_State* L);
	static int luaSpellName(lua_State* L);
	static int luaSpellId(lua_State* L);
	static int luaSpellGroup(lua_State* L);
	static int luaSpellCooldown(lua_State* L);
	static int luaSpellGroupCooldown(lua_State* L);
	static int luaSpellLevel(lua_State* L);
	static int luaSpellMagicLevel(lua_State* L);
	static int luaSpellMana(lua_State* L);
	static int luaSpellManaPercent(lua_State* L);
	static int luaSpellSoul(lua_State* L);
	static int luaSpellRange(lua_State* L);
	static int luaSpellPremium(lua_State* L);
	static int luaSpellEnabled(lua_State* L);
	static int luaSpellNeedTarget(lua_State* L);
	static int luaSpellAllowOnSelf(lua_State* L);
	static int luaSpellPzLocked(lua_State* L);
	static int luaSpellNeedWeapon(lua_State* L);
	static int luaSpellNeedLearn(lua_State* L);
	static int luaSpellSelfTarget(lua_State* L);
	static int luaSpellBlocking(lua_State* L);
	static int luaSpellAggressive(lua_State* L);
	static int luaSpellVocation(lua_State* L);

	static int luaSpellCastSound(lua_State* L);
	static int luaSpellImpactSound(lua_State* L);

	// Only for InstantSpells.
	static int luaSpellWords(lua_State* L);
	static int luaSpellNeedDirection(lua_State* L);
	static int luaSpellHasParams(lua_State* L);
	static int luaSpellHasPlayerNameParam(lua_State* L);
	static int luaSpellNeedCasterTargetOrDirection(lua_State* L);
	static int luaSpellIsBlockingWalls(lua_State* L);

	// Only for RuneSpells.
	static int luaSpellRuneId(lua_State* L);
	static int luaSpellCharges(lua_State* L);
	static int luaSpellAllowFarUse(lua_State* L);
	static int luaSpellBlockWalls(lua_State* L);
	static int luaSpellCheckFloor(lua_State* L);

	static int luaSpellManaWOD(lua_State* L);
	static int luaSpellCooldownWOD(lua_State* L);
	static int luaSpellGroupCooldownWOD(lua_State* L);
	static int luaSpellSecondaryGroupCooldownWOD(lua_State* L);
	static int luaSpellIncreaseManaLeechWOD(lua_State* L);
	static int luaSpellIncreaselifeLeechWOD(lua_State* L);
	static int luaSpellIncreaseDamageWOD(lua_State* L);
	static int luaSpellIncreaseDamageReductionWOD(lua_State* L);
	static int luaSpellIncreaseHealWOD(lua_State* L);
	static int luaSpellIncreaseCriticalDamageWOD(lua_State* L);
	static int luaSpellIncreaseCriticalChanceWOD(lua_State* L);
};
