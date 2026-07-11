/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/channel_switch_audit_store.hpp"

#include "database/database.hpp"
#include "game/multichannel/position_serialization.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <sstream>
#endif

bool ChannelSwitchAuditStore::write(const ChannelSwitchAuditRecord &record, int64_t nowMs) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "INSERT INTO `channel_switch_audit` (`player_id`, `account_id`, `source_channel_id`, `target_channel_id`, `source_position`, `resolved_position`, `fallback_reason`, `session_id`, `fencing_token`, `result`, `deny_reason`, `created_at`) VALUES ("
		  << record.playerId << ", "
		  << record.accountId << ", "
		  << (record.sourceChannelId.has_value() ? std::to_string(*record.sourceChannelId) : "NULL") << ", "
		  << record.targetChannelId << ", "
		  << db.escapeString(multichannel::formatPosition(record.sourcePosition)) << ", "
		  << db.escapeString(multichannel::formatPosition(record.resolvedPosition)) << ", "
		  << db.escapeString(record.fallbackReason) << ", "
		  << db.escapeString(record.sessionId) << ", "
		  << record.fencingToken << ", "
		  << db.escapeString(record.result) << ", "
		  << db.escapeString(record.denyReason) << ", "
		  << nowMs << ");";

	if (!db.executeQuery(query.str())) {
		g_logger().error("[ChannelSwitchAuditStore::write] - Failed to insert audit row for account {} (player {}) switching to channel {}.", record.accountId, record.playerId, record.targetChannelId);
		return false;
	}
	return true;
}

std::optional<PendingChannelSwitch> ChannelSwitchAuditStore::findPending(int32_t accountId, int32_t targetChannelId) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `id`, `resolved_position` FROM `channel_switch_audit` WHERE `account_id` = " << accountId
		  << " AND `target_channel_id` = " << targetChannelId
		  << " AND `result` = 'SUCCESS' AND `consumed_at` IS NULL"
		  << " ORDER BY `created_at` DESC, `id` DESC LIMIT 1;";

	const DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return std::nullopt;
	}

	const auto position = multichannel::parsePosition(result->getString("resolved_position"));
	if (!position.has_value()) {
		g_logger().error("[ChannelSwitchAuditStore::findPending] - Malformed resolved_position for audit row {}, ignoring.", result->getNumber<int64_t>("id"));
		return std::nullopt;
	}

	PendingChannelSwitch pending;
	pending.auditId = result->getNumber<int64_t>("id");
	pending.resolvedPosition = *position;
	return pending;
}

int64_t ChannelSwitchAuditStore::getLastSwitchAtMs(int32_t accountId) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `created_at` FROM `channel_switch_audit` WHERE `account_id` = " << accountId
		  << " AND `result` = 'SUCCESS' ORDER BY `created_at` DESC, `id` DESC LIMIT 1;";

	const DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return 0;
	}
	return result->getNumber<int64_t>("created_at");
}

bool ChannelSwitchAuditStore::markConsumed(int64_t auditId, int64_t nowMs) {
	Database &db = Database::getInstance();
	const std::string query = "UPDATE `channel_switch_audit` SET `consumed_at` = " + std::to_string(nowMs) + " WHERE `id` = " + std::to_string(auditId) + ";";
	if (!db.executeQuery(query)) {
		g_logger().error("[ChannelSwitchAuditStore::markConsumed] - Failed to mark audit row {} consumed.", auditId);
		return false;
	}
	return true;
}
