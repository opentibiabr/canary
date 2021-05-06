/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GUILD_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GUILD_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class GuildFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Guild", "", GuildFunctions::luaGuildCreate);
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

#endif  // SRC_LUA_FUNCTIONS_CREATURES_PLAYER_GUILD_FUNCTIONS_HPP_
