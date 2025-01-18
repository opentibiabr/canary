/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/grouping/familiars.hpp"

#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"
#include <creatures/creatures_definitions.hpp>

std::vector<std::shared_ptr<Familiar>> familiars[VOCATION_LAST + 1];

Familiars &Familiars::getInstance() {
	return inject<Familiars>();
}

bool Familiars::reload() {
	for (auto &familiarsVector : familiars) {
		familiarsVector.clear();
	}
	return loadFromXml();
}

std::vector<std::shared_ptr<Familiar>> &Familiars::getFamiliars(uint16_t vocation) {
	return familiars[vocation];
}

bool Familiars::loadFromXml() {
	pugi::xml_document doc;
	const auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/familiars.xml";
	const pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		g_logger().error("Failed to load Familiars");
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (const auto &familiarsNode : doc.child("familiars").children()) {
		pugi::xml_attribute attr;
		if ((attr = familiarsNode.attribute("enabled") && !attr.as_bool())) {
			continue;
		}

		if (!((attr = familiarsNode.attribute("vocation")))) {
			g_logger().warn("[Familiars::loadFromXml] - Missing familiar vocation.");
			continue;
		}

		auto vocation = pugi::cast<uint16_t>(attr.value());
		if (vocation > VOCATION_LAST) {
			g_logger().warn("[Familiars::loadFromXml] - Invalid familiar vocation {}", vocation);
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = familiarsNode.attribute("lookType");
		if (!lookTypeAttribute) {
			g_logger().warn("[Familiars::loadFromXml] - Missing looktype on familiar.");
			continue;
		}

		familiars[vocation].emplace_back(std::make_shared<Familiar>(
			familiarsNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			familiarsNode.attribute("premium").as_bool(),
			familiarsNode.attribute("unlocked").as_bool(true),
			familiarsNode.attribute("type").as_string()
		));
	}
	for (uint16_t vocation = VOCATION_NONE; vocation <= VOCATION_LAST; ++vocation) {
		familiars[vocation].shrink_to_fit();
	}
	return true;
}

std::shared_ptr<Familiar> Familiars::getFamiliarByLookType(uint16_t vocation, uint16_t lookType) const {
	if (auto it = std::ranges::find_if(familiars[vocation], [lookType](const auto &familiar_it) {
			return familiar_it->lookType == lookType;
		});
	    it != familiars[vocation].end()) {
		return *it;
	}
	return nullptr;
}
