/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/items/weapon_functions.hpp"

#include "game/game.hpp"
#include "items/item.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "utils/tools.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void WeaponFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Weapon", "", WeaponFunctions::luaCreateWeapon);
	Lua::registerMethod(L, "Weapon", "action", WeaponFunctions::luaWeaponAction);
	Lua::registerMethod(L, "Weapon", "register", WeaponFunctions::luaWeaponRegister);
	Lua::registerMethod(L, "Weapon", "id", WeaponFunctions::luaWeaponId);
	Lua::registerMethod(L, "Weapon", "level", WeaponFunctions::luaWeaponLevel);
	Lua::registerMethod(L, "Weapon", "magicLevel", WeaponFunctions::luaWeaponMagicLevel);
	Lua::registerMethod(L, "Weapon", "mana", WeaponFunctions::luaWeaponMana);
	Lua::registerMethod(L, "Weapon", "manaPercent", WeaponFunctions::luaWeaponManaPercent);
	Lua::registerMethod(L, "Weapon", "health", WeaponFunctions::luaWeaponHealth);
	Lua::registerMethod(L, "Weapon", "healthPercent", WeaponFunctions::luaWeaponHealthPercent);
	Lua::registerMethod(L, "Weapon", "soul", WeaponFunctions::luaWeaponSoul);
	Lua::registerMethod(L, "Weapon", "breakChance", WeaponFunctions::luaWeaponBreakChance);
	Lua::registerMethod(L, "Weapon", "premium", WeaponFunctions::luaWeaponPremium);
	Lua::registerMethod(L, "Weapon", "wieldUnproperly", WeaponFunctions::luaWeaponUnproperly);
	Lua::registerMethod(L, "Weapon", "vocation", WeaponFunctions::luaWeaponVocation);
	Lua::registerMethod(L, "Weapon", "onUseWeapon", WeaponFunctions::luaWeaponOnUseWeapon);
	Lua::registerMethod(L, "Weapon", "element", WeaponFunctions::luaWeaponElement);
	Lua::registerMethod(L, "Weapon", "attack", WeaponFunctions::luaWeaponAttack);
	Lua::registerMethod(L, "Weapon", "defense", WeaponFunctions::luaWeaponDefense);
	Lua::registerMethod(L, "Weapon", "range", WeaponFunctions::luaWeaponRange);
	Lua::registerMethod(L, "Weapon", "charges", WeaponFunctions::luaWeaponCharges);
	Lua::registerMethod(L, "Weapon", "duration", WeaponFunctions::luaWeaponDuration);
	Lua::registerMethod(L, "Weapon", "decayTo", WeaponFunctions::luaWeaponDecayTo);
	Lua::registerMethod(L, "Weapon", "transformEquipTo", WeaponFunctions::luaWeaponTransformEquipTo);
	Lua::registerMethod(L, "Weapon", "transformDeEquipTo", WeaponFunctions::luaWeaponTransformDeEquipTo);
	Lua::registerMethod(L, "Weapon", "slotType", WeaponFunctions::luaWeaponSlotType);
	Lua::registerMethod(L, "Weapon", "hitChance", WeaponFunctions::luaWeaponHitChance);
	Lua::registerMethod(L, "Weapon", "extraElement", WeaponFunctions::luaWeaponExtraElement);

	// exclusively for distance weapons
	Lua::registerMethod(L, "Weapon", "ammoType", WeaponFunctions::luaWeaponAmmoType);
	Lua::registerMethod(L, "Weapon", "maxHitChance", WeaponFunctions::luaWeaponMaxHitChance);

	// exclusively for wands
	Lua::registerMethod(L, "Weapon", "damage", WeaponFunctions::luaWeaponWandDamage);

	// exclusively for wands & distance weapons
	Lua::registerMethod(L, "Weapon", "shootType", WeaponFunctions::luaWeaponShootType);
}

