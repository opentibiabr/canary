/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.hpp"
#include "creatures/players/grouping/guild.hpp"
#include "lua/functions/creatures/player/guild_functions.hpp"

int GuildFunctions::luaGuildCreate(lua_State* L) {
	uint32_t id = getNumber<uint32_t>(L, 2);
	const auto guild = g_game().getGuild(id);
	if (guild) {
		pushUserdata<Guild>(L, guild);
		setMetatable(L, -1, "Guild");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetId(lua_State* L) {
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (guild) {
		lua_pushnumber(L, guild->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetName(lua_State* L) {
	// guild:getName()
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	pushString(L, guild->getName());
	return 1;
}

int GuildFunctions::luaGuildGetMembersOnline(lua_State* L) {
	// guild:getMembersOnline()
	const auto guild = getUserdataShared<const Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const auto members = guild->getMembersOnline();
	lua_createtable(L, members.size(), 0);

	int index = 0;
	for (std::shared_ptr<Player> player : members) {
		pushUserdata<Player>(L, player);
		setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GuildFunctions::luaGuildGetBankBalance(lua_State* L) {
	// guild:getBankBalance()
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	lua_pushnumber(L, guild->getBankBalance());
	return 1;
}

int GuildFunctions::luaGuildSetBankBalance(lua_State* L) {
	// guild:setBankBalance(bankBalance)
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	guild->setBankBalance(getNumber<uint64_t>(L, 2));
	pushBoolean(L, true);
	return 1;
}

int GuildFunctions::luaGuildAddRank(lua_State* L) {
	// guild:addRank(id, name, level)
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	uint32_t id = getNumber<uint32_t>(L, 2);
	const std::string &name = getString(L, 3);
	uint8_t level = getNumber<uint8_t>(L, 4);
	guild->addRank(id, name, level);
	pushBoolean(L, true);
	return 1;
}

int GuildFunctions::luaGuildGetRankById(lua_State* L) {
	// guild:getRankById(id)
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint32_t id = getNumber<uint32_t>(L, 2);
	GuildRank_ptr rank = guild->getRankById(id);
	if (rank) {
		lua_createtable(L, 0, 3);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "level", rank->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetRankByLevel(lua_State* L) {
	// guild:getRankByLevel(level)
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	uint8_t level = getNumber<uint8_t>(L, 2);
	GuildRank_ptr rank = guild->getRankByLevel(level);
	if (rank) {
		lua_createtable(L, 0, 3);
		setField(L, "id", rank->id);
		setField(L, "name", rank->name);
		setField(L, "level", rank->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetMotd(lua_State* L) {
	// guild:getMotd()
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	pushString(L, guild->getMotd());
	return 1;
}

int GuildFunctions::luaGuildSetMotd(lua_State* L) {
	// guild:setMotd(motd)
	const auto guild = getUserdataShared<Guild>(L, 1);
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	const std::string &motd = getString(L, 2);
	guild->setMotd(motd);
	pushBoolean(L, true);
	return 1;
}
