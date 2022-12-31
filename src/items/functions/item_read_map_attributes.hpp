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
	static Attr_ReadValue readAttributesMap(AttrTypes_t attr, Item &item, PropStream& propStream, const Position &position);

	static bool readAttributeCount(PropStream& propStream, Item &item, const Position &position);
	static bool readAttributeRuneCharge(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeActionId(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeUniqueId(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeText(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeWrittenDate(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeWrittenBy(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeDescription(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeCharge(PropStream& propStream, Item &item, const Position &position);
	static bool readAttributeDuration(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeDecayingState(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeName(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeArticle(PropStream& propStream, Item &item, const Position &);
	static bool readAttributePluralName(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeWeight(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeAttack(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeDefense(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeExtraDefense(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeImbuementSlot(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeOpenContainer(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeArmor(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeHitChance(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeShootRange(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeSpecial(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeQuicklootContainer(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeDepotId(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeHouseDoorId(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeSleeperGuid(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeSleepStart(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeTeleportDestination(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeContainerItems(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeCustomAttributes(PropStream& propStream, Item &item, const Position &);
	static bool readAttributeImbuementType(PropStream& propStream, Item &item, const Position &);
};

#endif // SRC_ITEMS_FUNCTIONS_READ_ATTRIBUTE_MAP_HPP_
