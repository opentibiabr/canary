/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "kv/kv_sql.hpp"

#include "lib/logging/logger.hpp"
#include "kv/value_wrapper_proto.hpp"
#include "utils/tools.hpp"

#include "database/database.hpp"

#include <kv.pb.h>

KVSQL::KVSQL(Database &db, Logger &logger) :
	KVStore(logger), db(db) { }

std::optional<ValueWrapper> KVSQL::load(const std::string &key) {
	auto query = "SELECT `key_name`, `timestamp`, `value` FROM `kv_store` WHERE `key_name` = ?";
	auto stmt = g_database().prepare(query);
	if (!stmt) {
		g_logger().error("Failed to prepare statement for key: '{}'", key);
		return std::nullopt;
	}

	if (stmt->executeWithParams(key)) {
		auto attributes = stmt->getStream("value");
		if (attributes.empty()) {
			g_logger().error("Failed to load value for key: '{}'", key);
			return std::nullopt;
		}

		auto timestamp = stmt->getU64("timestamp");
		Canary::protobuf::kv::ValueWrapper protoValue;
		if (!protoValue.ParseFromArray(attributes.data(), static_cast<int>(attributes.size()))) {
			g_logger().error("Failed to deserialize value for key {}", key);
			return std::nullopt;
		}

		ValueWrapper valueWrapper;
		valueWrapper = ProtoSerializable::fromProto(protoValue, timestamp);
		g_logger().trace("[{}] loaded data for key: '{}', valueSize: '{}', timeStamp: '{}'", __METHOD_NAME__, key, attributes.size(), timestamp);
		return valueWrapper;
	}

	return std::nullopt;
}

std::vector<std::string> KVSQL::loadPrefix(const std::string &prefix /* = ""*/) {
	std::vector<std::string> keys;
	std::string keySearch = g_database().escapeString(prefix + "%");
	auto query = fmt::format("SELECT `key_name` FROM `kv_store` WHERE `key_name` LIKE {}", keySearch);
	auto result = g_database().storeQuery(query);
	if (result == nullptr) {
		return keys;
	}

	do {
		std::string key = result->getString("key_name");
		replaceString(key, prefix, "");
		keys.push_back(key);
	} while (result->next());

	return keys;
}

bool KVSQL::save(const std::string &key, const ValueWrapper &value) {
	auto update = dbUpdate();
	prepareSave(key, value, update);
	return update.execute();
}

bool KVSQL::prepareSave(const std::string &key, const ValueWrapper &value, DBInsert &update) {
	auto protoValue = ProtoSerializable::toProto(value);
	std::vector<uint8_t> data(protoValue.ByteSizeLong());
	if (!protoValue.SerializeToArray(data.data(), data.size())) {
		g_logger().error("Failed to serialize protoValue for key: {}", key);
		return false;
	}

	if (value.isDeleted()) {
		try {
			mysqlx::Table tbl = g_database().getTable("kv_store");
			mysqlx::Result result = tbl.remove().where("key_name = :key").bind("key", key).execute();
			return true;
		} catch (const mysqlx::Error &err) {
			g_logger().error("KVStore remove, database error: {}", err.what());
			return false;
		} catch (const std::exception &ex) {
			g_logger().error("KVStore remove, standard exception: {}", ex.what());
			return false;
		}
	}

	static std::vector<std::string> columns = {
		"key_name",
		"timestamp",
		"value"
	};

	std::vector<mysqlx::Value> values = {
		key,
		value.getTimestamp(),
		mysqlx::Value(mysqlx::bytes(data.data(), data.size()))
	};

	if (!g_database().updateTable("kv_store", columns, values, "key_name", key)) {
		g_logger().error("Failed to update key {}", key);
		return false;
	}

	return true;
}

bool KVSQL::saveAll() {
	auto store = getStore();
	bool success = DBTransaction::executeWithinTransaction([this, &store]() {
		auto update = dbUpdate();
		if (!std::ranges::all_of(store, [this, &update](const auto &kv) {
				const auto &[key, value] = kv;
				return prepareSave(key, value.first, update);
			})) {
			return false;
		}
		return update.execute();
	});

	if (!success) {
		g_logger().error("[{}] Error occurred saving player", __FUNCTION__);
	}

	return success;
}

DBInsert KVSQL::dbUpdate() {
	auto insert = DBInsert("INSERT INTO `kv_store` (`key_name`, `timestamp`, `value`) VALUES");
	insert.upsert({ "key_name", "timestamp", "value" });
	return insert;
}
