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

class BitFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
#ifndef LUAJIT_VERSION
		registerTable(L, "bit");
		registerMethod(L, "bit", "bnot", BitFunctions::luaBitNot);
		registerMethod(L, "bit", "band", BitFunctions::luaBitAnd);
		registerMethod(L, "bit", "bor", BitFunctions::luaBitOr);
		registerMethod(L, "bit", "bxor", BitFunctions::luaBitXor);
		registerMethod(L, "bit", "lshift", BitFunctions::luaBitLeftShift);
		registerMethod(L, "bit", "rshift", BitFunctions::luaBitRightShift);
#endif
	}

private:
#ifndef LUAJIT_VERSION
	static int luaBitAnd(lua_State* L);
	static int luaBitLeftShift(lua_State* L);
	static int luaBitNot(lua_State* L);
	static int luaBitOr(lua_State* L);
	static int luaBitRightShift(lua_State* L);
	static int luaBitXor(lua_State* L);
#endif
};
