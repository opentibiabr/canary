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

ItemReadMapAttributes::ItemReadMapAttributes() = default;
ItemReadMapAttributes::~ItemReadMapAttributes() = default;

Attr_ReadValue ItemReadMapAttributes::readAttributesMap(AttrTypes_t attr, BinaryNode& binaryNode, Position position)
{
	switch (attr) {
	case ATTR_COUNT:
		readAttributeCount(binaryNode, position);
		break;
	case ATTR_RUNE_CHARGES:
		readAttributeRuneCharge(binaryNode);
		break;
	case ATTR_ACTION_ID: 
		readAttributeActionId(binaryNode);
		break;
	case ATTR_UNIQUE_ID:
		readAttributeUniqueId(binaryNode);
		break;
	case ATTR_TEXT:
		readAttributeText(binaryNode);
		break;
	case ATTR_WRITTENDATE:
		readAttributeWrittenDate(binaryNode);
		break;
	case ATTR_WRITTENBY: 
		readAttributeWrittenBy(binaryNode);
		break;
	case ATTR_DESC:
		readAttributeDescription(binaryNode);
		break;
	case ATTR_CHARGES:
		readAttributeCharge(binaryNode);
		break;
	case ATTR_DURATION:
		readAttributeDuration(binaryNode);
		break;
	case ATTR_DECAYING_STATE:
		readAttributeDecayingState(binaryNode);
		break;
	case ATTR_NAME:
		readAttributeName(binaryNode);
		break;
	case ATTR_ARTICLE:
		readAttributeArticle(binaryNode);
		break;
	case ATTR_PLURALNAME:
		readAttributePluralName(binaryNode);
		break;
	case ATTR_WEIGHT:
		readAttributeWeight(binaryNode);
		break;
	case ATTR_ATTACK:
		readAttributeAttack(binaryNode);
		break;
	case ATTR_DEFENSE:
		readAttributeDefense(binaryNode);
		break;
	case ATTR_EXTRADEFENSE:
		readAttributeExtraDefense(binaryNode);
		break;
	case ATTR_IMBUEMENT_SLOT:
		readAttributeImbuementSlot(binaryNode);
		break;
	case ATTR_OPENCONTAINER:
		readAttributeOpenContainer(binaryNode);
		break;
	case ATTR_ARMOR:
		readAttributeArmor(binaryNode);
		break;
	case ATTR_HITCHANCE:
		readAttributeHitChance(binaryNode);
		break;
	case ATTR_SHOOTRANGE:
		readAttributeShootRange(binaryNode);
		break;
	case ATTR_SPECIAL:
		readAttributeSpecial(binaryNode);
		break;
	case ATTR_QUICKLOOTCONTAINER:
		readAttributeQuicklootContainer(binaryNode);
		break;
	case ATTR_DEPOT_ID:
		readAttributeDepotId(binaryNode);
		break;
	case ATTR_HOUSEDOORID:
		readAttributeHouseDoorId(binaryNode);
		break;
	case ATTR_SLEEPERGUID:
		readAttributeSleeperGuid(binaryNode);
		break;
	case ATTR_SLEEPSTART:
		readAttributeSleepStart(binaryNode);
		break;
	case ATTR_TELE_DEST:
		readAttributeTeleportDestination(binaryNode);
		break;
	case ATTR_CONTAINER_ITEMS:
		readAttributeContainerItems(binaryNode);
		break;
	case ATTR_CUSTOM_ATTRIBUTES:
		readAttributeCustomAttributes(binaryNode);
		break;
	case ATTR_IMBUEMENT_TYPE:
		readAttributeImbuementType(binaryNode);
		break;
	default:
		return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeCount(BinaryNode& binaryNode, Position position) {
	uint8_t attrItemCount = binaryNode.getU8();
	if (attrItemCount == 0 || attrItemCount == -1) {
		attrItemCount = 1;
		SPDLOG_DEBUG("[Item::readAttributesMap] - Item with id {} on position {} have invalid count, setting count to 1", getID(), position.toString());
	}

	g_item.setItemCount(attrItemCount);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeRuneCharge(BinaryNode& binaryNode) {
	uint8_t charges = binaryNode.getU8();
	if (charges == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setSubType(charges);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeActionId(BinaryNode& binaryNode) {
	uint16_t actionId = binaryNode.getU16();
	if (actionId == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setActionId(actionId);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeUniqueId(BinaryNode& binaryNode) {
	uint16_t uniqueId = binaryNode.getU16();
	if (uniqueId == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setUniqueId(uniqueId);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeText(BinaryNode& binaryNode) {
	std::string text = binaryNode.getString();
	if (text.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setText(text);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeWrittenDate(BinaryNode& binaryNode) {
	uint32_t writtenDate = binaryNode.getU32();
	if (writtenDate == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setDate(writtenDate);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeWrittenBy(BinaryNode& binaryNode) {
	std::string writer = binaryNode.getString();
	if (writer.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setWriter(writer);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeDescription(BinaryNode& binaryNode) {
	std::string text = binaryNode.getString();
	if (text.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setSpecialDescription(text);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeCharge(BinaryNode& binaryNode) {
	uint16_t charges = binaryNode.getU16();
	// If item not have charges, then set to 1 and send warning
	if (charges == 0 || charges == -1) {
		charges = 1;
		SPDLOG_DEBUG("[Item::readAttributesMap] - Item with id {} on position {} have invalid charges, setting charge to 1", getID(), position.toString());
	}

	g_item.setSubType(charges);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeDuration(BinaryNode& binaryNode) {
	int32_t duration = binaryNode.getU32();
	if (duration == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setDuration(duration);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeDecayingState(BinaryNode& binaryNode) {
	uint8_t state = binaryNode.getU8();
	if (state == 0) {
		return ATTR_READ_ERROR;
	}

	if (state != DECAYING_FALSE) {
		g_item.setDecaying(DECAYING_PENDING);
	}
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeName(BinaryNode& binaryNode) {
	std::string name = binaryNode.getString();
	if (name.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setStrAttr(ITEM_ATTRIBUTE_NAME, name);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeArticle(BinaryNode& binaryNode) {
	std::string article = binaryNode.getString();
	if (article.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setStrAttr(ITEM_ATTRIBUTE_ARTICLE, article);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributePluralName(BinaryNode& binaryNode) {
	std::string pluralName = binaryNode.getString();
	if (pluralName.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setStrAttr(ITEM_ATTRIBUTE_PLURALNAME, pluralName);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeWeight(BinaryNode& binaryNode) {
	uint32_t weight = binaryNode.getU32();
	if (weight == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_WEIGHT, weight);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeAttack(BinaryNode& binaryNode) {
	int32_t attack = binaryNode.getU32();
	if (attack == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_ATTACK, attack);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeDefense(BinaryNode& binaryNode) {
	int32_t defense = binaryNode.getU32();
	if (defense == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_DEFENSE, defense);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeExtraDefense(BinaryNode& binaryNode) {
	int32_t extraDefense = binaryNode.getU32();
	if (extraDefense == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE, extraDefense);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeImbuementSlot(BinaryNode& binaryNode) {
	int32_t imbuementSlot = binaryNode.getU32();
	if (imbuementSlot == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_IMBUEMENT_SLOT, imbuementSlot);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeOpenContainer(BinaryNode& binaryNode) {
	uint8_t openContainer = binaryNode.getU8();
	if (openContainer == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, openContainer);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeArmor(BinaryNode& binaryNode) {
	int32_t armor = binaryNode.getU32();
	if (armor == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_ARMOR, armor);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeHitChance(BinaryNode& binaryNode) {
	int8_t hitChance = binaryNode.getU8();
	if (hitChance == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_HITCHANCE, hitChance);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeShootRange(BinaryNode& binaryNode) {
	uint8_t shootRange = binaryNode.getU8();
	if (shootRange == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE, shootRange);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeSpecial(BinaryNode& binaryNode) {
	std::string special = binaryNode.getString();
	if (special.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setStrAttr(ITEM_ATTRIBUTE_SPECIAL, special);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeQuicklootContainer(BinaryNode& binaryNode) {
	uint32_t flags = binaryNode.getU32();
	if (flags == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeDepotId(BinaryNode& binaryNode) {
	uint16_t attrDepotId = binaryNode.getU16();
	if (attrDepotId == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setDepotId(attrDepotId);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeHouseDoorId(BinaryNode& binaryNode) {
	uint8_t attrDoorId = binaryNode.getU8();
	if (attrDoorId == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setDoorId(attrDoorId);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeSleeperGuid(BinaryNode& binaryNode) {
	uint32_t guid = binaryNode.getU32();
	if (guid == 0) {
		return ATTR_READ_ERROR;
	}

	std::string name = IOLoginData::getNameByGuid(guid);
	if (!name.empty()) {
		g_item.setSpecialDescription(name + " is sleeping there.");
		g_game().setBedSleeper(g_item.getBed(), guid);
		g_item.setSleeperGuid(guid);
	}
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeSleepStart(BinaryNode& binaryNode) {
	uint32_t attrSleepStart = binaryNode.getU32();
	if (attrSleepStart == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setSleepStart(attrSleepStart);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeTeleportDestination(BinaryNode& binaryNode) {
	uint16_t x = binaryNode.getU16();
	uint16_t y = binaryNode.getU16();
	uint8_t z = binaryNode.getU8();
	Position newPosition(x, y, z);
	if (x == 0 || y == 0 || z == 0) {
		SPDLOG_DEBUG("[Item::readAttributesMap] - Item with id {} on position {} have empty destination", getID(), newPosition.toString());
	}

	g_item.setDestination(newPosition);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeContainerItems(BinaryNode& binaryNode) {
	uint32_t attrSerializationCount = binaryNode.getU32();
	if (attrSerializationCount == 0) {
		return ATTR_READ_ERROR;
	}

	g_item.setSerializationCount(attrSerializationCount);
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeCustomAttributes(BinaryNode& binaryNode) {
	uint64_t size = binaryNode.getU64();
	if (size == 0) {
		return ATTR_READ_ERROR;
	}

	for (uint64_t i = 0; i < size; i++) {
		// Unserialize key type and value
		std::string key = binaryNode.getString();
		if (key.empty()) {
		return ATTR_READ_ERROR;
		}

		// TODO: Finalize implement this
		//Unserialize value type and value
		ItemAttributes::CustomAttribute attribute;
		if (!attribute.unserialize(binaryNode)) {
		return ATTR_READ_ERROR;
		}

		g_item.setCustomAttribute(key, attribute);
	}
	return ATTR_READ_CONTINUE;
}

Attr_ReadValue ItemReadMapAttributes::readAttributeImbuementType(BinaryNode& binaryNode) {
	std::string imbuementType = binaryNode.getString();
	if (imbuementType.empty()) {
		return ATTR_READ_ERROR;
	}

	g_item.setStrAttr(ITEM_ATTRIBUTE_IMBUEMENT_TYPE, imbuementType);
	return ATTR_READ_CONTINUE;
}
