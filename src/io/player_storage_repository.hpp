/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/components/player_storage.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
	#include <map>
	#include <vector>
#endif

class IPlayerStorageRepository {
public:
	virtual ~IPlayerStorageRepository() = default;

	/**
	 * @brief Loads all storage rows for a given player.
	 * @param playerId Database GUID of the player.
	 * @return Vector of key/value rows. Empty if none exist.
	 */
	virtual std::vector<PlayerStorageRow> load(uint32_t playerId) = 0;

	/**
	 * @brief Deletes a batch of storage keys for a player.
	 * @param playerId Database GUID of the player.
	 * @param keys Keys to remove.
	 * @return true if the operation succeeded.
	 */
	virtual bool deleteKeys(uint32_t playerId, const std::vector<uint32_t> &keys) = 0;

	/**
	 * @brief Inserts or updates a batch of key/value pairs for a player.
	 * @param playerId Database GUID of the player.
	 * @param kv Map of keys and values to upsert.
	 * @return true if the operation succeeded.
	 */
	virtual bool upsert(uint32_t playerId, const std::map<uint32_t, int32_t> &kv) = 0;
};

IPlayerStorageRepository &g_playerStorageRepository();
