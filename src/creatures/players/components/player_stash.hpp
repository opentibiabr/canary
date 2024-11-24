/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

class Player;

class PlayerStash {
public:
	explicit PlayerStash(Player &player);

	void add(uint16_t itemId, uint32_t count = 1);

	uint32_t getCount(uint16_t itemId) const;

	bool remove(uint16_t itemId, uint32_t amount);

	bool find(uint16_t itemId) const;

	const std::map<uint16_t, uint32_t> &getItems() const;

	uint16_t getSize() const;

	bool load();

	bool save();

private:
	// Map of <itemId, itemCount> for the stash
	std::map<uint16_t, uint32_t> m_stashItems;
	std::map<uint16_t, uint32_t> m_modifiedItems;
	std::set<uint16_t> m_removedItems;
	Player &m_player;
};
