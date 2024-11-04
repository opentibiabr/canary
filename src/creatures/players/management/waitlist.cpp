/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/management/waitlist.hpp"

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

#include "enums/account_type.hpp"

constexpr std::size_t SLOT_LIMIT_ONE = 5;
constexpr std::size_t SLOT_LIMIT_TWO = 10;
constexpr std::size_t SLOT_LIMIT_THREE = 20;
constexpr std::size_t SLOT_LIMIT_FOUR = 50;
constexpr std::size_t TIMEOUT_EXTRA = 15;

WaitingList::WaitingList() :
	info(new WaitListInfo) { }

WaitingList &WaitingList::getInstance() {
	return inject<WaitingList>();
}

void WaitingList::cleanupList(WaitList &list) const {
	const int64_t time = OTSYS_TIME();

	auto it = list.begin();
	while (it != list.end()) {
		const auto timeout = static_cast<int64_t>(it->timeout);
		g_logger().debug("[{}] time: {}", __FUNCTION__, timeout - time);
		if ((timeout - time) <= 0) {
			info->playerReferences.erase(it->playerGUID);
			it = list.erase(it);
		} else {
			++it;
		}
	}
}

std::size_t WaitingList::getTimeout(std::size_t slot) const {
	return WaitingList::getTime(slot) + TIMEOUT_EXTRA;
}

std::size_t WaitingList::getTime(std::size_t slot) {
	if (slot < SLOT_LIMIT_ONE) {
		return 5;
	}
	if (slot < SLOT_LIMIT_TWO) {
		return 10;
	}
	if (slot < SLOT_LIMIT_THREE) {
		return 20;
	}
	if (slot < SLOT_LIMIT_FOUR) {
		return 60;
	}
	return 120;
}

bool WaitingList::clientLogin(const std::shared_ptr<Player> &player) const {
	if (player->hasFlag(PlayerFlags_t::CanAlwaysLogin) || player->getAccountType() >= ACCOUNT_TYPE_GAMEMASTER) {
		return true;
	}

	auto maxPlayers = static_cast<uint32_t>(g_configManager().getNumber(MAX_PLAYERS));
	if (maxPlayers == 0 || (info->priorityWaitList.empty() && info->waitList.empty() && g_game().getPlayersOnline() < maxPlayers)) {
		return true;
	}

	cleanupList(info->priorityWaitList);
	cleanupList(info->waitList);

	addPlayerToList(player);

	auto it = info->playerReferences.find(player->getGUID());
	const std::size_t slot = it->second.second;
	if ((g_game().getPlayersOnline() + slot) <= maxPlayers) {
		// should be able to login now
		info->waitList.erase(it->second.first);
		info->playerReferences.erase(it);
		return true;
	}
	return false;
}

void WaitingList::addPlayerToList(const std::shared_ptr<Player> &player) const {
	auto it = info->playerReferences.find(player->getGUID());
	if (it != info->playerReferences.end()) {
		std::size_t slot;
		if (player->isPremium()) {
			slot = std::distance(info->priorityWaitList.begin(), it->second.first) + 1;
		} else {
			slot = info->priorityWaitList.size() + std::distance(info->waitList.begin(), it->second.first) + 1;
		}
		it->second.second = slot;
		it->second.first->timeout = OTSYS_TIME() + (getTimeout(slot) * 1000);
	} else {
		std::size_t slot = info->priorityWaitList.size();
		if (player->isPremium()) {
			info->priorityWaitList.emplace_back(OTSYS_TIME() + (getTimeout(slot + 1) * 1000), player->getGUID());
			auto insertedIt = std::prev(info->priorityWaitList.end());
			info->playerReferences[player->getGUID()] = { insertedIt, slot + 1 };
		} else {
			slot += info->waitList.size();
			info->waitList.emplace_back(OTSYS_TIME() + (getTimeout(slot + 1) * 1000), player->getGUID());
			auto insertedIt = std::prev(info->waitList.end());
			info->playerReferences[player->getGUID()] = { insertedIt, slot + 1 };
		}
	}
}

std::size_t WaitingList::getClientSlot(const std::shared_ptr<Player> &player) const {
	auto it = info->playerReferences.find(player->getGUID());
	if (it == info->playerReferences.end()) {
		return 0;
	}

	std::size_t slot;
	if (player->isPremium()) {
		slot = std::distance(info->priorityWaitList.begin(), it->second.first) + 1;
	} else {
		slot = info->priorityWaitList.size() + std::distance(info->waitList.begin(), it->second.first) + 1;
	}
	return slot;
}
