/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/components/player_storage.hpp"

#include "creatures/players/player.hpp"
#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/grouping/familiars.hpp"
#include "creatures/players/storages/storages.hpp"
#include "utils/benchmark.hpp"
#include "database/database.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <utility>
	#include <ranges>
#endif

PlayerStorage::PlayerStorage(Player &player) :
	m_player(player) { }

void PlayerStorage::add(const uint32_t key, const int32_t value, const bool shouldStorageUpdate /* = false*/, const bool shouldTrackModification /*= true*/) {
	if (isStorageKeyInRange(key, PSTRG_RESERVED_RANGE_START, PSTRG_RESERVED_RANGE_SIZE)) {
		if (isStorageKeyInRange(key, PSTRG_OUTFITS_RANGE_START, PSTRG_OUTFITS_RANGE_SIZE)) {
			m_player.outfits.emplace_back(
				value >> 16,
				value & 0xFF
			);
			return;
		}
		if (isStorageKeyInRange(key, PSTRG_FAMILIARS_RANGE_START, PSTRG_FAMILIARS_RANGE_SIZE)) {
			m_player.familiars.emplace_back(value >> 16);
			return;
		}

		static constexpr std::array<std::pair<uint32_t, uint32_t>, 5> passThroughRanges { {
			{ PSTRG_MOUNTS_RANGE_START, PSTRG_MOUNTS_RANGE_SIZE },
			{ PSTRG_WING_RANGE_START, PSTRG_WING_RANGE_SIZE },
			{ PSTRG_EFFECT_RANGE_START, PSTRG_EFFECT_RANGE_SIZE },
			{ PSTRG_AURA_RANGE_START, PSTRG_AURA_RANGE_SIZE },
			{ PSTRG_SHADER_RANGE_START, PSTRG_SHADER_RANGE_SIZE },
		} };

		const bool isPassThrough = std::ranges::any_of(passThroughRanges, [&](const auto &r) {
			auto [rangeStart, rangeSize] = r;
			return isStorageKeyInRange(key, rangeStart, rangeSize);
		});

		if (!m_player.m_isUnitTestMock && !isPassThrough) {
			g_logger().warn("Unknown reserved key: {} for player: {}", key, m_player.getName());
		}
	}

	if (value != -1) {
		int32_t oldValue = get(key);
		m_storageMap[key] = value;

		if (shouldTrackModification) {
			m_modifiedKeys.insert(key);
		}
		if (!shouldStorageUpdate) {
			auto currentFrameTime = g_dispatcher().getDispatcherCycle();
			const auto &player = m_player.getPlayer();
			g_events().eventOnStorageUpdate(player, key, value, oldValue, currentFrameTime);
			g_callbacks().executeCallback(EventCallback_t::playerOnStorageUpdate, &EventCallback::playerOnStorageUpdate, player, key, value, oldValue, currentFrameTime);
		}
	} else {
		m_storageMap.erase(key);
		m_modifiedKeys.erase(key);
		m_removedKeys.insert(key);
	}
}

int32_t PlayerStorage::get(const uint32_t key) const {
	int32_t value = -1;
	const auto it = m_storageMap.find(key);
	if (it == m_storageMap.end()) {
		return value;
	}

	value = it->second;
	return value;
}

bool PlayerStorage::has(uint32_t key) const {
	return m_storageMap.find(key) != m_storageMap.end();
}

int32_t PlayerStorage::get(const std::string &storageName) const {
	const auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		return -1;
	}
	const uint32_t key = it->second;

	return get(key);
}

void PlayerStorage::add(const std::string &storageName, const int32_t value) {
	auto it = g_storages().getStorageMap().find(storageName);
	if (it == g_storages().getStorageMap().end()) {
		g_logger().error("[{}] Storage name '{}' not found in storage map, register your storage in 'storages.xml' first for use", __func__, storageName);
		return;
	}
	const uint32_t key = it->second;
	add(key, value);
}

bool PlayerStorage::remove(const uint32_t key) {
	if (!has(key)) {
		return false;
	}

	m_storageMap.erase(key);
	m_modifiedKeys.erase(key);
	m_removedKeys.insert(key);
	return true;
}

bool PlayerStorage::save() {
	getReservedRange();

	if (m_removedKeys.empty() && m_modifiedKeys.empty()) {
		return true;
	}

	Benchmark benchmarkSaveStorage;
	if (!m_removedKeys.empty()) {
		std::string keysList = fmt::format("{}", fmt::join(m_removedKeys, ", "));
		std::string deleteQuery = fmt::format(
			"DELETE FROM `player_storage` WHERE `player_id` = {} AND `key` IN ({})",
			m_player.getGUID(), keysList
		);

		if (!g_database().executeQuery(deleteQuery)) {
			g_logger().error("[PlayerStorage::save] - Failed to delete query to player: {}", m_player.getName());
			return false;
		}

		m_removedKeys.clear();
	}

	if (!m_modifiedKeys.empty()) {
		DBInsert storageQuery("INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES ");
		storageQuery.upsert({ "value" });

		auto playerGUID = m_player.getGUID();
		for (const auto key : m_modifiedKeys) {
			auto row = fmt::format("{}, {}, {}", playerGUID, key, m_storageMap.at(key));
			if (!storageQuery.addRow(row)) {
				g_logger().warn("[PlayerStorage::save] - Failed to add row for player storage: {}", m_player.getName());
				return false;
			}
		}

		if (!storageQuery.execute()) {
			g_logger().error("[PlayerStorage::save] - Failed to execute storage insertion for player: {}", m_player.getName());
			return false;
		}

		m_modifiedKeys.clear();
	}

	benchmarkSaveStorage.log("[PlayerStorage::save] Total function time");
	return true;
}

bool PlayerStorage::load() {
	Benchmark benchmarkLoadStorage;
	Database &db = Database::getInstance();
	auto query = fmt::format("SELECT `key`, `value` FROM `player_storage` WHERE `player_id` = {}", m_player.getGUID());

	for (auto result = db.storeQuery(query); result && result->hasNext(); result->next()) {
		uint32_t key = result->getNumber<uint32_t>("key");
		int32_t value = result->getNumber<int32_t>("value");
		add(key, value, true, false);
	}

	benchmarkLoadStorage.log("[PlayerStorage::load] Total function time");
	return true;
}

void PlayerStorage::getReservedRange() {
	auto upsertKey = [&](uint32_t k, int32_t v){
		auto it = m_storageMap.find(k);
		if (it == m_storageMap.end() || it->second != v) {
			m_storageMap[k] = v;
			m_modifiedKeys.insert(k);
		}
	};
	// Generate outfits range
	uint32_t outfits_key = PSTRG_OUTFITS_RANGE_START;
	for (const auto &entry : m_player.outfits) {
		++outfits_key;
		upsertKey(outfits_key, (entry.lookType << 16) | entry.addons);
	}

	// Generate familiars range
	uint32_t familiar_key = PSTRG_FAMILIARS_RANGE_START;
	for (const auto &entry : m_player.familiars) {
		++familiar_key;
		upsertKey(familiar_key, (entry.lookType << 16));
	}
}
