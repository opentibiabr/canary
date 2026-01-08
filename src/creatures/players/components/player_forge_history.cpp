/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "creatures/players/components/player_forge_history.hpp"

#include "creatures/players/player.hpp"
#include "utils/benchmark.hpp"
#include "database/database.hpp"
#include "utils/tools.hpp"

PlayerForgeHistory::PlayerForgeHistory(Player &player) :
	m_player(player) { }

const std::vector<ForgeHistory> &PlayerForgeHistory::get() const {
	return m_history;
}

void PlayerForgeHistory::add(const ForgeHistory &history) {
	auto adjustedHistory = history;
	while (std::ranges::any_of(m_history, [&adjustedHistory](const ForgeHistory &existing) {
		return existing.createdAt == adjustedHistory.createdAt;
	})) {
		++adjustedHistory.createdAt;
	}

	m_history.push_back(adjustedHistory);
	m_modifiedHistory.push_back(adjustedHistory);
}

void PlayerForgeHistory::remove(uint32_t id) {
	m_removedHistoryIds.push_back(id);
	std::erase_if(m_history, [id](const ForgeHistory &h) {
		return h.id == id;
	});
}

bool PlayerForgeHistory::load() {
	auto playerGUID = m_player.getGUID();
	Benchmark benchmark;
	auto query = fmt::format("SELECT * FROM forge_history WHERE player_id = {}", playerGUID);
	const DBResult_ptr &result = g_database().storeQuery(query);
	if (!result) {
		g_logger().debug("No forge history found for player with ID: {}", playerGUID);
		benchmark.log("PlayerForgeHistory::load completed (no history found)");
		return true;
	}

	do {
		ForgeHistory history;
		history.id = result->getNumber<uint32_t>("id");
		history.actionType = static_cast<ForgeAction_t>(result->getNumber<uint8_t>("action_type"));
		history.description = result->getString("description");
		history.createdAt = result->getNumber<uint64_t>("done_at");
		history.success = result->getNumber<bool>("is_success");
		m_history.push_back(history);
	} while (result->next());

	benchmark.log("PlayerForgeHistory::load completed");
	return true;
}

bool PlayerForgeHistory::save() {
	if (m_modifiedHistory.empty() && m_removedHistoryIds.empty()) {
		return true;
	}

	auto playerGUID = m_player.getGUID();

	Benchmark benchmark;
	if (!m_removedHistoryIds.empty()) {
		std::string idsToDelete = fmt::format("{}", fmt::join(m_removedHistoryIds, ", "));
		std::string deleteQuery = fmt::format(
			"DELETE FROM `forge_history` WHERE `player_id` = {} AND `id` IN ({})",
			playerGUID, idsToDelete
		);

		if (!g_database().executeQuery(deleteQuery)) {
			g_logger().error("Failed to delete forge history entries for player with ID: {}", playerGUID);
			return false;
		}

		m_removedHistoryIds.clear();
	}

	DBInsert insertQuery("INSERT INTO `forge_history` (`player_id`, `action_type`, `description`, `done_at`, `is_success`) VALUES ");

	for (const auto &history : m_modifiedHistory) {
		auto row = fmt::format("{}, {}, {}, {}, {}", playerGUID, static_cast<int>(history.actionType), g_database().escapeString(history.description), history.createdAt, history.success ? 1 : 0);

		if (!insertQuery.addRow(row)) {
			g_logger().warn("Failed to add forge history entry for player with ID: {}", playerGUID);
			return false;
		}

		g_logger().debug("Added forge history entry date: {}, for player with ID: {}", formatDate(history.createdAt / 1000), playerGUID);
	}

	if (!insertQuery.execute()) {
		g_logger().error("Failed to execute insertion for forge history entries for player with ID: {}", playerGUID);
		return false;
	}

	m_modifiedHistory.clear();

	benchmark.log("PlayerForgeHistory::save completed");
	return true;
}
