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

#include "lua/functions/core/libs/spdlog_functions.hpp"

int SpdlogFunctions::luaSpdlogInfo(lua_State* L) {
	// Spdlog.info(text)
	if (isString(L, 1)) {
		SPDLOG_INFO(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogWarn(lua_State* L) {
	// Spdlog.warn(text)
	if (isString(L, 1)) {
		SPDLOG_WARN(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogError(lua_State* L) {
	// Spdlog.error(text)
	if (isString(L, 1)) {
		SPDLOG_ERROR(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogDebug(lua_State* L) {
	// Spdlog.debug(text)
	if (isString(L, 1)) {
		SPDLOG_DEBUG(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
