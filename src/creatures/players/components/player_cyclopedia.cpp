/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// Player.hpp already includes the cylopedia
#include "creatures/players/player.hpp"

#include "database/databasetasks.hpp"
#include "enums/player_blessings.hpp"
#include "enums/player_cyclopedia.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerCyclopedia::PlayerCyclopedia(Player &player) :
	m_player(player) { }

Summary PlayerCyclopedia::getSummary() const {
	return { getAmount(Summary_t::PREY_CARDS),
		     getAmount(Summary_t::INSTANT_REWARDS),
		     getAmount(Summary_t::HIRELINGS) };
}

void PlayerCyclopedia::loadSummaryData() const {
	const DBResult_ptr result = g_database().storeQuery(fmt::format("SELECT COUNT(*) as `count` FROM `player_hirelings` WHERE `player_id` = {}", m_player.getGUID()));
	const auto kvScoped = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(static_cast<uint8_t>(Summary_t::HIRELINGS)));
	if (result && !kvScoped->get("amount").has_value()) {
		kvScoped->set("amount", result->getNumber<int16_t>("count"));
	}
}

void PlayerCyclopedia::loadDeathHistory(uint16_t page, uint16_t entriesPerPage) const {
	Benchmark bm_check;
	uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
	const auto query = fmt::format("SELECT `time`, `level`, `killed_by`, `mostdamage_by`, (select count(*) FROM `player_deaths` WHERE `player_id` = {}) as `entries` FROM `player_deaths` WHERE `player_id` = {} AND `time` >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 30 DAY)) ORDER BY `time` DESC LIMIT {}, {}", m_player.getGUID(), m_player.getGUID(), offset, entriesPerPage);

	uint32_t playerID = m_player.getID();
	const std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](const DBResult_ptr &result, bool) {
		const auto &player = g_game().getPlayerByID(playerID);
		if (!player) {
			return;
		}

		player->resetAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);
		if (!result) {
			player->sendCyclopediaCharacterRecentDeaths(0, 0, {});
			return;
		}

		auto pages = result->getNumber<uint32_t>("entries");
		pages += entriesPerPage - 1;
		pages /= entriesPerPage;

		std::vector<RecentDeathEntry> entries;
		entries.reserve(result->countResults());
		do {
			std::string killed_by = result->getString("killed_by");
			std::string mostdamage_by = result->getString("mostdamage_by");

			std::string cause = fmt::format("Died at Level {}", result->getNumber<uint32_t>("level"));

			if (!killed_by.empty()) {
				cause.append(fmt::format(" by{}", formatWithArticle(killed_by)));
			}

			if (!mostdamage_by.empty()) {
				cause.append(fmt::format("{}{}", !killed_by.empty() ? " and" : "", formatWithArticle(mostdamage_by)));
			}

			entries.emplace_back(cause, result->getNumber<uint32_t>("time"));
		} while (result->next());
		player->sendCyclopediaCharacterRecentDeaths(page, static_cast<uint16_t>(pages), entries);
	};
	g_databaseTasks().store(query, callback);
	m_player.addAsyncOngoingTask(PlayerAsyncTask_RecentDeaths);

	g_logger().debug("Loading death history from the player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::loadRecentKills(uint16_t page, uint16_t entriesPerPage) const {
	Benchmark bm_check;

	const std::string &escapedName = g_database().escapeString(m_player.getName());
	uint32_t offset = static_cast<uint32_t>(page - 1) * entriesPerPage;
	const auto query = fmt::format("SELECT `d`.`time`, `d`.`killed_by`, `d`.`mostdamage_by`, `d`.`unjustified`, `d`.`mostdamage_unjustified`, `p`.`name`, (select count(*) FROM `player_deaths` WHERE ((`killed_by` = {} AND `is_player` = 1) OR (`mostdamage_by` = {} AND `mostdamage_is_player` = 1))) as `entries` FROM `player_deaths` AS `d` INNER JOIN `players` AS `p` ON `d`.`player_id` = `p`.`id` WHERE ((`d`.`killed_by` = {} AND `d`.`is_player` = 1) OR (`d`.`mostdamage_by` = {} AND `d`.`mostdamage_is_player` = 1)) AND `time` >= UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 70 DAY)) ORDER BY `time` DESC LIMIT {}, {}", escapedName, escapedName, escapedName, escapedName, offset, entriesPerPage);

	uint32_t playerID = m_player.getID();
	const std::function<void(DBResult_ptr, bool)> callback = [playerID, page, entriesPerPage](const DBResult_ptr &result, bool) {
		const auto &player = g_game().getPlayerByID(playerID);
		if (!player) {
			return;
		}

		player->resetAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);
		if (!result) {
			player->sendCyclopediaCharacterRecentPvPKills(0, 0, {});
			return;
		}

		auto pages = result->getNumber<uint32_t>("entries");
		pages += entriesPerPage - 1;
		pages /= entriesPerPage;

		std::vector<RecentPvPKillEntry> entries;
		entries.reserve(result->countResults());
		do {
			std::string cause1 = result->getString("killed_by");
			std::string cause2 = result->getString("mostdamage_by");
			std::string name = result->getString("name");

			uint8_t status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_JUSTIFIED;
			if (player->getName() == cause1) {
				if (result->getNumber<uint32_t>("unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			} else if (player->getName() == cause2) {
				if (result->getNumber<uint32_t>("mostdamage_unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			}

			entries.emplace_back(fmt::format("Killed {}.", name), result->getNumber<uint32_t>("time"), status);
		} while (result->next());
		player->sendCyclopediaCharacterRecentPvPKills(page, static_cast<uint16_t>(pages), entries);
	};
	g_databaseTasks().store(query, callback);
	m_player.addAsyncOngoingTask(PlayerAsyncTask_RecentPvPKills);

	g_logger().debug("Loading recent kills from the player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::updateStoreSummary(uint8_t type, uint16_t amount, const std::string &id) const {
	switch (type) {
		case Summary_t::HOUSE_ITEMS:
		case Summary_t::BLESSINGS:
			insertValue(type, amount, id);
			break;
		case Summary_t::ALL_BLESSINGS:
			for (auto blessIt : magic_enum::enum_values<Blessings>()) {
				insertValue(static_cast<uint8_t>(Summary_t::BLESSINGS), amount, fmt::format("{}", blessIt));
			}
			break;
		default:
			updateAmount(type, amount);
			break;
	}
}

uint16_t PlayerCyclopedia::getAmount(uint8_t type) const {
	const auto kvScope = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->get("amount");
	return static_cast<uint16_t>(kvScope ? kvScope->getNumber() : 0);
}

void PlayerCyclopedia::updateAmount(uint8_t type, uint16_t amount) const {
	const auto oldAmount = getAmount(type);
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->set("amount", oldAmount + amount);
}

std::map<uint16_t, uint16_t> PlayerCyclopedia::getResult(uint8_t type) const {
	const auto kvScope = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type));
	std::map<uint16_t, uint16_t> result; // ID, amount
	for (const auto &scope : kvScope->keys()) {
		const size_t &pos = scope.find('.');
		if (pos == std::string::npos) {
			g_logger().error("[{}] Invalid key format: {}", __FUNCTION__, scope);
			continue;
		}
		std::string id = scope.substr(0, pos);
		const auto amount = kvScope->scoped(id)->get("amount");
		result.emplace(std::stoll(id), static_cast<uint16_t>(amount ? amount->getNumber() : 0));
	}
	return result;
}

void PlayerCyclopedia::insertValue(uint8_t type, uint16_t amount, const std::string &id) const {
	auto result = getResult(type);
	const auto it = result.find(std::stoll(id));
	auto oldAmount = (it != result.end() ? it->second : 0);
	auto newAmount = oldAmount + amount;
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->scoped(id)->set("amount", newAmount);
	g_logger().debug("[{}] type: {}, id: {}, old amount: {}, added amount: {}, new amount: {}", __FUNCTION__, type, id, oldAmount, amount, newAmount);
}
