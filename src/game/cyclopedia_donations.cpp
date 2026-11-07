/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "game/cyclopedia_donations.hpp"

#include "creatures/players/player.hpp"
#include "database/database.hpp"
#include "game/game.hpp"
#include "io/iologindata.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <nlohmann/json.hpp>
	#include <ranges>
	#include <algorithm>
	#include <chrono>
	#include <fstream>
	#include <limits>
	#include <vector>
#endif

namespace {
	struct Run {
		uint16_t area, x1, x2;
	};
	struct Catalog {
		std::map<uint16_t, bool> areas;
		std::map<uint32_t, std::vector<Run>> rows;
		bool valid = false;
		Catalog() {
			try {
				std::ifstream input("data/XML/cyclopedia-donation-areas.json");
				nlohmann::json document;
				input >> document;
				if (document.at("areas").size() > 255) {
					return;
				}
				for (const auto &area : document.at("areas")) {
					const auto id = area.at("id").get<uint16_t>();
					const bool rejected = area.at("reject").get<bool>();
					areas.emplace(id, rejected);
					for (const auto &run : area.at("runs")) {
						const auto z = run.at(0).get<uint32_t>();
						const auto y = run.at(1).get<uint32_t>();
						const auto x1 = run.at(2).get<uint32_t>();
						const auto x2 = run.at(3).get<uint32_t>();
						if (z > 15 || y > UINT16_MAX || x2 > UINT16_MAX || x1 > x2) {
							return;
						}
						rows[(z << 16) | y].push_back({ id, static_cast<uint16_t>(x1), static_cast<uint16_t>(x2) });
					}
				}
				valid = !areas.empty();
			} catch (const std::exception &error) {
				g_logger().error("[CyclopediaDonations] Invalid area catalog: {}", error.what());
			}
		}
	};
	const Catalog &catalog() {
		// Immutable coordinate/value data only; no gameplay ownership at shutdown.
		static const Catalog value;
		return value;
	}
	uint64_t day() {
		return std::chrono::duration_cast<std::chrono::hours>(std::chrono::system_clock::now().time_since_epoch()).count() / 24;
	}
}

bool CyclopediaDonations::load() {
	if (loaded) {
		return true;
	}
	const auto now = static_cast<uint64_t>(std::chrono::duration_cast<std::chrono::seconds>(std::chrono::steady_clock::now().time_since_epoch()).count());
	if (now < retryAfter) {
		return false;
	}
	retryAfter = now + 30; // Isolate database/catalog failures from spawn hot paths.
	if (!catalog().valid) {
		return false;
	}
	auto &db = g_database();
	if (!db.executeQuery("CREATE TABLE IF NOT EXISTS `cyclopedia_donations` (`world_id` INT UNSIGNED NOT NULL,`area_id` SMALLINT UNSIGNED NOT NULL,`amount` BIGINT UNSIGNED NOT NULL DEFAULT 0,`active` TINYINT UNSIGNED NOT NULL DEFAULT 0,PRIMARY KEY (`world_id`,`area_id`)) ENGINE=InnoDB")
	    || !db.executeQuery("CREATE TABLE IF NOT EXISTS `cyclopedia_donation_cycles` (`world_id` INT UNSIGNED NOT NULL PRIMARY KEY,`last_day` BIGINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=InnoDB")
	    || !db.executeQuery("CREATE TABLE IF NOT EXISTS `cyclopedia_donation_log` (`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,`world_id` INT UNSIGNED NOT NULL,`player_id` INT UNSIGNED NOT NULL,`area_id` SMALLINT UNSIGNED NOT NULL,`amount` INT UNSIGNED NOT NULL,`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB")) {
		return false;
	}
	for (const auto &[area, rejected] : catalog().areas) {
		if (!db.executeQuery(fmt::format("INSERT IGNORE INTO `cyclopedia_donations` (`world_id`,`area_id`) VALUES ({},{})", 0, area))) {
			return false;
		}
	}
	if (!db.executeQuery(fmt::format("INSERT IGNORE INTO `cyclopedia_donation_cycles` (`world_id`) VALUES ({})", 0))) {
		return false;
	}
	const auto result = db.storeQuery(fmt::format("SELECT `area_id`,`amount`,`active` FROM `cyclopedia_donations` WHERE `world_id`={}", 0));
	if (!result) {
		return false;
	}
	state.clear();
	do {
		const auto area = result->getNumber<uint16_t>("area_id");
		if (catalog().areas.contains(area)) {
			state.emplace(area, Entry { result->getNumber<uint64_t>("amount"), result->getNumber<uint8_t>("active") != 0 });
		}
	} while (result->next());
	loaded = true;
	return true;
}

const std::map<uint16_t, CyclopediaDonations::Entry> &CyclopediaDonations::entries() {
	load();
	return state;
}

