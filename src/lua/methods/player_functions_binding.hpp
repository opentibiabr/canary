/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_METHODS_PLAYER_LUA_BINDING_HPP_
#define SRC_LUA_METHODS_PLAYER_LUA_BINDING_HPP_

#include "lua/methods/player_functions.hpp"

#include "lua/scripts/luascript.h"

class LuaPlayerFunctionsBinding : public LuaScriptInterface
{
public:
	static void init(lua_State* L);

	static const std::unordered_map<std::string, lua_CFunction> getPlayerFunctionsMap(lua_State *L);
};

#endif  // SRC_LUA_METHODS_PLAYER_LUA_BINDING_HPP_
