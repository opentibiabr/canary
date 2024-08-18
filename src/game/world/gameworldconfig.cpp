/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lib/di/container.hpp"
#include "utils/tools.hpp"
#include "game/world/gameworldconfig.hpp"
#include "utils/pugicast.hpp"
#include "config/configmanager.hpp"

GameWorldConfig &GameWorldConfig::getInstance() {
	return inject<GameWorldConfig>();
}

[[nodiscard]] const char* GameWorldConfig::getWorldIp(uint16_t id) {
	return worldIp[id];
}

[[nodiscard]] uint16_t GameWorldConfig::getWorldPort(uint16_t id) {
	return worldPort[id];
}

[[nodiscard]] std::string GameWorldConfig::getWorldName(uint16_t id) {
	return worldName[id];
}

[[nodiscard]] uint16_t GameWorldConfig::getWorldId() const noexcept {
	return worldId;
}

void GameWorldConfig::setWorldId(uint16_t id) noexcept {
	worldId = id;
}

bool GameWorldConfig::reload() {
	gameworlds.clear();
	return loadFromXml();
}
