/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/grouping/guild.hpp"

#include "game/game.hpp"

void Guild::addMember(const std::shared_ptr<Player> &player) {
	membersOnline.emplace_back(player);
	for (const auto &member : getMembersOnline()) {
		g_game().updatePlayerHelpers(member);
	}
}

void Guild::removeMember(const std::shared_ptr<Player> &player) {
	// loop over to udpate all members and delete the player from the list
	membersOnline.remove(player);
	for (const auto &member : membersOnline) {
		g_game().updatePlayerHelpers(member);
	}

	g_game().updatePlayerHelpers(player);
	if (membersOnline.empty()) {
		g_game().removeGuild(id);
	}
}

GuildRank_ptr Guild::getRankById(uint32_t rankId) const {
	for (const auto &rank : ranks) {
		if (rank->id == rankId) {
			return rank;
		}
	}
	return nullptr;
}

GuildRank_ptr Guild::getRankByName(const std::string &guildName) const {
	for (const auto &rank : ranks) {
		if (rank->name == guildName) {
			return rank;
		}
	}
	return nullptr;
}

GuildRank_ptr Guild::getRankByLevel(uint8_t level) const {
	for (const auto &rank : ranks) {
		if (rank->level == level) {
			return rank;
		}
	}
	return nullptr;
}

void Guild::addRank(uint32_t rankId, const std::string &rankName, uint8_t level) {
	ranks.emplace_back(std::make_shared<GuildRank>(rankId, rankName, level));
}
