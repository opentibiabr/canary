/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

#include "enums/forge_conversion.hpp"

class Player;

struct ForgeHistory {
	ForgeAction_t actionType = ForgeAction_t::FUSION;
	uint8_t tier = 0;
	uint8_t bonus = 0;

	uint64_t createdAt;

	uint32_t id = 0;

	uint64_t cost = 0;
	uint64_t dustCost = 0;
	uint64_t coresCost = 0;
	uint64_t gained = 0;

	bool success = false;
	bool tierLoss = false;
	bool successCore = false;
	bool tierCore = false;
	bool convergence = false;

	std::string description;
	std::string firstItemName;
	std::string secondItemName;
};

class PlayerForgeHistory {
public:
	PlayerForgeHistory() = delete;
	explicit PlayerForgeHistory(Player &player);

	const std::vector<ForgeHistory> &get() const;
	void add(const ForgeHistory &history);
	void remove(uint32_t id);

	bool load();
	bool save();

private:
	std::vector<ForgeHistory> m_history;
	std::vector<ForgeHistory> m_modifiedHistory;
	std::vector<uint32_t> m_removedHistoryIds;
	Player &m_player;
};
