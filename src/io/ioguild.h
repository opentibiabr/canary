/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO_IOGUILD_H_
#define SRC_IO_IOGUILD_H_

class Guild;
using GuildWarVector = std::vector<uint32_t>;

class IOGuild
{
	public:
		static Guild* loadGuild(uint32_t guildId);
    static void saveGuild(Guild* guild);
		static uint32_t getGuildIdByName(const std::string& name);
		static void getWarList(uint32_t guildId, GuildWarVector& guildWarVector);
};

#endif  // SRC_IO_IOGUILD_H_
