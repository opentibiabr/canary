/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/libs/spdlog_functions.hpp"

int SpdlogFunctions::luaSpdlogInfo(lua_State* L) {
	// Spdlog.info(text)
	if (isString(L, 1)) {
		g_logger().info(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogWarn(lua_State* L) {
	// Spdlog.warn(text)
	if (isString(L, 1)) {
		g_logger().warn(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogError(lua_State* L) {
	// Spdlog.error(text)
	if (isString(L, 1)) {
		g_logger().error(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int SpdlogFunctions::luaSpdlogDebug(lua_State* L) {
	// Spdlog.debug(text)
	if (isString(L, 1)) {
		g_logger().debug(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}
