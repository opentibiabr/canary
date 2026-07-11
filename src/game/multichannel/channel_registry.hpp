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
	#include <mutex>
	#include <optional>
	#include <string>
	#include <vector>
#endif

// One row of the `channels` table (see docs/multichannel/ARCHITECTURE.md §3.3).
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

// In-memory view of the `channels` table, the authoritative registry of every
// channel in the cluster (docs/multichannel/ARCHITECTURE.md §3.3). Loaded
// from the database; never guesses configuration on its own except for the
// one-time Channel 1 bootstrap described in docs/multichannel/MIGRATION.md.
class ChannelRegistry {
public:
	ChannelRegistry() = default;

	// Singleton - ensures we don't accidentally copy it.
	ChannelRegistry(const ChannelRegistry &) = delete;
	ChannelRegistry &operator=(const ChannelRegistry &) = delete;

	static ChannelRegistry &getInstance();

	// Reloads the full channel list from the database. Returns false (and
	// leaves the previous in-memory list untouched) if the query fails, so a
	// transient DB hiccup never wipes out a previously-good registry.
	bool reload();

	[[nodiscard]] std::optional<ChannelInfo> getChannel(int32_t channelId) const;

	// Channels eligible to appear on the login gateway's world list: enabled,
	// not in maintenance, ordered by sort_order then id.
	[[nodiscard]] std::vector<ChannelInfo> getLoginListChannels() const;

	[[nodiscard]] std::size_t size() const;

	// If multiChannelEnabled is true, the resolved channel id is 1, and no row
	// for id 1 exists yet, inserts one derived from the current ConfigManager
	// values (SERVER_NAME/IP/GAME_PORT/STATUS_PORT/worldType). No-op
	// otherwise. See docs/multichannel/MIGRATION.md for why this can't be
	// done from the SQL migration itself.
	bool ensureBootstrapChannel();

	// Deterministic FNV-1a 64-bit hash of a file's contents, hex-encoded.
	// Used to detect map/data incompatibility across channels (spec §3.5).
	// Pure and side-effect free so it's unit-testable without a real map file.
	static std::string computeFileHash(const std::string &filePath);
	static std::string hashBytes(const unsigned char* data, std::size_t length);

	// Test-only: replace the in-memory list without touching the database.
	void setChannelsForTesting(std::vector<ChannelInfo> testChannels);

private:
	mutable std::mutex mutex;
	std::vector<ChannelInfo> channels;
};

constexpr auto g_channelRegistry = ChannelRegistry::getInstance;
