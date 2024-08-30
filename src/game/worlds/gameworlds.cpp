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

[[nodiscard]] const std::shared_ptr<World> &Worlds::getById(uint8_t id) const {
	auto it = std::find_if(worlds.begin(), worlds.end(), [id](const std::shared_ptr<World> &world) {
		return world->id == id;
	});

	return it != worlds.end() ? (*it) : nullptr;
}

void Worlds::setId(uint8_t newId) {
	thisWorld->id = newId;
}

[[nodiscard]] uint8_t Worlds::getId() const {
	return thisWorld->id;
}

void Worlds::setName(const std::string newName) {
	thisWorld->name = newName;
}

[[nodiscard]] const std::string &Worlds::getName() const {
	return thisWorld->name;
}

void Worlds::setType(WorldType_t newType) {
	thisWorld->type = newType;
}

[[nodiscard]] WorldType_t Worlds::getType() const {
	return thisWorld->type;
}

void Worlds::setMotd(const std::string newMotd) {
	thisWorld->motd = newMotd;
}

[[nodiscard]] const std::string &Worlds::getMotd() const {
	return thisWorld->motd;
}

void Worlds::setLocation(Location_t newLocation) {
	thisWorld->location = newLocation;
}

[[nodiscard]] Location_t Worlds::getLocation() const {
	return thisWorld->location;
}

void Worlds::setIp(const std::string newIp) {
	thisWorld->ip = newIp;
}

[[nodiscard]] const std::string &Worlds::getIp() const {
	return thisWorld->ip;
}

void Worlds::setPort(uint16_t newPort) {
	thisWorld->port = newPort;
}

[[nodiscard]] uint16_t Worlds::getPort() const {
	return thisWorld->port;
}

void Worlds::setCreation(uint16_t creation) {
	thisWorld->creation = creation;
}

[[nodiscard]] uint16_t Worlds::getCreation() const {
	return thisWorld->creation;
}

[[nodiscard]] WorldType_t Worlds::getTypeByString(const std::string &type) {
	const std::string worldType = asLowerCaseString(type);

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

[[nodiscard]] Location_t Worlds::getLocationCode(const std::string &location) {
	const std::string location_ = asLowerCaseString(location);

	if (location_ == "europe") {
		return LOCATION_EUROPE;
	} else if (location_ == "north america") {
		return LOCATION_NORTH_AMERICA;
	} else if (location_ == "south america") {
		return LOCATION_SOUTH_AMERICA;
	} else if (location_ == "oceania") {
		return LOCATION_OCEANIA;
	}

	g_logger().error("[{}] - Unable to get world location from string '{}'", __FUNCTION__, location_);

	return LOCATION_NONE;
}
