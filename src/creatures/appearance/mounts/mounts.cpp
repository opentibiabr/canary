/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

bool Mounts::reload() {
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml() {
	pugi::xml_document doc;
	const auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/mounts.xml";
	const pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (const auto &mountNode : doc.child("mounts").children()) {
		const auto lookType = pugi::cast<uint16_t>(mountNode.attribute("clientid").value());
		if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && lookType != 0 && !g_game().isLookTypeRegistered(lookType)) {
			g_logger().warn("{} - An unregistered creature mount with id '{}' was blocked to prevent client crash.", __FUNCTION__, lookType);
			continue;
		}

		mounts.emplace(std::make_shared<Mount>(
			static_cast<uint8_t>(pugi::cast<uint16_t>(mountNode.attribute("id").value())),
			lookType,
			mountNode.attribute("name").as_string(),
			pugi::cast<int32_t>(mountNode.attribute("speed").value()),
			mountNode.attribute("premium").as_bool(),
			mountNode.attribute("type").as_string()
		));
	}
	return true;
}

std::shared_ptr<Mount> Mounts::getMountByID(uint8_t id) {
	const auto it = std::ranges::find_if(mounts, [id](const auto &mount) {
		return mount->id == id; // Note the use of -> operator to access the members of the Mount object
	});

	return it != mounts.end() ? *it : nullptr; // Returning the shared_ptr to the Mount object
}

std::shared_ptr<Mount> Mounts::getMountByName(const std::string &name) {
	auto mountName = name.c_str();
	const auto it = std::ranges::find_if(mounts, [mountName](const auto &mount) {
		return strcasecmp(mountName, mount->name.c_str()) == 0;
	});

	return it != mounts.end() ? *it : nullptr;
}

std::shared_ptr<Mount> Mounts::getMountByClientID(uint16_t clientId) {
	const auto it = std::ranges::find_if(mounts, [clientId](const auto &mount) {
		return mount->clientId == clientId; // Note the use of -> operator to access the members of the Mount object
	});

	return it != mounts.end() ? *it : nullptr; // Returning the shared_ptr to the Mount object
}
