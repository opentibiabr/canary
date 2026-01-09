/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/creatures/player/guild_functions.hpp"

#include "game/game.hpp"
#include "creatures/players/grouping/guild.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void GuildFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "Guild", "", GuildFunctions::luaGuildCreate);
	Lua::registerMetaMethod(L, "Guild", "__eq", Lua::luaUserdataCompare);

	Lua::registerMethod(L, "Guild", "getId", GuildFunctions::luaGuildGetId);
	Lua::registerMethod(L, "Guild", "getName", GuildFunctions::luaGuildGetName);
	Lua::registerMethod(L, "Guild", "getMembersOnline", GuildFunctions::luaGuildGetMembersOnline);

	Lua::registerMethod(L, "Guild", "getBankBalance", GuildFunctions::luaGuildGetBankBalance);
	Lua::registerMethod(L, "Guild", "setBankBalance", GuildFunctions::luaGuildSetBankBalance);

	Lua::registerMethod(L, "Guild", "addRank", GuildFunctions::luaGuildAddRank);
	Lua::registerMethod(L, "Guild", "getRankById", GuildFunctions::luaGuildGetRankById);
	Lua::registerMethod(L, "Guild", "getRankByLevel", GuildFunctions::luaGuildGetRankByLevel);

	Lua::registerMethod(L, "Guild", "getMotd", GuildFunctions::luaGuildGetMotd);
	Lua::registerMethod(L, "Guild", "setMotd", GuildFunctions::luaGuildSetMotd);
}

int GuildFunctions::luaGuildCreate(lua_State* L) {
	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);
	const auto &guild = g_game().getGuild(id);
	if (guild) {
		Lua::pushUserdata<Guild>(L, guild);
		Lua::setMetatable(L, -1, "Guild");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetId(lua_State* L) {
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (guild) {
		lua_pushnumber(L, guild->getId());
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetName(lua_State* L) {
	// guild:getName()
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	Lua::pushString(L, guild->getName());
	return 1;
}

int GuildFunctions::luaGuildGetMembersOnline(lua_State* L) {
	// guild:getMembersOnline()
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const auto members = guild->getMembersOnline();
	lua_createtable(L, members.size(), 0);

	int index = 0;
	for (const auto &player : members) {
		Lua::pushUserdata<Player>(L, player);
		Lua::setMetatable(L, -1, "Player");
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

int GuildFunctions::luaGuildGetBankBalance(lua_State* L) {
	// guild:getBankBalance()
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	lua_pushnumber(L, guild->getBankBalance());
	return 1;
}

int GuildFunctions::luaGuildSetBankBalance(lua_State* L) {
	// guild:setBankBalance(bankBalance)
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	guild->setBankBalance(Lua::getNumber<uint64_t>(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int GuildFunctions::luaGuildAddRank(lua_State* L) {
	// guild:addRank(id, name, level)
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);
	const std::string &name = Lua::getString(L, 3);
	const uint8_t level = Lua::getNumber<uint8_t>(L, 4);
	guild->addRank(id, name, level);
	Lua::pushBoolean(L, true);
	return 1;
}

int GuildFunctions::luaGuildGetRankById(lua_State* L) {
	// guild:getRankById(id)
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const uint32_t id = Lua::getNumber<uint32_t>(L, 2);
	const GuildRank_ptr rank = guild->getRankById(id);
	if (rank) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "id", rank->id);
		Lua::setField(L, "name", rank->name);
		Lua::setField(L, "level", rank->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetRankByLevel(lua_State* L) {
	// guild:getRankByLevel(level)
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}

	const uint8_t level = Lua::getNumber<uint8_t>(L, 2);
	const GuildRank_ptr rank = guild->getRankByLevel(level);
	if (rank) {
		lua_createtable(L, 0, 3);
		Lua::setField(L, "id", rank->id);
		Lua::setField(L, "name", rank->name);
		Lua::setField(L, "level", rank->level);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int GuildFunctions::luaGuildGetMotd(lua_State* L) {
	// guild:getMotd()
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	Lua::pushString(L, guild->getMotd());
	return 1;
}

int GuildFunctions::luaGuildSetMotd(lua_State* L) {
	// guild:setMotd(motd)
	const auto &guild = Lua::getUserdataShared<Guild>(L, 1, "Guild");
	if (!guild) {
		lua_pushnil(L);
		return 1;
	}
	const std::string &motd = Lua::getString(L, 2);
	guild->setMotd(motd);
	Lua::pushBoolean(L, true);
	return 1;
}
