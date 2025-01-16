/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "utils/pugicast.hpp"
#include "utils/tools.hpp"

namespace ParsePlayerFlagMap {
	// Initialize the map with all the values from the PlayerFlags_t enumeration
	phmap::flat_hash_map<std::string, PlayerFlags_t> initParsePlayerFlagMap() {
		phmap::flat_hash_map<std::string, PlayerFlags_t> map;
		// Iterate through all values of the PlayerFlags_t enumeration
		for (auto value : magic_enum::enum_values<PlayerFlags_t>()) {
			// Get the string representation of the current enumeration value
			std::string name(magic_enum::enum_name(value).data());
			// Convert the string to lowercase
			std::ranges::transform(name.begin(), name.end(), name.begin(), ::tolower);
			// Add the current value to the map with its lowercase string representation as the key
			map[name] = value;
		}

		return map;
	}

	const phmap::flat_hash_map<std::string, PlayerFlags_t> parsePlayerFlagMap = initParsePlayerFlagMap();
}

uint8_t Groups::getFlagNumber(PlayerFlags_t playerFlags) {
	return magic_enum::enum_integer(playerFlags);
}

PlayerFlags_t Groups::getFlagFromNumber(uint8_t value) {
	return magic_enum::enum_value<PlayerFlags_t>(value);
}

bool Groups::reload() {
	// Clear groups
	g_game().groups.getGroups().clear();
	return g_game().groups.load();
}

void parseGroupFlags(Group &group, const pugi::xml_node &groupNode) {
	if (pugi::xml_node node = groupNode.child("flags")) {
		for (auto flagNode : node.children()) {
			pugi::xml_attribute attr = flagNode.first_attribute();
			if (!attr || !attr.as_bool()) {
				continue;
			}

			// Ensure always send the string completely in lower case
			std::string string = asLowerCaseString(attr.name());
			auto parseFlag = ParsePlayerFlagMap::parsePlayerFlagMap.find(string);
			if (parseFlag != ParsePlayerFlagMap::parsePlayerFlagMap.end()) {
				group.flags[Groups::getFlagNumber(parseFlag->second)] = true;
			}
		}
	}
}

bool Groups::load() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/groups.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	for (auto groupNode : doc.child("groups").children()) {
		Group group;
		group.id = pugi::cast<uint32_t>(groupNode.attribute("id").value());
		group.name = groupNode.attribute("name").as_string();
		group.access = groupNode.attribute("access").as_bool();
		group.maxDepotItems = pugi::cast<uint32_t>(groupNode.attribute("maxdepotitems").value());
		group.maxVipEntries = pugi::cast<uint32_t>(groupNode.attribute("maxvipentries").value());
		auto flagsInt = static_cast<uint8_t>(groupNode.attribute("flags").as_uint());
		std::bitset<magic_enum::enum_integer(PlayerFlags_t::FlagLast)> flags(flagsInt);
		for (uint8_t i = 0; i < getFlagNumber(PlayerFlags_t::FlagLast); i++) {
			PlayerFlags_t flag = getFlagFromNumber(i);
			group.flags[i] = flags[Groups::getFlagNumber(flag)];
		}

		// Parsing group flags
		parseGroupFlags(group, groupNode);

		groups_vector.emplace_back(std::make_shared<Group>(group));
	}
	groups_vector.shrink_to_fit();
	return true;
}

std::shared_ptr<Group> Groups::getGroup(uint16_t id) const {
	if (auto it = std::find_if(groups_vector.begin(), groups_vector.end(), [id](auto group_it) {
			return group_it->id == id;
		});
	    it != groups_vector.end()) {
		return *it;
	}
	return nullptr;
}
