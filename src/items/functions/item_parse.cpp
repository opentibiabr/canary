/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2018-2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#include "otpch.h"

#include "items/functions/item_parse.hpp"

void ItemParse::parseType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "type") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = ItemTypesMap.find(tmpStrValue);
		if (itemMap != ItemTypesMap.end()) {
			itemType.type = itemMap->second;
			if (itemType.type == ITEM_TYPE_CONTAINER) {
				itemType.group = ITEM_GROUP_CONTAINER;
			}
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown type: {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseDescription(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "description") {
		itemType.description = valueAttribute.as_string();
	}
}

void ItemParse::parseRuneSpellName(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "runespellname") {
		itemType.runeSpellName = valueAttribute.as_string();
	}
}

void ItemParse::parseWeight(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "weight") {
		itemType.weight = pugi::cast <uint32_t> (valueAttribute.value());
	}
}

void ItemParse::parseShowCount(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "showcount") {
		itemType.showCount = valueAttribute.as_bool();
	}
}

void ItemParse::parseArmor(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "armor") {
		itemType.armor = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseDefense(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "defense") {
		itemType.defense = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseExtraDefense(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "extradef") {
		itemType.extraDefense = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseAttack(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "attack") {
		itemType.attack = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseRotateTo(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "rotateto") {
		itemType.rotateTo = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseWrapContainer(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "wrapcontainer") {
		itemType.wrapContainer = valueAttribute.as_bool();
	}
}

void ItemParse::parseImbuingSlot(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "imbuingslot") {
		itemType.imbuingSlots = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseWrapableTo(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "wrapableto") {
		itemType.wrapableTo = pugi::cast <int32_t> (valueAttribute.value());
		itemType.wrapable = true;
	}
}

void ItemParse::parseMoveable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "moveable") {
		itemType.moveable = valueAttribute.as_bool();
	}
}

void ItemParse::parsePodium(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "podium") {
		itemType.isPodium = valueAttribute.as_bool();
	}
}

void ItemParse::parseBlockProjectTile(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "blockprojectile") {
		itemType.blockProjectile = valueAttribute.as_bool();
	}
}

void ItemParse::parsePickupable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "pickupable") {
		itemType.allowPickupable = valueAttribute.as_bool();
	}
}

