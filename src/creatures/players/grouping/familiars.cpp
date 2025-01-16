/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/grouping/familiars.hpp"
#include "lib/di/container.hpp"
#include "config/configmanager.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

Familiars &Familiars::getInstance() {
	return inject<Familiars>();
}

bool Familiars::reload() {
	for (auto &familiarsVector : familiars) {
		familiarsVector.clear();
	}
	return loadFromXml();
}

bool Familiars::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/familiars.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		g_logger().error("Failed to load Familiars");
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto familiarsNode : doc.child("familiars").children()) {
		pugi::xml_attribute attr;
		if ((attr = familiarsNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = familiarsNode.attribute("vocation"))) {
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
	if (auto it = std::find_if(familiars[vocation].begin(), familiars[vocation].end(), [lookType](auto familiar_it) {
			return familiar_it->lookType == lookType;
		});
	    it != familiars[vocation].end()) {
		return *it;
	}
	return nullptr;
}
