/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/item.h"
#include "items/functions/item_read_map_attributes.hpp"
#include "game/game.h"
#include "io/iologindata.h"

class PropStream;

Attr_ReadValue ItemReadMapAttributes::readAttributesMap(AttrTypes_t attr, Item &item, PropStream& propStream, Position position)
{
	switch (attr) {
	case ATTR_COUNT:
		if (!readAttributeCount(propStream, item, position)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read count attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_RUNE_CHARGES:
		if (!readAttributeRuneCharge(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read rune charge attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}

		break;
	case ATTR_ACTION_ID:
		if (!readAttributeActionId(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read action id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_UNIQUE_ID:
		if (!readAttributeUniqueId(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read unique id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_TEXT:
		if (!readAttributeText(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read text attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WRITTENDATE:
		if (!readAttributeWrittenDate(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read written date attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WRITTENBY:
		if (!readAttributeWrittenBy(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read written by attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DESC:
		if (!readAttributeDescription(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read description attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_CHARGES:
		if (!readAttributeCharge(propStream, item, position)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read charge attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DURATION:
		if (!readAttributeDuration(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read duration attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DECAYING_STATE:
		if (!readAttributeDecayingState(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read decaying state attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_NAME:
		if (!readAttributeName(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read name attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ARTICLE:
		if (!readAttributeArticle(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read article attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_PLURALNAME:
		if (!readAttributePluralName(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read plural name attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_WEIGHT:
		if (!readAttributeWeight(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read weight attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ATTACK:
		if (!readAttributeAttack(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read attack attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DEFENSE:
		if (!readAttributeDefense(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read defense attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_EXTRADEFENSE:
		if (!readAttributeExtraDefense(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read extra defense attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_IMBUEMENT_SLOT:
		if (!readAttributeImbuementSlot(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read imbuement slot attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_OPENCONTAINER:
		if (!readAttributeOpenContainer(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read open container attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_ARMOR:
		if (!readAttributeArmor(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read armor attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_HITCHANCE:
		if (!readAttributeHitChance(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read hit chance attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SHOOTRANGE:
		if (!readAttributeShootRange(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read shoot range attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SPECIAL:
		if (!readAttributeSpecial(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read special attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_QUICKLOOTCONTAINER:
		if (!readAttributeQuicklootContainer(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read quickloot container attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_DEPOT_ID:
		if (!readAttributeDepotId(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read depot id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_HOUSEDOORID:
		if (!readAttributeHouseDoorId(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read house door id attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SLEEPERGUID:
		if (!readAttributeSleeperGuid(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read sleeper guid attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_SLEEPSTART:
		if (!readAttributeSleepStart(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read sleeper start attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_TELE_DEST:
		if (!readAttributeTeleportDestination(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read teleport destination attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_CONTAINER_ITEMS:
		if (!readAttributeContainerItems(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read container items attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}

		break;
	case ATTR_CUSTOM_ATTRIBUTES:
		if (!readAttributeCustomAttributes(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read custom attributes for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	case ATTR_IMBUEMENT_TYPE:
		if (!readAttributeImbuementType(propStream, item)) {
			SPDLOG_ERROR("[ItemReadMapAttributes::readAttributesMap] - Failed to read imbuement type attribute for item with id {}, on position {}", item.getID(), position.toString());
			return ATTR_READ_ERROR;
		}
		
		break;
	default:
		return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

bool ItemReadMapAttributes::readAttributeCount(PropStream& propStream, Item &item, Position position) {
	uint8_t attrItemCount = propStream.read<uint8_t>();
	if (attrItemCount == 0 || attrItemCount == -1) {
		attrItemCount = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid count, setting count to 1", getID(), position.toString());
	}

	item.setItemCount(attrItemCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeRuneCharge(PropStream& propStream, Item &item) {
	uint8_t charges = propStream.read<uint8_t>();
	if (charges == 0) {
		return false;
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeActionId(PropStream& propStream, Item &item) {
	uint16_t actionId = propStream.read<uint16_t>();
	if (actionId == 0) {
		return false;
	}

	item.setActionId(actionId);
	return true;
}

bool ItemReadMapAttributes::readAttributeUniqueId(PropStream& propStream, Item &item) {
	uint16_t uniqueId = propStream.read<uint16_t>();
	if (uniqueId == 0) {
		return false;
	}

	item.setUniqueId(uniqueId);
	return true;
}

bool ItemReadMapAttributes::readAttributeText(PropStream& propStream, Item &item) {
	std::string text = propStream.getString();
	if (text.empty()) {
		return false;
	}

	item.setText(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenDate(PropStream& propStream, Item &item) {
	uint32_t writtenDate = propStream.read<uint32_t>();
	if (writtenDate == 0) {
		return false;
	}

	item.setDate(writtenDate);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenBy(PropStream& propStream, Item &item) {
	std::string writer = propStream.getString();
	if (writer.empty()) {
		return false;
	}

	item.setWriter(writer);
	return true;
}

bool ItemReadMapAttributes::readAttributeDescription(PropStream& propStream, Item &item) {
	std::string text = propStream.getString();
	if (text.empty()) {
		return false;
	}

	item.setSpecialDescription(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeCharge(PropStream& propStream, Item &item, Position position) {
	uint16_t charges = propStream.read<uint16_t>();
	// If item not have charges, then set to 1 and send warning
	if (charges == 0) {
		charges = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid charges, setting charge to 1", getID(), position.toString());
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeDuration(PropStream& propStream, Item &item) {
	int32_t duration = propStream.read<uint32_t>();
	if (duration == 0) {
		return false;
	}

	item.setDuration(duration);
	return true;
}

bool ItemReadMapAttributes::readAttributeDecayingState(PropStream& propStream, Item &item) {
	uint8_t state = propStream.read<uint8_t>();
	if (state == 0) {
		return false;
	}

	if (state != DECAYING_FALSE) {
		item.setDecaying(DECAYING_PENDING);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeName(PropStream& propStream, Item &item) {
	std::string name = propStream.getString();
	if (name.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_NAME, name);
	return true;
}

bool ItemReadMapAttributes::readAttributeArticle(PropStream& propStream, Item &item) {
	std::string article = propStream.getString();
	if (article.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_ARTICLE, article);
	return true;
}

bool ItemReadMapAttributes::readAttributePluralName(PropStream& propStream, Item &item) {
	std::string pluralName = propStream.getString();
	if (pluralName.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_PLURALNAME, pluralName);
	return true;
}

bool ItemReadMapAttributes::readAttributeWeight(PropStream& propStream, Item &item) {
	uint32_t weight = propStream.read<uint32_t>();
	if (weight == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_WEIGHT, weight);
	return true;
}

bool ItemReadMapAttributes::readAttributeAttack(PropStream& propStream, Item &item) {
	int32_t attack = propStream.read<uint32_t>();
	if (attack == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ATTACK, attack);
	return true;
}

bool ItemReadMapAttributes::readAttributeDefense(PropStream& propStream, Item &item) {
	int32_t defense = propStream.read<uint32_t>();
	if (defense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_DEFENSE, defense);
	return true;
}

bool ItemReadMapAttributes::readAttributeExtraDefense(PropStream& propStream, Item &item) {
	int32_t extraDefense = propStream.read<uint32_t>();
	if (extraDefense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE, extraDefense);
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementSlot(PropStream& propStream, Item &item) {
	int32_t imbuementSlot = propStream.read<uint32_t>();
	if (imbuementSlot == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_IMBUEMENT_SLOT, imbuementSlot);
	return true;
}

bool ItemReadMapAttributes::readAttributeOpenContainer(PropStream& propStream, Item &item) {
	uint8_t openContainer = propStream.read<uint8_t>();
	if (openContainer == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, openContainer);
	return true;
}

bool ItemReadMapAttributes::readAttributeArmor(PropStream& propStream, Item &item) {
	int32_t armor = propStream.read<uint32_t>();
	if (armor == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ARMOR, armor);
	return true;
}

bool ItemReadMapAttributes::readAttributeHitChance(PropStream& propStream, Item &item) {
	int8_t hitChance = propStream.read<uint8_t>();
	if (hitChance == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_HITCHANCE, hitChance);
	return true;
}

bool ItemReadMapAttributes::readAttributeShootRange(PropStream& propStream, Item &item) {
	uint8_t shootRange = propStream.read<uint8_t>();
	if (shootRange == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE, shootRange);
	return true;
}

bool ItemReadMapAttributes::readAttributeSpecial(PropStream& propStream, Item &item) {
	std::string special = propStream.getString();
	if (special.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_SPECIAL, special);
	return true;
}

bool ItemReadMapAttributes::readAttributeQuicklootContainer(PropStream& propStream, Item &item) {
	uint32_t flags = propStream.read<uint32_t>();
	if (flags == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags);
	return true;
}

bool ItemReadMapAttributes::readAttributeDepotId(PropStream& propStream, Item &item) {
	uint16_t attrDepotId = propStream.read<uint16_t>();
	if (attrDepotId == 0) {
		return false;
	}

	item.setDepotId(attrDepotId);
	return true;
}

bool ItemReadMapAttributes::readAttributeHouseDoorId(PropStream& propStream, Item &item) {
	uint8_t attrDoorId = propStream.read<uint8_t>();
	if (attrDoorId == 0) {
		return false;
	}

	item.setDoorId(attrDoorId);
	return true;
}

bool ItemReadMapAttributes::readAttributeSleeperGuid(PropStream& propStream, Item &item) {
	uint32_t guid = propStream.read<uint32_t>();
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

bool ItemReadMapAttributes::readAttributeSleepStart(PropStream& propStream, Item &item) {
	uint32_t attrSleepStart = propStream.read<uint32_t>();
	if (attrSleepStart == 0) {
		return false;
	}

	item.setSleepStart(attrSleepStart);
	return true;
}

bool ItemReadMapAttributes::readAttributeTeleportDestination(PropStream& propStream, Item &item) {
	uint16_t x = propStream.read<uint16_t>();
	uint16_t y = propStream.read<uint16_t>();
	uint8_t z = propStream.read<uint8_t>();
	Position newPosition(x, y, z);
	if (x == 0 || y == 0 || z == 0) {
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have empty destination", getID(), newPosition.toString());
	}

	item.setDestination(newPosition);
	return true;
}

bool ItemReadMapAttributes::readAttributeContainerItems(PropStream& propStream, Item &item) {
	uint32_t attrSerializationCount = propStream.read<uint32_t>();
	if (attrSerializationCount == 0) {
		return false;
	}

	item.setSerializationCount(attrSerializationCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeCustomAttributes(PropStream& propStream, Item &item) {
	uint64_t size = propStream.read<uint64_t>();
	if (size == 0) {
		return false;
	}

	for (uint64_t i = 0; i < size; i++) {
		// Unserialize key type and value
		std::string key = propStream.getString();
		if (key.empty()) {
		return false;
		}

		// TODO: Finalize implement this
		//Unserialize value type and value
		ItemAttributes::CustomAttribute attribute;
		if (!attribute.unserialize(propStream, __FUNCTION__)) {
			return false;
		}

		item.setCustomAttribute(key, attribute);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementType(PropStream& propStream, Item &item) {
	std::string imbuementType = propStream.getString();
	if (imbuementType.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_IMBUEMENT_TYPE, imbuementType);
	return true;
}
