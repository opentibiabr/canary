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

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_BIT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_BIT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

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

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_BIT_FUNCTIONS_HPP_
