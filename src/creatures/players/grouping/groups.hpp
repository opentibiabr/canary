/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/utils_definitions.hpp"

struct Group {
	std::string name;
	std::array<bool, magic_enum::enum_integer(PlayerFlags_t::FlagLast)> flags { false };
	uint32_t maxDepotItems;
	uint32_t maxVipEntries;
	uint16_t id;
	bool access;
};

class Groups {
public:
	static uint8_t getFlagNumber(PlayerFlags_t playerFlags);
	static PlayerFlags_t getFlagFromNumber(uint8_t value);
	static bool reload();
	bool load();
	[[nodiscard]] std::shared_ptr<Group> getGroup(uint16_t id) const;
	std::vector<std::shared_ptr<Group>> &getGroups();

private:
	std::vector<std::shared_ptr<Group>> groups_vector;
};
