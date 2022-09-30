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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_COMBAT_SPELL_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_COMBAT_SPELL_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class SpellFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Spell", "", SpellFunctions::luaSpellCreate);
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
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_COMBAT_SPELL_FUNCTIONS_HPP_
