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
	static Attr_ReadValue readAttributesMap(AttrTypes_t attr, Item &item, PropStream& propStream, Position position);

private:
	static bool readAttributeCount(PropStream& propStream, Item &item, Position position);
	static bool readAttributeRuneCharge(PropStream& propStream, Item &item);
	static bool readAttributeActionId(PropStream& propStream, Item &item);
	static bool readAttributeUniqueId(PropStream& propStream, Item &item);
	static bool readAttributeText(PropStream& propStream, Item &item);
	static bool readAttributeWrittenDate(PropStream& propStream, Item &item);
	static bool readAttributeWrittenBy(PropStream& propStream, Item &item);
	static bool readAttributeDescription(PropStream& propStream, Item &item);
	static bool readAttributeCharge(PropStream& propStream, Item &item, Position position);
	static bool readAttributeDuration(PropStream& propStream, Item &item);
	static bool readAttributeDecayingState(PropStream& propStream, Item &item);
	static bool readAttributeName(PropStream& propStream, Item &item);
	static bool readAttributeArticle(PropStream& propStream, Item &item);
	static bool readAttributePluralName(PropStream& propStream, Item &item);
	static bool readAttributeWeight(PropStream& propStream, Item &item);
	static bool readAttributeAttack(PropStream& propStream, Item &item);
	static bool readAttributeDefense(PropStream& propStream, Item &item);
	static bool readAttributeExtraDefense(PropStream& propStream, Item &item);
	static bool readAttributeImbuementSlot(PropStream& propStream, Item &item);
	static bool readAttributeOpenContainer(PropStream& propStream, Item &item);
	static bool readAttributeArmor(PropStream& propStream, Item &item);
	static bool readAttributeHitChance(PropStream& propStream, Item &item);
	static bool readAttributeShootRange(PropStream& propStream, Item &item);
	static bool readAttributeSpecial(PropStream& propStream, Item &item);
	static bool readAttributeQuicklootContainer(PropStream& propStream, Item &item);
	static bool readAttributeDepotId(PropStream& propStream, Item &item);
	static bool readAttributeHouseDoorId(PropStream& propStream, Item &item);
	static bool readAttributeSleeperGuid(PropStream& propStream, Item &item);
	static bool readAttributeSleepStart(PropStream& propStream, Item &item);
	static bool readAttributeTeleportDestination(PropStream& propStream, Item &item);
	static bool readAttributeContainerItems(PropStream& propStream, Item &item);
	static bool readAttributeCustomAttributes(PropStream& propStream, Item &item);
	static bool readAttributeImbuementType(PropStream& propStream, Item &item);
};

#endif // SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_
