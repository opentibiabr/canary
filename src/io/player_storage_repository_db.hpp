/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "io/player_storage_repository.hpp"

/**
 * @brief Database-backed implementation of IPlayerStorageRepository.
 *
 * Uses synchronous SQL queries (via Database/DBInsert) to persist and retrieve
 * player storage values. Intended for production usage.
 *
 * Not thread-safe; calls must be made from the main game thread.
 */
class DbPlayerStorageRepository final : public IPlayerStorageRepository {
public:
	/**
	 * @brief Loads all storage rows for a player from the database.
	 * @param playerId Player GUID.
	 * @return Vector of PlayerStorageRow with all key/value pairs.
	 */
	std::vector<PlayerStorageRow> load(uint32_t playerId) override;

	/**
	 * @brief Deletes a batch of storage keys for a player in the database.
	 * @param playerId Player GUID.
	 * @param keys Keys to delete.
	 * @return true if the DELETE executed successfully.
	 */
	bool deleteKeys(uint32_t playerId, const std::vector<uint32_t> &keys) override;

	/**
	 * @brief Inserts or updates a batch of storage entries for a player.
	 *
	 * Builds a single bulk INSERT ... ON DUPLICATE KEY UPDATE query to
	 * ensure new keys are inserted and existing ones updated in-place.
	 *
	 * @param playerId Player GUID.
	 * @param kv Map of <key,value> pairs to persist.
	 * @return true if the UPSERT executed successfully.
	 *
	 * @note This call overwrites the "value" column for existing keys.
	 * It does not delete missing keys; use @ref deleteKeys for removals.
	 */
	bool upsert(uint32_t playerId, const std::map<uint32_t, int32_t> &kv) override;
};
