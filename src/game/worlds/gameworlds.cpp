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
#include "game/game_definitions.hpp"

[[nodiscard]] const char* Worlds::getIp(uint16_t id) {
	return ip[id];
}

[[nodiscard]] uint16_t Worlds::getPort(uint16_t id) {
	return port[id];
}

[[nodiscard]] std::string Worlds::getName(uint16_t id) {
	return name[id];
}

[[nodiscard]] uint16_t Worlds::getId() const noexcept {
	return id;
}

void Worlds::setId(uint16_t newId) noexcept {
	id = newId;
}

void Worlds::setType(WorldType_t newType) noexcept {
	type = newType;
}

[[nodiscard]] WorldType_t Worlds::getType() const noexcept {
	return type;
}
