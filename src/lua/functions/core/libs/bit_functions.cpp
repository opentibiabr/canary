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

#include "lua/functions/core/libs/bit_functions.hpp"

#ifndef LUAJIT_VERSION
int GlobalFunctions::luaBitNot(lua_State* L) {
	int32_t number = getNumber<int32_t>(L, -1);
	lua_pushnumber(L, ~number);
	return 1;
}

#define MULTIOP(name, op) \
int GlobalFunctions::luaBit##name(lua_State* L) \ { \
	int n = lua_gettop(L); \
	uint32_t w = getNumber<uint32_t>(L, -1); \
	for (int i = 1; i < n; ++i) \
		w op getNumber<uint32_t>(L, i); \
	lua_pushnumber(L, w); \
	return 1; \
}

MULTIOP(And, &= )
MULTIOP(Or, |= )
MULTIOP(Xor, ^= )

#define SHIFTOP(name, op) \
int GlobalFunctions::luaBit##name(lua_State* L) \ { \
	uint32_t n1 = getNumber<uint32_t>(L, 1), n2 = getNumber<uint32_t>(L, 2); \
	lua_pushnumber(L, (n1 op n2)); \
	return 1; \
}

SHIFTOP(LeftShift, << )
SHIFTOP(RightShift, >> )
#endif
