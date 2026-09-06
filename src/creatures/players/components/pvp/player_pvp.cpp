/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/components/pvp/player_pvp.hpp"

#include "creatures/players/components/pvp/expert_pvp.hpp"

bool PlayerPvp::isExpertPvpEnabled() const {
	return ExpertPvp::isEnabled();
}

PvpMode_t PlayerPvp::getMode() const {
	return m_mode;
}

ExpertPvpModeResult PlayerPvp::defaultModeForClient() const {
	return ExpertPvp::defaultModeForClient();
}

ExpertPvpModeResult PlayerPvp::modeFromClientByte(uint8_t rawMode) const {
	return ExpertPvp::modeFromClientByte(rawMode);
}

ExpertPvpModeResult PlayerPvp::normalizeMode(PvpMode_t requestedMode, ExpertPvpModeSource source) const {
	return ExpertPvp::normalizeMode(requestedMode, source);
}

ExpertPvpModeResult PlayerPvp::setMode(PvpMode_t requestedMode, ExpertPvpModeSource source) {
	auto result = normalizeMode(requestedMode, source);
	m_mode = result.mode;
	return result;
}
