/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/libs/result_functions.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void ResultFunctions::init(lua_State* L) {
	Lua::registerTable(L, "Result");
	Lua::registerMethod(L, "Result", "getNumber", ResultFunctions::luaResultGetNumber);
	Lua::registerMethod(L, "Result", "getString", ResultFunctions::luaResultGetString);
	Lua::registerMethod(L, "Result", "getStream", ResultFunctions::luaResultGetStream);
	Lua::registerMethod(L, "Result", "next", ResultFunctions::luaResultNext);
	Lua::registerMethod(L, "Result", "free", ResultFunctions::luaResultFree);
}

int ResultFunctions::luaResultGetNumber(lua_State* L) {
	const auto &res = ScriptEnvironment::getResultByID(Lua::getNumber<uint32_t>(L, 1));
	if (!res) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const std::string &s = Lua::getString(L, 2);
	lua_pushnumber(L, res->getNumber<int64_t>(s));
	return 1;
}

int ResultFunctions::luaResultGetString(lua_State* L) {
	const auto &res = ScriptEnvironment::getResultByID(Lua::getNumber<uint32_t>(L, 1));
	if (!res) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	const std::string &s = Lua::getString(L, 2);
	Lua::pushString(L, res->getString(s));
	return 1;
}

int ResultFunctions::luaResultGetStream(lua_State* L) {
	const auto &res = ScriptEnvironment::getResultByID(Lua::getNumber<uint32_t>(L, 1));
	if (!res) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	unsigned long length;
	const char* stream = res->getStream(Lua::getString(L, 2), length);
	lua_pushlstring(L, stream, length);
	lua_pushnumber(L, length);
	return 2;
}

int ResultFunctions::luaResultNext(lua_State* L) {
	const auto &res = ScriptEnvironment::getResultByID(Lua::getNumber<uint32_t>(L, -1));
	if (!res) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, res->next());
	return 1;
}

int ResultFunctions::luaResultFree(lua_State* L) {
	Lua::pushBoolean(L, ScriptEnvironment::removeResult(Lua::getNumber<uint32_t>(L, -1)));
	return 1;
}
