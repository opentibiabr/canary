/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_CREATURES_PLAYERS_GROUPING_GROUPS_H_
#define SRC_CREATURES_PLAYERS_GROUPING_GROUPS_H_

struct Group {
	std::string name;
	uint64_t flags;
	uint64_t customflags;
	uint32_t maxDepotItems;
	uint32_t maxVipEntries;
	uint16_t id;
	bool access;
};

class Groups {
	public:
		bool load();
		Group* getGroup(uint16_t id);

	private:
		std::vector<Group> groups;
};

#endif  // SRC_CREATURES_PLAYERS_GROUPING_GROUPS_H_
