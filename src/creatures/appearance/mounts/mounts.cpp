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

#include "creatures/appearance/mounts/mounts.h"
#include "game/game.h"

#include "utils/tools.h"

#include <string>
#include <ranges>

bool Mounts::reload()
{
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/mounts.xml");
	if (!result) {
		printXMLError("Mounts::loadFromXml", "data/XML/mounts.xml", result);
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
		} else {
			SPDLOG_WARN("[Mounts::loadFromXml] - "
						"Missing clientid id for mount name: {}", mountName);
		}

		mounts.emplace_back(
			static_cast<uint8_t>(mountNode.attribute("id").as_uint()),
			static_cast<uint16_t>(mountNode.attribute("clientid").as_uint()),
			mountNode.attribute("name").as_string(),
			mountNode.attribute("speed").as_int(),
			mountNode.attribute("premium").as_bool(),
			mountNode.attribute("type").as_string()
		);
	}
	mounts.shrink_to_fit();
	return true;
}

Mount* Mounts::getMountByID(uint8_t id)
{
	auto it = std::ranges::find_if(mounts.begin(), mounts.end(), [id](const Mount& mount) {
		return mount.id == id;
	});

	return it != mounts.end() ? &*it : nullptr;
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
