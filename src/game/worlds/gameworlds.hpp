/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct World {
	World(uint16_t id, std::string name, std::string ip, uint16_t port) :
		id(id), name(std::move(name)), ip(std::move(ip)), port(port) { }

	std::string name = "";
	std::string ip = "";

	uint16_t id = 0;
	uint16_t port = 7171;
};

class Worlds {
public:
	void setId(uint16_t id) noexcept;
	[[nodiscard]] const char* getIp(uint16_t id);
	[[nodiscard]] uint16_t getPort(uint16_t id);
	[[nodiscard]] std::string getName(uint16_t id);
	[[nodiscard]] uint16_t getId() const noexcept;
	void setType(WorldType_t type) noexcept;
	[[nodiscard]] WorldType_t getType() const noexcept;

	[[nodiscard]] const std::vector<World> &getWorlds() const noexcept {
		return worlds;
	}

private:
	std::vector<World> worlds;

	uint16_t id = 0;
	std::map<uint16_t, const char*> ip;
	std::map<uint16_t, std::string> name;
	WorldType_t type = WORLD_TYPE_PVP;
	std::map<uint16_t, uint16_t> port;
};
