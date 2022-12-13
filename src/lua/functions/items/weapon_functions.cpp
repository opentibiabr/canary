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

#include "game/game.h"
#include "items/item.h"
#include "items/weapons/weapons.h"
#include "lua/functions/items/weapon_functions.hpp"
#include "lua/scripts/scripts.h"
#include "utils/tools.h"

int WeaponFunctions::luaCreateWeapon(lua_State* L) {
	// Weapon(type)
	if (getScriptEnv()->getScriptInterface() != &g_scripts().getScriptInterface()) {
		reportErrorFunc("Weapons can only be registered in the Scripts interface.");
		lua_pushnil(L);
		return 1;
	}

	WeaponType_t type = getNumber<WeaponType_t>(L, 2);
	switch (type) {
		case WEAPON_SWORD:
		case WEAPON_AXE:
		case WEAPON_CLUB: {
			WeaponMelee* weapon = new WeaponMelee(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponMelee>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		case WEAPON_DISTANCE:
		case WEAPON_AMMO: {
			WeaponDistance* weapon = new WeaponDistance(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponDistance>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		case WEAPON_WAND: {
			WeaponWand* weapon = new WeaponWand(getScriptEnv()->getScriptInterface());
			if (weapon) {
				pushUserdata<WeaponWand>(L, weapon);
				setMetatable(L, -1, "Weapon");
				weapon->weaponType = type;
				weapon->fromLua = true;
			} else {
				lua_pushnil(L);
			}
			break;
		}
		default: {
			lua_pushnil(L);
			break;
		}
	}
	return 1;
}

int WeaponFunctions::luaWeaponAction(lua_State* L) {
	// weapon:action(callback)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		std::string typeName = getString(L, 2);
		std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "removecount") {
			weapon->action = WEAPONACTION_REMOVECOUNT;
		} else if (tmpStr == "removecharge") {
			weapon->action = WEAPONACTION_REMOVECHARGE;
		} else if (tmpStr == "move") {
			weapon->action = WEAPONACTION_MOVE;
		} else {
			SPDLOG_ERROR("[WeaponFunctions::luaWeaponAction] - "
                         "No valid action {}", typeName);
			pushBoolean(L, false);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponRegister(lua_State* L) {
	// weapon:register()
	Weapon** weaponPtr = getRawUserdata<Weapon>(L, 1);
	if (weaponPtr && *weaponPtr) {
		Weapon* weapon = *weaponPtr;
		if (weapon->weaponType == WEAPON_DISTANCE || weapon->weaponType == WEAPON_AMMO) {
			weapon = getUserdata<WeaponDistance>(L, 1);
		} else if (weapon->weaponType == WEAPON_WAND) {
			weapon = getUserdata<WeaponWand>(L, 1);
		} else {
			weapon = getUserdata<WeaponMelee>(L, 1);
		}

		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.weaponType = weapon->weaponType;

		if (weapon->getWieldInfo() != 0) {
			it.wieldInfo = weapon->getWieldInfo();
			it.vocationString = weapon->getVocationString();
			it.minReqLevel = weapon->getReqLevel();
			it.minReqMagicLevel = weapon->getReqMagLv();
		}

		weapon->configureWeapon(it);
		pushBoolean(L, g_weapons().registerLuaEvent(weapon));
		weapon = nullptr; // Releases weapon, removing the luascript reference
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponOnUseWeapon(lua_State* L) {
	// weapon:onUseWeapon(callback)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		if (!weapon->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponUnproperly(lua_State* L) {
	// weapon:wieldedUnproperly(bool)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setWieldUnproperly(getBoolean(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponLevel(lua_State* L) {
	// weapon:level(lvl)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredLevel(getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_LEVEL);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMagicLevel(lua_State* L) {
	// weapon:magicLevel(lvl)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredMagLevel(getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_MAGLV);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMana(lua_State* L) {
	// weapon:mana(mana)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setMana(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponManaPercent(lua_State* L) {
	// weapon:manaPercent(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setManaPercent(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHealth(lua_State* L) {
	// weapon:health(health)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealth(getNumber<int64_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHealthPercent(lua_State* L) {
	// weapon:healthPercent(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealthPercent(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponSoul(lua_State* L) {
	// weapon:soul(soul)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setSoul(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponBreakChance(lua_State* L) {
	// weapon:breakChance(percent)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setBreakChance(getNumber<uint32_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponWandDamage(lua_State* L) {
	// weapon:damage(damage[min, max]) only use this if the weapon is a wand!
	WeaponWand* weapon = getUserdata<WeaponWand>(L, 1);
	if (weapon) {
		weapon->setMinChange(getNumber<uint32_t>(L, 2));
		if (lua_gettop(L) > 2) {
			weapon->setMaxChange(getNumber<uint32_t>(L, 3));
		} else {
			weapon->setMaxChange(getNumber<uint32_t>(L, 2));
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponElement(lua_State* L) {
	// weapon:element(combatType)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		if (!getNumber<CombatType_t>(L, 2)) {
			std::string element = getString(L, 2);
			std::string tmpStrValue = asLowerCaseString(element);
			if (tmpStrValue == "earth") {
				weapon->params.combatType = COMBAT_EARTHDAMAGE;
			} else if (tmpStrValue == "ice") {
				weapon->params.combatType = COMBAT_ICEDAMAGE;
			} else if (tmpStrValue == "energy") {
				weapon->params.combatType = COMBAT_ENERGYDAMAGE;
			} else if (tmpStrValue == "fire") {
				weapon->params.combatType = COMBAT_FIREDAMAGE;
			} else if (tmpStrValue == "death") {
				weapon->params.combatType = COMBAT_DEATHDAMAGE;
			} else if (tmpStrValue == "holy") {
				weapon->params.combatType = COMBAT_HOLYDAMAGE;
			} else {
				SPDLOG_WARN("[WeaponFunctions:luaWeaponElement] - "
							"Type {} does not exist", element);
			}
		} else {
			weapon->params.combatType = getNumber<CombatType_t>(L, 2);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponPremium(lua_State* L) {
	// weapon:premium(bool)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setNeedPremium(getBoolean(L, 2));
		weapon->setWieldInfo(WIELDINFO_PREMIUM);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponVocation(lua_State* L) {
	// weapon:vocation(vocName[, showInDescription = false, lastVoc = false])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->addVocWeaponMap(getString(L, 2));
		weapon->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = false;
		bool lastVoc = false;
		if (getBoolean(L, 3)) {
			showInDescription = getBoolean(L, 3);
		}
		if (getBoolean(L, 4)) {
			lastVoc = getBoolean(L, 4);
		}
		if (showInDescription) {
			if (weapon->getVocationString().empty()) {
				tmp = asLowerCaseString(getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			} else {
				tmp = weapon->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			}
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponId(lua_State* L) {
	// weapon:id(id)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		weapon->setID(getNumber<uint16_t>(L, 2));
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponAttack(lua_State* L) {
	// weapon:attack(atk)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.attack = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDefense(lua_State* L) {
	// weapon:defense(defense[, extraDefense])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.defense = getNumber<int32_t>(L, 2);
		if (lua_gettop(L) > 2) {
			it.extraDefense = getNumber<int32_t>(L, 3);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponRange(lua_State* L) {
	// weapon:range(range)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.shootRange = getNumber<uint8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponCharges(lua_State* L) {
	// weapon:charges(charges[, showCharges = true])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		bool showCharges = true;
		if (lua_gettop(L) > 2) {
			showCharges = getBoolean(L, 3);
		}
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.charges = getNumber<uint8_t>(L, 2);
		it.showCharges = showCharges;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDuration(lua_State* L) {
	// weapon:duration(duration[, showDuration = true])
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		bool showDuration = true;
		if (lua_gettop(L) > 2) {
			showDuration = getBoolean(L, 3);
		}
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.decayTime = getNumber<uint8_t>(L, 2);
		it.showDuration = showDuration;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDecayTo(lua_State* L) {
	// weapon:decayTo([itemid = 0]
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t itemid = 0;
		if (lua_gettop(L) > 1) {
			itemid = getNumber<uint16_t>(L, 2);
		}
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.decayTo = itemid;
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponTransformEquipTo(lua_State* L) {
	// weapon:transformEquipTo(itemid)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.transformEquipTo = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponTransformDeEquipTo(lua_State* L) {
	// weapon:transformDeEquipTo(itemid)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.transformDeEquipTo = getNumber<uint16_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponShootType(lua_State* L) {
	// weapon:shootType(type)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.shootType = getNumber<ShootType_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponSlotType(lua_State* L) {
	// weapon:slotType(slot)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		std::string slot = getString(L, 2);

		if (slot == "two-handed") {
			it.slotPosition = SLOTP_TWO_HAND;
		} else {
			it.slotPosition = SLOTP_HAND;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponAmmoType(lua_State* L) {
	// weapon:ammoType(type)
	WeaponDistance* weapon = getUserdata<WeaponDistance>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		std::string type = getString(L, 2);

		if (type == "arrow") {
			it.ammoType = AMMO_ARROW;
		} else if (type == "bolt"){
			it.ammoType = AMMO_BOLT;
		} else {
			SPDLOG_WARN("[WeaponFunctions:luaWeaponAmmoType] - "
						"Type {} does not exist", type);
			lua_pushnil(L);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHitChance(lua_State* L) {
	// weapon:hitChance(chance)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.hitChance = getNumber<int8_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMaxHitChance(lua_State* L) {
	// weapon:maxHitChance(max)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.maxHitChance = getNumber<int32_t>(L, 2);
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponExtraElement(lua_State* L) {
	// weapon:extraElement(atk, combatType)
	Weapon* weapon = getUserdata<Weapon>(L, 1);
	if (weapon) {
		uint16_t id = weapon->getID();
		ItemType& it = Item::items.getItemType(id);
		it.abilities.get()->elementDamage = getNumber<uint16_t>(L, 2);

		if (!getNumber<CombatType_t>(L, 3)) {
			std::string element = getString(L, 3);
			std::string tmpStrValue = asLowerCaseString(element);
			if (tmpStrValue == "earth") {
				it.abilities.get()->elementType = COMBAT_EARTHDAMAGE;
			} else if (tmpStrValue == "ice") {
				it.abilities.get()->elementType = COMBAT_ICEDAMAGE;
			} else if (tmpStrValue == "energy") {
				it.abilities.get()->elementType = COMBAT_ENERGYDAMAGE;
			} else if (tmpStrValue == "fire") {
				it.abilities.get()->elementType = COMBAT_FIREDAMAGE;
			} else if (tmpStrValue == "death") {
				it.abilities.get()->elementType = COMBAT_DEATHDAMAGE;
			} else if (tmpStrValue == "holy") {
				it.abilities.get()->elementType = COMBAT_HOLYDAMAGE;
			} else {
				SPDLOG_WARN("[WeaponFunctions:luaWeaponExtraElement] - "
							"Type {} does not exist", element);
			}
		} else {
			it.abilities.get()->elementType = getNumber<CombatType_t>(L, 3);
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
