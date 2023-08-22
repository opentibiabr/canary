/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class GuildFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "Guild", "", GuildFunctions::luaGuildCreate);
		registerMetaMethod(L, "Guild", "__eq", GuildFunctions::luaUserdataCompare);

		registerMethod(L, "Guild", "getId", GuildFunctions::luaGuildGetId);
		registerMethod(L, "Guild", "getName", GuildFunctions::luaGuildGetName);
		registerMethod(L, "Guild", "getMembersOnline", GuildFunctions::luaGuildGetMembersOnline);

		registerMethod(L, "Guild", "getBankBalance", GuildFunctions::luaGuildGetBankBalance);
		registerMethod(L, "Guild", "setBankBalance", GuildFunctions::luaGuildSetBankBalance);

		registerMethod(L, "Guild", "addRank", GuildFunctions::luaGuildAddRank);
		registerMethod(L, "Guild", "getRankById", GuildFunctions::luaGuildGetRankById);
		registerMethod(L, "Guild", "getRankByLevel", GuildFunctions::luaGuildGetRankByLevel);

		registerMethod(L, "Guild", "getMotd", GuildFunctions::luaGuildGetMotd);
		registerMethod(L, "Guild", "setMotd", GuildFunctions::luaGuildSetMotd);
	}

private:
	static int luaGuildCreate(lua_State* L);

	static int luaGuildGetId(lua_State* L);
	static int luaGuildGetName(lua_State* L);
	static int luaGuildGetMembersOnline(lua_State* L);

	static int luaGuildGetBankBalance(lua_State* L);
	static int luaGuildSetBankBalance(lua_State* L);

	static int luaGuildAddRank(lua_State* L);
	static int luaGuildGetRankById(lua_State* L);
	static int luaGuildGetRankByLevel(lua_State* L);

	static int luaGuildGetMotd(lua_State* L);
	static int luaGuildSetMotd(lua_State* L);
};
