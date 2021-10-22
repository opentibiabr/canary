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

void ItemParse::parseType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string type = tmpStrValue;
	if (type == "type") {
		type = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = ItemTypesMap.find(type);
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

void ItemParse::parseDescription(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string description = tmpStrValue;
	if (description == "description") {
		itemType.description = valueAttribute.as_string();
	}
}

void ItemParse::parseRuneSpellName(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string runespellname = tmpStrValue;
	std::string string = tmpStrValue;
	if (string == "runespellname") {
		itemType.runeSpellName = valueAttribute.as_string();
	}
}

void ItemParse::parseWeight(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string weight = tmpStrValue;
	if (weight == "weight") {
		itemType.weight = pugi::cast<uint32_t>(valueAttribute.value());
	}
}

void ItemParse::parseShowCount(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string showCount = tmpStrValue;
	if (showCount == "showcount") {
		itemType.showCount = valueAttribute.as_bool();
	}
}

void ItemParse::parseArmor(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string armor = tmpStrValue;
	if (armor == "armor") {
		itemType.armor = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseDefense(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string defense = tmpStrValue;
	if (defense == "defense") {
		itemType.defense = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseExtraDefense(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string extraDefense = tmpStrValue;
	if (extraDefense == "extradef") {
		itemType.extraDefense = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseAttack(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string attack = tmpStrValue;
	if (attack == "attack") {
		itemType.attack = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseRotateTo(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string rotateTo = tmpStrValue;
	if (rotateTo == "rotateto") {
		itemType.rotateTo = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseWrapContainer(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string wrapContainer = tmpStrValue;
	if (wrapContainer == "wrapcontainer") {
		itemType.wrapContainer = valueAttribute.as_bool();
	}
}

void ItemParse::parseImbuingSlot(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string imbuingSlots = tmpStrValue;
	if (imbuingSlots == "imbuingslot") {
		itemType.imbuingSlots = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseWrapableTo(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string wrapable = tmpStrValue;
	if (wrapable == "wrapableto") {
		itemType.wrapableTo = pugi::cast<int32_t>(valueAttribute.value());
		itemType.wrapable = true;
	}
}

void ItemParse::parseMoveable(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string moveable = tmpStrValue;
	if (moveable == "moveable") {
		itemType.moveable = valueAttribute.as_bool();
	}
}

void ItemParse::parsePodium(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string isPodium = tmpStrValue;
	if (isPodium == "podium") {
		itemType.isPodium = valueAttribute.as_bool();
	}
}

void ItemParse::parseBlockProjectTile(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string blockProjectile = tmpStrValue;
	if (blockProjectile == "blockprojectile") {
		itemType.blockProjectile = valueAttribute.as_bool();
	}
}

void ItemParse::parsePickupable(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string allowPickupable = tmpStrValue;
	if (allowPickupable == "pickupable") {
		itemType.allowPickupable = valueAttribute.as_bool();
	}
}

void ItemParse::parseFloorChange(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string floorChange = tmpStrValue;
	if (floorChange == "floorchange") {
		floorChange = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = TileStatesMap.find(floorChange);
		if (itemMap != TileStatesMap.end()) {
			itemType.floorChange = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown floorChange {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseCorpseType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string corpseType = tmpStrValue;
	if (corpseType == "corpsetype") {
		corpseType = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = RaceTypesMap.find(corpseType);
		if (itemMap != RaceTypesMap.end()) {
			itemType.corpseType = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown corpseType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseContainerSize(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "containersize") {
		itemType.maxItems = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseFluidSource(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "fluidsource") {
		string = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = FluidTypesMap.find(string);
		if (itemMap != FluidTypesMap.end()) {
			itemType.fluidSource = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown fluidSource {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseWriteables(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "readable") {
		itemType.canReadText = valueAttribute.as_bool();
	} else if (string == "writeable") {
		itemType.canWriteText = valueAttribute.as_bool();
		itemType.canReadText = itemType.canWriteText;
	} else if (string == "maxtextlen") {
		itemType.maxTextLen = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (string == "writeonceitemid") {
		itemType.writeOnceItemId = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseWeaponType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "weapontype") {
		string = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = WeaponTypesMap.find(string);
		if (itemMap != WeaponTypesMap.end()) {
			itemType.weaponType = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown weaponType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseSlotType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "slottype") {
		string = asLowerCaseString(valueAttribute.as_string());
	if (string == "head") {
			itemType.slotPosition |= SLOTP_HEAD;
		} else if (string == "body") {
			itemType.slotPosition |= SLOTP_ARMOR;
		} else if (string == "legs") {
			itemType.slotPosition |= SLOTP_LEGS;
		} else if (string == "feet") {
			itemType.slotPosition |= SLOTP_FEET;
		} else if (string == "backpack") {
			itemType.slotPosition |= SLOTP_BACKPACK;
		} else if (string == "two-handed") {
			itemType.slotPosition |= SLOTP_TWO_HAND;
		} else if (string == "right-hand") {
			itemType.slotPosition &= ~SLOTP_LEFT;
		} else if (string == "left-hand") {
			itemType.slotPosition &= ~SLOTP_RIGHT;
		} else if (string == "necklace") {
			itemType.slotPosition |= SLOTP_NECKLACE;
		} else if (string == "ring") {
			itemType.slotPosition |= SLOTP_RING;
		} else if (string == "ammo") {
			itemType.slotPosition |= SLOTP_AMMO;
		} else if (string == "hand") {
			itemType.slotPosition |= SLOTP_HAND;
		} else {
			SPDLOG_WARN("[itemParseSlotType - Items::parseItemNode] - Unknown slotType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseAmmoType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "ammotype") {
		itemType.ammoType = getAmmoType(asLowerCaseString(valueAttribute.as_string()));
		if (itemType.ammoType == AMMO_NONE) {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown ammoType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseShootType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "shoottype") {
		ShootType_t shoot = getShootType(asLowerCaseString(valueAttribute.as_string()));
		if (shoot != CONST_ANI_NONE) {
			itemType.shootType = shoot;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown shootType {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseMagicEffect(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "effect") {
		MagicEffectClasses effect = getMagicEffect(asLowerCaseString(valueAttribute.as_string()));
		if (effect != CONST_ME_NONE) {
			itemType.magicEffect = effect;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown effect {}",
                        valueAttribute.as_string());
		}
	}
}

void ItemParse::parseLootType(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "loottype") {
		itemType.type = Item::items.getLootType(valueAttribute.as_string());
	}
}

void ItemParse::parseRange(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "range") {
		itemType.shootRange = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseDuration(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "duration") {
		itemType.decayTime = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "stopduration") {
		itemType.stopTime = valueAttribute.as_bool();
	} else if (string == "showduration") {
		itemType.showDuration = valueAttribute.as_bool();
	}
}

void ItemParse::parseTransform(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "transformequipto") {
		itemType.transformEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (string == "transformdeequipto") {
		itemType.transformDeEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (string == "transformto") {
		itemType.transformToFree = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (string == "destroyto") {
		itemType.destroyTo = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseCharges(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "charges") {
		itemType.charges = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "showcharges") {
		itemType.showCharges = valueAttribute.as_bool();
	}
}

void ItemParse::parseShowAttributes(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "showattributes") {
		itemType.showAttributes = valueAttribute.as_bool();
	}
}

void ItemParse::parseHitChance(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "hitchance") {
		itemType.hitChance = std::min<int8_t>(100, std::max<int8_t>(-100, pugi::cast<int16_t>(valueAttribute.value())));
	} else if (string == "maxhitchance") {
		itemType.maxHitChance = std::min<uint32_t>(100, pugi::cast<uint32_t>(valueAttribute.value()));
	}
}

void ItemParse::parseInvisible(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "invisible") {
		itemType.getAbilities().invisible = valueAttribute.as_bool();
	}
}

void ItemParse::parseSpeed(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "speed") {
		itemType.getAbilities().speed = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseHealthAndMana(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "healthgain") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.healthGain = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "healthticks") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.healthTicks = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "managain") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.manaGain = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "manaticks") {
		Abilities & abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.manaTicks = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (string == "manashield") {
		itemType.getAbilities().manaShield = valueAttribute.as_bool();
	}
}

void ItemParse::parseSkills(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "skillsword") {
		itemType.getAbilities().skills[SKILL_SWORD] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skillaxe") {
		itemType.getAbilities().skills[SKILL_AXE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skillclub") {
		itemType.getAbilities().skills[SKILL_CLUB] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skilldist") {
		itemType.getAbilities().skills[SKILL_DISTANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skillfish") {
		itemType.getAbilities().skills[SKILL_FISHING] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skillshield") {
		itemType.getAbilities().skills[SKILL_SHIELD] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "skillfist") {
		itemType.getAbilities().skills[SKILL_FIST] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseCriticalHit(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "criticalhitchance") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "criticalhitdamage") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_DAMAGE] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseLifeAndManaLeech(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "lifeleechchance") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "lifeleechamount") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_AMOUNT] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "manaleechchance") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "manaleechamount") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_AMOUNT] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseMaxHitAndManaPoints(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "maxhitpoints") {
		itemType.getAbilities().stats[STAT_MAXHITPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "maxhitpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXHITPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "maxmanapoints") {
		itemType.getAbilities().stats[STAT_MAXMANAPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "maxmanapointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXMANAPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseMagicPoints(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "magicpoints") {
		itemType.getAbilities().stats[STAT_MAGICPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (string == "magicpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAGICPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseFieldAbsorbPercent(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "fieldabsorbpercentenergy") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "fieldabsorbpercentfire") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "fieldabsorbpercentpoison") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseAbsorbPercent(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "absorbpercentall") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		for (auto & i: abilities.absorbPercent) {
			i += value;
		}
	} else if (string == "absorbpercentelements") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
	} else if (string == "absorbpercentmagic") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities & abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += value;
	} else if (string == "absorbpercentenergy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentfire") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentpoison") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentice") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentholy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentdeath") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentlifedrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_LIFEDRAIN)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentmanadrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_MANADRAIN)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentdrown") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DROWNDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercentphysical") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (string == "absorbpercenthealing") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HEALING)] += pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseSupressDrunk(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "suppressdrunk") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DRUNK;
		}
	} else if (string == "suppressenergy") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_ENERGY;
		}
	} else if (string == "suppressfire") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FIRE;
		}
	} else if (string == "suppresspoison") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_POISON;
		}
	} else if (string == "suppressdrown") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DROWN;
		}
	} else if (string == "suppressphysical") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_BLEEDING;
		}
	} else if (string == "suppressfreeze") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FREEZING;
		}
	} else if (string == "suppressdazzle") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DAZZLED;
		}
	} else if (string == "suppresscurse") {
		if (valueAttribute.as_bool()) {
			itemType.getAbilities().conditionSuppressions |= CONDITION_CURSED;
		}
	}
}

void ItemParse::parseField(const std::string& tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "field") {
		CombatType_t combatType = COMBAT_NONE;
		ConditionDamage *conditionDamage = nullptr;

		string = asLowerCaseString(valueAttribute.as_string());
		if (string == "fire") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_FIRE);
			combatType = COMBAT_FIREDAMAGE;
		} else if (string == "energy") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_ENERGY);
			combatType = COMBAT_ENERGYDAMAGE;
		} else if (string == "poison") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_POISON);
			combatType = COMBAT_EARTHDAMAGE;
		} else if (string == "drown") {
			conditionDamage = new ConditionDamage(CONDITIONID_COMBAT, CONDITION_DROWN);
			combatType = COMBAT_DROWNDAMAGE;
		} else if (string == "physical") {
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

				string = asLowerCaseString(subKeyAttribute.as_string());
				if (string == "ticks") {
					ticks = pugi::cast<uint32_t>(subValueAttribute.value());
				} else if (string == "count") {
					count = std::max<int32_t>(1, pugi::cast<int32_t>(subValueAttribute.value()));
				} else if (string == "start") {
					start = std::max<int32_t>(0, pugi::cast<int32_t>(subValueAttribute.value()));
				} else if (string == "damage") {
					damage = -pugi::cast<int32_t>(subValueAttribute.value());
					if (start > 0) {
						std::list<int32_t>damageList;
						ConditionDamage::generateDamageList(damage, start, damageList);
						for (int32_t damageValue: damageList) {
							conditionDamage->addDamage(1, ticks, -damageValue);
						}

						start = 0;
					} else {
						conditionDamage->addDamage(count, ticks, damage);
					}
				}
			}

			conditionDamage->setParam(CONDITION_PARAM_FIELD, 1);

			if (conditionDamage->getTotalDamage() > 0) {
				conditionDamage->setParam(CONDITION_PARAM_FORCEUPDATE, 1);
			}
		}
	}
}

