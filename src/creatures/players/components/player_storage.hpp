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
#endif

class Player;

/**
 * @brief Manages a player's persistent storages.
 *
 * Encapsulates the player's storage map, providing operations for
 * reading, writing, saving, and loading.
 */
class PlayerStorage {
public:
	/**
	 * @brief Constructs the storage manager.
	 * @param player Reference to the owning player.
	 */
	explicit PlayerStorage(Player &player);

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
	 * @brief Gets the value of a key registered by name.
	 */
	int32_t get(const std::string &storageName) const;

	/**
	 * @brief Sets the value of a key registered by name.
	 */
	void add(const std::string &storageName, int32_t value);

	/**
	 * @brief Saves pending changes to the database.
	 */
	bool save();

	/**
	 * @brief Loads values from the database.
	 */
	bool load();

	/**
	 * @brief Returns the full storage map.
	 */
	auto getStorageMap() const {
		return m_storageMap;
	}

	/**
	 * @brief Returns the keys modified since the last save.
	 */
	auto getModifiedKeys() const {
		return m_modifiedKeys;
	}

	/**
	 * @brief Returns the keys removed since the last save.
	 */
	auto getRemovedKeys() const {
		return m_removedKeys;
	}

	/**
	 * @brief Replaces the internal storage state.
	 */
	void setStorageData(const std::map<uint32_t, int32_t> &storageMap, const std::set<uint32_t> &modified, const std::set<uint32_t> &removed) {
		m_storageMap = storageMap;
		m_modifiedKeys = modified;
		m_removedKeys = removed;
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
	 * @brief Reference to the Player owning this storage manager.
	 *
	 * No ownership is implied. Assumes the Player's lifetime outlives
	 * the PlayerStorage. Access is not thread-safe; use only in the game thread.
	 */
	Player &m_player;

	/**
	 * @brief Key→value map of persistent storages.
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
