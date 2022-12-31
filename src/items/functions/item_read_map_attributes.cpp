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

namespace AttributeReader {
using AttributeFunctionsReader = std::function<bool(PropStream&, Item&, const Position&)>;
std::unordered_map<AttrTypes_t, AttributeFunctionsReader> attributeReaders = {
	{ ATTR_COUNT, ItemReadMapAttributes::readAttributeCount },
	{ ATTR_RUNE_CHARGES, ItemReadMapAttributes::readAttributeRuneCharge },
	{ ATTR_ACTION_ID, ItemReadMapAttributes::readAttributeActionId },
	{ ATTR_UNIQUE_ID, ItemReadMapAttributes::readAttributeUniqueId },
	{ ATTR_TEXT, ItemReadMapAttributes::readAttributeText },
	{ ATTR_WRITTENDATE, ItemReadMapAttributes::readAttributeWrittenDate },
	{ ATTR_WRITTENBY, ItemReadMapAttributes::readAttributeWrittenBy },
	{ ATTR_DESC, ItemReadMapAttributes::readAttributeDescription },
	{ ATTR_CHARGES, ItemReadMapAttributes::readAttributeCharge },
	{ ATTR_DURATION, ItemReadMapAttributes::readAttributeDuration },
	{ ATTR_DECAYING_STATE, ItemReadMapAttributes::readAttributeDecayingState },
	{ ATTR_NAME, ItemReadMapAttributes::readAttributeName },
	{ ATTR_ARTICLE, ItemReadMapAttributes::readAttributeArticle },
	{ ATTR_PLURALNAME, ItemReadMapAttributes::readAttributePluralName },
	{ ATTR_WEIGHT, ItemReadMapAttributes::readAttributeWeight },
	{ ATTR_ATTACK, ItemReadMapAttributes::readAttributeAttack },
	{ ATTR_DEFENSE, ItemReadMapAttributes::readAttributeDefense },
	{ ATTR_EXTRADEFENSE, ItemReadMapAttributes::readAttributeExtraDefense },
	{ ATTR_IMBUEMENT_SLOT, ItemReadMapAttributes::readAttributeImbuementSlot },
	{ ATTR_OPENCONTAINER, ItemReadMapAttributes::readAttributeOpenContainer },
	{ ATTR_ARMOR, ItemReadMapAttributes::readAttributeArmor },
	{ ATTR_HITCHANCE, ItemReadMapAttributes::readAttributeHitChance },
	{ ATTR_SHOOTRANGE, ItemReadMapAttributes::readAttributeShootRange },
	{ ATTR_SPECIAL, ItemReadMapAttributes::readAttributeSpecial },
	{ ATTR_QUICKLOOTCONTAINER, ItemReadMapAttributes::readAttributeQuicklootContainer },
	{ ATTR_DEPOT_ID, ItemReadMapAttributes::readAttributeDepotId },
	{ ATTR_HOUSEDOORID, ItemReadMapAttributes::readAttributeHouseDoorId },
	{ ATTR_SLEEPERGUID, ItemReadMapAttributes::readAttributeSleeperGuid },
	{ ATTR_SLEEPSTART, ItemReadMapAttributes::readAttributeSleepStart },
	{ ATTR_TELE_DEST, ItemReadMapAttributes::readAttributeTeleportDestination },
	{ ATTR_CONTAINER_ITEMS, ItemReadMapAttributes::readAttributeContainerItems },
	{ ATTR_CUSTOM_ATTRIBUTES, ItemReadMapAttributes::readAttributeCustomAttributes },
	{ ATTR_IMBUEMENT_TYPE, ItemReadMapAttributes::readAttributeImbuementType }
};
} // namespace

