/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/worlds/gameworlds.hpp"
#include "io/iologindata.hpp"
#include "utils/tools.hpp"

void Worlds::load() {
	IOLoginData::createFirstWorld();
	worlds = IOLoginData::loadWorlds();
}

void Worlds::reload() {
	worlds.clear();
	load();
}

[[nodiscard]] std::shared_ptr<World> Worlds::getWorldConfigsById(uint8_t id) const {
	auto it = std::ranges::find_if(worlds, [id](const std::shared_ptr<World> &world) {
		return world->id == id;
	});

	if (it != worlds.end()) {
		return *it;
	}

	g_logger().error(fmt::format("World with the specified ID: {} not found", id));
	return nullptr;
}

void Worlds::setCurrentWorld(const std::shared_ptr<World> &world) {
	m_currentWorld = world;
}

const std::shared_ptr<World> &Worlds::getCurrentWorld() const {
	return m_currentWorld;
}

[[nodiscard]] WorldType_t Worlds::getWorldTypeIdByKey(const std::string &key) {
	const std::string worldType = asLowerCaseString(key);

	if (worldType == "pvp") {
		return WORLD_TYPE_PVP;
	} else if (worldType == "no-pvp") {
		return WORLD_TYPE_NO_PVP;
	} else if (worldType == "pvp-enforced") {
		return WORLD_TYPE_PVP_ENFORCED;
	} else if (worldType == "retro-pvp") {
		return WORLD_TYPE_RETRO_PVP;
	} else if (worldType == "retro-pvp-enforced") {
		return WORLD_TYPE_RETRO_PVP_ENFORCED;
	}

	g_logger().error("[{}] - Unable to get world type from string '{}'", __FUNCTION__, worldType);

	return WORLD_TYPE_NONE;
}

[[nodiscard]] Location_t Worlds::getWorldLocationByKey(const std::string &key) {
	const std::string location = asLowerCaseString(key);

	if (location == "europe") {
		return Location_t::Europe;
	} else if (location == "north america") {
		return Location_t::NorthAmerica;
	} else if (location == "south america") {
		return Location_t::SouthAmerica;
	} else if (location == "oceania") {
		return Location_t::Oceania;
	}

	g_logger().error("[{}] - Unable to get world location from string '{}'", __FUNCTION__, location);

	return Location_t::None;
}
