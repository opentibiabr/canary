/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/libs/result_functions.hpp"

int ResultFunctions::luaResultGetNumber(lua_State* L) {
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	const std::string &s = getString(L, 2);
	lua_pushnumber(L, res->getI64(s));
	return 1;
}

int ResultFunctions::luaResultGetString(lua_State* L) {
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	const std::string &s = getString(L, 2);
	pushString(L, res->getString(s));
	return 1;
}

int ResultFunctions::luaResultGetStream(lua_State* L) {
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, 1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	auto stream = res->getStream(getString(L, 2));
	lua_pushlstring(L, reinterpret_cast<const char*>(stream.data()), stream.size());
	lua_pushnumber(L, stream.size());
	return 2;
}

int ResultFunctions::luaResultNext(lua_State* L) {
	DBResult_ptr res = ScriptEnvironment::getResultByID(getNumber<uint32_t>(L, -1));
	if (!res) {
		pushBoolean(L, false);
		return 1;
	}

	pushBoolean(L, res->next());
	return 1;
}

int ResultFunctions::luaResultFree(lua_State* L) {
	pushBoolean(L, ScriptEnvironment::removeResult(getNumber<uint32_t>(L, -1)));
	return 1;
}
