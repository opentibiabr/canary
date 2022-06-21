/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_
#define SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_

#include "declarations.hpp"

class ItemReadMapAttributes final : public Item
{
public:
	static Attr_ReadValue readAttributesMap(AttrTypes_t attr, Item &item, BinaryNode& binaryNode, Position position);

private:
	static bool readAttributeCount(BinaryNode& binaryNode, Item &item, Position position);
	static bool readAttributeRuneCharge(BinaryNode& binaryNode, Item &item);
	static bool readAttributeActionId(BinaryNode& binaryNode, Item &item);
	static bool readAttributeUniqueId(BinaryNode& binaryNode, Item &item);
	static bool readAttributeText(BinaryNode& binaryNode, Item &item);
	static bool readAttributeWrittenDate(BinaryNode& binaryNode, Item &item);
	static bool readAttributeWrittenBy(BinaryNode& binaryNode, Item &item);
	static bool readAttributeDescription(BinaryNode& binaryNode, Item &item);
	static bool readAttributeCharge(BinaryNode& binaryNode, Item &item, Position position);
	static bool readAttributeDuration(BinaryNode& binaryNode, Item &item);
	static bool readAttributeDecayingState(BinaryNode& binaryNode, Item &item);
	static bool readAttributeName(BinaryNode& binaryNode, Item &item);
	static bool readAttributeArticle(BinaryNode& binaryNode, Item &item);
	static bool readAttributePluralName(BinaryNode& binaryNode, Item &item);
	static bool readAttributeWeight(BinaryNode& binaryNode, Item &item);
	static bool readAttributeAttack(BinaryNode& binaryNode, Item &item);
	static bool readAttributeDefense(BinaryNode& binaryNode, Item &item);
	static bool readAttributeExtraDefense(BinaryNode& binaryNode, Item &item);
	static bool readAttributeImbuementSlot(BinaryNode& binaryNode, Item &item);
	static bool readAttributeOpenContainer(BinaryNode& binaryNode, Item &item);
	static bool readAttributeArmor(BinaryNode& binaryNode, Item &item);
	static bool readAttributeHitChance(BinaryNode& binaryNode, Item &item);
	static bool readAttributeShootRange(BinaryNode& binaryNode, Item &item);
	static bool readAttributeSpecial(BinaryNode& binaryNode, Item &item);
	static bool readAttributeQuicklootContainer(BinaryNode& binaryNode, Item &item);
	static bool readAttributeDepotId(BinaryNode& binaryNode, Item &item);
	static bool readAttributeHouseDoorId(BinaryNode& binaryNode, Item &item);
	static bool readAttributeSleeperGuid(BinaryNode& binaryNode, Item &item);
	static bool readAttributeSleepStart(BinaryNode& binaryNode, Item &item);
	static bool readAttributeTeleportDestination(BinaryNode& binaryNode, Item &item);
	static bool readAttributeContainerItems(BinaryNode& binaryNode, Item &item);
	static bool readAttributeCustomAttributes(BinaryNode& binaryNode, Item &item);
	static bool readAttributeImbuementType(BinaryNode& binaryNode, Item &item);
};

#endif // SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_
