/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "player_cyclopedia.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "kv/kv.hpp"

PlayerCyclopedia::PlayerCyclopedia(Player &player) :
	m_player(player) { }

void PlayerCyclopedia::loadSummaryData() {
	loadSummary();
	loadRecentKills();
	loadDeathHistory();
}

void PlayerCyclopedia::loadSummary() {
}

void PlayerCyclopedia::loadRecentKills() {
	Benchmark bm_check;

	Database &db = g_database();
	const std::string &escapedName = db.escapeString(m_player.getName());
	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `d`.`time`, `d`.`killed_by`, `d`.`mostdamage_by`, `d`.`unjustified`, `d`.`mostdamage_unjustified`, `p`.`name` FROM `player_deaths` AS `d` INNER JOIN `players` AS `p` ON `d`.`player_id` = `p`.`id` WHERE ((`d`.`killed_by` = {} AND `d`.`is_player` = 1) OR (`d`.`mostdamage_by` = {} AND `d`.`mostdamage_is_player` = 1))", escapedName, escapedName));
	if (result) {
		do {
			std::string cause1 = result->getString("killed_by");
			std::string cause2 = result->getString("mostdamage_by");
			std::string name = result->getString("name");

			uint8_t status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_JUSTIFIED;
			if (m_player.getName() == cause1) {
				if (result->getNumber<uint32_t>("unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			} else if (m_player.getName() == cause2) {
				if (result->getNumber<uint32_t>("mostdamage_unjustified") == 1) {
					status = CYCLOPEDIA_CHARACTERINFO_RECENTKILLSTATUS_UNJUSTIFIED;
				}
			}

			insertPvpKillOnHistory(fmt::format("Killed {}.", name), result->getNumber<uint32_t>("time"), status);
		} while (result->next());
	}

	g_logger().debug("Checking and updating recent kill of player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::loadDeathHistory() {
	Benchmark bm_check;

	DBResult_ptr result = g_database().storeQuery(fmt::format("SELECT `time`, `level`, `killed_by`, `mostdamage_by` FROM `player_deaths` WHERE `player_id` = {} ORDER BY `time` DESC", m_player.getGUID()));
	if (result) {
		do {
			std::string cause1 = result->getString("killed_by");
			std::string cause2 = result->getString("mostdamage_by");
			std::ostringstream description;
			description << "Died at Level " << result->getNumber<uint32_t>("level") << " by";
			if (!cause1.empty()) {
				description << getArticle(cause1) << cause1;
			}

			if (!cause2.empty()) {
				if (!cause1.empty()) {
					description << " and";
				}
				description << getArticle(cause2) << cause2;
			}
			description << '.';

			insertDeathOnHistory(std::move(description.str()), result->getNumber<uint32_t>("time"));
		} while (result->next());
	}

	g_logger().debug("Checking and updating death history of player {} took {} milliseconds.", m_player.getName(), bm_check.duration());
}

void PlayerCyclopedia::updateStoreSummary(uint8_t type, uint16_t count, uint8_t itemType, uint8_t offerId, uint8_t blessId) {
	updateAmount(type, count);
}

uint16_t PlayerCyclopedia::getAmount(uint8_t type) {
	auto kv = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->get("amount");
	return static_cast<uint16_t>(kv ? kv->getNumber() : 0);
}

void PlayerCyclopedia::updateAmount(uint8_t type, uint16_t toAddPoints) {
	auto oldPoints = getAmount(type);
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->set("amount", oldPoints + toAddPoints);
}

std::vector<RecentDeathEntry> PlayerCyclopedia::getDeathHistory() const {
	return m_deathHistory;
}

void PlayerCyclopedia::insertDeathOnHistory(std::string cause, uint32_t timestamp) {
	m_deathHistory.emplace_back(std::move(cause), timestamp);
}

std::vector<RecentPvPKillEntry> PlayerCyclopedia::getPvpKillsHistory() const {
	return m_pvpKillsHistory;
}

void PlayerCyclopedia::insertPvpKillOnHistory(std::string cause, uint32_t timestamp, uint8_t status) {
	m_pvpKillsHistory.emplace_back(std::move(cause), timestamp, status);
}

std::map<Blessings_t, uint16_t> PlayerCyclopedia::getBlessings() const {
}
void insertBlessings(uint8_t bless, uint32_t timestamp) {
}

std::vector<uint8_t> PlayerCyclopedia::getHirelingJobs() const {
}
void insertHirelingJobs(uint8_t job, uint32_t timestamp) {
}

std::vector<uint16_t> PlayerCyclopedia::getHirelingOutfits() const {
}
void insertHirelingOutfits(uint8_t outfit, uint32_t timestamp) {
}

std::map<uint32_t, uint16_t> PlayerCyclopedia::getHouseItems() const {
	auto type = static_cast<uint8_t>(Summary_t::HOUSE_ITEMS);
	auto kvItem = m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type));

	std::map<uint32_t, uint16_t> items = {};
	for (const auto &itemId : kvItem->keys()) {
		auto kv = kvItem->scoped(itemId)->get("amount");
		auto amount = static_cast<uint16_t>(kv ? kv->getNumber() : 0);
		items[std::stoull(itemId)] += amount;
	}

	return items;
}

void PlayerCyclopedia::insertHouseItems(uint32_t itemId, uint16_t amount) {
	auto type = static_cast<uint8_t>(Summary_t::HOUSE_ITEMS);
	auto oldAmount = static_cast<uint16_t>(m_houseItems[itemId]);
	m_player.kv()->scoped("summary")->scoped(g_game().getSummaryKeyByType(type))->scoped(fmt::format("{}", itemId))->set("amount", oldAmount + amount);
}