int WeaponFunctions::luaCreateWeapon(lua_State* L) {
	// Weapon(type)
	const WeaponType_t type = Lua::getNumber<WeaponType_t>(L, 2);
	switch (type) {
		case WEAPON_SWORD:
		case WEAPON_AXE:
		case WEAPON_CLUB: {
			auto weaponPtr = std::make_shared<WeaponMelee>();
			Lua::pushUserdata<WeaponMelee>(L, weaponPtr);
			Lua::setMetatable(L, -1, "Weapon");
			weaponPtr->weaponType = type;
			break;
		}
		case WEAPON_MISSILE:
		case WEAPON_DISTANCE:
		case WEAPON_AMMO: {
			auto weaponPtr = std::make_shared<WeaponDistance>();
			Lua::pushUserdata<WeaponDistance>(L, weaponPtr);
			Lua::setMetatable(L, -1, "Weapon");
			weaponPtr->weaponType = type;
			break;
		}
		case WEAPON_WAND: {
			auto weaponPtr = std::make_shared<WeaponWand>();
			Lua::pushUserdata<WeaponWand>(L, weaponPtr);
			Lua::setMetatable(L, -1, "Weapon");
			weaponPtr->weaponType = type;
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
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		std::string typeName = Lua::getString(L, 2);
		const std::string tmpStr = asLowerCaseString(typeName);
		if (tmpStr == "removecount") {
			weapon->action = WEAPONACTION_REMOVECOUNT;
		} else if (tmpStr == "removecharge") {
			weapon->action = WEAPONACTION_REMOVECHARGE;
		} else if (tmpStr == "move") {
			weapon->action = WEAPONACTION_MOVE;
		} else {
			g_logger().error("[WeaponFunctions::luaWeaponAction] - "
			                 "No valid action {}",
			                 typeName);
			Lua::pushBoolean(L, false);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponRegister(lua_State* L) {
	// weapon:register()
	const WeaponShared_ptr* weaponPtr = Lua::getRawUserDataShared<Weapon>(L, 1);
	if (weaponPtr && *weaponPtr) {
		WeaponShared_ptr weapon = *weaponPtr;
		if (weapon->weaponType == WEAPON_DISTANCE || weapon->weaponType == WEAPON_AMMO || weapon->weaponType == WEAPON_MISSILE) {
			weapon = Lua::getUserdataShared<WeaponDistance>(L, 1);
		} else if (weapon->weaponType == WEAPON_WAND) {
			weapon = Lua::getUserdataShared<WeaponWand>(L, 1);
		} else {
			weapon = Lua::getUserdataShared<WeaponMelee>(L, 1);
		}

		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.weaponType = weapon->weaponType;

		if (weapon->getWieldInfo() != 0) {
			it.wieldInfo = weapon->getWieldInfo();
			it.vocationString = weapon->getVocationString();
			it.minReqLevel = weapon->getReqLevel();
			it.minReqMagicLevel = weapon->getReqMagLv();
		}

		weapon->configureWeapon(it);
		Lua::pushBoolean(L, g_weapons().registerLuaEvent(weapon));
		weapon = nullptr; // Releases weapon, removing the luascript reference
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponOnUseWeapon(lua_State* L) {
	// weapon:onUseWeapon(callback)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		if (!weapon->loadScriptId()) {
			Lua::pushBoolean(L, false);
			return 1;
		}

		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponUnproperly(lua_State* L) {
	// weapon:wieldedUnproperly(bool)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setWieldUnproperly(Lua::getBoolean(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponLevel(lua_State* L) {
	// weapon:level(lvl)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredLevel(Lua::getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_LEVEL);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMagicLevel(lua_State* L) {
	// weapon:magicLevel(lvl)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setRequiredMagLevel(Lua::getNumber<uint32_t>(L, 2));
		weapon->setWieldInfo(WIELDINFO_MAGLV);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMana(lua_State* L) {
	// weapon:mana(mana)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setMana(Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponManaPercent(lua_State* L) {
	// weapon:manaPercent(percent)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setManaPercent(Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHealth(lua_State* L) {
	// weapon:health(health)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealth(Lua::getNumber<int32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHealthPercent(lua_State* L) {
	// weapon:healthPercent(percent)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setHealthPercent(Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponSoul(lua_State* L) {
	// weapon:soul(soul)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setSoul(Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponBreakChance(lua_State* L) {
	// weapon:breakChance(percent)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setBreakChance(Lua::getNumber<uint32_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponWandDamage(lua_State* L) {
	// weapon:damage(damage[min, max]) only use this if the weapon is a wand!
	const auto &weapon = Lua::getUserdataShared<WeaponWand>(L, 1);
	if (weapon) {
		weapon->setMinChange(Lua::getNumber<uint32_t>(L, 2));
		if (lua_gettop(L) > 2) {
			weapon->setMaxChange(Lua::getNumber<uint32_t>(L, 3));
		} else {
			weapon->setMaxChange(Lua::getNumber<uint32_t>(L, 2));
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponElement(lua_State* L) {
	// weapon:element(combatType)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		if (!Lua::getNumber<CombatType_t>(L, 2)) {
			std::string element = Lua::getString(L, 2);
			const std::string tmpStrValue = asLowerCaseString(element);
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
				g_logger().warn("[WeaponFunctions:luaWeaponElement] - "
				                "Type {} does not exist",
				                element);
			}
		} else {
			weapon->params.combatType = Lua::getNumber<CombatType_t>(L, 2);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponPremium(lua_State* L) {
	// weapon:premium(bool)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setNeedPremium(Lua::getBoolean(L, 2));
		weapon->setWieldInfo(WIELDINFO_PREMIUM);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponVocation(lua_State* L) {
	// weapon:vocation(vocName[, showInDescription = false, lastVoc = false])
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->addVocWeaponMap(Lua::getString(L, 2));
		weapon->setWieldInfo(WIELDINFO_VOCREQ);
		std::string tmp;
		bool showInDescription = false;
		bool lastVoc = false;
		if (Lua::getBoolean(L, 3)) {
			showInDescription = Lua::getBoolean(L, 3);
		}
		if (Lua::getBoolean(L, 4)) {
			lastVoc = Lua::getBoolean(L, 4);
		}
		if (showInDescription) {
			if (weapon->getVocationString().empty()) {
				tmp = asLowerCaseString(Lua::getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			} else {
				tmp = weapon->getVocationString();
				if (lastVoc) {
					tmp += " and ";
				} else {
					tmp += ", ";
				}
				tmp += asLowerCaseString(Lua::getString(L, 2));
				tmp += "s";
				weapon->setVocationString(tmp);
			}
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponId(lua_State* L) {
	// weapon:id(id)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		weapon->setID(Lua::getNumber<uint16_t>(L, 2));
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponAttack(lua_State* L) {
	// weapon:attack(atk)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.attack = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDefense(lua_State* L) {
	// weapon:defense(defense[, extraDefense])
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.defense = Lua::getNumber<int32_t>(L, 2);
		if (lua_gettop(L) > 2) {
			it.extraDefense = Lua::getNumber<int32_t>(L, 3);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponRange(lua_State* L) {
	// weapon:range(range)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.shootRange = Lua::getNumber<uint8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponCharges(lua_State* L) {
	// weapon:charges(charges[, showCharges = true])
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		bool showCharges = true;
		if (lua_gettop(L) > 2) {
			showCharges = Lua::getBoolean(L, 3);
		}
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.charges = Lua::getNumber<uint8_t>(L, 2);
		it.showCharges = showCharges;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDuration(lua_State* L) {
	// weapon:duration(duration[, showDuration = true])
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		bool showDuration = true;
		if (lua_gettop(L) > 2) {
			showDuration = Lua::getBoolean(L, 3);
		}
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.decayTime = Lua::getNumber<uint8_t>(L, 2);
		it.showDuration = showDuration;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponDecayTo(lua_State* L) {
	// weapon:decayTo([itemid = 0]
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		uint16_t itemid = 0;
		if (lua_gettop(L) > 1) {
			itemid = Lua::getNumber<uint16_t>(L, 2);
		}
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.decayTo = itemid;
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponTransformEquipTo(lua_State* L) {
	// weapon:transformEquipTo(itemid)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.transformEquipTo = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponTransformDeEquipTo(lua_State* L) {
	// weapon:transformDeEquipTo(itemid)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.transformDeEquipTo = Lua::getNumber<uint16_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponShootType(lua_State* L) {
	// weapon:shootType(type)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.shootType = Lua::getNumber<ShootType_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponSlotType(lua_State* L) {
	// weapon:slotType(slot)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		const std::string slot = Lua::getString(L, 2);

		if (slot == "two-handed") {
			it.slotPosition = SLOTP_TWO_HAND;
		} else {
			it.slotPosition = SLOTP_HAND;
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponAmmoType(lua_State* L) {
	// weapon:ammoType(type)
	const auto &weapon = Lua::getUserdataShared<WeaponDistance>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		std::string type = Lua::getString(L, 2);

		if (type == "arrow") {
			it.ammoType = AMMO_ARROW;
		} else if (type == "bolt") {
			it.ammoType = AMMO_BOLT;
		} else {
			g_logger().warn("[WeaponFunctions:luaWeaponAmmoType] - "
			                "Type {} does not exist",
			                type);
			lua_pushnil(L);
			return 1;
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponHitChance(lua_State* L) {
	// weapon:hitChance(chance)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.hitChance = Lua::getNumber<int8_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponMaxHitChance(lua_State* L) {
	// weapon:maxHitChance(max)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		ItemType &it = Item::items.getItemType(id);
		it.maxHitChance = Lua::getNumber<int32_t>(L, 2);
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int WeaponFunctions::luaWeaponExtraElement(lua_State* L) {
	// weapon:extraElement(atk, combatType)
	const WeaponShared_ptr &weapon = Lua::getUserdataShared<Weapon>(L, 1);
	if (weapon) {
		const uint16_t id = weapon->getID();
		const ItemType &it = Item::items.getItemType(id);
		it.abilities->elementDamage = Lua::getNumber<uint16_t>(L, 2);

		if (!Lua::getNumber<CombatType_t>(L, 3)) {
			std::string element = Lua::getString(L, 3);
			const std::string tmpStrValue = asLowerCaseString(element);
			if (tmpStrValue == "earth") {
				it.abilities->elementType = COMBAT_EARTHDAMAGE;
			} else if (tmpStrValue == "ice") {
				it.abilities->elementType = COMBAT_ICEDAMAGE;
			} else if (tmpStrValue == "energy") {
				it.abilities->elementType = COMBAT_ENERGYDAMAGE;
			} else if (tmpStrValue == "fire") {
				it.abilities->elementType = COMBAT_FIREDAMAGE;
			} else if (tmpStrValue == "death") {
				it.abilities->elementType = COMBAT_DEATHDAMAGE;
			} else if (tmpStrValue == "holy") {
				it.abilities->elementType = COMBAT_HOLYDAMAGE;
			} else {
				g_logger().warn("[WeaponFunctions:luaWeaponExtraElement] - "
				                "Type {} does not exist",
				                element);
			}
		} else {
			it.abilities->elementType = Lua::getNumber<CombatType_t>(L, 3);
		}
		Lua::pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
