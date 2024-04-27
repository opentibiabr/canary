/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/appearance/outfit/outfit.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"
#include "game/game.hpp"

Outfits &Outfits::getInstance() {
	return inject<Outfits>();
}

bool Outfits::reload() {
	for (auto &outfitsVector : outfits) {
		outfitsVector.clear();
	}
	return loadFromXml();
}

bool Outfits::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/outfits.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto outfitNode : doc.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			g_logger().warn("[Outfits::loadFromXml] - Missing outfit type");
			continue;
		}

		auto type = pugi::cast<uint16_t>(attr.value());
		if (type > PLAYERSEX_LAST) {
			g_logger().warn("[Outfits::loadFromXml] - Invalid outfit type {}", type);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		if (!lookTypeAttribute) {
			g_logger().warn("[Outfits::loadFromXml] - Missing looktype on outfit");
			continue;
		}

		if (auto lookType = pugi::cast<uint16_t>(lookTypeAttribute.value());
			g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS, __FUNCTION__) && lookType != 0
			&& !g_game().isLookTypeRegistered(lookType)) {
			g_logger().warn("[Outfits::loadFromXml] An unregistered creature looktype type with id '{}' was ignored to prevent client crash.", lookType);
			continue;
		}

		outfits[type].emplace_back(std::make_shared<Outfit>(
			outfitNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true),
			outfitNode.attribute("from").as_string()
		));
	}
	for (uint8_t sex = PLAYERSEX_FEMALE; sex <= PLAYERSEX_LAST; ++sex) {
		outfits[sex].shrink_to_fit();
	}
	return true;
}

std::shared_ptr<Outfit> Outfits::getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const {
	auto it = std::ranges::find_if(outfits[sex], [&lookType](const auto &outfit) {
		return outfit->lookType == lookType;
	});

	if (it != outfits[sex].end()) {
		return *it;
	}
	return nullptr;
}

/**
 * Get the oposite sex equivalent outfit
 * @param sex current sex
 * @param lookType current looktype
 * @return <b>const</b> pointer to the outfit or <b>nullptr</b> if it could not be found.
 */
[[maybe_unused]] std::shared_ptr<Outfit> Outfits::getOpositeSexOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const {
	PlayerSex_t searchSex = (sex == PLAYERSEX_MALE) ? PLAYERSEX_FEMALE : PLAYERSEX_MALE;
	return getOutfitByLookType(searchSex, lookType);
}
