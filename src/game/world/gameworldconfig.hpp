/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

struct GameWorld {
	std::string name = "";
	std::string ip = "";

	uint16_t worldId = 0;
	uint16_t port = 7171;
};

class GameWorldConfig {
public:
	static GameWorldConfig &getInstance();

	bool load();
	bool reload();
	[[nodiscard]] const char* getWorldIp(uint16_t id);
	[[nodiscard]] uint16_t getWorldPort(uint16_t id);
	[[nodiscard]] std::string getWorldName(uint16_t id);
	[[nodiscard]] uint16_t getWorldId() const noexcept;
	void setWorldId(uint16_t id) noexcept;

	[[nodiscard]] const std::vector<GameWorld> &getGameworlds() const noexcept {
		return gameworlds;
	}

private:
	std::vector<GameWorld> gameworlds;
	std::map<uint16_t, const char*> worldIp;
	std::map<uint16_t, std::string> worldName;
	std::map<uint16_t, uint16_t> worldPort;
	uint16_t worldId = 0;
	bool loaded = false;
};

constexpr auto g_gameworld = GameWorldConfig::getInstance;