void ItemParse::parseReplaceable(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "replaceable") {
		itemType.replaceable = valueAttribute.as_bool();
	}
}

void ItemParse::parseLevelDoor(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "leveldoor") {
		itemType.levelDoor = pugi::cast<uint32_t>(valueAttribute.value());
	}
}

void ItemParse::parseBeds(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "partnerdirection") {
		itemType.bedPartnerDir = getDirection(valueAttribute.as_string());
	}
		
	if (string == "maletransformto") {
		uint16_t value = pugi::cast<uint16_t>(valueAttribute.value());
		itemType.transformToOnUse[PLAYERSEX_MALE] = value;
		ItemType & other = Item::items.getItemType(value);
		if (other.transformToFree == 0) {
			other.transformToFree = itemType.id;
		}

		if (itemType.transformToOnUse[PLAYERSEX_FEMALE] == 0) {
			itemType.transformToOnUse[PLAYERSEX_FEMALE] = value;
		}
	} else if (string == "femaletransformto") {
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

void ItemParse::parseElement(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "elementice") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ICEDAMAGE;
	} else if (string == "elementearth") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_EARTHDAMAGE;
	} else if (string == "elementfire") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_FIREDAMAGE;
	} else if (string == "elementenergy") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ENERGYDAMAGE;
	} else if (string == "elementdeath") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_DEATHDAMAGE;
	} else if (string == "elementholy") {
		Abilities & abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_HOLYDAMAGE;
	}
}

void ItemParse::parseWalk(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "walkstack") {
		itemType.walkStack = valueAttribute.as_bool();
	} else if (string == "block_solid") {
		itemType.blockSolid = valueAttribute.as_bool();
	}
}

void ItemParse::parseAllowDistanceRead(const std::string& tmpStrValue, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string string = tmpStrValue;
	if (string == "allowdistread") {
		itemType.allowDistRead = booleanString(valueAttribute.as_string());
	}
}
