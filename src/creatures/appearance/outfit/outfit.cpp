/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "creatures/appearance/outfit/outfit.h"

#include "utils/tools.h"
#include "game/game.h"

#include <cctype>

bool Outfits::parseOutfitNode()
{
	pugi::xml_document document;
	for (auto outfitNode : document.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Missing outfit type");
			continue;
		}

		auto type = static_cast<uint8_t>(outfitNode.attribute("type").as_uint());
		if (type > PLAYERSEX_LAST) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Invalid outfit type {}", type);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		auto lookType = static_cast<uint16_t>(lookTypeAttribute.as_uint());
		const std::string outfitName = outfitNode.attribute("name").as_string();
		if (lookTypeAttribute.empty()) {
			SPDLOG_WARN("[Outfits::loadFromXml] - "
						"Missing looktype id for outfit name: {}", outfitName);
			continue;
		}

		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0
		&& !g_game().isLookTypeRegistered(lookType))
		{
			SPDLOG_WARN("[Outfits::loadFromXml] An unregistered creature looktype type with id '{}' was blocked to prevent client crash.", lookType);
			continue;
		}

		const std::string lookTypeString = lookTypeAttribute.as_string();
		if (lookTypeString.empty() || lookType == 0) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Empty looktype on outfit with name {}", outfitName);
			continue;
		}

		if (!isNumber(lookTypeString)) {
			SPDLOG_WARN("[Outfits::loadFromXml] - Invalid looktype {} with name {}", lookTypeString, outfitName);
			continue;
		}

		if (pugi::xml_attribute nameAttribute = outfitNode.attribute("name");
		!nameAttribute || outfitName.empty())
		{
			SPDLOG_WARN("[Outfits::loadFromXml] - Missing or empty name on outfit with looktype {}", lookTypeString);
			continue;
		}

		outfits[type].emplace_back(
			outfitName,
			lookType,
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true),
			outfitNode.attribute("from").as_string()
		);
	}
	return true;
}

bool Outfits::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/outfits.xml");
	if (!result) {
		printXMLError("[Outfits::loadFromXml] - ", "data/XML/outfits.xml", result);
		return false;
	}

	if (!parseOutfitNode()) {
		SPDLOG_ERROR("[Outfits::loadFromXml] - Error to load outfit node");
		return false;
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
