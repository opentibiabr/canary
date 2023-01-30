/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_CREATURES_PLAYERS_MANAGEMENT_WAITLIST_H_
#define SRC_CREATURES_PLAYERS_MANAGEMENT_WAITLIST_H_

struct WaitListInfo;

class WaitingList
{
	public:
		static WaitingList& getInstance();

		bool clientLogin(const Player* player);
		std::size_t getClientSlot(const Player* player);
		static std::size_t getTime(std::size_t slot);

	private:
		WaitingList();

		std::unique_ptr<WaitListInfo> info;
};

#endif  // SRC_CREATURES_PLAYERS_MANAGEMENT_WAITLIST_H_
