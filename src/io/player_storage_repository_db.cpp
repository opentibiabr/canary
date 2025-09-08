/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/player_storage_repository_db.hpp"

#include "database/database.hpp"
#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <map>
	#include <set>
	#include <string>
	#include <vector>
	#include <fmt/format.h>
	#include <fmt/ranges.h>
#endif

std::vector<PlayerStorageRow> DbPlayerStorageRepository::load(uint32_t id) {
	std::vector<PlayerStorageRow> out;
	auto query = fmt::format("SELECT `key`,`value` FROM `player_storage` WHERE `player_id`={}", id);
	if (auto result = Database::getInstance().storeQuery(query)) {
		do {
			out.push_back({ result->getNumber<uint32_t>("key"), result->getNumber<int32_t>("value") });
		} while (result->next());
	}
	return out;
}

bool DbPlayerStorageRepository::deleteKeys(uint32_t id, const std::vector<uint32_t> &keys) {
	if (keys.empty()) {
		return true;
	}
	auto in = fmt::format("{}", fmt::join(keys, ","));
	auto query = fmt::format("DELETE FROM `player_storage` WHERE `player_id`={} AND `key` IN ({})", id, in);
	return Database::getInstance().executeQuery(query);
}

bool DbPlayerStorageRepository::upsert(uint32_t id, const std::map<uint32_t, int32_t> &kv) {
	if (kv.empty()) {
		return true;
	}
	DBInsert insert("INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ");
	insert.upsert({ "value" });
	for (auto &[key, value] : kv) {
		if (!insert.addRow(fmt::format("{},{},{}", id, key, value))) {
			return false;
		}
	}
	return insert.execute();
}

IPlayerStorageRepository &g_playerStorageRepository() {
	return inject<DbPlayerStorageRepository>();
}
