/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/libs/db_functions.hpp"

#include "database/databasemanager.hpp"
#include "database/databasetasks.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void DBFunctions::init(lua_State* L) {
	Lua::registerTable(L, "db");
	Lua::registerMethod(L, "db", "query", DBFunctions::luaDatabaseExecute);
	Lua::registerMethod(L, "db", "asyncQuery", DBFunctions::luaDatabaseAsyncExecute);
	Lua::registerMethod(L, "db", "storeQuery", DBFunctions::luaDatabaseStoreQuery);
	Lua::registerMethod(L, "db", "asyncStoreQuery", DBFunctions::luaDatabaseAsyncStoreQuery);
	Lua::registerMethod(L, "db", "escapeString", DBFunctions::luaDatabaseEscapeString);
	Lua::registerMethod(L, "db", "escapeBlob", DBFunctions::luaDatabaseEscapeBlob);
	Lua::registerMethod(L, "db", "lastInsertId", DBFunctions::luaDatabaseLastInsertId);
	Lua::registerMethod(L, "db", "tableExists", DBFunctions::luaDatabaseTableExists);
}

int DBFunctions::luaDatabaseExecute(lua_State* L) {
	Lua::pushBoolean(L, Database::getInstance().executeQuery(Lua::getString(L, -1)));
	return 1;
}

int DBFunctions::luaDatabaseAsyncExecute(lua_State* L) {
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = Lua::getScriptEnv()->getScriptId();
		callback = [ref, scriptId](const DBResult_ptr &, bool success) {
			lua_State* luaState = g_luaEnvironment().getLuaState();
			if (!luaState) {
				return;
			}

			if (!Lua::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			Lua::pushBoolean(luaState, success);
			const auto env = Lua::getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment());
			g_luaEnvironment().callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().execute(Lua::getString(L, -1), callback);
	return 0;
}

int DBFunctions::luaDatabaseStoreQuery(lua_State* L) {
	if (const DBResult_ptr &res = Database::getInstance().storeQuery(Lua::getString(L, -1))) {
		lua_pushnumber(L, ScriptEnvironment::addResult(res));
	} else {
		Lua::pushBoolean(L, false);
	}
	return 1;
}

int DBFunctions::luaDatabaseAsyncStoreQuery(lua_State* L) {
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = Lua::getScriptEnv()->getScriptId();
		callback = [ref, scriptId](const DBResult_ptr &result, bool) {
			lua_State* luaState = g_luaEnvironment().getLuaState();
			if (!luaState) {
				return;
			}

			if (!Lua::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			if (result) {
				lua_pushnumber(luaState, ScriptEnvironment::addResult(result));
			} else {
				Lua::pushBoolean(luaState, false);
			}
			const auto env = Lua::getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment());
			g_luaEnvironment().callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().store(Lua::getString(L, -1), callback);
	return 0;
}

int DBFunctions::luaDatabaseEscapeString(lua_State* L) {
	Lua::pushString(L, Database::getInstance().escapeString(Lua::getString(L, -1)));
	return 1;
}

int DBFunctions::luaDatabaseEscapeBlob(lua_State* L) {
	const uint32_t length = Lua::getNumber<uint32_t>(L, 2);
	Lua::pushString(L, Database::getInstance().escapeBlob(Lua::getString(L, 1).c_str(), length));
	return 1;
}

int DBFunctions::luaDatabaseLastInsertId(lua_State* L) {
	lua_pushnumber(L, Database::getInstance().getLastInsertId());
	return 1;
}

int DBFunctions::luaDatabaseTableExists(lua_State* L) {
	Lua::pushBoolean(L, DatabaseManager::tableExists(Lua::getString(L, -1)));
	return 1;
}
