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
	World(uint8_t id, std::string name, WorldType_t type, std::string motd, Location_t location, std::string ip, uint16_t port, uint16_t creation) :
		id(id), name(std::move(name)), type(type), motd(std::move(motd)), location(location), ip(std::move(ip)), port(port), creation(creation) { }

	uint8_t id = 0;
	std::string name;
	WorldType_t type = WORLD_TYPE_PVP;
	std::string motd;
	Location_t location = LOCATION_SOUTH_AMERICA;
	std::string ip;
	uint16_t port = 7171;
	uint16_t creation = 0;
};

class Worlds {
public:
	void load();
	void reload();

	[[nodiscard]] const std::shared_ptr<World> &getById(uint8_t id) const;
	void setId(uint8_t id);
	[[nodiscard]] uint8_t getId() const;
	void setName(const std::string newName);
	[[nodiscard]] const std::string &getName() const;
	void setType(WorldType_t newType);
	[[nodiscard]] WorldType_t getType() const;
	void setMotd(const std::string newMotd);
	[[nodiscard]] const std::string &getMotd() const;
	void setLocation(Location_t newLocation);
	[[nodiscard]] Location_t getLocation() const;
	void setIp(const std::string newIp);
	[[nodiscard]] const std::string &getIp() const;
	void setPort(uint16_t newPort);
	[[nodiscard]] uint16_t getPort() const;
	void setCreation(uint16_t creation);
	[[nodiscard]] uint16_t getCreation() const;

	[[nodiscard]] static WorldType_t getTypeByString(const std::string &type);

	[[nodiscard]] static Location_t getLocationCode(const std::string &location);

	[[nodiscard]] const std::vector<std::shared_ptr<World>> &getWorlds() const noexcept {
		return worlds;
	}

private:
	std::vector<std::shared_ptr<World>> worlds;

	std::shared_ptr<World> thisWorld = std::make_shared<World>();
};
