/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <map>
	#include <set>
	#include <string>
	#include <vector>
#endif

class Player;

/**
 * @brief Single storage entry.
 *
 * Represents one key > value pair loaded from or saved to the database.
 */
struct PlayerStorageRow {
	uint32_t key; // Storage key identifier
	int32_t value; // Stored integer value
};

/**
 * @brief Manages a player's persistent storages.
 */
class PlayerStorage {
public:
	/**
	 * @brief Constructs the storage manager.
	 * @param player Reference to the owning player.
	 */
	explicit PlayerStorage(Player &player);

	/**
	 * @brief Loads storage rows into memory.
	 */
	void ingest(const std::vector<PlayerStorageRow> &rows);

	/**
	 * @brief Sets the value of a storage key.
	 *
	 * @param key Storage key number.
	 * @param value Value to assign; use -1 to remove.
	 * @param shouldStorageUpdate If false, triggers update events.
	 * @param shouldTrackModification If false, does not mark the key as modified.
	 */
	void add(uint32_t key, int32_t value, bool shouldStorageUpdate = false, bool shouldTrackModification = true);

	/**
	 * @brief Removes a storage key.
	 * @param key Key to remove.
	 * @return true if the key existed.
	 */
	bool remove(uint32_t key);

	/**
	 * @brief Checks whether a key exists.
	 */
	bool has(uint32_t key) const;

	/**
	 * @brief Gets the value of a key.
	 * @return Value of the key or -1 if missing.
	 */
	int32_t get(uint32_t key) const;

	/**
	 * @brief Synchronizes reserved ranges prior to persistence.
	 */
	void prepareForPersist();

	/**
	 * @brief Represents the difference between in-memory storage state and the database.
	 *
	 * Used by IO code to persist only what changed since the last synchronization.
	 *
	 * - @ref upserts contains key>value pairs that must be inserted or updated.
	 * - @ref deletions contains keys that must be removed from the database.
	 *
	 * Produced by @ref PlayerStorage::delta() and consumed by repository calls
	 * (e.g., IPlayerStorageRepository::upsert / deleteKeys).
	 */
	struct PlayerStorageDelta {
		// Keys that were added or modified; should be upserted into the database.
		std::map<uint32_t, int32_t> upserts;

		// Keys that were removed; should be deleted from the database.
		std::vector<uint32_t> deletions;
	};

	/**
	 * @brief Computes pending changes without touching the database.
	 */
	PlayerStorageDelta delta() const;

	/**
	 * @brief Clears modified and removed tracking sets.
	 */
	void clearDirty();

	/**
	 * @brief Returns the full storage map.
	 */
	auto getStorageMap() const {
		return m_storageMap;
	}

	/**
	 * @brief Returns the keys modified since the last persistence.
	 */
	auto getModifiedKeys() const {
		return m_modifiedKeys;
	}

	/**
	 * @brief Returns the keys removed since the last persistence.
	 */
	auto getRemovedKeys() const {
		return m_removedKeys;
	}

private:
	/**
	 * @brief Populates the map with values from reserved ranges.
	 *
	 * Mirrors into @ref m_storageMap the data derived from Player-owned
	 * structures that are not stored directly (e.g., outfits and familiars).
	 * Must be called before persisting to ensure consistency between memory and DB.
	 */
	void getReservedRange();

	/**
	 * @brief Inserts or updates a storage key if value differs.
	 *
	 * - Creates the key if missing.
	 * - Updates it if the value changed.
	 * - Marks the key as modified for the next save.
	 *
	 * @param k Storage key.
	 * @param v Value to assign.
	 */
	void upsertKey(uint32_t key, int32_t value);

	/**
	 * @brief Reference to the Player owning this storage manager.
	 *
	 * No ownership is implied. Assumes the Player's lifetime outlives
	 * the PlayerStorage. Access is not thread-safe; use only in the game thread.
	 */
	Player &m_player;

	/**
	 * @brief Key>value map of persistent storages.
	 *
	 * Contains only keys actually stored. Special values:
	 * - Missing key: interpreted as -1 by @ref get(uint32_t).
	 * - Value -1: treated as removal in @ref add(uint32_t,int32_t,...).
	 */
	std::map<uint32_t, int32_t> m_storageMap;

	/**
	 * @brief Set of keys modified since the last @ref save().
	 *
	 * Used for batch UPSERT. If a key is later removed, it is erased
	 * from here and moved into @ref m_removedKeys.
	 */
	std::set<uint32_t> m_modifiedKeys;

	/**
	 * @brief Set of keys removed and pending deletion in the DB.
	 *
	 * Processed first in @ref save() via DELETE with IN (...).
	 * Cleared after success. Never loaded from the DB.
	 */
	std::set<uint32_t> m_removedKeys;
};
