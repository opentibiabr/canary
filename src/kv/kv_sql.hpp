/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "kv/kv.hpp"

class Database;
class Logger;
class DBInsert;
class ValueWrapper;

class KVSQL final : public KVStore {
public:
	explicit KVSQL(Database &db, Logger &logger);

	bool saveAll() override;

private:
	std::vector<std::string> loadPrefix(const std::string &prefix = "") override;
	std::optional<ValueWrapper> load(const std::string &key) override;
	bool save(const std::string &key, const ValueWrapper &value) override;
	bool prepareSave(const std::string &key, const ValueWrapper &value, DBInsert &update) const;

	DBInsert dbUpdate();

	Database &db;
};
