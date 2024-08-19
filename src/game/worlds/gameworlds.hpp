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
	World(uint16_t id, std::string name, WorldType_t type, std::string ip, uint16_t port) :
		id(id), name(std::move(name)), type(type), ip(std::move(ip)), port(port) { }

	uint8_t id = 0;
	std::string name = "";
	WorldType_t type = WORLD_TYPE_PVP;
	std::string ip = "";
	uint16_t port = 7171;
};

class Worlds {
public:
	void load();
	void reload();

	[[nodiscard]] const std::shared_ptr<World> &getById(uint8_t id) const;
	void setId(uint8_t id);
	[[nodiscard]] uint8_t getId() const;
	void setIp(const std::string newIp);
	[[nodiscard]] const std::string &getIp() const;
	void setPort(uint16_t newPort);
	[[nodiscard]] uint16_t getPort() const;
	void setName(const std::string newName);
	[[nodiscard]] const std::string &getName() const;
	void setType(WorldType_t newType);
	[[nodiscard]] WorldType_t getType() const;

	[[nodiscard]] static WorldType_t getTypeByString(const std::string &type);

	[[nodiscard]] const std::vector<std::shared_ptr<World>> &getWorlds() const noexcept {
		return worlds;
	}

private:
	std::vector<std::shared_ptr<World>> worlds;

	std::shared_ptr<World> thisWorld = std::make_shared<World>();
};
