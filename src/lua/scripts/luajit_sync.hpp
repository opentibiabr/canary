/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#if LUA_VERSION_NUM >= 502
	#ifndef LUA_COMPAT_ALL
		#ifndef LUA_COMPAT_MODULE
			#define luaL_register(L, libname, l)(luaL_newlib(L, l),
	lua_pushvalue(L, -1), lua_setglobal(L, libname))
		#endif
		#undef lua_equal
		#define lua_equal(L, i1, i2) lua_compare(L, (i1), (i2), LUA_OPEQ)
	#endif
#endif