Attr_ReadValue ItemReadMapAttributes::readAttributesMap(AttrTypes_t attr, Item &item, PropStream& propStream, const Position &position)
{
	if (const auto &reader = AttributeReader::attributeReaders[attr];
		!reader(propStream, item, position))
	{
		SPDLOG_ERROR("[{}] Failed to read attribute {} for item with id {}, on position {}", __FUNCTION__, attr, item.getID(), position.toString());
		return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}

bool ItemReadMapAttributes::readAttributeCount(PropStream& propStream, Item &item, [[maybe_unused]] const Position &position) {
	uint8_t attrItemCount = propStream.get<uint8_t>();
	if (attrItemCount == 0 || attrItemCount == -1) {
		attrItemCount = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid count, setting count to 1", getID(), position.toString());
	}

	item.setItemCount(attrItemCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeRuneCharge(PropStream& propStream, Item &item, const Position &) {
	uint8_t charges = propStream.get<uint8_t>();
	if (charges == 0) {
		return false;
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeActionId(PropStream& propStream, Item &item, const Position &) {
	uint16_t actionId = propStream.get<uint16_t>();
	if (actionId == 0) {
		return false;
	}

	item.setActionId(actionId);
	return true;
}

bool ItemReadMapAttributes::readAttributeUniqueId(PropStream& propStream, Item &item, const Position &) {
	uint16_t uniqueId = propStream.get<uint16_t>();
	if (uniqueId == 0) {
		return false;
	}

	item.setUniqueId(uniqueId);
	return true;
}

bool ItemReadMapAttributes::readAttributeText(PropStream& propStream, Item &item, const Position &) {
	std::string text = propStream.getString();
	if (text.empty()) {
		return false;
	}

	item.setText(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenDate(PropStream& propStream, Item &item, const Position &) {
	uint32_t writtenDate = propStream.get<uint32_t>();
	if (writtenDate == 0) {
		return false;
	}

	item.setDate(writtenDate);
	return true;
}

bool ItemReadMapAttributes::readAttributeWrittenBy(PropStream& propStream, Item &item, const Position &) {
	std::string writer = propStream.getString();
	if (writer.empty()) {
		return false;
	}

	item.setWriter(writer);
	return true;
}

bool ItemReadMapAttributes::readAttributeDescription(PropStream& propStream, Item &item, const Position &) {
	std::string text = propStream.getString();
	if (text.empty()) {
		return false;
	}

	item.setSpecialDescription(text);
	return true;
}

bool ItemReadMapAttributes::readAttributeCharge(PropStream& propStream, Item &item, [[maybe_unused]]const Position &position) {
	uint16_t charges = propStream.get<uint16_t>();
	// If item not have charges, then set to 1 and send warning
	if (charges == 0) {
		charges = 1;
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have invalid charges, setting charge to 1", getID(), position.toString());
	}

	item.setSubType(charges);
	return true;
}

bool ItemReadMapAttributes::readAttributeDuration(PropStream& propStream, Item &item, const Position &) {
	int32_t duration = propStream.get<uint32_t>();
	if (duration == 0) {
		return false;
	}

	item.setDuration(duration);
	return true;
}

bool ItemReadMapAttributes::readAttributeDecayingState(PropStream& propStream, Item &item, const Position &) {
	uint8_t state = propStream.get<uint8_t>();
	if (state == 0) {
		return false;
	}

	if (state != DECAYING_FALSE) {
		item.setDecaying(DECAYING_PENDING);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeName(PropStream& propStream, Item &item, const Position &) {
	std::string name = propStream.getString();
	if (name.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_NAME, name);
	return true;
}

bool ItemReadMapAttributes::readAttributeArticle(PropStream& propStream, Item &item, const Position &) {
	std::string article = propStream.getString();
	if (article.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_ARTICLE, article);
	return true;
}

bool ItemReadMapAttributes::readAttributePluralName(PropStream& propStream, Item &item, const Position &) {
	std::string pluralName = propStream.getString();
	if (pluralName.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_PLURALNAME, pluralName);
	return true;
}

bool ItemReadMapAttributes::readAttributeWeight(PropStream& propStream, Item &item, const Position &) {
	uint32_t weight = propStream.get<uint32_t>();
	if (weight == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_WEIGHT, weight);
	return true;
}

bool ItemReadMapAttributes::readAttributeAttack(PropStream& propStream, Item &item, const Position &) {
	int32_t attack = propStream.get<uint32_t>();
	if (attack == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ATTACK, attack);
	return true;
}

bool ItemReadMapAttributes::readAttributeDefense(PropStream& propStream, Item &item, const Position &) {
	int32_t defense = propStream.get<uint32_t>();
	if (defense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_DEFENSE, defense);
	return true;
}

bool ItemReadMapAttributes::readAttributeExtraDefense(PropStream& propStream, Item &item, const Position &) {
	int32_t extraDefense = propStream.get<uint32_t>();
	if (extraDefense == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_EXTRADEFENSE, extraDefense);
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementSlot(PropStream& propStream, Item &item, const Position &) {
	int32_t imbuementSlot = propStream.get<uint32_t>();
	if (imbuementSlot == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_IMBUEMENT_SLOT, imbuementSlot);
	return true;
}

bool ItemReadMapAttributes::readAttributeOpenContainer(PropStream& propStream, Item &item, const Position &) {
	uint8_t openContainer = propStream.get<uint8_t>();
	if (openContainer == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_OPENCONTAINER, openContainer);
	return true;
}

bool ItemReadMapAttributes::readAttributeArmor(PropStream& propStream, Item &item, const Position &) {
	int32_t armor = propStream.get<uint32_t>();
	if (armor == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_ARMOR, armor);
	return true;
}

bool ItemReadMapAttributes::readAttributeHitChance(PropStream& propStream, Item &item, const Position &) {
	int8_t hitChance = propStream.get<uint8_t>();
	if (hitChance == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_HITCHANCE, hitChance);
	return true;
}

bool ItemReadMapAttributes::readAttributeShootRange(PropStream& propStream, Item &item, const Position &) {
	uint8_t shootRange = propStream.get<uint8_t>();
	if (shootRange == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_SHOOTRANGE, shootRange);
	return true;
}

bool ItemReadMapAttributes::readAttributeSpecial(PropStream& propStream, Item &item, const Position &) {
	std::string special = propStream.getString();
	if (special.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_SPECIAL, special);
	return true;
}

bool ItemReadMapAttributes::readAttributeQuicklootContainer(PropStream& propStream, Item &item, const Position &) {
	uint32_t flags = propStream.get<uint32_t>();
	if (flags == 0) {
		return false;
	}

	item.setIntAttr(ITEM_ATTRIBUTE_QUICKLOOTCONTAINER, flags);
	return true;
}

bool ItemReadMapAttributes::readAttributeDepotId(PropStream& propStream, Item &item, const Position &) {
	uint16_t attrDepotId = propStream.get<uint16_t>();
	if (attrDepotId == 0) {
		return false;
	}

	item.setDepotId(attrDepotId);
	return true;
}

bool ItemReadMapAttributes::readAttributeHouseDoorId(PropStream& propStream, Item &item, const Position &) {
	uint8_t attrDoorId = propStream.get<uint8_t>();
	if (attrDoorId == 0) {
		return false;
	}

	item.setDoorId(attrDoorId);
	return true;
}

bool ItemReadMapAttributes::readAttributeSleeperGuid(PropStream& propStream, Item &item, const Position &) {
	uint32_t guid = propStream.get<uint32_t>();
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

bool ItemReadMapAttributes::readAttributeSleepStart(PropStream& propStream, Item &item, const Position &) {
	uint32_t attrSleepStart = propStream.get<uint32_t>();
	if (attrSleepStart == 0) {
		return false;
	}

	item.setSleepStart(attrSleepStart);
	return true;
}

bool ItemReadMapAttributes::readAttributeTeleportDestination(PropStream& propStream, Item &item, const Position &) {
	uint16_t x = propStream.get<uint16_t>();
	uint16_t y = propStream.get<uint16_t>();
	uint8_t z = propStream.get<uint8_t>();
	Position newPosition(x, y, z);
	if (x == 0 || y == 0 || z == 0) {
		SPDLOG_DEBUG("[readAttributesMap] - Item with id {} on position {} have empty destination", getID(), newPosition.toString());
	}

	item.setDestination(newPosition);
	return true;
}

bool ItemReadMapAttributes::readAttributeContainerItems(PropStream& propStream, Item &item, const Position &) {
	uint32_t attrSerializationCount = propStream.get<uint32_t>();
	if (attrSerializationCount == 0) {
		return false;
	}

	item.setSerializationCount(attrSerializationCount);
	return true;
}

bool ItemReadMapAttributes::readAttributeCustomAttributes(PropStream& propStream, Item &item, const Position &) {
	uint64_t size = propStream.get<uint64_t>();
	if (size == 0) {
		return false;
	}

	for (uint64_t i = 0; i < size; i++) {
		// Unserialize key type and value
		std::string key = propStream.getString();
		if (key.empty()) {
		return false;
		}

		//Unserialize value type and value
		ItemAttributes::CustomAttribute attribute;
		if (!attribute.unserialize(propStream, __FUNCTION__)) {
			return false;
		}

		item.setCustomAttribute(key, attribute);
	}
	return true;
}

bool ItemReadMapAttributes::readAttributeImbuementType(PropStream& propStream, Item &item, const Position &) {
	std::string imbuementType = propStream.getString();
	if (imbuementType.empty()) {
		return false;
	}

	item.setStrAttr(ITEM_ATTRIBUTE_IMBUEMENT_TYPE, imbuementType);
	return true;
}