std::string CyclopediaDonations::donate(const std::shared_ptr<Player> &player, uint16_t area, uint32_t amount) {
	if (!player || player->isRemoved() || !load()) {
		return "Donations are temporarily unavailable.";
	}
	const auto permitted = catalog().areas.find(area);
	if (permitted == catalog().areas.end() || permitted->second || !state.contains(area) || state.at(area).active) {
		return "This area cannot receive donations today.";
	}
	if (amount == 0 || amount > INT32_MAX) {
		return "Enter a donation between 1 and 2147483647 gold.";
	}
	const auto balance = player->getBankBalance();
	if (balance < amount) {
		return "You need enough gold in your bank account to donate.";
	}
	// Persist the live balance first. All subsequent debit/area/log writes commit
	// together; update memory only after commit, on the same dispatcher turn.
	if (!IOLoginData::savePlayer(player)) {
		return "Could not save your character. No donation was charged.";
	}
	uint64_t updated = 0;
	auto &db = g_database();
	const bool committed = DBTransaction::executeWithinTransactionRollbackOnFailure([&] {
		const auto owner = db.storeQuery(fmt::format("SELECT `balance` FROM `players` WHERE `id`={} AND {}=0 AND `account_id`={} FOR UPDATE", player->getGUID(), 0, player->getAccountId()));
		const auto row = db.storeQuery(fmt::format("SELECT `amount`,`active` FROM `cyclopedia_donations` WHERE `world_id`={} AND `area_id`={} FOR UPDATE", 0, area));
		if (!owner || owner->getNumber<uint64_t>("balance") != balance || !row || row->getNumber<uint8_t>("active") != 0) {
			return false;
		}
		const auto old = row->getNumber<uint64_t>("amount");
		if (old > static_cast<uint64_t>(INT64_MAX) - amount) {
			return false;
		}
		updated = old + amount;
		return db.executeQuery(fmt::format("UPDATE `players` SET `balance`={} WHERE `id`={} AND {}=0", balance - amount, player->getGUID(), 0))
			&& db.executeQuery(fmt::format("UPDATE `cyclopedia_donations` SET `amount`={} WHERE `world_id`={} AND `area_id`={}", updated, 0, area))
			&& db.executeQuery(fmt::format("INSERT INTO `cyclopedia_donation_log` (`world_id`,`player_id`,`area_id`,`amount`) VALUES ({},{},{},{})", 0, player->getGUID(), area, amount));
	});
	if (!committed) {
		return "Donation could not be completed. No gold was charged.";
	}
	player->setBankBalance(balance - amount);
	state.at(area).amount = updated;
	player->sendResourceBalance(RESOURCE_BANK, balance - amount);
	broadcast();
	g_logger().info(fmt::format("[CyclopediaDonations] player={} area={} amount={} total={}", player->getGUID(), area, amount, updated));
	return "";
}

bool CyclopediaDonations::advance() {
	if (!load()) {
		return false;
	}
	uint16_t winner = 0;
	auto &db = g_database();
	const bool committed = DBTransaction::executeWithinTransactionRollbackOnFailure([&] {
		const auto cycle = db.storeQuery(fmt::format("SELECT `last_day` FROM `cyclopedia_donation_cycles` WHERE `world_id`={} FOR UPDATE", 0));
		if (!cycle || cycle->getNumber<uint64_t>("last_day") >= day()) {
			return false;
		}
		const auto rows = db.storeQuery(fmt::format("SELECT `area_id`,`amount`,`active` FROM `cyclopedia_donations` WHERE `world_id`={} ORDER BY `amount` DESC,`area_id` ASC FOR UPDATE", 0));
		if (!rows) {
			return false;
		}
		do {
			const auto area = rows->getNumber<uint16_t>("area_id");
			const auto permitted = catalog().areas.find(area);
			if (!winner && permitted != catalog().areas.end() && !permitted->second && rows->getNumber<uint8_t>("active") == 0 && rows->getNumber<uint64_t>("amount") >= threshold) {
				winner = area;
			}
		} while (rows->next());
		if (!db.executeQuery(fmt::format("UPDATE `cyclopedia_donations` SET `active`=0 WHERE `world_id`={}", 0))) {
			return false;
		}
		if (winner && !db.executeQuery(fmt::format("UPDATE `cyclopedia_donations` SET `active`=1,`amount`=0 WHERE `world_id`={} AND `area_id`={}", 0, winner))) {
			return false;
		}
		return db.executeQuery(fmt::format("UPDATE `cyclopedia_donation_cycles` SET `last_day`={} WHERE `world_id`={}", day(), 0));
	});
	if (!committed) {
		return false;
	}
	loaded = false;
	retryAfter = 0;
	if (!load()) {
		return false;
	}
	broadcast();
	g_logger().info(fmt::format("[CyclopediaDonations] new cycle, active area={}", winner));
	return true;
}

bool CyclopediaDonations::improved(const Position &position) {
	if (!load()) {
		return false;
	}
	if (!hasActive()) {
		return false;
	}
	const auto row = catalog().rows.find((static_cast<uint32_t>(position.z) << 16) | position.y);
	if (row == catalog().rows.end()) {
		return false;
	}
	for (const auto &run : row->second) {
		const auto entry = state.find(run.area);
		if (entry != state.end() && entry->second.active && position.x >= run.x1 && position.x <= run.x2) {
			return true;
		}
	}
	return false;
}

void CyclopediaDonations::broadcast() {
	for (const auto &[id, player] : g_game().getPlayers()) {
		player->sendCyclopediaMapDonations();
	}
}

bool CyclopediaDonations::hasActive() const {
	return std::ranges::any_of(state, [](const auto &row) { return row.second.active; });
}
