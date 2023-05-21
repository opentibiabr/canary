/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/libs/bit_functions.hpp"

#ifndef LUAJIT_VERSION
int GlobalFunctions::luaBitNot(lua_State* L) {
	int32_t number = getNumber<int32_t>(L, -1);
	lua_pushnumber(L, ~number);
	return 1;
}

	#define MULTIOP(name, op)                               \
		int GlobalFunctions::luaBit##name(lua_State* L) \ { \
			int n = lua_gettop(L);                          \
			uint32_t w = getNumber<uint32_t>(L, -1);        \
			for (int i = 1; i < n; ++i)                     \
				w op getNumber<uint32_t>(L, i);             \
			lua_pushnumber(L, w);                           \
			return 1;                                       \
		}

MULTIOP(And, &=)
MULTIOP(Or, |=)
MULTIOP(Xor, ^=)

	#define SHIFTOP(name, op)                                                        \
		int GlobalFunctions::luaBit##name(lua_State* L) \ {                          \
			uint32_t n1 = getNumber<uint32_t>(L, 1), n2 = getNumber<uint32_t>(L, 2); \
			lua_pushnumber(L, (n1 op n2));                                           \
			return 1;                                                                \
		}

SHIFTOP(LeftShift, <<)
SHIFTOP(RightShift, >>)
#endif
