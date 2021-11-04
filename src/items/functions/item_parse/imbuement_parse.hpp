/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2018-2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * It under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifndef SRC_ITEMS_FUNCTIONS_ITEM_PARSE_IMBUEMENT_PARSE_HPP_
#define SRC_ITEMS_FUNCTIONS_ITEM_PARSE_IMBUEMENT_PARSE_HPP_

#include "items/functions/item_parse.hpp"
#include "creatures/combat/condition.h"
#include "declarations.hpp"
#include "items/item.h"
#include "items/items.h"
#include "utils/pugicast.h"

class ConditionDamage;

class ParseImbuement final : public ItemParse
{
	public:
	static void initParseImbuement(const std::string& tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute keyAttribute, pugi::xml_attribute valueAttribute, ItemType& itemType);

	private:
};

#endif // SRC_ITEMS_FUNCTIONS_ITEM_PARSE_IMBUEMENT_PARSE_HPP_
