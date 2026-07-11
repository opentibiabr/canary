/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_registry.hpp"

#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "game/multichannel/channel_context.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <fstream>
	#include <sstream>
#endif

ChannelRegistry &ChannelRegistry::getInstance() {
	return inject<ChannelRegistry>();
}

namespace {
	// `channels.temple_town_id` is nullable; the DBResult API surfaced by this
	// codebase collapses NULL and 0 into the same T() default rather than
	// exposing a distinct null check, and town id 0 is never a real town, so
	// treating 0 as "unset" is the safe, spec-consistent interpretation here.
	std::optional<int32_t> optionalIntColumn(const DBResult_ptr &result, const std::string &column) {
		const auto value = result->getNumber<int32_t>(column);
		if (value == 0) {
			return std::nullopt;
		}
		return value;
	}
} // namespace

bool ChannelRegistry::reload() {
	Database &db = Database::getInstance();
	const DBResult_ptr result = db.storeQuery("SELECT `id`, `name`, `pvp_type`, `external_host`, `game_port`, `status_port`, `max_players`, `enabled`, `sort_order`, `temple_town_id`, `maintenance`, `maintenance_message`, `login_gateway`, `map_hash` FROM `channels`;");
	if (!result) {
		g_logger().error("[ChannelRegistry::reload] - Failed to query channels table; keeping previous in-memory registry ({} channel(s)).", channels.size());
		return false;
	}

	std::vector<ChannelInfo> loaded;
	do {
		ChannelInfo info;
		info.id = result->getNumber<int32_t>("id");
		info.name = result->getString("name");
		info.pvpType = result->getString("pvp_type");
		info.externalHost = result->getString("external_host");
		info.gamePort = result->getNumber<int32_t>("game_port");
		info.statusPort = result->getNumber<int32_t>("status_port");
		info.maxPlayers = result->getNumber<int32_t>("max_players");
		info.enabled = result->getNumber<int32_t>("enabled") != 0;
		info.sortOrder = result->getNumber<int32_t>("sort_order");
		info.templeTownId = optionalIntColumn(result, "temple_town_id");
		info.maintenance = result->getNumber<int32_t>("maintenance") != 0;
		info.maintenanceMessage = result->getString("maintenance_message");
		info.loginGateway = result->getNumber<int32_t>("login_gateway") != 0;
		info.mapHash = result->getString("map_hash");

		if (!info.isValidPvpType()) {
			g_logger().error("[ChannelRegistry::reload] - Channel id {} has an invalid pvp_type '{}', skipping it.", info.id, info.pvpType);
			continue;
		}

		loaded.emplace_back(std::move(info));
	} while (result->next());

	std::lock_guard lock(mutex);
	channels = std::move(loaded);
	return true;
}

std::optional<ChannelInfo> ChannelRegistry::getChannel(int32_t channelId) const {
	std::lock_guard lock(mutex);
	const auto it = std::find_if(channels.begin(), channels.end(), [channelId](const ChannelInfo &info) {
		return info.id == channelId;
	});
	if (it == channels.end()) {
		return std::nullopt;
	}
	return *it;
}

std::vector<ChannelInfo> ChannelRegistry::getLoginListChannels() const {
	std::vector<ChannelInfo> selectable;
	{
		std::lock_guard lock(mutex);
		for (const auto &info : channels) {
			if (info.isSelectable()) {
				selectable.push_back(info);
			}
		}
	}
	std::sort(selectable.begin(), selectable.end(), [](const ChannelInfo &a, const ChannelInfo &b) {
		if (a.sortOrder != b.sortOrder) {
			return a.sortOrder < b.sortOrder;
		}
		return a.id < b.id;
	});
	return selectable;
}

std::size_t ChannelRegistry::size() const {
	std::lock_guard lock(mutex);
	return channels.size();
}

