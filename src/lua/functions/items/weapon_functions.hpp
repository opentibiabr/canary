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

class WeaponFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Weapon", "", WeaponFunctions::luaCreateWeapon);
		registerMethod(L, "Weapon", "action", WeaponFunctions::luaWeaponAction);
		registerMethod(L, "Weapon", "register", WeaponFunctions::luaWeaponRegister);
		registerMethod(L, "Weapon", "id", WeaponFunctions::luaWeaponId);
		registerMethod(L, "Weapon", "level", WeaponFunctions::luaWeaponLevel);
		registerMethod(L, "Weapon", "magicLevel", WeaponFunctions::luaWeaponMagicLevel);
		registerMethod(L, "Weapon", "mana", WeaponFunctions::luaWeaponMana);
		registerMethod(L, "Weapon", "manaPercent", WeaponFunctions::luaWeaponManaPercent);
		registerMethod(L, "Weapon", "health", WeaponFunctions::luaWeaponHealth);
		registerMethod(L, "Weapon", "healthPercent", WeaponFunctions::luaWeaponHealthPercent);
		registerMethod(L, "Weapon", "soul", WeaponFunctions::luaWeaponSoul);
		registerMethod(L, "Weapon", "breakChance", WeaponFunctions::luaWeaponBreakChance);
		registerMethod(L, "Weapon", "premium", WeaponFunctions::luaWeaponPremium);
		registerMethod(L, "Weapon", "wieldUnproperly", WeaponFunctions::luaWeaponUnproperly);
		registerMethod(L, "Weapon", "vocation", WeaponFunctions::luaWeaponVocation);
		registerMethod(L, "Weapon", "onUseWeapon", WeaponFunctions::luaWeaponOnUseWeapon);
		registerMethod(L, "Weapon", "element", WeaponFunctions::luaWeaponElement);
		registerMethod(L, "Weapon", "attack", WeaponFunctions::luaWeaponAttack);
		registerMethod(L, "Weapon", "defense", WeaponFunctions::luaWeaponDefense);
		registerMethod(L, "Weapon", "range", WeaponFunctions::luaWeaponRange);
		registerMethod(L, "Weapon", "charges", WeaponFunctions::luaWeaponCharges);
		registerMethod(L, "Weapon", "duration", WeaponFunctions::luaWeaponDuration);
		registerMethod(L, "Weapon", "decayTo", WeaponFunctions::luaWeaponDecayTo);
		registerMethod(L, "Weapon", "transformEquipTo", WeaponFunctions::luaWeaponTransformEquipTo);
		registerMethod(L, "Weapon", "transformDeEquipTo", WeaponFunctions::luaWeaponTransformDeEquipTo);
		registerMethod(L, "Weapon", "slotType", WeaponFunctions::luaWeaponSlotType);
		registerMethod(L, "Weapon", "hitChance", WeaponFunctions::luaWeaponHitChance);
		registerMethod(L, "Weapon", "extraElement", WeaponFunctions::luaWeaponExtraElement);

		// exclusively for distance weapons
		registerMethod(L, "Weapon", "ammoType", WeaponFunctions::luaWeaponAmmoType);
		registerMethod(L, "Weapon", "maxHitChance", WeaponFunctions::luaWeaponMaxHitChance);

		// exclusively for wands
		registerMethod(L, "Weapon", "damage", WeaponFunctions::luaWeaponWandDamage);

		// exclusively for wands & distance weapons
		registerMethod(L, "Weapon", "shootType", WeaponFunctions::luaWeaponShootType);
	}

private:
	static int luaCreateWeapon(lua_State* L);
	static int luaWeaponId(lua_State* L);
	static int luaWeaponLevel(lua_State* L);
	static int luaWeaponMagicLevel(lua_State* L);
	static int luaWeaponMana(lua_State* L);
	static int luaWeaponManaPercent(lua_State* L);
	static int luaWeaponHealth(lua_State* L);
	static int luaWeaponHealthPercent(lua_State* L);
	static int luaWeaponSoul(lua_State* L);
	static int luaWeaponPremium(lua_State* L);
	static int luaWeaponBreakChance(lua_State* L);
	static int luaWeaponAction(lua_State* L);
	static int luaWeaponUnproperly(lua_State* L);
	static int luaWeaponVocation(lua_State* L);
	static int luaWeaponOnUseWeapon(lua_State* L);
	static int luaWeaponRegister(lua_State* L);
	static int luaWeaponElement(lua_State* L);
	static int luaWeaponAttack(lua_State* L);
	static int luaWeaponDefense(lua_State* L);
	static int luaWeaponRange(lua_State* L);
	static int luaWeaponCharges(lua_State* L);
	static int luaWeaponDuration(lua_State* L);
	static int luaWeaponDecayTo(lua_State* L);
	static int luaWeaponTransformEquipTo(lua_State* L);
	static int luaWeaponTransformDeEquipTo(lua_State* L);
	static int luaWeaponSlotType(lua_State* L);
	static int luaWeaponHitChance(lua_State* L);
	static int luaWeaponExtraElement(lua_State* L);

	// exclusively for distance weapons
	static int luaWeaponMaxHitChance(lua_State* L);
	static int luaWeaponAmmoType(lua_State* L);

	// exclusively for wands
	static int luaWeaponWandDamage(lua_State* L);

	// exclusively for wands & distance weapons
	static int luaWeaponShootType(lua_State* L);
};
