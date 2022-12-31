/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "town.h"

Town::Town(uint32_t initId) : id(initId) {}

Town::Town(uint32_t initTownId, const std::string &initTownName, const Position &initPosition) : id(initTownId), name(initTownName), templePosition(initPosition)
{
	if (name.empty())
	{
		SPDLOG_WARN("{} - Town {} was created with invalid name.", __FUNCTION__, this->id);
	}

	if (templePosition.x == 0 || templePosition.y == 0 || templePosition.z == 0)
	{
		SPDLOG_WARN("{} - Town {} was created with invalid temple position.", __FUNCTION__, this->id);
	}
}

bool Towns::addTown(uint32_t townId, Town* town) {
	return townMap.emplace(townId, town).second;
}

Town* Towns::getTown(const std::string& townName) const {
	for (const auto& [townId, town] : townMap) {
		if (strcasecmp(townName.c_str(), town->getName().c_str()) == 0) {
			return town;
		}
	}
	return nullptr;
}

Town* Towns::getTown(uint32_t townId) const {
	auto it = townMap.find(townId);
	if (it == townMap.end()) {
		return nullptr;
	}
	return it->second;
}

const std::map<uint32_t, Town*>& Towns::getTowns() const {
	return townMap;
}
