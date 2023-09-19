/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Player;

struct WaitListInfo;

struct Wait {
	constexpr Wait(std::size_t initTimeout, uint32_t initPlayerGUID) :
		timeout(initTimeout), playerGUID(initPlayerGUID) { }

	std::size_t timeout;
	uint32_t playerGUID;
};

using WaitList = std::list<Wait>;

struct WaitListInfo {
	WaitList priorityWaitList;
	WaitList waitList;

	phmap::flat_hash_map<uint32_t, std::pair<WaitList::iterator, std::size_t>> playerReferences;
};

class WaitingList {
public:
	WaitingList();
	static WaitingList &getInstance();
	bool clientLogin(std::shared_ptr<Player> player);
	std::size_t getClientSlot(std::shared_ptr<Player> player);
	static std::size_t getTime(std::size_t slot);

private:
	void cleanupList(WaitList &list);
	std::size_t getTimeout(std::size_t slot);
	void addPlayerToList(std::shared_ptr<Player> player);
	std::unique_ptr<WaitListInfo> info;
};
