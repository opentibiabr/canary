/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/management/ban.hpp"

#include "database/database.hpp"
#include "database/databasetasks.hpp"
#include "utils/tools.hpp"

namespace {
	// An entry can no longer influence acceptConnection() once its block has
	// expired and its last attempt fell out of the 5s burst window, so keeping
	// it around only costs memory and lookup time.
	constexpr uint64_t CONNECT_BLOCK_BURST_WINDOW = 5000;
	// How often the map is swept. Amortises the O(n) scan so the hot path stays
	// O(log n).
	constexpr uint64_t CONNECT_BLOCK_PRUNE_INTERVAL = 60000;
} // namespace

void Ban::pruneStaleEntries(uint64_t currentTime) {
	if (currentTime - lastPrune < CONNECT_BLOCK_PRUNE_INTERVAL) {
		return;
	}

	lastPrune = currentTime;
	std::erase_if(ipConnectMap, [currentTime](const auto &entry) {
		const ConnectBlock &connectBlock = entry.second;
		return connectBlock.blockTime <= currentTime
			&& currentTime - connectBlock.lastAttempt > CONNECT_BLOCK_BURST_WINDOW;
	});
}

bool Ban::acceptConnection(uint32_t clientIP) {
	std::scoped_lock<std::recursive_mutex> lockClass(lock);

	const uint64_t currentTime = OTSYS_TIME();
	pruneStaleEntries(currentTime);

	auto it = ipConnectMap.find(clientIP);
	if (it == ipConnectMap.end()) {
		ipConnectMap.emplace(clientIP, ConnectBlock(currentTime, 0, 1));
		return true;
	}

	ConnectBlock &connectBlock = it->second;
	if (connectBlock.blockTime > currentTime) {
		connectBlock.blockTime += 250;
		return false;
	}

	const int64_t timeDiff = currentTime - connectBlock.lastAttempt;
	connectBlock.lastAttempt = currentTime;
	if (timeDiff <= 5000) {
		if (++connectBlock.count > 5) {
			connectBlock.count = 0;
			if (timeDiff <= 500) {
				connectBlock.blockTime = currentTime + 3000;
				return false;
			}
		}
	} else {
		connectBlock.count = 1;
	}
	return true;
}

bool IOBan::isAccountBanned(uint32_t accountId, BanInfo &banInfo) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `reason`, `expires_at`, `banned_at`, `banned_by`, (SELECT `name` FROM `players` WHERE `id` = `banned_by`) AS `name` FROM `account_bans` WHERE `account_id` = " << accountId;

	const DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	const auto expiresAt = result->getNumber<int64_t>("expires_at");
	if (expiresAt != 0 && time(nullptr) > expiresAt) {
		// Move the ban to history if it has expired
		query.str(std::string());
		query << "INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES (" << accountId << ',' << db.escapeString(result->getString("reason")) << ',' << result->getNumber<time_t>("banned_at") << ',' << expiresAt << ',' << result->getNumber<uint32_t>("banned_by") << ')';
		g_databaseTasks().execute(query.str());

		query.str(std::string());
		query << "DELETE FROM `account_bans` WHERE `account_id` = " << accountId;
		g_databaseTasks().execute(query.str());
		return false;
	}

	banInfo.expiresAt = expiresAt;
	banInfo.reason = result->getString("reason");
	banInfo.bannedBy = result->getString("name");
	return true;
}

bool IOBan::isIpBanned(uint32_t clientIP, BanInfo &banInfo) {
	if (clientIP == 0) {
		return false;
	}

	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `reason`, `expires_at`, (SELECT `name` FROM `players` WHERE `id` = `banned_by`) AS `name` FROM `ip_bans` WHERE `ip` = " << clientIP;

	const DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	const auto expiresAt = result->getNumber<int64_t>("expires_at");
	if (expiresAt != 0 && time(nullptr) > expiresAt) {
		query.str(std::string());
		query << "DELETE FROM `ip_bans` WHERE `ip` = " << clientIP;
		g_databaseTasks().execute(query.str());
		return false;
	}

	banInfo.expiresAt = expiresAt;
	banInfo.reason = result->getString("reason");
	banInfo.bannedBy = result->getString("name");
	return true;
}

bool IOBan::isPlayerNamelocked(uint32_t playerId) {
	std::ostringstream query;
	query << "SELECT 1 FROM `player_namelocks` WHERE `player_id` = " << playerId;
	return Database::getInstance().storeQuery(query.str()).get() != nullptr;
}
