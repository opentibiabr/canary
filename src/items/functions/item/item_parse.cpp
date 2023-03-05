/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/functions/item/item_parse.hpp"
#include "utils/pugicast.h"

void ItemParse::initParse(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	// Parse all item attributes
	ItemParse::parseType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseDescription(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseRuneSpellName(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWeight(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseShowCount(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseArmor(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseDefense(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseExtraDefense(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAttack(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseRotateTo(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWrapContainer(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWrapableTo(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMoveable(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseBlockProjectTile(tmpStrValue, valueAttribute, itemType);
	ItemParse::parsePickupable(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseFloorChange(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseContainerSize(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseFluidSource(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWriteables(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWeaponType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSlotType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAmmoType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseShootType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMagicEffect(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseLootType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseRange(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseDecayTo(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseDuration(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseTransform(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseCharges(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseShowAttributes(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseHitChance(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseInvisible(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSpeed(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseHealthAndMana(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSkills(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseCriticalHit(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseLifeAndManaLeech(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMaxHitAndManaPoints(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMagicPoints(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseFieldAbsorbPercent(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAbsorbPercent(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseElementalMagicLevel(tmpStrValue, valueAttribute, itemType);
	ItemParse::parsePerfectShotDamage(tmpStrValue, valueAttribute, itemType);
	ItemParse::parsePerfectShotRange(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSupressDrunk(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseField(tmpStrValue, attributeNode, valueAttribute, itemType);
	ItemParse::parseReplaceable(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseLevelDoor(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseBeds(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseElement(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWalk(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAllowDistanceRead(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseImbuement(tmpStrValue, attributeNode, valueAttribute, itemType);
	ItemParse::parseDamageReflection(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMagicShieldCapacity(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseCleave(tmpStrValue, valueAttribute, itemType);
}

void ItemParse::parseType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "type") {
		stringValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = ItemTypesMap.find(stringValue);
		if (itemMap != ItemTypesMap.end()) {
			itemType.type = itemMap->second;
			if (itemType.type == ITEM_TYPE_CONTAINER) {
				itemType.group = ITEM_GROUP_CONTAINER;
			}
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown type: {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseDescription(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "description") {
		itemType.description = valueAttribute.as_string();
	}
}

void ItemParse::parseRuneSpellName(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "runespellname") {
		itemType.runeSpellName = valueAttribute.as_string();
	}
}

void ItemParse::parseWeight(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "weight") {
		itemType.weight = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseShowCount(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "showcount") {
		itemType.showCount = valueAttribute.as_bool();
	}
}

void ItemParse::parseArmor(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "armor") {
		itemType.armor = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseDefense(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "defense") {
		itemType.defense = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseExtraDefense(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "extradef") {
		itemType.extraDefense = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseAttack(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "attack") {
		itemType.attack = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseRotateTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "rotateto") {
		itemType.rotateTo = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseWrapContainer(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "wrapcontainer") {
		itemType.wrapContainer = valueAttribute.as_bool();
	}
}

void ItemParse::parseWrapableTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "wrapableto") {
		itemType.wrapableTo = pugi::cast<int32_t>(valueAttribute.value());
		itemType.wrapable = true;
	}
}

void ItemParse::parseMoveable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "moveable") {
		itemType.moveable = valueAttribute.as_bool();
	}
}

void ItemParse::parseBlockProjectTile(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "blockprojectile") {
		itemType.blockProjectile = valueAttribute.as_bool();
	}
}

void ItemParse::parsePickupable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "allowpickupable" || stringValue == "pickupable") {
		itemType.pickupable = valueAttribute.as_bool();
	}
}

void ItemParse::parseFloorChange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "floorchange") {
		stringValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = TileStatesMap.find(stringValue);
		if (itemMap != TileStatesMap.end()) {
			itemType.floorChange = itemMap->second;
		} else {
			SPDLOG_WARN("[ItemParse::parseFloorChange] - Unknown floorChange {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseContainerSize(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "containersize") {
		itemType.maxItems = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseFluidSource(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "fluidsource") {
		stringValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = FluidTypesMap.find(stringValue);
		if (itemMap != FluidTypesMap.end()) {
			itemType.fluidSource = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown fluidSource {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseWriteables(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "readable") {
		itemType.canReadText = valueAttribute.as_bool();
	} else if (stringValue == "writeable") {
		itemType.canWriteText = valueAttribute.as_bool();
		itemType.canReadText = itemType.canWriteText;
	} else if (stringValue == "maxtextlen") {
		itemType.maxTextLen = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (stringValue == "writeonceitemid") {
		itemType.writeOnceItemId = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseWeaponType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "weapontype") {
		stringValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = WeaponTypesMap.find(stringValue);
		if (itemMap != WeaponTypesMap.end()) {
			itemType.weaponType = itemMap->second;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown weaponType {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseSlotType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "slottype") {
		itemType.slotPosition = SLOTP_HAND;
		stringValue = asLowerCaseString(valueAttribute.as_string());
		if (stringValue == "head") {
			itemType.slotPosition |= SLOTP_HEAD;
		} else if (stringValue == "body") {
			itemType.slotPosition |= SLOTP_ARMOR;
		} else if (stringValue == "legs") {
			itemType.slotPosition |= SLOTP_LEGS;
		} else if (stringValue == "feet") {
			itemType.slotPosition |= SLOTP_FEET;
		} else if (stringValue == "backpack") {
			itemType.slotPosition |= SLOTP_BACKPACK;
		} else if (stringValue == "two-handed") {
			itemType.slotPosition |= SLOTP_TWO_HAND;
		} else if (stringValue == "right-hand") {
			itemType.slotPosition &= ~SLOTP_LEFT;
		} else if (stringValue == "left-hand") {
			itemType.slotPosition &= ~SLOTP_RIGHT;
		} else if (stringValue == "necklace") {
			itemType.slotPosition |= SLOTP_NECKLACE;
		} else if (stringValue == "ring") {
			itemType.slotPosition |= SLOTP_RING;
		} else if (stringValue == "ammo") {
			itemType.slotPosition |= SLOTP_AMMO;
		} else if (stringValue == "hand") {
			itemType.slotPosition |= SLOTP_HAND;
		} else {
			SPDLOG_WARN("[itemParseSlotType - Items::parseItemNode] - Unknown slotType {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseAmmoType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "ammotype") {
		itemType.ammoType = getAmmoType(asLowerCaseString(valueAttribute.as_string()));
		if (itemType.ammoType == AMMO_NONE) {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown ammoType {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseShootType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "shoottype") {
		ShootType_t shoot = getShootType(asLowerCaseString(valueAttribute.as_string()));
		if (shoot != CONST_ANI_NONE) {
			itemType.shootType = shoot;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown shootType {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseMagicEffect(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "effect") {
		MagicEffectClasses effect = getMagicEffect(asLowerCaseString(valueAttribute.as_string()));
		if (effect != CONST_ME_NONE) {
			itemType.magicEffect = effect;
		} else {
			SPDLOG_WARN("[Items::parseItemNode] - Unknown effect {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseLootType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "loottype") {
		itemType.type = Item::items.getLootType(valueAttribute.as_string());
	}
}

void ItemParse::parseRange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "range") {
		itemType.shootRange = pugi::cast<uint8_t>(valueAttribute.value());
	}
}

void ItemParse::parseDecayTo(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "decayto") {
		itemType.decayTo = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseDuration(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "duration") {
		itemType.decayTime = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (stringValue == "stopduration") {
		itemType.stopTime = valueAttribute.as_bool();
	} else if (stringValue == "showduration") {
		itemType.showDuration = valueAttribute.as_bool();
	}
}

void ItemParse::parseTransform(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "transformequipto") {
		itemType.transformEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
		if (ItemType &transform = Item::items.getItemType(itemType.transformEquipTo);
			transform.type == ITEM_TYPE_NONE) {
			transform.type = itemType.type;
		}
	} else if (stringValue == "transformdeequipto") {
		itemType.transformDeEquipTo = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (stringValue == "transformto") {
		itemType.transformToFree = pugi::cast<uint16_t>(valueAttribute.value());
	} else if (stringValue == "destroyto") {
		itemType.destroyTo = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parseCharges(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "charges") {
		itemType.charges = pugi::cast<uint32_t>(valueAttribute.value());
	} else if (stringValue == "showcharges") {
		itemType.showCharges = valueAttribute.as_bool();
	}
}

void ItemParse::parseShowAttributes(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string lowerStringValue = asLowerCaseString(tmpStrValue);
	if (lowerStringValue == "showattributes") {
		itemType.showAttributes = valueAttribute.as_bool();
	}
}

void ItemParse::parseHitChance(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "hitchance") {
		itemType.hitChance = std::min<int8_t>(100, std::max<int8_t>(-100, pugi::cast<int8_t>(valueAttribute.value())));
	} else if (stringValue == "maxhitchance") {
		itemType.maxHitChance = std::min<uint32_t>(100, pugi::cast<uint32_t>(valueAttribute.value()));
	}
}

void ItemParse::parseInvisible(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "invisible") {
		itemType.getAbilities().invisible = valueAttribute.as_bool();
	}
}

void ItemParse::parseSpeed(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "speed") {
		itemType.getAbilities().speed = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseHealthAndMana(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "healthgain") {
		Abilities &abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.setHealthGain(pugi::cast<uint32_t>(valueAttribute.value()));
	} else if (stringValue == "healthticks") {
		Abilities &abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.setHealthTicks(pugi::cast<uint32_t>(valueAttribute.value()));
	} else if (stringValue == "managain") {
		Abilities &abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.setManaGain(pugi::cast<uint32_t>(valueAttribute.value()));
	} else if (stringValue == "manaticks") {
		Abilities &abilities = itemType.getAbilities();
		abilities.regeneration = true;
		abilities.setManaTicks(pugi::cast<uint32_t>(valueAttribute.value()));
	} else if (stringValue == "manashield") {
		itemType.getAbilities().manaShield = valueAttribute.as_bool();
	}
}

void ItemParse::parseSkills(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "skillsword") {
		itemType.getAbilities().skills[SKILL_SWORD] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skillaxe") {
		itemType.getAbilities().skills[SKILL_AXE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skillclub") {
		itemType.getAbilities().skills[SKILL_CLUB] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skilldist") {
		itemType.getAbilities().skills[SKILL_DISTANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skillfish") {
		itemType.getAbilities().skills[SKILL_FISHING] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skillshield") {
		itemType.getAbilities().skills[SKILL_SHIELD] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "skillfist") {
		itemType.getAbilities().skills[SKILL_FIST] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseCriticalHit(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "criticalhitchance") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "criticalhitdamage") {
		itemType.getAbilities().skills[SKILL_CRITICAL_HIT_DAMAGE] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseLifeAndManaLeech(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "lifeleechchance") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "lifeleechamount") {
		itemType.getAbilities().skills[SKILL_LIFE_LEECH_AMOUNT] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "manaleechchance") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_CHANCE] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "manaleechamount") {
		itemType.getAbilities().skills[SKILL_MANA_LEECH_AMOUNT] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseMaxHitAndManaPoints(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "maxhitpoints") {
		itemType.getAbilities().stats[STAT_MAXHITPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "maxhitpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXHITPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "maxmanapoints") {
		itemType.getAbilities().stats[STAT_MAXMANAPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "maxmanapointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAXMANAPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseMagicPoints(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "magicpoints") {
		itemType.getAbilities().stats[STAT_MAGICPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "magicpointspercent") {
		itemType.getAbilities().statsPercent[STAT_MAGICPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseFieldAbsorbPercent(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "fieldabsorbpercentenergy") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "fieldabsorbpercentfire") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "fieldabsorbpercentpoison") {
		itemType.getAbilities().fieldAbsorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseAbsorbPercent(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "absorbpercentall") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities &abilities = itemType.getAbilities();
		for (auto &i : abilities.absorbPercent) {
			i += value;
		}
	} else if (stringValue == "absorbpercentelements") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities &abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
	} else if (stringValue == "absorbpercentmagic") {
		int16_t value = pugi::cast<int16_t>(valueAttribute.value());
		Abilities &abilities = itemType.getAbilities();
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += value;
		abilities.absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += value;
	} else if (stringValue == "absorbpercentenergy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentfire") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentpoison") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentice") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_ICEDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentholy") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentdeath") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentlifedrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_LIFEDRAIN)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentmanadrain") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_MANADRAIN)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentdrown") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_DROWNDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercentphysical") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "absorbpercenthealing") {
		itemType.getAbilities().absorbPercent[combatTypeToIndex(COMBAT_HEALING)] += pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseElementalMagicLevel(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "deathmagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "energymagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "earthmagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "firemagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "healingmagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_HEALING)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "holymagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "icemagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_ICEDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "physicalmagiclevelpoints") {
		itemType.getAbilities().specializedMagicLevel[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseCleave(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "cleavepercent") {
		itemType.getAbilities().cleavePercent = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseMagicShieldCapacity(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "magicshieldcapacitypercent") {
		itemType.getAbilities().magicShieldCapacityPercent = pugi::cast<int16_t>(valueAttribute.value());
	} else if (stringValue == "magicshieldcapacityflat") {
		itemType.getAbilities().magicShieldCapacityFlat = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseDamageReflection(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "damagereflection") {
		itemType.getAbilities().damageReflection = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parsePerfectShotDamage(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "perfectshotdamage") {
		itemType.getAbilities().perfectShotDamage = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parsePerfectShotRange(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "perfectshotrange") {
		itemType.getAbilities().perfectShotRange = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseSupressDrunk(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (valueAttribute.as_bool()) {
		if (stringValue == "suppressdrunk") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DRUNK;
		} else if (stringValue == "suppressenergy") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_ENERGY;
		} else if (stringValue == "suppressfire") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FIRE;
		} else if (stringValue == "suppresspoison") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_POISON;
		} else if (stringValue == "suppressdrown") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DROWN;
		} else if (stringValue == "suppressphysical") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_BLEEDING;
		} else if (stringValue == "suppressfreeze") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_FREEZING;
		} else if (stringValue == "suppressdazzle") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_DAZZLED;
		} else if (stringValue == "suppresscurse") {
			itemType.getAbilities().conditionSuppressions |= CONDITION_CURSED;
		}
	}
}

std::tuple<ConditionId_t, ConditionType_t> ItemParse::parseFieldConditions(std::string lowerStringValue, pugi::xml_attribute valueAttribute) {
	lowerStringValue = asLowerCaseString(valueAttribute.as_string());
	ConditionId_t conditionId = CONDITIONID_COMBAT;
	ConditionType_t conditionType = CONDITION_NONE;
	if (lowerStringValue == "fire") {
		conditionType = CONDITION_FIRE;
		return std::make_tuple(conditionId, conditionType);
	} else if (lowerStringValue == "energy") {
		conditionType = CONDITION_ENERGY;
		return std::make_tuple(conditionId, conditionType);
	} else if (lowerStringValue == "poison") {
		conditionType = CONDITION_POISON;
		return std::make_tuple(conditionId, conditionType);
	} else if (lowerStringValue == "drown") {
		conditionType = CONDITION_DROWN;
		return std::make_tuple(conditionId, conditionType);
	} else if (lowerStringValue == "physical") {
		conditionType = CONDITION_BLEEDING;
		return std::make_tuple(conditionId, conditionType);
	} else {
		SPDLOG_WARN("[Items::parseItemNode] Unknown field value {}", valueAttribute.as_string());
	}
	return std::make_tuple(CONDITIONID_DEFAULT, CONDITION_NONE);
}

CombatType_t ItemParse::parseFieldCombatType(std::string lowerStringValue, pugi::xml_attribute valueAttribute) {
	lowerStringValue = asLowerCaseString(valueAttribute.as_string());
	if (lowerStringValue == "fire") {
		return COMBAT_FIREDAMAGE;
	} else if (lowerStringValue == "energy") {
		return COMBAT_ENERGYDAMAGE;
	} else if (lowerStringValue == "poison") {
		return COMBAT_EARTHDAMAGE;
	} else if (lowerStringValue == "drown") {
		return COMBAT_DROWNDAMAGE;
	} else if (lowerStringValue == "physical") {
		return COMBAT_PHYSICALDAMAGE;
	} else {
		SPDLOG_WARN("[Items::parseItemNode] Unknown field value {}", valueAttribute.as_string());
	}
	return COMBAT_NONE;
}

void ItemParse::parseFieldCombatDamage(ConditionDamage* conditionDamage, std::string stringValue, pugi::xml_node attributeNode) {
	uint32_t combatTicks = 0;
	int32_t combatDamage = 0;
	int32_t combatStart = 0;
	int32_t combatCount = 1;

	for (auto subAttributeNode : attributeNode.children()) {
		pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
		if (!subKeyAttribute) {
			continue;
		}

		pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
		if (!subValueAttribute) {
			continue;
		}

		stringValue = asLowerCaseString(subKeyAttribute.as_string());
		if (stringValue == "ticks") {
			combatTicks = pugi::cast<uint32_t>(subValueAttribute.value());
		} else if (stringValue == "count") {
			combatCount = std::max<int32_t>(1, pugi::cast<int32_t>(subValueAttribute.value()));
		} else if (stringValue == "start") {
			combatStart = std::max<int32_t>(0, pugi::cast<int32_t>(subValueAttribute.value()));
		} else if (stringValue == "damage") {
			combatDamage = -pugi::cast<int32_t>(subValueAttribute.value());
			if (combatStart == 0) {
				conditionDamage->addDamage(combatCount, combatTicks, combatDamage);
			}

			std::list<int32_t> damageList;
			ConditionDamage::generateDamageList(combatDamage, combatStart, damageList);
			for (int32_t damageValue : damageList) {
				conditionDamage->addDamage(1, combatTicks, -damageValue);
			}

			combatStart = 0;
		}
	}
}

void ItemParse::parseField(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue == "field") {
		CombatType_t combatType = COMBAT_NONE;
		ConditionDamage* conditionDamage = nullptr;

		// Parse fields conditions (fire/energy/poison/drown/physical)
		combatType = parseFieldCombatType(tmpStrValue, valueAttribute);
		auto [conditionId, conditionType] = parseFieldConditions(tmpStrValue, valueAttribute);

		if (combatType != COMBAT_NONE) {
			if (conditionDamage) {
				delete conditionDamage;
			}

			conditionDamage = new ConditionDamage(conditionId, conditionType);

			itemType.combatType = combatType;
			itemType.conditionDamage.reset(conditionDamage);

			parseFieldCombatDamage(conditionDamage, tmpStrValue, attributeNode);

			conditionDamage->setParam(CONDITION_PARAM_FIELD, 1);

			if (conditionDamage->getTotalDamage() > 0) {
				conditionDamage->setParam(CONDITION_PARAM_FORCEUPDATE, 1);
			}
		}
	}
}

void ItemParse::parseReplaceable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "replaceable") {
		itemType.replaceable = valueAttribute.as_bool();
	}
}

void ItemParse::parseLevelDoor(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "leveldoor") {
		itemType.levelDoor = pugi::cast<uint32_t>(valueAttribute.value());
	}
}

void ItemParse::parseBeds(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "partnerdirection") {
		itemType.bedPartnerDir = getDirection(valueAttribute.as_string());
	}

	if (stringValue == "maletransformto") {
		uint16_t valueMale = pugi::cast<uint16_t>(valueAttribute.value());
		ItemType &other = Item::items.getItemType(valueMale);
		itemType.transformToOnUse[PLAYERSEX_MALE] = valueMale;
		if (other.transformToFree == 0) {
			other.transformToFree = itemType.id;
		}

		if (itemType.transformToOnUse[PLAYERSEX_FEMALE] == 0) {
			itemType.transformToOnUse[PLAYERSEX_FEMALE] = valueMale;
		}
	} else if (stringValue == "femaletransformto") {
		uint16_t valueFemale = pugi::cast<uint16_t>(valueAttribute.value());
		ItemType &other = Item::items.getItemType(valueFemale);

		itemType.transformToOnUse[PLAYERSEX_FEMALE] = valueFemale;

		if (other.transformToFree == 0) {
			other.transformToFree = itemType.id;
		}

		if (itemType.transformToOnUse[PLAYERSEX_MALE] == 0) {
			itemType.transformToOnUse[PLAYERSEX_MALE] = valueFemale;
		}
	}
}

void ItemParse::parseElement(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "elementice") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ICEDAMAGE;
	} else if (stringValue == "elementearth") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_EARTHDAMAGE;
	} else if (stringValue == "elementfire") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_FIREDAMAGE;
	} else if (stringValue == "elementenergy") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ENERGYDAMAGE;
	} else if (stringValue == "elementdeath") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_DEATHDAMAGE;
	} else if (stringValue == "elementholy") {
		Abilities &abilities = itemType.getAbilities();
		abilities.elementDamage = pugi::cast<uint16_t>(valueAttribute.value());
		abilities.elementType = COMBAT_HOLYDAMAGE;
	}
}

void ItemParse::parseWalk(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "walkstack") {
		itemType.walkStack = valueAttribute.as_bool();
	} else if (stringValue == "blocking") {
		itemType.blockSolid = valueAttribute.as_bool();
	}
}

void ItemParse::parseAllowDistanceRead(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "allowdistread") {
		itemType.allowDistRead = booleanString(valueAttribute.as_string());
	}
}

void ItemParse::parseImbuement(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue != "imbuementslot") {
		return;
	}
	itemType.imbuementSlot = pugi::cast<uint8_t>(valueAttribute.value());

	for (auto subAttributeNode : attributeNode.children()) {
		pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
		if (!subKeyAttribute) {
			continue;
		}

		pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
		if (!subValueAttribute) {
			continue;
		}

		auto itemMap = ImbuementsTypeMap.find(asLowerCaseString(subKeyAttribute.as_string()));
		if (itemMap != ImbuementsTypeMap.end()) {
			ImbuementTypes_t imbuementType = getImbuementType(asLowerCaseString(subKeyAttribute.as_string()));
			if (imbuementType != IMBUEMENT_NONE) {
				itemType.setImbuementType(imbuementType, pugi::cast<uint16_t>(subValueAttribute.value()));
				continue;
			}
		} else {
			SPDLOG_WARN("[ParseImbuement::initParseImbuement] - Unknown type: {}", valueAttribute.as_string());
		}
	}
}
