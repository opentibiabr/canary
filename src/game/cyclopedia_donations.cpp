/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "game/cyclopedia_donations.hpp"
#include "game/cyclopedia_storage.hpp"
#include "kv/kv.hpp"

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
	bool validDonationState(const nlohmann::json &doc) {
		if (!doc.is_object() || !doc.contains("version") || doc["version"] != 1
		    || !doc.contains("last_day") || !doc["last_day"].is_number_unsigned()
		    || !doc.contains("areas") || !doc["areas"].is_object() || doc["areas"].size() > 255) {
			return false;
		}
		return std::ranges::all_of(doc["areas"], [](const auto &entry) {
			return entry.is_object() && entry.contains("amount") && entry["amount"].is_number_unsigned()
				&& entry["amount"].template get<uint64_t>() <= INT64_MAX
				&& entry.contains("active") && entry["active"].is_boolean();
		});
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
	retryAfter = now + 30;
	if (!catalog().valid || !CyclopediaStorage::ready()) {
		return false;
	}
	const auto stored = CyclopediaStorage::read(CyclopediaStorage::donationsKey);
	const auto doc = stored ? nlohmann::json::parse(*stored, nullptr, false) : nlohmann::json();
	if (!validDonationState(doc)) {
		return false;
	}
	std::map<uint16_t, Entry> restored;
	for (const auto &[area, rejected] : catalog().areas) {
		const auto entry = doc["areas"].find(std::to_string(area));
		restored.emplace(area, entry == doc["areas"].end() ? Entry {} : Entry { (*entry)["amount"].get<uint64_t>(), (*entry)["active"].get<bool>() });
	}
	state = std::move(restored);
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
	if (!IOLoginData::savePlayer(player)) {
		return "Could not save your character. No donation was charged.";
	}
	uint64_t updated = 0;
	auto &db = g_database();
	const bool committed = DBTransaction::executeWithinTransactionRollbackOnFailure([&] {
		const auto owner = db.storeQuery(fmt::format("SELECT `balance` FROM `players` WHERE `id`={} AND `account_id`={} FOR UPDATE", player->getGUID(), player->getAccountId()));
		const auto stored = CyclopediaStorage::read(CyclopediaStorage::donationsKey, true);
		auto doc = stored ? nlohmann::json::parse(*stored, nullptr, false) : nlohmann::json();
		if (!owner || owner->getNumber<uint64_t>("balance") != balance || !validDonationState(doc)) {
			return false;
		}
		auto &entry = doc["areas"][std::to_string(area)];
		if (entry.is_null()) {
			entry = { { "amount", uint64_t { 0 } }, { "active", false } };
		}
		const auto old = entry["amount"].get<uint64_t>();
		if (entry["active"].get<bool>() || old > static_cast<uint64_t>(INT64_MAX) - amount) {
			return false;
		}
		updated = old + amount;
		entry["amount"] = updated;
		const auto createdAt = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
		const nlohmann::json audit = { { "player_id", player->getGUID() }, { "area_id", area }, { "amount", amount }, { "total", updated }, { "created_at", createdAt } };
		return db.executeQuery(fmt::format("UPDATE `players` SET `balance`={} WHERE `id`={} AND `account_id`={}", balance - amount, player->getGUID(), player->getAccountId()))
			&& CyclopediaStorage::write(CyclopediaStorage::donationsKey, doc.dump())
			&& CyclopediaStorage::write("cyclopedia.atomic.audit." + KV::generateUUID(), audit.dump());
	});
	if (!committed) {
		return "Donation could not be completed. No gold was charged.";
	}
	player->setBankBalance(balance - amount);
	state.at(area).amount = updated;
	player->sendResourceBalance(RESOURCE_BANK, balance - amount);
	broadcast();
	g_logger().info("[CyclopediaDonations] player={} area={} amount={} total={}", player->getGUID(), area, amount, updated);
	return "";
}

bool CyclopediaDonations::advance() {
	if (!load()) {
		return false;
	}
	uint16_t winner = 0;
	bool rotated = false;
	const bool committed = DBTransaction::executeWithinTransactionRollbackOnFailure([&] {
		const auto stored = CyclopediaStorage::read(CyclopediaStorage::donationsKey, true);
		auto doc = stored ? nlohmann::json::parse(*stored, nullptr, false) : nlohmann::json();
		if (!validDonationState(doc)) {
			return false;
		}
		if (doc["last_day"].get<uint64_t>() >= day()) {
			return true;
		}
		uint64_t best = threshold - 1;
		for (const auto &[area, rejected] : catalog().areas) {
			const auto it = doc["areas"].find(std::to_string(area));
			if (it == doc["areas"].end()) {
				continue;
			}
			const auto amount = (*it)["amount"].get<uint64_t>();
			if (!rejected && !(*it)["active"].get<bool>() && amount > best) {
				winner = area;
				best = amount;
			}
		}
		for (auto &entry : doc["areas"]) {
			entry["active"] = false;
		}
		if (winner) {
			auto &entry = doc["areas"][std::to_string(winner)];
			entry["active"] = true;
			entry["amount"] = uint64_t { 0 };
		}
		doc["last_day"] = day();
		rotated = true;
		return CyclopediaStorage::write(CyclopediaStorage::donationsKey, doc.dump());
	});
	if (!committed) {
		return false;
	}
	if (!rotated) {
		return true;
	}
	loaded = false;
	retryAfter = 0;
	if (!load()) {
		return false;
	}
	broadcast();
	g_logger().info("[CyclopediaDonations] new cycle, active area={}", winner);
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
