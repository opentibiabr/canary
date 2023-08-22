/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/libs/logger_functions.hpp"

void LoggerFunctions::init(lua_State* L) {
	// Kept for compatibility purposes only, it's deprecated
	registerTable(L, "Spdlog");
	registerMethod(L, "Spdlog", "info", LoggerFunctions::luaSpdlogInfo);
	registerMethod(L, "Spdlog", "warn", LoggerFunctions::luaSpdlogWarn);
	registerMethod(L, "Spdlog", "error", LoggerFunctions::luaSpdlogError);
	registerMethod(L, "Spdlog", "debug", LoggerFunctions::luaSpdlogDebug);

	registerTable(L, "logger");
	registerMethod(L, "logger", "info", LoggerFunctions::luaLoggerInfo);
	registerMethod(L, "logger", "warn", LoggerFunctions::luaLoggerWarn);
	registerMethod(L, "logger", "error", LoggerFunctions::luaLoggerError);
	registerMethod(L, "logger", "debug", LoggerFunctions::luaLoggerDebug);
}

int LoggerFunctions::luaSpdlogInfo(lua_State* L) {
	// Spdlog.info(text)
	if (isString(L, 1)) {
		g_logger().info(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogWarn(lua_State* L) {
	// Spdlog.warn(text)
	if (isString(L, 1)) {
		g_logger().warn(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogError(lua_State* L) {
	// Spdlog.error(text)
	if (isString(L, 1)) {
		g_logger().error(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogDebug(lua_State* L) {
	// Spdlog.debug(text)
	if (isString(L, 1)) {
		g_logger().debug(getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Logger
int LoggerFunctions::luaLoggerInfo(lua_State* L) {
	// logger.info(text)
	if (isString(L, 1)) {
		g_logger().info(getFormatedLoggerMessage(L));
	} else {
		reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}

int LoggerFunctions::luaLoggerWarn(lua_State* L) {
	// logger.warn(text)
	if (isString(L, 1)) {
		g_logger().warn(getFormatedLoggerMessage(L));
	} else {
		reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}

int LoggerFunctions::luaLoggerError(lua_State* L) {
	// logger.error(text)
	if (isString(L, 1)) {
		g_logger().error(getFormatedLoggerMessage(L));
	} else {
		reportErrorFunc("First parameter needs to be a string");
	}

	return 1;
}

int LoggerFunctions::luaLoggerDebug(lua_State* L) {
	// logger.debug(text)
	if (isString(L, 1)) {
		g_logger().debug(getFormatedLoggerMessage(L));
	} else {
		reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}
