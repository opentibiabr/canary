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

#ifndef SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class ResultFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerTable(L, "Result");
			// Signed integer conversion
			registerMethod(L, "Result", "get8", ResultFunctions::luaResultGet8);
			registerMethod(L, "Result", "get16", ResultFunctions::luaResultGet16);
			registerMethod(L, "Result", "get32", ResultFunctions::luaResultGet32);
			registerMethod(L, "Result", "get64", ResultFunctions::luaResultGet64);
			// Unsigned intenger conversion
			registerMethod(L, "Result", "getU8", ResultFunctions::luaResultGetU8);
			registerMethod(L, "Result", "getU16", ResultFunctions::luaResultGetU16);
			registerMethod(L, "Result", "getU32", ResultFunctions::luaResultGetU32);
			registerMethod(L, "Result", "getU64", ResultFunctions::luaResultGetU64);
			// Others conversions
			registerMethod(L, "Result", "getTime", ResultFunctions::luaResultGetTime);
			registerMethod(L, "Result", "getBoolean", ResultFunctions::luaResultGetBoolean);

			registerMethod(L, "Result", "getString", ResultFunctions::luaResultGetString);
			registerMethod(L, "Result", "getStream", ResultFunctions::luaResultGetStream);
			registerMethod(L, "Result", "next", ResultFunctions::luaResultNext);
			registerMethod(L, "Result", "free", ResultFunctions::luaResultFree);
		}

	private:
		static int luaResultFree(lua_State* L);
		static int luaResultGet8(lua_State* L);
		static int luaResultGet16(lua_State* L);
		static int luaResultGet32(lua_State* L);
		static int luaResultGet64(lua_State* L);
		static int luaResultGetU8(lua_State* L);
		static int luaResultGetU16(lua_State* L);
		static int luaResultGetU32(lua_State* L);
		static int luaResultGetU64(lua_State* L);
		static int luaResultGetTime(lua_State* L);
		static int luaResultGetBoolean(lua_State* L);
		static int luaResultGetStream(lua_State* L);
		static int luaResultGetString(lua_State* L);
		static int luaResultNext(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CORE_LIBS_RESULT_FUNCTIONS_HPP_
