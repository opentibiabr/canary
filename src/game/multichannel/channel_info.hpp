/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <optional>
	#include <string>
#endif

// One row of the `channels` table (see docs/multichannel/ARCHITECTURE.md
// §3.3). Deliberately kept in its own header, separate from ChannelRegistry:
// several lightweight, dependency-free modules (e.g. ClusterConfigValidator)
// only need this plain data struct, not the DI-backed registry singleton.
struct ChannelInfo {
	int32_t id = 0;
	std::string name;
	std::string pvpType = "pvp";
	std::string externalHost = "127.0.0.1";
	int32_t gamePort = 0;
	int32_t statusPort = 0;
	int32_t maxPlayers = 0;
	bool enabled = true;
	int32_t sortOrder = 0;
	std::optional<int32_t> templeTownId;
	bool maintenance = false;
	std::string maintenanceMessage;
	bool loginGateway = false;
	std::string mapHash;

	[[nodiscard]] bool isValidPvpType() const {
		return pvpType == "no-pvp" || pvpType == "pvp" || pvpType == "pvp-enforced";
	}

	// A channel is offerable on the login list when it is enabled and not
	// under maintenance. Liveness (heartbeat) and capacity are checked
	// separately against the runtime registry, not here.
	[[nodiscard]] bool isSelectable() const {
		return enabled && !maintenance;
	}
};
