/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "kv/kv.hpp"

#include "database/database.hpp"
#include "lib/logging/logger.hpp"

class Database;

class KVSQL final : public KVStore {
public:
	explicit KVSQL(Database &db, Logger &logger) :
		KVStore(logger),
		db(db) { }

	bool saveAll() override;

protected:
	std::optional<ValueWrapper> load(const std::string &key) override;
	bool save(const std::string &key, const ValueWrapper &value) override;

private:
	Database &db;
};
