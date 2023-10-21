/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include <ranges>
#include <algorithm>

#include "kv/kv_sql.hpp"
#include "kv/value_wrapper_proto.hpp"
#include "protobuf/kv.pb.h"
#include "utils/tools.hpp"

std::optional<ValueWrapper> KVSQL::load(const std::string &key) {
	auto query = fmt::format("SELECT `key_name`, `timestamp`, `value` FROM `kv_store` WHERE `key_name` = {}", db.escapeString(key));
	auto result = db.storeQuery(query);
	if (result == nullptr) {
		return std::nullopt;
	}

	unsigned long size;
	auto data = result->getStream("value", size);
	if (data == nullptr) {
		return std::nullopt;
	}

	ValueWrapper valueWrapper;
	auto timestamp = result->getNumber<uint64_t>("timestamp");
	Canary::protobuf::kv::ValueWrapper protoValue;
	if (protoValue.ParseFromArray(data, static_cast<int>(size))) {
		valueWrapper = ProtoSerializable<ValueWrapper>::fromProto(protoValue, timestamp);
		return valueWrapper;
	}
	logger.error("Failed to deserialize value for key {}", key);
	return std::nullopt;
}

bool KVSQL::save(const std::string &key, const ValueWrapper &value) {
	auto update = dbUpdate();
	prepareSave(key, value, update);
	return update.execute();
}

bool KVSQL::prepareSave(const std::string &key, const ValueWrapper &value, DBInsert &update) {
	auto protoValue = ProtoSerializable<ValueWrapper>::toProto(value);
	std::string data;
	if (!protoValue.SerializeToString(&data)) {
		return false;
	}
	if (value.isDeleted()) {
		auto query = fmt::format("DELETE FROM `kv_store` WHERE `key_name` = {}", db.escapeString(key));
		return db.executeQuery(query);
	}

	update.addRow(fmt::format("{}, {}, {}", db.escapeString(key), getTimeMsNow(), db.escapeString(data)));
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
