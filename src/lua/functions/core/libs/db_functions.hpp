/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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