void ItemParse::parseFloorChange(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "floorchange") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = TileStatesMap.find(tmpStrValue);
		if (itemMap != TileStatesMap.end()) {
			itemType.floorChange = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown floorChange {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseCorpseType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "corpsetype") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = RaceTypesMap.find(tmpStrValue);
		if (itemMap != RaceTypesMap.end()) {
			itemType.corpseType = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown corpseType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseContainerSize(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "containersize") {
		itemType.maxItems = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseFluidSource(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "fluidsource") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = FluidTypesMap.find(tmpStrValue);
		if (itemMap != FluidTypesMap.end()) {
			itemType.fluidSource = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown fluidSource {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseWriteables(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "readable") {
		itemType.canReadText = valueAttribute.as_bool();
	} else if (tmpStrValue == "writeable") {
		itemType.canWriteText = valueAttribute.as_bool();
		itemType.canReadText = itemType.canWriteText;
	} else if (tmpStrValue == "maxtextlen") {
		itemType.maxTextLen = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (tmpStrValue == "writeonceitemid") {
		itemType.writeOnceItemId = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseWeaponType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "weapontype") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = WeaponTypesMap.find(tmpStrValue);
		if (itemMap != WeaponTypesMap.end()) {
			itemType.weaponType = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown weaponType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseSlotType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "slottype") {
		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		if (tmpStrValue == "head") {
			itemType.slotPosition |= SLOTP_HEAD;
		} else if (tmpStrValue == "body") {
			itemType.slotPosition |= SLOTP_ARMOR;
		} else if (tmpStrValue == "legs") {
			itemType.slotPosition |= SLOTP_LEGS;
		} else if (tmpStrValue == "feet") {
			itemType.slotPosition |= SLOTP_FEET;
		} else if (tmpStrValue == "backpack") {
			itemType.slotPosition |= SLOTP_BACKPACK;
		} else if (tmpStrValue == "two-handed") {
			itemType.slotPosition |= SLOTP_TWO_HAND;
		} else if (tmpStrValue == "right-hand") {
			itemType.slotPosition &= ~SLOTP_LEFT;
		} else if (tmpStrValue == "left-hand") {
			itemType.slotPosition &= ~SLOTP_RIGHT;
		} else if (tmpStrValue == "necklace") {
			itemType.slotPosition |= SLOTP_NECKLACE;
		} else if (tmpStrValue == "ring") {
			itemType.slotPosition |= SLOTP_RING;
		} else if (tmpStrValue == "ammo") {
			itemType.slotPosition |= SLOTP_AMMO;
		} else if (tmpStrValue == "hand") {
			itemType.slotPosition |= SLOTP_HAND;
		} else {
			SPDLOG_WARN("[itemParseSlotType - Items::parseItemNode] - Unknown slotType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseAmmoType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "ammotype") {
		itemType.ammoType = getAmmoType(asLowerCaseString(valueAttribute.as_string()));
		if (itemType.ammoType == AMMO_NONE) {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown ammoType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseShootType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "shoottype") {
		ShootType_t shoot = getShootType(asLowerCaseString(valueAttribute.as_string()));
		if (shoot != CONST_ANI_NONE) {
			itemType.shootType = shoot;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown shootType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseMagicEffect(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "effect") {
		MagicEffectClasses effect = getMagicEffect(asLowerCaseString(valueAttribute.as_string()));
		if (effect != CONST_ME_NONE) {
			itemType.magicEffect = effect;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown effect {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseLootType(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "loottype") {
		itemType.type = Item::items.getLootType(valueAttribute.as_string());
	}
}

void ItemParse::parseRange(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "range") {
		itemType.shootRange = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseDuration(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "duration") {
		itemType.decayTime = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "stopduration") {
		itemType.stopTime = valueAttribute.as_bool();
	} else if (tmpStrValue == "showduration") {
		itemType.showDuration = valueAttribute.as_bool();
	}
}

void ItemParse::parseTransform(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "transformequipto") {
		itemType.transformEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (tmpStrValue == "transformdeequipto") {
		itemType.transformDeEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (tmpStrValue == "transformto") {
		itemType.transformToFree = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (tmpStrValue == "destroyto") {
		itemType.destroyTo = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseCharges(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "charges") {
		itemType.charges = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "showcharges") {
		itemType.showCharges = valueAttribute.as_bool();
	}
}

void ItemParse::parseShowAttributes(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "showattributes") {
		itemType.showAttributes = valueAttribute.as_bool();
	}
}

void ItemParse::parseHitChance(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "hitchance") {
		itemType.hitChance = std::min<int8_t>(100, std::max<int8_t>(-100, pugi::cast<int16_t>(valueAttribute.value())));
	} else if (tmpStrValue == "maxhitchance") {
		itemType.maxHitChance = std::min<uint32_t>(100, pugi::cast<uint32_t>(valueAttribute.value()));
	}
}

void ItemParse::parseInvisible(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "invisible") {
		itemType.getAbilities().invisible = valueAttribute.as_bool();
	}
}

void ItemParse::parseSpeed(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "speed") {
		itemType.getAbilities().speed = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseHealthAndMana(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "healthgain") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.healthGain = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "healthticks") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.healthTicks = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "managain") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.manaGain = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "manaticks") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.manaTicks = pugi::cast <uint32_t> (valueAttribute.value());
	} else if (tmpStrValue == "manashield") {
		itemType.getAbilities().manaShield = valueAttribute.as_bool();
	}
}

void ItemParse::parseSkills(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "skillsword") {
		itemType.getAbilities().skills[SKILL_SWORD] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skillaxe") {
		itemType.getAbilities().skills[SKILL_AXE] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skillclub") {
		itemType.getAbilities().skills[SKILL_CLUB] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skilldist") {
		itemType.getAbilities().skills[SKILL_DISTANCE] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skillfish") {
		itemType.getAbilities().skills[SKILL_FISHING] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skillshield") {
		itemType.getAbilities().skills[SKILL_SHIELD] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "skillfist") {
		itemType.getAbilities().skills[SKILL_FIST] = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseCriticalHit(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "criticalhitchance") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_CHANCE] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "criticalhitdamage") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_DAMAGE] = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseLifeAndManaLeech(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "lifeleechchance") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_CHANCE] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "lifeleechamount") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_AMOUNT] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "manaleechchance") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_CHANCE] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "manaleechamount") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_AMOUNT] = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseMaxHitAndManaPoints(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "maxhitpoints") {
		itemType.getAbilities().stats[STAT_MAXHITPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "maxhitpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXHITPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "maxmanapoints") {
		itemType.getAbilities().stats[STAT_MAXMANAPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "maxmanapointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXMANAPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseMagicPoints(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "magicpoints") {
		itemType.getAbilities().stats[STAT_MAGICPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	} else if (tmpStrValue == "magicpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAGICPOINTS] = pugi::cast <int32_t> (valueAttribute.value());
	}
}

void ItemParse::parseFieldAbsorbPercent(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "fieldabsorbpercentenergy") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "fieldabsorbpercentfire") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "fieldabsorbpercentpoison") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	}
}

