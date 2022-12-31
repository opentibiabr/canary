/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "creatures/appearance/mounts/mounts.h"
#include "game/game.h"
#include "utils/pugicast.h"
#include "utils/tools.h"

bool Mounts::reload()
{
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml()
{
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/mounts.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto mountNode : doc.child("mounts").children()) {
		pugi::xml_attribute clientIdAttribute = mountNode.attribute("clientid");
		auto clientId = static_cast<uint16_t>(clientIdAttribute.as_uint());
		const std::string mountName = mountNode.attribute("name").as_string();
		if (!clientIdAttribute.empty()) {
			if (g_configManager().getBoolean(WARN_UNSAFE_SCRIPTS) && clientId != 0
			&& !g_game().isLookTypeRegistered(clientId))
			{
				SPDLOG_WARN("[Mounts::loadFromXml] An unregistered creature clientid type with id '{}' was blocked to prevent client crash.", clientId);
				return false;
			}

			const std::string clientIdString = clientIdAttribute.as_string();
			if (clientIdString.empty() || clientId == 0) {
				SPDLOG_WARN("[Mounts::loadFromXml] - Empty clientid on mount with name {}", mountName);
				continue;
			}

			if (!isNumber(clientIdString)) {
				SPDLOG_WARN("[Mounts::loadFromXml] - Invalid clientid {} with name {}", clientIdString, mountName);
				continue;
			}

			if (pugi::xml_attribute nameAttribute = mountNode.attribute("name");
			!nameAttribute || mountName.empty())
			{
				SPDLOG_WARN("[Mounts::loadFromXml] - Missing or empty name on mount with clientid {}", clientIdString);
				continue;
			}

			mounts.emplace_back(
				static_cast<uint8_t>(mountNode.attribute("id").as_uint()),
				clientId,
				mountName,
				mountNode.attribute("speed").as_int(),
				mountNode.attribute("premium").as_bool(),
				mountNode.attribute("type").as_string()
			);
		} else {
			SPDLOG_WARN("[Mounts::loadFromXml] - "
						"Missing clientid id for mount name: {}", mountName);
		}
	}
	mounts.shrink_to_fit();
	return true;
}

Mount* Mounts::getMountByID(uint8_t id)
{
	auto it = std::ranges::find_if(mounts.begin(), mounts.end(), [id](const Mount& mount) {
		return mount.id == id;
	});

	return it != mounts.end() ? std::to_address(it) : nullptr;
}

Mount* Mounts::getMountByName(const std::string& name) {
	auto mountName = name.c_str();
	for (auto& it : mounts) {
		if (strcasecmp(mountName, it.name.c_str()) == 0) {
			return &it;
		}
	}

	return nullptr;
}

Mount* Mounts::getMountByClientID(uint16_t clientId)
{
	auto it = std::ranges::find_if(mounts.begin(), mounts.end(), [clientId](const Mount& mount) {
		return mount.clientId == clientId;
	});

	return it != mounts.end() ? std::to_address(it) : nullptr;
}
