/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class WeaponFunctions {
public:
	static void init(lua_State* L);

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
