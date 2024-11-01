/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

class Player;

class PlayerStorage {
public:
	explicit PlayerStorage(Player &player);

	void add(const uint32_t key, const int32_t value, const bool shouldStorageUpdate = false, const bool shouldTrackModification = true);
	bool remove(const uint32_t key);
	bool has(const uint32_t key) const;
	int32_t get(const uint32_t key) const;

	int32_t get(const std::string &storageName) const;
	void add(const std::string &storageName, const int32_t value);

	bool save();
	bool load();

private:
	void getReservedRange();

	Player &m_player;
	std::map<uint32_t, int32_t> m_storageMap;
	std::set<uint32_t> m_modifiedKeys;
	std::set<uint32_t> m_removedKeys;
};
