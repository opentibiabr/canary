/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/game_definitions.hpp"

#pragma once

struct World {
	World() = default;
	World(uint8_t id, std::string name, WorldType_t type, std::string motd, std::string locationName, Location_t location, std::string ip, uint16_t port, uint32_t port_status, uint16_t creation) :
		id(id), name(std::move(name)), type(type), motd(std::move(motd)), locationName(std::move(locationName)), location(location), ip(std::move(ip)), port(port), portStatus(port_status), creation(creation) { }

	uint8_t id = 0;
	std::string name;
	WorldType_t type = WORLD_TYPE_PVP;
	std::string motd;
	std::string locationName;
	Location_t location = LOCATION_SOUTH_AMERICA;
	std::string ip;
	uint16_t port = 7172;
	uint32_t portStatus = 97172;
	uint16_t creation = 0;

	bool operator==(const World &other) const {
		return id == other.id;
	}
};

namespace std {
	template <>
	struct hash<World> {
		std::size_t operator()(const World &w) const {
			return hash<uint8_t>()(w.id);
		}
	};
}

class Worlds {
public:
	void load();
	void reload();

	[[nodiscard]] std::shared_ptr<World> getWorldConfigsById(uint8_t id) const;
	void setCurrentWorld(const std::shared_ptr<World> &world);
	[[nodiscard]] const std::shared_ptr<World> &getCurrentWorld() const;
	[[nodiscard]] static WorldType_t getWorldTypeIdByKey(const std::string &key);
	[[nodiscard]] static Location_t getWorldLocationByKey(const std::string &key);
	[[nodiscard]] const std::vector<std::shared_ptr<World>> &getWorlds() const noexcept {
		return worlds;
	}

private:
	std::vector<std::shared_ptr<World>> worlds;
	std::shared_ptr<World> m_currentWorld = std::make_shared<World>();
};
