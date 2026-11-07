/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "game/cyclopedia_storage.hpp"

#include "database/database.hpp"
#include "kv/value_wrapper.hpp"
#include "kv/value_wrapper_proto.hpp"
#include <kv.pb.h>

namespace {
	bool store(const std::string &key, const std::string &value, bool initialize) {
		if (!key.starts_with("cyclopedia.atomic.") || key.size() > 191 || value.size() > 262144) {
			return false;
		}
		const ValueWrapper wrapper(value);
		const auto proto = ProtoSerializable::toProto(wrapper);
		std::string bytes;
		if (!proto.SerializeToString(&bytes)) {
			return false;
		}
		auto &db = g_database();
		return db.executeQuery(fmt::format(
			"INSERT {} INTO `kv_store` (`key_name`,`timestamp`,`value`) VALUES ({},{},{}) {}",
			initialize ? "IGNORE" : "", db.escapeString(key), wrapper.getTimestamp(),
			db.escapeBlob(bytes.data(), static_cast<uint32_t>(bytes.size())),
			initialize ? "" : "ON DUPLICATE KEY UPDATE `timestamp`=VALUES(`timestamp`),`value`=VALUES(`value`)"
		));
	}
}

bool CyclopediaStorage::ready() {
	const auto version = read("cyclopedia.atomic.migration-v1");
	return version && *version == "1";
}

bool CyclopediaStorage::initialize(const std::string &key, const std::string &value) {
	return ready() && store(key, value, true);
}

std::optional<std::string> CyclopediaStorage::read(const std::string &key, bool forUpdate) {
	if (!key.starts_with("cyclopedia.atomic.")) {
		return std::nullopt;
	}
	auto &db = g_database();
	const auto row = db.storeQuery(fmt::format(
		"SELECT `timestamp`,`value` FROM `kv_store` WHERE `key_name`={} {}", db.escapeString(key), forUpdate ? "FOR UPDATE" : ""
	));
	if (!row) {
		return std::nullopt;
	}
	unsigned long size = 0;
	const auto bytes = row->getStream("value", size);
	Canary::protobuf::kv::ValueWrapper proto;
	if (!bytes || size > 262150 || !proto.ParseFromArray(bytes, static_cast<int>(size))
	    || proto.value_case() != Canary::protobuf::kv::ValueWrapper::kStrValue) {
		return std::nullopt;
	}
	return ProtoSerializable::fromProto(proto, row->getNumber<uint64_t>("timestamp")).get<std::string>();
}

bool CyclopediaStorage::write(const std::string &key, const std::string &value) {
	return store(key, value, false);
}

std::string CyclopediaStorage::discoveryKey(uint32_t playerId) {
	return fmt::format("cyclopedia.atomic.discovery.{}", playerId);
}