void ItemParse::parseAbsorbPercent(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "absorbpercentall") {
		int16_t value = pugi::cast <int16_t> (valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		for (auto & i: abilities.absorbPercent) {
			i += value;
		}
	} else if (tmpStrValue == "absorbpercentelements") {
		int16_t value = pugi::cast <int16_t> (valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
	} else if (tmpStrValue == "absorbpercentmagic") {
		int16_t value = pugi::cast <int16_t> (valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += value;
	} else if (tmpStrValue == "absorbpercentenergy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentfire") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentpoison") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentice") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentholy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentdeath") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentlifedrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_LIFEDRAIN)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentmanadrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_MANADRAIN)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentdrown") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DROWNDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercentphysical") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast <int16_t> (valueAttribute.value());
	} else if (tmpStrValue == "absorbpercenthealing") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HEALING)] += pugi::cast <int16_t> (valueAttribute.value());
	}
}

void ItemParse::parseSupressDrunk(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "suppressdrunk") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DRUNK;
		}
	} else if (tmpStrValue == "suppressenergy") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_ENERGY;
		}
	} else if (tmpStrValue == "suppressfire") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FIRE;
		}
	} else if (tmpStrValue == "suppresspoison") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_POISON;
		}
	} else if (tmpStrValue == "suppressdrown") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DROWN;
		}
	} else if (tmpStrValue == "suppressphysical") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_BLEEDING;
		}
	} else if (tmpStrValue == "suppressfreeze") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FREEZING;
		}
	} else if (tmpStrValue == "suppressdazzle") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DAZZLED;
		}
	} else if (tmpStrValue == "suppresscurse") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_CURSED;
		}
	}
}

