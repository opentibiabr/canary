/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/components/pvp/expert_pvp_definitions.hpp"

class Player;

class PlayerPvp {
public:
	explicit PlayerPvp(Player &initPlayer);

	[[nodiscard]] bool isExpertPvpEnabled() const;
	[[nodiscard]] ExpertPvpModeResult defaultModeForClient() const;
	[[nodiscard]] ExpertPvpModeResult modeFromClientByte(uint8_t rawMode) const;
	[[nodiscard]] ExpertPvpModeResult normalizeMode(PvpMode_t requestedMode, ExpertPvpModeSource source = ExpertPvpModeSource::StoredPlayerState) const;

private:
	Player &m_player;
};
