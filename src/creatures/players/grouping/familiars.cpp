/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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
#include "creatures/players/grouping/familiars.h"
#include "utils/tools.h"

bool Familiars::loadFromXml() {
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/familiars.xml");
	if (!result) {
		SPDLOG_ERROR("Failed to load Familiars");
		printXMLError("[Familiars::loadFromXml] - ", "data/XML/familiars.xml", result);
		return false;
	}

	for (auto familiarsNode : doc.child("familiars").children()) {
		pugi::xml_attribute attr;
		if ((attr = familiarsNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = familiarsNode.attribute("vocation"))) {
			SPDLOG_WARN("[Familiars::loadFromXml] - Missing familiar vocation.");
			continue;
		}

		auto vocationId = static_cast<uint16_t>(attr.as_uint());
		if (vocationId > VOCATION_LAST) {
			SPDLOG_WARN("[Familiars::loadFromXml] - Invalid familiar vocation {}", vocationId);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = familiarsNode.attribute("lookType");
		auto lookType = static_cast<uint16_t>(lookTypeAttribute.as_uint());
		const std::string familiarName = familiarsNode.attribute("name").as_string();
		if (!lookTypeAttribute.empty()) {
			const std::string lookTypeString = lookTypeAttribute.as_string();
			if (lookTypeString.empty() || lookType == 0) {
				SPDLOG_WARN("[Familiars::loadFromXml] - Empty looktype on outfit with name {}", familiarName);
				continue;
			}

			if (!isNumber(lookTypeString)) {
				SPDLOG_WARN("[Familiars::loadFromXml] - Invalid looktype {} with name {}", lookTypeString, familiarName);
				continue;
			}

			if (pugi::xml_attribute nameAttribute = familiarsNode.attribute("name");
			!nameAttribute || familiarName.empty())
			{
				SPDLOG_WARN("[Familiars::loadFromXml] - Missing or empty name on outfit with looktype {}", lookTypeString);
				continue;
			}
		} else {
			SPDLOG_WARN("[Familiars::loadFromXml] - "
						"Missing looktype id for outfit name: {}", familiarName);
		}

		familiars[vocationId].emplace_back(
			familiarName,
			lookType,
			familiarsNode.attribute("premium").as_bool(),
			familiarsNode.attribute("unlocked").as_bool(true),
			familiarsNode.attribute("type").as_string());
	}
	for (uint16_t vocationId = VOCATION_NONE; vocationId <= VOCATION_LAST; ++vocationId) {
		familiars[vocationId].shrink_to_fit();
	}
	return true;
}

const Familiar* Familiars::getFamiliarByLookType(uint16_t vocationId, uint16_t lookType) const {
	for (const Familiar& familiar : familiars[vocationId]) {
		if (familiar.lookType == lookType) {
			return &familiar;
		}
	}
	return nullptr;
}
