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

class ItemReadMapAttributes : public Item
{
public:
	ItemReadMapAttributes();
	~ItemReadMapAttributes() override;

	NONCOPYABLE(ItemReadMapAttributes);

	static Attr_ReadValue readAttributesMap(AttrTypes_t attr, BinaryNode& binaryNode, Position position);

private:
	static Attr_ReadValue readAttributeCount(BinaryNode& binaryNode, Position position);
	static Attr_ReadValue readAttributeRuneCharge(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeActionId(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeUniqueId(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeText(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeWrittenDate(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeWrittenBy(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeDescription(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeCharge(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeDuration(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeDecayingState(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeName(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeArticle(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributePluralName(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeWeight(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeAttack(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeDefense(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeExtraDefense(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeImbuementSlot(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeOpenContainer(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeArmor(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeHitChance(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeShootRange(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeSpecial(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeQuicklootContainer(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeDepotId(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeHouseDoorId(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeSleeperGuid(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeSleepStart(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeTeleportDestination(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeContainerItems(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeCustomAttributes(BinaryNode& binaryNode);
	static Attr_ReadValue readAttributeImbuementType(BinaryNode& binaryNode);
};

#endif // SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_
