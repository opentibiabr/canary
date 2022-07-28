/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "items/item.h"
#include "items/functions/item_read_map_attributes.hpp"
#include "game/game.h"
#include "io/iologindata.h"

Attr_ReadValue ItemReadMapAttributes::readAttributesMap(AttrTypes_t attr, Item &item, BinaryNode& binaryNode, Position position)
{
	switch (attr) {
	case ATTR_COUNT:
		if (!readAttributeCount(binaryNode, item, position)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read count attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_RUNE_CHARGES:
		if (!readAttributeRuneCharge(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read rune charge attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}

		break;
	case ATTR_ACTION_ID:
		if (!readAttributeActionId(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read action id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_UNIQUE_ID:
		if (!readAttributeUniqueId(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read unique id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_TEXT:
		if (!readAttributeText(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read text attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WRITTENDATE:
		if (!readAttributeWrittenDate(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read written date attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WRITTENBY:
		if (!readAttributeWrittenBy(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read written by attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DESC:
		if (!readAttributeDescription(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read description attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_CHARGES:
		if (!readAttributeCharge(binaryNode, item, position)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read charge attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DURATION:
		if (!readAttributeDuration(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read duration attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DECAYING_STATE:
		if (!readAttributeDecayingState(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read decaying state attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_NAME:
		if (!readAttributeName(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read name attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ARTICLE:
		if (!readAttributeArticle(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read article attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_PLURALNAME:
		if (!readAttributePluralName(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read plural name attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WEIGHT:
		if (!readAttributeWeight(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read weight attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ATTACK:
		if (!readAttributeAttack(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read attack attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DEFENSE:
		if (!readAttributeDefense(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read defense attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_EXTRADEFENSE:
		if (!readAttributeExtraDefense(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read extra defense attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_IMBUEMENT_SLOT:
		if (!readAttributeImbuementSlot(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read imbuement slot attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_OPENCONTAINER:
		if (!readAttributeOpenContainer(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read open container attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ARMOR:
		if (!readAttributeArmor(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read armor attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_HITCHANCE:
		if (!readAttributeHitChance(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read hit chance attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SHOOTRANGE:
		if (!readAttributeShootRange(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read shoot range attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SPECIAL:
		if (!readAttributeSpecial(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read special attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_QUICKLOOTCONTAINER:
		if (!readAttributeQuicklootContainer(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read quickloot container attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DEPOT_ID:
		if (!readAttributeDepotId(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read depot id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_HOUSEDOORID:
		if (!readAttributeHouseDoorId(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read house door id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SLEEPERGUID:
		if (!readAttributeSleeperGuid(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read sleeper guid attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SLEEPSTART:
		if (!readAttributeSleepStart(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read sleeper start attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_TELE_DEST:
		if (!readAttributeTeleportDestination(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read teleport destination attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_CONTAINER_ITEMS:
		if (!readAttributeContainerItems(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read container items attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}

		break;
	case ATTR_CUSTOM_ATTRIBUTES:
		if (!readAttributeCustomAttributes(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read custom attributes for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_IMBUEMENT_TYPE:
		if (!readAttributeImbuementType(binaryNode, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read imbuement type attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	default:
		return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

bool ItemReadMapAttributes::readAttributeCount(BinaryNode& binaryNode, Item &item, Position position) {
	uint8_t attrItemCount = binaryNode.getU8();
	if (attrItemCount == 0 || attrItemCount == -1) {
		attrItemCount = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid count, setting count to 1", getID(), position.toString());
	}

	item.setItemCount(attrItemCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeRuneCharge(BinaryNode& binaryNode, Item &item) {
	uint8_t charges = binaryNode.getU8();
	if (charges == 0) {
		return false;
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeActionId(BinaryNode& binaryNode, Item &item) {
	uint16_t actionId = binaryNode.getU16();
	if (actionId == 0) {
		return false;
	}

	item.setActionId(actionId);
	return true;
}

bool ItemReadMapAttributes::readAttributeUniqueId(BinaryNode& binaryNode, Item &item) {
	uint16_t uniqueId = binaryNode.getU16();
	if (uniqueId == 0) {
		return false;
	}

	item.setUniqueId(uniqueId);
	return true;
}

bool ItemReadMapAttributes::readAttributeText(BinaryNode& binaryNode, Item &item) {
	std::string text = binaryNode.getString();
	if (text.empty()) {
		return false;
	}

	item.setText(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenDate(BinaryNode& binaryNode, Item &item) {
	uint32_t writtenDate = binaryNode.getU32();
	if (writtenDate == 0) {
		return false;
	}

	item.setDate(writtenDate);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenBy(BinaryNode& binaryNode, Item &item) {
	std::string writer = binaryNode.getString();
	if (writer.empty()) {
		return false;
	}

	item.setWriter(writer);
	return true;
}

bool ItemReadMapAttributes::readAttributeDescription(BinaryNode& binaryNode, Item &item) {
	std::string text = binaryNode.getString();
	if (text.empty()) {
		return false;
	}

	item.setSpecialDescription(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeCharge(BinaryNode& binaryNode, Item &item, Position position) {
	uint16_t charges = binaryNode.getU16();
	// If item not have charges, then set to 1 and send warning
	if (charges == 0 || charges == -1) {
		charges = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid charges, setting charge to 1", getID(), position.toString());
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeDuration(BinaryNode& binaryNode, Item &item) {
	int32_t duration = binaryNode.getU32();
	if (duration == 0) {
		return false;
	}

	item.setDuration(duration);
	return true;
}

bool ItemReadMapAttributes::readAttributeDecayingState(BinaryNode& binaryNode, Item &item) {
	uint8_t state = binaryNode.getU8();
	if (state == 0) {
		return false;
	}

	if (state != DECAYING_FALSE) {
		item.setDecaying(DECAYING_PENDING);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeName(BinaryNode& binaryNode, Item &item) {
	std::string name = binaryNode.getString();
	if (name.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_NAME, name);
	return true;
}

bool ItemReadMapAttributes::readAttributeArticle(BinaryNode& binaryNode, Item &item) {
	std::string article = binaryNode.getString();
	if (article.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_ARTICLE, article);
	return true;
}

bool ItemReadMapAttributes::readAttributePluralName(BinaryNode& binaryNode, Item &item) {
	std::string pluralName = binaryNode.getString();
	if (pluralName.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_PLURALNAME, pluralName);
	return true;
}

bool ItemReadMapAttributes::readAttributeWeight(BinaryNode& binaryNode, Item &item) {
	uint32_t weight = binaryNode.getU32();
	if (weight == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_WEIGHT, weight);
	return true;
}

bool ItemReadMapAttributes::readAttributeAttack(BinaryNode& binaryNode, Item &item) {
	int32_t attack = binaryNode.getU32();
	if (attack == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ATTACK, attack);
	return true;
}

bool ItemReadMapAttributes::readAttributeDefense(BinaryNode& binaryNode, Item &item) {
	int32_t defense = binaryNode.getU32();
	if (defense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_DEFENSE, defense);
	return true;
}

bool ItemReadMapAttributes::readAttributeExtraDefense(BinaryNode& binaryNode, Item &item) {
	int32_t extraDefense = binaryNode.getU32();
	if (extraDefense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE, extraDefense);
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementSlot(BinaryNode& binaryNode, Item &item) {
	int32_t imbuementSlot = binaryNode.getU32();
	if (imbuementSlot == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_IMBUEMENT_SLOT, imbuementSlot);
	return true;
}

bool ItemReadMapAttributes::readAttributeOpenContainer(BinaryNode& binaryNode, Item &item) {
	uint8_t openContainer = binaryNode.getU8();
	if (openContainer == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, openContainer);
	return true;
}

bool ItemReadMapAttributes::readAttributeArmor(BinaryNode& binaryNode, Item &item) {
	int32_t armor = binaryNode.getU32();
	if (armor == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ARMOR, armor);
	return true;
}

bool ItemReadMapAttributes::readAttributeHitChance(BinaryNode& binaryNode, Item &item) {
	int8_t hitChance = binaryNode.getU8();
	if (hitChance == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_HITCHANCE, hitChance);
	return true;
}

bool ItemReadMapAttributes::readAttributeShootRange(BinaryNode& binaryNode, Item &item) {
	uint8_t shootRange = binaryNode.getU8();
	if (shootRange == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE, shootRange);
	return true;
}

bool ItemReadMapAttributes::readAttributeSpecial(BinaryNode& binaryNode, Item &item) {
	std::string special = binaryNode.getString();
	if (special.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_SPECIAL, special);
	return true;
}

bool ItemReadMapAttributes::readAttributeQuicklootContainer(BinaryNode& binaryNode, Item &item) {
	uint32_t flags = binaryNode.getU32();
	if (flags == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags);
	return true;
}

bool ItemReadMapAttributes::readAttributeDepotId(BinaryNode& binaryNode, Item &item) {
	uint16_t attrDepotId = binaryNode.getU16();
	if (attrDepotId == 0) {
		return false;
	}

	item.setDepotId(attrDepotId);
	return true;
}

bool ItemReadMapAttributes::readAttributeHouseDoorId(BinaryNode& binaryNode, Item &item) {
	uint8_t attrDoorId = binaryNode.getU8();
	if (attrDoorId == 0) {
		return false;
	}

	item.setDoorId(attrDoorId);
	return true;
}

bool ItemReadMapAttributes::readAttributeSleeperGuid(BinaryNode& binaryNode, Item &item) {
	uint32_t guid = binaryNode.getU32();
	if (guid == 0) {
		return false;
	}

	std::string name = IOLoginData::getNameByGuid(guid);
	if (name.empty()) {
		SPDLOG_ERROR("[ItemReadMapAttributes::readAttributeSleeperGuid] - Sleeper name is wrong");
		return false;
	}

	item.setSpecialDescription(name + " is sleeping there.");
	g_game().setBedSleeper(item.getBed(), guid);
	item.setSleeperGuid(guid);
	return true;
}

bool ItemReadMapAttributes::readAttributeSleepStart(BinaryNode& binaryNode, Item &item) {
	uint32_t attrSleepStart = binaryNode.getU32();
	if (attrSleepStart == 0) {
		return false;
	}

	item.setSleepStart(attrSleepStart);
	return true;
}

bool ItemReadMapAttributes::readAttributeTeleportDestination(BinaryNode& binaryNode, Item &item) {
	uint16_t x = binaryNode.getU16();
	uint16_t y = binaryNode.getU16();
	uint8_t z = binaryNode.getU8();
	Position newPosition(x, y, z);
	if (x == 0 || y == 0 || z == 0) {
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have empty destination", getID(), newPosition.toString());
	}

	item.setDestination(newPosition);
	return true;
}

bool ItemReadMapAttributes::readAttributeContainerItems(BinaryNode& binaryNode, Item &item) {
	uint32_t attrSerializationCount = binaryNode.getU32();
	if (attrSerializationCount == 0) {
		return false;
	}

	item.setSerializationCount(attrSerializationCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeCustomAttributes(BinaryNode& binaryNode, Item &item) {
	uint64_t size = binaryNode.getU64();
	if (size == 0) {
		return false;
	}

	for (uint64_t i = 0; i < size; i++) {
		// Unserialize key type and value
		std::string key = binaryNode.getString();
		if (key.empty()) {
		return false;
		}

		// TODO: Finalize implement this
		//Unserialize value type and value
		ItemAttributes::CustomAttribute attribute;
		if (!attribute.unserialize(binaryNode)) {
			return false;
		}

		item.setCustomAttribute(key, attribute);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementType(BinaryNode& binaryNode, Item &item) {
	std::string imbuementType = binaryNode.getString();
	if (imbuementType.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_IMBUEMENT_TYPE, imbuementType);
	return true;
}
