/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "items/functions/item/item_parse.hpp"
#include "items/weapons/weapons.hpp"
#include "lua/creature/movement.hpp"
#include "utils/pugicast.hpp"
#include "creatures/combat/combat.hpp"

void ItemParse::initParse(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	// Parse all item attributes
	ItemParse::parseType(tmpStrValue, attributeNode, valueAttribute, itemType);
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
	ItemParse::parseMovable(tmpStrValue, valueAttribute, itemType);
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
	ItemParse::parseMagicLevelPoint(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseFieldAbsorbPercent(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAbsorbPercent(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSupressDrunk(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseField(tmpStrValue, attributeNode, valueAttribute, itemType);
	ItemParse::parseReplaceable(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseLevelDoor(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseBeds(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseElement(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseWalk(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseAllowDistanceRead(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseImbuement(tmpStrValue, attributeNode, valueAttribute, itemType);
	ItemParse::parseStackSize(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseSpecializedMagicLevelPoint(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseMagicShieldCapacity(tmpStrValue, valueAttribute, itemType);
	ItemParse::parsePerfecShot(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseCleavePercent(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseReflectDamage(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseTransformOnUse(tmpStrValue, valueAttribute, itemType);
	ItemParse::parsePrimaryType(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseHouseRelated(tmpStrValue, valueAttribute, itemType);
	ItemParse::parseUnscriptedItems(tmpStrValue, attributeNode, valueAttribute, itemType);
}

void ItemParse::parseDummyRate(pugi::xml_node attributeNode, ItemType &itemType) {
	for (auto subAttributeNode : attributeNode.children()) {
		pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
		if (!subKeyAttribute) {
			continue;
		}

		pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
		if (!subValueAttribute) {
			continue;
		}

		auto stringValue = asLowerCaseString(subKeyAttribute.as_string());
		if (stringValue == "rate") {
			uint16_t rate = subValueAttribute.as_uint();
			Item::items.addDummyId(itemType.id, rate);
		}
	}
}

void ItemParse::parseType(const std::string &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "type") {
		stringValue = asLowerCaseString(valueAttribute.as_string());
		auto itemMap = ItemTypesMap.find(stringValue);
		if (itemMap != ItemTypesMap.end()) {
			itemType.type = itemMap->second;
			if (itemType.type == ITEM_TYPE_CONTAINER) {
				itemType.group = ITEM_GROUP_CONTAINER;
			}
			if (itemType.type == ITEM_TYPE_LADDER) {
				Item::items.addLadderId(itemType.id);
			}
			if (itemType.type == ITEM_TYPE_DUMMY) {
				parseDummyRate(attributeNode, itemType);
			}
		} else {
			g_logger().warn("[Items::parseItemNode] - Unknown type: {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseDescription(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "description") {
		itemType.description = valueAttribute.as_string();
		if (g_configManager().getBoolean(TOGGLE_GOLD_POUCH_QUICKLOOT_ONLY, __FUNCTION__) && itemType.id == ITEM_GOLD_POUCH) {
			auto pouchLimit = g_configManager().getNumber(LOOTPOUCH_MAXLIMIT, __FUNCTION__);
			itemType.description = fmt::format("A bag with {} slots where you can hold your loots.", pouchLimit);
			itemType.name = "loot pouch";
		}
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

void ItemParse::parseMovable(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "movable") {
		itemType.movable = valueAttribute.as_bool();
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
			g_logger().warn("[ItemParse::parseFloorChange] - Unknown floorChange {}", valueAttribute.as_string());
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
			g_logger().warn("[Items::parseItemNode] - Unknown fluidSource {}", valueAttribute.as_string());
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
			if (tmpStrValue == "spellbook") {
				itemType.spellbook = true;
			}
			itemType.weaponType = itemMap->second;
		} else {
			g_logger().warn("[Items::parseItemNode] - Unknown weaponType {}", valueAttribute.as_string());
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
			g_logger().warn("[itemParseSlotType - Items::parseItemNode] - Unknown slotType {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseAmmoType(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "ammotype") {
		itemType.ammoType = getAmmoType(asLowerCaseString(valueAttribute.as_string()));
		if (itemType.ammoType == AMMO_NONE) {
			g_logger().warn("[Items::parseItemNode] - Unknown ammoType {}", valueAttribute.as_string());
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
			g_logger().warn("[Items::parseItemNode] - Unknown shootType {}", valueAttribute.as_string());
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
			g_logger().warn("[Items::parseItemNode] - Unknown effect {}", valueAttribute.as_string());
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
		if (itemType.transformEquipTo == itemType.decayTo) {
			g_logger().warn("[{}] item with id {} is transforming on equip to the same id of decay to '{}'", __FUNCTION__, itemType.id, itemType.decayTo);
			itemType.decayTo = 0;
		}
		if (ItemType &transform = Item::items.getItemType(itemType.transformEquipTo);
			transform.type == ITEM_TYPE_NONE) {
			transform.type = itemType.type;
		}
	} else if (stringValue == "transformdeequipto") {
		if (itemType.transformDeEquipTo == itemType.decayTo) {
			g_logger().warn("[{}] item with id {} is transforming on de-equip to the same id of decay to '{}'", __FUNCTION__, itemType.id, itemType.decayTo);
			itemType.decayTo = 0;
		}

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

void ItemParse::parseMagicLevelPoint(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "magiclevelpoints" || stringValue == "magicpoints") {
		itemType.getAbilities().stats[STAT_MAGICPOINTS] = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "magiclevelpointspercent") {
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
	} else if (stringValue == "absorbpercentpoison" || stringValue == "absorbpercentearth") {
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

void ItemParse::parseSupressDrunk(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (valueAttribute.as_bool()) {
		ConditionType_t conditionType = CONDITION_NONE;
		if (stringValue == "suppressdrunk") {
			conditionType = CONDITION_DRUNK;
		} else if (stringValue == "suppressenergy") {
			conditionType = CONDITION_ENERGY;
		} else if (stringValue == "suppressfire") {
			conditionType = CONDITION_FIRE;
		} else if (stringValue == "suppresspoison") {
			conditionType = CONDITION_POISON;
		} else if (stringValue == "suppressdrown") {
			conditionType = CONDITION_DROWN;
		} else if (stringValue == "suppressphysical") {
			conditionType = CONDITION_BLEEDING;
		} else if (stringValue == "suppressfreeze") {
			conditionType = CONDITION_FREEZING;
		} else if (stringValue == "suppressdazzle") {
			conditionType = CONDITION_DAZZLED;
		} else if (stringValue == "suppresscurse") {
			conditionType = CONDITION_CURSED;
		}

		itemType.getAbilities().conditionSuppressions[conditionType] = conditionType;
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
		g_logger().warn("[Items::parseItemNode] Unknown field value {}", valueAttribute.as_string());
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
		g_logger().warn("[Items::parseItemNode] Unknown field value {}", valueAttribute.as_string());
	}
	return COMBAT_NONE;
}

void ItemParse::parseFieldCombatDamage(std::shared_ptr<ConditionDamage> conditionDamage, std::string stringValue, pugi::xml_node attributeNode) {
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
		std::shared_ptr<ConditionDamage> conditionDamage = nullptr;

		// Parse fields conditions (fire/energy/poison/drown/physical)
		combatType = parseFieldCombatType(tmpStrValue, valueAttribute);
		auto [conditionId, conditionType] = parseFieldConditions(tmpStrValue, valueAttribute);

		if (combatType != COMBAT_NONE) {
			if (conditionDamage) {
			}

			conditionDamage = std::make_shared<ConditionDamage>(conditionId, conditionType);

			itemType.combatType = combatType;
			itemType.conditionDamage = conditionDamage;

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

	if (stringValue == "bedpart") {
		itemType.bedPart = getBedPart(valueAttribute.as_string());
	} else if (stringValue == "bedpartof") {
		itemType.bedPartOf = pugi::cast<uint16_t>(valueAttribute.value());
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
			g_logger().warn("[ParseImbuement::initParseImbuement] - Unknown type: {}", valueAttribute.as_string());
		}
	}
}

void ItemParse::parseStackSize(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "stacksize") {
		auto stackSize = pugi::cast<uint16_t>(valueAttribute.value());
		if (stackSize > 255) {
			stackSize = 255;
			g_logger().warn("[{}] Invalid stack size value: {}. Stack size must be between 1 and 255.", __FUNCTION__, stackSize);
		}
		itemType.stackSize = static_cast<uint8_t>(stackSize);
	}
}

void ItemParse::parseSpecializedMagicLevelPoint(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	Abilities &abilities = itemType.getAbilities();
	if (stringValue == "deathmagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_DEATHDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_DEATHDAMAGE;
	} else if (stringValue == "energymagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_ENERGYDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ENERGYDAMAGE;
	} else if (stringValue == "earthmagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_EARTHDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_EARTHDAMAGE;
	} else if (stringValue == "firemagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_FIREDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_FIREDAMAGE;
	} else if (stringValue == "healingmagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_HEALING)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_HEALING;
	} else if (stringValue == "holymagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_HOLYDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_HOLYDAMAGE;
	} else if (stringValue == "icemagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_ICEDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_ICEDAMAGE;
	} else if (stringValue == "physicalmagiclevelpoints") {
		abilities.specializedMagicLevel[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
		abilities.elementType = COMBAT_PHYSICALDAMAGE;
	}
}

void ItemParse::parseMagicShieldCapacity(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	Abilities &abilities = itemType.getAbilities();
	if (stringValue == "magicshieldcapacitypercent") {
		abilities.magicShieldCapacityPercent += pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "magicshieldcapacityflat") {
		abilities.magicShieldCapacityFlat += pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parsePerfecShot(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	Abilities &abilities = itemType.getAbilities();
	if (stringValue == "perfectshotdamage") {
		abilities.perfectShotDamage = pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "perfectshotrange") {
		abilities.perfectShotRange = pugi::cast<int16_t>(valueAttribute.value());
	}
}

void ItemParse::parseCleavePercent(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	Abilities &abilities = itemType.getAbilities();
	if (stringValue == "cleavepercent") {
		abilities.cleavePercent += pugi::cast<int32_t>(valueAttribute.value());
	}
}

void ItemParse::parseReflectDamage(const std::string &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	std::string stringValue = tmpStrValue;
	Abilities &abilities = itemType.getAbilities();
	if (stringValue == "reflectdamage") {
		abilities.reflectFlat[combatTypeToIndex(COMBAT_PHYSICALDAMAGE)] += pugi::cast<int32_t>(valueAttribute.value());
	} else if (stringValue == "reflectpercentall") {
		int32_t value = pugi::cast<int32_t>(valueAttribute.value());
		std::transform(std::begin(abilities.reflectPercent), std::end(abilities.reflectPercent), std::begin(abilities.reflectPercent), [&](const auto &i) {
			return i + value;
		});
	}
}

void ItemParse::parseTransformOnUse(const std::string_view &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue == "transformonuse") {
		itemType.m_transformOnUse = pugi::cast<uint16_t>(valueAttribute.value());
	}
}

void ItemParse::parsePrimaryType(const std::string_view &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue == "primarytype") {
		itemType.m_primaryType = asLowerCaseString(valueAttribute.as_string());
	}
}

void ItemParse::parseHouseRelated(const std::string_view &tmpStrValue, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue == "usedbyhouseguests") {
		g_logger().debug("[{}] item {}, used by guests {}", __FUNCTION__, itemType.id, valueAttribute.as_bool());
		itemType.m_canBeUsedByGuests = valueAttribute.as_bool();
	}
}

void ItemParse::createAndRegisterScript(ItemType &itemType, pugi::xml_node attributeNode, MoveEvent_t eventType /*= MOVE_EVENT_NONE*/, WeaponType_t weaponType /*= WEAPON_NONE*/) {
	std::shared_ptr<MoveEvent> moveevent;
	if (eventType != MOVE_EVENT_NONE) {
		moveevent = std::make_shared<MoveEvent>(&g_moveEvents().getScriptInterface());
		moveevent->setItemId(itemType.id);
		moveevent->setEventType(eventType);
		moveevent->setFromXML(true);

		if (eventType == MOVE_EVENT_EQUIP) {
			moveevent->equipFunction = moveevent->EquipItem;
		} else if (eventType == MOVE_EVENT_DEEQUIP) {
			moveevent->equipFunction = moveevent->DeEquipItem;
		} else if (eventType == MOVE_EVENT_STEP_IN) {
			moveevent->stepFunction = moveevent->StepInField;
		} else if (eventType == MOVE_EVENT_STEP_OUT) {
			moveevent->stepFunction = moveevent->StepOutField;
		} else if (eventType == MOVE_EVENT_ADD_ITEM_ITEMTILE) {
			moveevent->moveFunction = moveevent->AddItemField;
		} else if (eventType == MOVE_EVENT_REMOVE_ITEM) {
			moveevent->moveFunction = moveevent->RemoveItemField;
		}
	}

	std::shared_ptr<Weapon> weapon = nullptr;
	if (weaponType != WEAPON_NONE) {
		if (weaponType == WEAPON_DISTANCE || weaponType == WEAPON_AMMO || weaponType == WEAPON_MISSILE) {
			weapon = std::make_shared<WeaponDistance>(&g_weapons().getScriptInterface());
		} else if (weaponType == WEAPON_WAND) {
			weapon = std::make_shared<WeaponWand>(&g_weapons().getScriptInterface());
		} else {
			weapon = std::make_shared<WeaponMelee>(&g_weapons().getScriptInterface());
		}

		weapon->weaponType = weaponType;
		itemType.weaponType = weapon->weaponType;
		weapon->configureWeapon(itemType);
		g_logger().trace("Created weapon with type '{}'", getWeaponName(weaponType));
	}
	uint32_t fromDamage = 0;
	uint32_t toDamage = 0;
	for (auto subAttributeNode : attributeNode.children()) {
		pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
		if (!subKeyAttribute) {
			continue;
		}

		pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
		if (!subValueAttribute) {
			continue;
		}

		auto stringKey = asLowerCaseString(subKeyAttribute.as_string());
		if (stringKey == "slot") {
			auto slotName = asLowerCaseString(subValueAttribute.as_string());
			if (moveevent && (moveevent->getEventType() == MOVE_EVENT_EQUIP || moveevent->getEventType() == MOVE_EVENT_DEEQUIP)) {
				if (slotName == "head") {
					moveevent->setSlot(SLOTP_HEAD);
				} else if (slotName == "necklace") {
					moveevent->setSlot(SLOTP_NECKLACE);
				} else if (slotName == "backpack") {
					moveevent->setSlot(SLOTP_BACKPACK);
				} else if (slotName == "armor" || slotName == "body") {
					moveevent->setSlot(SLOTP_ARMOR);
				} else if (slotName == "right-hand") {
					moveevent->setSlot(SLOTP_RIGHT);
				} else if (slotName == "left-hand") {
					moveevent->setSlot(SLOTP_LEFT);
				} else if (slotName == "hand" || slotName == "shield") {
					moveevent->setSlot(SLOTP_RIGHT | SLOTP_LEFT);
				} else if (slotName == "legs") {
					moveevent->setSlot(SLOTP_LEGS);
				} else if (slotName == "feet") {
					moveevent->setSlot(SLOTP_FEET);
				} else if (slotName == "ring") {
					moveevent->setSlot(SLOTP_RING);
				} else if (slotName == "ammo") {
					moveevent->setSlot(SLOTP_AMMO);
				} else if (slotName == "two-handed") {
					moveevent->setSlot(SLOTP_TWO_HAND);
				} else {
					g_logger().warn("[{}] unknown slot type '{}'", __FUNCTION__, slotName);
				}
			} else if (weapon) {
				uint16_t id = weapon->getID();
				ItemType &it = Item::items.getItemType(id);
				if (slotName == "two-handed") {
					it.slotPosition = SLOTP_TWO_HAND;
				} else {
					it.slotPosition = SLOTP_HAND;
				}
			}
		} else if (stringKey == "level") {
			auto numberValue = subValueAttribute.as_uint();
			if (moveevent) {
				g_logger().trace("Added required moveevent level '{}'", numberValue);
				moveevent->setRequiredLevel(numberValue);
				moveevent->setWieldInfo(WIELDINFO_LEVEL);
			} else if (weapon) {
				g_logger().trace("Added required weapon level '{}'", numberValue);
				weapon->setRequiredLevel(numberValue);
				weapon->setWieldInfo(WIELDINFO_LEVEL);
			}
		} else if (stringKey == "vocation") {
			auto vocations = subValueAttribute.as_string();
			std::string tmp;
			std::stringstream ss(vocations);
			std::string token;

			while (std::getline(ss, token, ',')) {
				token.erase(token.begin(), std::find_if(token.begin(), token.end(), [](unsigned char ch) {
								return !std::isspace(ch);
							}));
				token.erase(std::find_if(token.rbegin(), token.rend(), [](unsigned char ch) {
								return !std::isspace(ch);
							}).base(),
							token.end());

				std::string v1;
				bool showInDescription = false;

				std::stringstream inner_ss(token);
				std::getline(inner_ss, v1, ';');
				std::string showInDescriptionStr;
				std::getline(inner_ss, showInDescriptionStr, ';');
				showInDescription = showInDescriptionStr == "true";

				if (moveevent) {
					moveevent->addVocEquipMap(v1);
					moveevent->setWieldInfo(WIELDINFO_VOCREQ);
				}

				if (showInDescription) {
					if (moveevent && moveevent->getVocationString().empty()) {
						tmp = asLowerCaseString(v1);
						tmp += "s";
						moveevent->setVocationString(tmp);
					} else if (weapon && weapon->getVocationString().empty()) {
						tmp = asLowerCaseString(v1);
						tmp += "s";
						weapon->setVocationString(tmp);
					} else {
						tmp += ", ";
						tmp += asLowerCaseString(v1);
						tmp += "s";
					}
				}
			}

			size_t lastComma = tmp.rfind(',');
			if (lastComma != std::string::npos) {
				tmp.replace(lastComma, 1, " and");
				if (moveevent) {
					moveevent->setVocationString(tmp);
				} else if (weapon) {
					weapon->setVocationString(tmp);
				}
			}
		} else if (stringKey == "action" && weapon) {
			auto action = asLowerCaseString(subValueAttribute.as_string());
			if (action == "removecharge") {
				weapon->action = WEAPONACTION_REMOVECHARGE;
			} else if (action == "removecount") {
				weapon->action = WEAPONACTION_REMOVECOUNT;
			} else if (action == "move") {
				weapon->action = WEAPONACTION_MOVE;
			}
		} else if (stringKey == "breakchance" && weapon) {
			weapon->setBreakChance(subValueAttribute.as_uint());
		} else if (stringKey == "mana" && weapon) {
			weapon->setMana(subValueAttribute.as_uint());
		} else if (stringKey == "unproperly" && weapon) {
			weapon->setWieldUnproperly(subValueAttribute.as_bool());
		} else if (stringKey == "fromdamage" && weapon) {
			fromDamage = subValueAttribute.as_uint();
		} else if (stringKey == "todamage" && weapon) {
			toDamage = subValueAttribute.as_uint();
		} else if (stringKey == "wandtype" && weapon) {
			std::string elementName = asLowerCaseString(subValueAttribute.as_string());
			if (elementName == "earth") {
				weapon->params.combatType = COMBAT_EARTHDAMAGE;
			} else if (elementName == "ice") {
				weapon->params.combatType = COMBAT_ICEDAMAGE;
			} else if (elementName == "energy") {
				weapon->params.combatType = COMBAT_ENERGYDAMAGE;
			} else if (elementName == "fire") {
				weapon->params.combatType = COMBAT_FIREDAMAGE;
			} else if (elementName == "death") {
				weapon->params.combatType = COMBAT_DEATHDAMAGE;
			} else if (elementName == "holy") {
				weapon->params.combatType = COMBAT_HOLYDAMAGE;
			} else {
				g_logger().warn("[{}] - wandtype '{}' does not exist", __FUNCTION__, elementName);
			}

		} else if (stringKey == "chain" && weapon) {
			auto doubleValue = subValueAttribute.as_double();
			if (doubleValue > 0) {
				weapon->setChainSkillValue(doubleValue);
				g_logger().trace("Found chain skill value '{}' for weapon: {}", doubleValue, itemType.name);
			}
			if (doubleValue < 0.1 && subValueAttribute.as_bool() == false) {
				weapon->setDisabledChain();
				g_logger().trace("Chain disabled for weapon: {}", itemType.name);
			}
		}
	}

	if (weapon) {
		if (auto weaponWand = dynamic_pointer_cast<WeaponWand>(weapon)) {
			g_logger().trace("Added weapon damage from '{}', to '{}'", fromDamage, toDamage);
			weaponWand->setMinChange(fromDamage);
			weaponWand->setMaxChange(toDamage);
			weaponWand->configureWeapon(itemType);
		}

		auto combat = weapon->getCombat();
		if (combat) {
			combat->setupChain(weapon);
		}

		if (weapon->getWieldInfo() != 0) {
			itemType.wieldInfo = weapon->getWieldInfo();
			itemType.vocationString = weapon->getVocationString();
			itemType.minReqLevel = weapon->getReqLevel();
			itemType.minReqMagicLevel = weapon->getReqMagLv();
		}

		if (!g_weapons().registerLuaEvent(weapon, true)) {
			g_logger().error("[{}] failed to register weapon from item name {}", __FUNCTION__, itemType.name);
		}
	}

	if (moveevent && !g_moveEvents().registerLuaItemEvent(moveevent)) {
		g_logger().error("[{}] failed to register moveevent from item name {}", __FUNCTION__, itemType.name);
	}
}

void ItemParse::parseUnscriptedItems(const std::string_view &tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute valueAttribute, ItemType &itemType) {
	if (tmpStrValue == "script") {
		std::string scriptName = valueAttribute.as_string();
		auto tokens = split(scriptName.data(), ';');
		for (const auto &token : tokens) {
			if (token == "moveevent") {
				g_logger().trace("Registering moveevent for item id '{}', name '{}'", itemType.id, itemType.name);
				MoveEvent_t eventType = MOVE_EVENT_NONE;
				for (auto subAttributeNode : attributeNode.children()) {
					pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
					if (!subKeyAttribute) {
						continue;
					}

					pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
					if (!subValueAttribute) {
						continue;
					}

					auto stringKey = asLowerCaseString(subKeyAttribute.as_string());
					if (stringKey == "eventtype") {
						const auto &eventTypeName = asLowerCaseString(subValueAttribute.as_string());
						eventType = getMoveEventType(eventTypeName);
						g_logger().trace("Found event type '{}'", eventTypeName);
						break;
					}
				}

				// Event type stepin/out need to be registered both at same time
				if (eventType == MOVE_EVENT_NONE) {
					createAndRegisterScript(itemType, attributeNode, MOVE_EVENT_EQUIP);
					createAndRegisterScript(itemType, attributeNode, MOVE_EVENT_DEEQUIP);
				} else {
					createAndRegisterScript(itemType, attributeNode, eventType);
				}
			} else if (token == "weapon") {
				WeaponType_t weaponType;
				g_logger().trace("Registering weapon for item id '{}', name '{}'", itemType.id, itemType.name);
				for (auto subAttributeNode : attributeNode.children()) {
					pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
					if (!subKeyAttribute) {
						continue;
					}

					pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
					if (!subValueAttribute) {
						continue;
					}

					auto stringKey = asLowerCaseString(subKeyAttribute.as_string());
					if (stringKey == "weapontype") {
						weaponType = getWeaponType(subValueAttribute.as_string());
						g_logger().trace("Found weapon type '{}''", subValueAttribute.as_string());
						break;
					}
				}

				createAndRegisterScript(itemType, attributeNode, MOVE_EVENT_NONE, weaponType);
			}
		}
	}
}
