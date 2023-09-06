/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Guild;
using GuildWarVector = std::vector<uint32_t>;

class IOGuild {
public:
	static std::shared_ptr<Guild> loadGuild(uint32_t guildId);
	static void saveGuild(const std::shared_ptr<Guild> guild);
	static uint32_t getGuildIdByName(const std::string &name);
	static void getWarList(uint32_t guildId, GuildWarVector &guildWarVector);
};
