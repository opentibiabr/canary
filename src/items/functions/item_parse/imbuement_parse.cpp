/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2018-2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
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

#include "otpch.h"

#include "items/functions/item_parse/imbuement_parse.hpp"

void ParseImbuement::initParseImbuement(const std::string& tmpStrValue, pugi::xml_node attributeNode, pugi::xml_attribute keyAttribute, pugi::xml_attribute valueAttribute, ItemType& itemType) {
	std::string stringValue = tmpStrValue;
	if (stringValue == "imbuementslot") {
		if (valueAttribute.value() == "0") {
			SPDLOG_INFO("DESACTIVATED ITEM IMBUEMENT {}", itemType.id);
			return;
		}

		itemType.imbuingSlots = pugi::cast<int32_t>(valueAttribute.value());

		for (auto subAttributeNode: attributeNode.children()) {
			pugi::xml_attribute subKeyAttribute = subAttributeNode.attribute("key");
			if (!subKeyAttribute) {
				continue;
			}

			pugi::xml_attribute subValueAttribute = subAttributeNode.attribute("value");
			if (!subValueAttribute) {
				continue;
			}

			stringValue = asLowerCaseString(subKeyAttribute.as_string());

			auto itemMap = ImbuementsTypeMap.find(stringValue);
			if (itemMap != ImbuementsTypeMap.end()) {
				itemType.setImbuementType(itemMap->second);
			} else {
				SPDLOG_WARN("[ParseImbuement::initParseImbuement] - Unknown type: {}",
          	              valueAttribute.as_string());
			}
		}
	}
}
