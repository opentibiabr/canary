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

bool GameWorldConfig::load() {
	pugi::xml_document doc;
	const auto folder = fmt::format("{}/XML/gameworlds.xml", g_configManager().getString(CORE_DIRECTORY, __FUNCTION__));
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	gameworlds.clear();

	for (auto worldNode : doc.child("worlds").children()) {
		GameWorld gameWorld;

		// Normal handling values
		gameWorld.name = worldNode.attribute("name").as_string();
		gameWorld.ip = worldNode.attribute("ip").as_string();
		gameWorld.port = pugi::cast<uint16_t>(worldNode.attribute("port").value());
		gameWorld.worldId = pugi::cast<uint16_t>(worldNode.attribute("id").value());

		// Stored values to use later
		std::string oldIp = gameWorld.ip;
		const char* serverIp = oldIp.c_str();
		worldIp[gameWorld.worldId] = serverIp;
		worldPort[gameWorld.worldId] = gameWorld.port;
		worldName[gameWorld.worldId] = gameWorld.name;

		gameworlds.emplace_back(gameWorld);
	}

	loaded = true;
	return true;
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
	return load();
}
