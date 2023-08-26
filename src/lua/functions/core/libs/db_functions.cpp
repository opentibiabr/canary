/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "database/databasemanager.hpp"
#include "database/databasetasks.hpp"
#include "lua/functions/core/libs/db_functions.hpp"
#include "lua/scripts/lua_environment.hpp"

int DBFunctions::luaDatabaseExecute(lua_State* L) {
	pushBoolean(L, Database::getInstance().executeQuery(getString(L, -1)));
	return 1;
}

int DBFunctions::luaDatabaseAsyncExecute(lua_State* L) {
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = getScriptEnv()->getScriptId();
		callback = [ref, scriptId](DBResult_ptr, bool success) {
			lua_State* luaState = g_luaEnvironment().getLuaState();
			if (!luaState) {
				return;
			}

			if (!DBFunctions::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			pushBoolean(luaState, success);
			auto env = getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment());
			g_luaEnvironment().callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().execute(getString(L, -1), callback);
	return 0;
}

int DBFunctions::luaDatabaseStoreQuery(lua_State* L) {
	if (DBResult_ptr res = Database::getInstance().storeQuery(getString(L, -1))) {
		lua_pushnumber(L, ScriptEnvironment::addResult(res));
	} else {
		pushBoolean(L, false);
	}
	return 1;
}

int DBFunctions::luaDatabaseAsyncStoreQuery(lua_State* L) {
	std::function<void(DBResult_ptr, bool)> callback;
	if (lua_gettop(L) > 1) {
		int32_t ref = luaL_ref(L, LUA_REGISTRYINDEX);
		auto scriptId = getScriptEnv()->getScriptId();
		callback = [ref, scriptId](DBResult_ptr result, bool) {
			lua_State* luaState = g_luaEnvironment().getLuaState();
			if (!luaState) {
				return;
			}

			if (!DBFunctions::reserveScriptEnv()) {
				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
				return;
			}

			lua_rawgeti(luaState, LUA_REGISTRYINDEX, ref);
			if (result) {
				lua_pushnumber(luaState, ScriptEnvironment::addResult(result));
			} else {
				pushBoolean(luaState, false);
			}
			auto env = getScriptEnv();
			env->setScriptId(scriptId, &g_luaEnvironment());
			g_luaEnvironment().callFunction(1);

			luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().store(getString(L, -1), callback);
	return 0;
}

int DBFunctions::luaDatabaseEscapeString(lua_State* L) {
	pushString(L, Database::getInstance().escapeString(getString(L, -1)));
	return 1;
}

int DBFunctions::luaDatabaseEscapeBlob(lua_State* L) {
	uint32_t length = getNumber<uint32_t>(L, 2);
	pushString(L, Database::getInstance().escapeBlob(getString(L, 1).c_str(), length));
	return 1;
}

int DBFunctions::luaDatabaseLastInsertId(lua_State* L) {
	lua_pushnumber(L, Database::getInstance().getLastInsertId());
	return 1;
}

int DBFunctions::luaDatabaseTableExists(lua_State* L) {
	pushBoolean(L, DatabaseManager::tableExists(getString(L, -1)));
	return 1;
}
