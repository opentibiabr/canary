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

#include "pch.hpp"

#include "database/databasemanager.h"
#include "database/databasetasks.h"
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
				lua_State* luaState = g_luaEnvironment.getLuaState();
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
				env->setScriptId(scriptId, &g_luaEnvironment);
				g_luaEnvironment.callFunction(1);

				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().addTask(getString(L, -1), callback);
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
				lua_State* luaState = g_luaEnvironment.getLuaState();
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
				env->setScriptId(scriptId, &g_luaEnvironment);
				g_luaEnvironment.callFunction(1);

				luaL_unref(luaState, LUA_REGISTRYINDEX, ref);
		};
	}
	g_databaseTasks().addTask(getString(L, -1), callback, true);
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