bool ChannelRegistry::ensureBootstrapChannel() {
	if (!g_configManager().getBoolean(MULTICHANNEL_ENABLED)) {
		return true;
	}
	if (g_channelContext().getChannelId() != ChannelContext::DefaultSingleChannelId) {
		// Only the bootstrap process (channel 1) is allowed to auto-create a
		// row; every other channel must be configured explicitly by the
		// operator (see docs/multichannel/MIGRATION.md).
		return true;
	}

	Database &db = Database::getInstance();
	const DBResult_ptr existing = db.storeQuery("SELECT `id` FROM `channels` WHERE `id` = 1 LIMIT 1;");
	if (existing) {
		return true;
	}

	const std::string name = "Channel 1";
	const std::string pvpType = g_configManager().getString(WORLD_TYPE);
	const std::string host = g_configManager().getString(IP);
	const int32_t gamePort = g_configManager().getNumber(GAME_PORT);
	const int32_t statusPort = g_configManager().getNumber(STATUS_PORT);

	std::ostringstream query;
	query << "INSERT INTO `channels` (`id`, `name`, `pvp_type`, `external_host`, `game_port`, `status_port`, `max_players`, `enabled`, `sort_order`, `maintenance`, `maintenance_message`, `login_gateway`, `map_hash`, `created_at`, `updated_at`) VALUES ("
		  << "1, "
		  << db.escapeString(name) << ", "
		  << db.escapeString(pvpType) << ", "
		  << db.escapeString(host) << ", "
		  << gamePort << ", "
		  << statusPort << ", "
		  << "0, 1, 0, 0, '', 1, '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP());";

	if (!db.executeQuery(query.str())) {
		g_logger().error("[ChannelRegistry::ensureBootstrapChannel] - Failed to insert bootstrap Channel 1 row.");
		return false;
	}

	g_logger().info("[ChannelRegistry::ensureBootstrapChannel] - Seeded Channel 1 ('{}', {}:{}, pvp_type={}) from current config.lua.", name, host, gamePort, pvpType);
	return reload();
}

std::string ChannelRegistry::hashBytes(const unsigned char* data, std::size_t length) {
	// FNV-1a 64-bit. Not a cryptographic hash - this is a compatibility
	// fingerprint (spec §3.5), not a security boundary, so a fast,
	// dependency-free, deterministic hash is the right tool.
	constexpr uint64_t offsetBasis = 0xcbf29ce484222325ULL;
	constexpr uint64_t prime = 0x100000001b3ULL;

	uint64_t hash = offsetBasis;
	for (std::size_t i = 0; i < length; ++i) {
		hash ^= static_cast<uint64_t>(data[i]);
		hash *= prime;
	}

	static constexpr char hexDigits[] = "0123456789abcdef";
	std::string hex(16, '0');
	for (int i = 15; i >= 0; --i) {
		hex[static_cast<std::size_t>(i)] = hexDigits[hash & 0xF];
		hash >>= 4;
	}
	return hex;
}

std::string ChannelRegistry::computeFileHash(const std::string &filePath) {
	std::ifstream file(filePath, std::ios::binary);
	if (!file) {
		return {};
	}

	constexpr uint64_t offsetBasis = 0xcbf29ce484222325ULL;
	constexpr uint64_t prime = 0x100000001b3ULL;
	uint64_t hash = offsetBasis;

	std::array<char, 1 << 16> buffer {};
	while (file) {
		file.read(buffer.data(), static_cast<std::streamsize>(buffer.size()));
		const auto readCount = file.gcount();
		for (std::streamsize i = 0; i < readCount; ++i) {
			hash ^= static_cast<uint64_t>(static_cast<unsigned char>(buffer[static_cast<std::size_t>(i)]));
			hash *= prime;
		}
	}

	static constexpr char hexDigits[] = "0123456789abcdef";
	std::string hex(16, '0');
	for (int i = 15; i >= 0; --i) {
		hex[static_cast<std::size_t>(i)] = hexDigits[hash & 0xF];
		hash >>= 4;
	}
	return hex;
}

void ChannelRegistry::setChannelsForTesting(std::vector<ChannelInfo> testChannels) {
	std::lock_guard lock(mutex);
	channels = std::move(testChannels);
}