void ItemParse::parseField(std::string tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "field") {
		CombatType_t combatType = COMBAT_NONE;
		ConditionDamage *conditionDamage = nullptr;

		tmpStrValue = asLowerCaseString(valueAttribute.as_string());
		if (tmpStrValue == "fire") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_FIRE);
			combatType = COMBAT_FIREDAMAGE;
		} else if (tmpStrValue == "energy") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_ENERGY);
			combatType = COMBAT_ENERGYDAMAGE;
		} else if (tmpStrValue == "poison") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_POISON);
			combatType = COMBAT_EARTHDAMAGE;
		} else if (tmpStrValue == "drown") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_DROWN);
			combatType = COMBAT_DROWNDAMAGE;
		} else if (tmpStrValue == "physical") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_BLEEDING);
			combatType = COMBAT_PHYSICALDAMAGE;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] Unknown field value {}",
                        valueAttribute.as_string());
		}

		if (combatType != COMBAT_NONE) {
			itemType.combatType = combatType;
			itemType.conditionDamage.reset(conditionDamage);
			uint32_t ticks = 0;
			int32_t damage = 0;
			int32_t start = 0;
			int32_t count = 1;

			for (auto subAttributeNode: attributeNode.children()) {

				pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
				if (!subKeyAttribute) {
					continue;
				}

				pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
				if (!subValueAttribute) {
					continue;
				}

				tmpStrValue = asLowerCaseString(subKeyAttribute.as_string());
				if (tmpStrValue == "ticks") {
							ticks = pugi::cast <uint32_t> (subValueAttribute.value());
				} else if (tmpStrValue == "count") {
					count = std::max <int32_t> (1, pugi::cast <int32_t> (subValueAttribute.value()));
				} else if (tmpStrValue == "start") {
					start = std::max <int32_t> (0, pugi::cast <int32_t> (subValueAttribute.value()));
				} else if (tmpStrValue == "damage") {
					damage = -pugi::cast <int32_t> (subValueAttribute.value());
					if (start > 0) {
						std::list <int32_t> damageList;
						ConditionDamage::generateDamageList(damage, start, damageList);
						for (int32_t damageValue: damageList) {
							conditionDamage -> addDamage(1, ticks, -damageValue);
						}

						start = 0;
					} else {
						conditionDamage -> addDamage(count, ticks, damage);
					}
				}
			}

			conditionDamage -> setParam(CONDITION_PARAM_FIELD, 1);

			if (conditionDamage -> getTotalDamage() > 0) {
				conditionDamage -> setParam(CONDITION_PARAM_FORCEUPDATE, 1);
			}
		}
	}
}

void ItemParse::parseReplaceable(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "replaceable") {
		itemType.replaceable = valueAttribute.as_bool();
	}
}

void ItemParse::parseLevelDoor(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "leveldoor") {
		itemType.levelDoor = pugi::cast <uint32_t> (valueAttribute.value());
	}
}

void ItemParse::parseBeds(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "partnerdirection") {
		itemType.bedPartnerDir = getDirection(valueAttribute.as_string());
	}
		
	if (tmpStrValue == "maletransformto") {
		uint16_t value = pugi::cast<uint16_t>(valueAttribute.value());
		itemType.transformToOnUse[PLAYERSEX_MALE] = value;
		ItemType & other = Item::items.getItemType(value);
		if (other.transformToFree == 0) {
			other.transformToFree = itemType.id;
		}

		if (itemType.transformToOnUse[PLAYERSEX_FEMALE] == 0) {
			itemType.transformToOnUse[PLAYERSEX_FEMALE] = value;
		}
	} else if (tmpStrValue == "femaletransformto") {
		uint16_t value = pugi::cast<uint16_t>(valueAttribute.value());
		itemType.transformToOnUse[PLAYERSEX_FEMALE] = value;

		ItemType & other = Item::items.getItemType(value);
		if (other.transformToFree == 0) {
			other.transformToFree = itemType.id;
		}

		if (itemType.transformToOnUse[PLAYERSEX_MALE] == 0) {
			itemType.transformToOnUse[PLAYERSEX_MALE] = value;
		}
	}
}

void ItemParse::parseElement(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "elementice") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ICEDAMAGE;
	} else if (tmpStrValue == "elementearth") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_EARTHDAMAGE;
	} else if (tmpStrValue == "elementfire") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_FIREDAMAGE;
	} else if (tmpStrValue == "elementenergy") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ENERGYDAMAGE;
	} else if (tmpStrValue == "elementdeath") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_DEATHDAMAGE;
	} else if (tmpStrValue == "elementholy") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_HOLYDAMAGE;
	}
}

void ItemParse::parseWalk(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "walkstack") {
		itemType.walkStack = valueAttribute.as_bool();
	} else if (tmpStrValue == "block_solid") {
		itemType.blockSolid = valueAttribute.as_bool();
	}
}

void ItemParse::parseAllowDistanceRead(std::string tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	if (tmpStrValue == "allowdistread") {
		itemType.allowDistRead = booleanString(valueAttribute.as_string());
	}
}
