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

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_DB_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_DB_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class DBFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "db");
			registerMethod(L, "db", "query", DBFunctions::luaDatabaseExecute);
			registerMethod(L, "db", "asyncQuery", DBFunctions::luaDatabaseAsyncExecute);
			registerMethod(L, "db", "storeQuery", DBFunctions::luaDatabaseStoreQuery);
			registerMethod(L, "db", "asyncStoreQuery", DBFunctions::luaDatabaseAsyncStoreQuery);
			registerMethod(L, "db", "escapeString", DBFunctions::luaDatabaseEscapeString);
			registerMethod(L, "db", "escapeBlob", DBFunctions::luaDatabaseEscapeBlob);
			registerMethod(L, "db", "lastInsertId", DBFunctions::luaDatabaseLastInsertId);
			registerMethod(L, "db", "tableExists", DBFunctions::luaDatabaseTableExists);
		}

	private:
		static int luaDatabaseAsyncExecute(lua_State* L);
		static int luaDatabaseAsyncStoreQuery(lua_State* L);
		static int luaDatabaseEscapeBlob(lua_State* L);
		static int luaDatabaseEscapeString(lua_State* L);
		static int luaDatabaseExecute(lua_State* L);
		static int luaDatabaseLastInsertId(lua_State* L);
		static int luaDatabaseStoreQuery(lua_State* L);
		static int luaDatabaseTableExists(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_DB_FUNCTIONS_HPP_
