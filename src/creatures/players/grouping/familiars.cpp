/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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
#include "utils/pugicast.h"
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

		uint16_t vocation = pugi::cast<uint16_t>(attr.value());
		if (vocation > VOCATION_LAST) {
			SPDLOG_WARN("[Familiars::loadFromXml] - Invalid familiar vocation {}", vocation);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = familiarsNode.attribute("lookType");
		if (!lookTypeAttribute) {
			SPDLOG_WARN("[Familiars::loadFromXml] - Missing looktype on familiar.");
			continue;
		}

		familiars[vocation].emplace_back(
			familiarsNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			familiarsNode.attribute("premium").as_bool(),
			familiarsNode.attribute("unlocked").as_bool(true),
			familiarsNode.attribute("type").as_string());
	}
	for (uint16_t vocation = VOCATION_NONE; vocation <= VOCATION_LAST; ++vocation) {
		familiars[vocation].shrink_to_fit();
	}
	return true;
}

const Familiar* Familiars::getFamiliarByLookType(uint16_t vocation, uint16_t lookType) const {
	for (const Familiar& familiar : familiars[vocation]) {
		if (familiar.lookType == lookType) {
			return &familiar;
		}
	}
	return nullptr;
}
