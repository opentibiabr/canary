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

#include "creatures/appearance/outfit/outfit.h"

#include "utils/pugicast.h"
#include "utils/tools.h"

bool Outfits::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/outfits.xml");
	if (!result) {
		printXMLError("[Outfits::loadFromXml] - ", "data/XML/outfits.xml", result);
		return false;
	}

	for (auto outfitNode : doc.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Missing outfit type");
			continue;
		}

		uint16_t type = pugi::cast<uint16_t>(attr.value());
		if (type > PLAYERSEX_LAST) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Invalid outfit type {}", type);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		if (!lookTypeAttribute) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Missing looktype on outfit");
			continue;
		}

		outfits[type].emplace_back(
			outfitNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true),
			outfitNode.attribute("from").as_string()
		);
	}
	for (uint8_t sex = PLAYERSEX_FEMALE; sex <= PLAYERSEX_LAST; ++sex) {
		outfits[sex].shrink_to_fit();
	}
	return true;
}

const Outfit* Outfits::getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const
{
	for (const Outfit& outfit : outfits[sex]) {
		if (outfit.lookType == lookType) {
			return &outfit;
		}
	}
	return nullptr;
}

/**
 * Get the oposite sex equivalent outfit
 * @param sex current sex
 * @param lookType current looktype
 * @return <b>const</b> pointer to the outfit or <b>nullptr</b> if it could not be found.
 */

const Outfit *Outfits::getOpositeSexOutfitByLookType(PlayerSex_t sex, uint16_t lookType)
{
	PlayerSex_t	searchSex = (sex == PLAYERSEX_MALE)?PLAYERSEX_FEMALE:PLAYERSEX_MALE;

	for(uint16_t i=0; i< outfits[sex].size(); i++) {
		if (outfits[sex].at(i).lookType == lookType) {
			if (outfits[searchSex].size()>i) {
				return &outfits[searchSex].at(i);
			} else { //looktype found but the oposite sex array doesn't have this index.
				return nullptr;
			}
		}
	}
	return nullptr;
}
