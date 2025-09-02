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
#include "game/scheduling/dispatcher.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "lua/creature/events.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <utility>
	#include <ranges>
	#include <vector>
#endif

namespace {
	constexpr std::array<std::pair<uint32_t, uint32_t>, 5> kPassThroughRanges { {
		{ PSTRG_MOUNTS_RANGE_START, PSTRG_MOUNTS_RANGE_SIZE },
		{ PSTRG_WING_RANGE_START, PSTRG_WING_RANGE_SIZE },
		{ PSTRG_EFFECT_RANGE_START, PSTRG_EFFECT_RANGE_SIZE },
		{ PSTRG_AURA_RANGE_START, PSTRG_AURA_RANGE_SIZE },
		{ PSTRG_SHADER_RANGE_START, PSTRG_SHADER_RANGE_SIZE },
	} };

	inline bool isInPassThrough(uint32_t key) {
		return std::ranges::any_of(kPassThroughRanges, [key](const auto &r) {
			auto [rangeStart, rangeSize] = r;
			return isStorageKeyInRange(key, rangeStart, rangeSize);
		});
	}
} // namespace

PlayerStorage::PlayerStorage(Player &player) :
	m_player(player) { }

void PlayerStorage::ingest(const std::vector<PlayerStorageRow> &rows) {
	m_storageMap.clear();
	m_modifiedKeys.clear();
	m_removedKeys.clear();
	for (const auto &row : rows) {
		add(row.key, row.value, true, false);
	}
}

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

		if (!isInPassThrough(key)) {
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
	return m_storageMap.contains(key);
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

void PlayerStorage::prepareForPersist() {
	getReservedRange();
}

PlayerStorage::PlayerStorageDelta PlayerStorage::delta() const {
	PlayerStorageDelta data;
	for (auto key : m_modifiedKeys) {
		data.upserts.emplace(key, m_storageMap.at(key));
	}
	data.deletions.assign(m_removedKeys.begin(), m_removedKeys.end());
	return data;
}

void PlayerStorage::clearDirty() {
	m_modifiedKeys.clear();
	m_removedKeys.clear();
}

void PlayerStorage::getReservedRange() {
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

void PlayerStorage::upsertKey(uint32_t key, int32_t value) {
	auto it = m_storageMap.find(key);
	if (it == m_storageMap.end() || it->second != value) {
		m_storageMap[key] = value;
		m_modifiedKeys.insert(key);
	}
}
