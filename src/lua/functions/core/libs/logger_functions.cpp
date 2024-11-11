/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/libs/logger_functions.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void LoggerFunctions::init(lua_State* L) {
	// Kept for compatibility purposes only, it's deprecated
	Lua::registerTable(L, "Spdlog");
	Lua::registerMethod(L, "Spdlog", "info", LoggerFunctions::luaSpdlogInfo);
	Lua::registerMethod(L, "Spdlog", "warn", LoggerFunctions::luaSpdlogWarn);
	Lua::registerMethod(L, "Spdlog", "error", LoggerFunctions::luaSpdlogError);
	Lua::registerMethod(L, "Spdlog", "debug", LoggerFunctions::luaSpdlogDebug);

	Lua::registerTable(L, "logger");
	Lua::registerMethod(L, "logger", "info", LoggerFunctions::luaLoggerInfo);
	Lua::registerMethod(L, "logger", "warn", LoggerFunctions::luaLoggerWarn);
	Lua::registerMethod(L, "logger", "error", LoggerFunctions::luaLoggerError);
	Lua::registerMethod(L, "logger", "debug", LoggerFunctions::luaLoggerDebug);
	Lua::registerMethod(L, "logger", "trace", LoggerFunctions::luaLoggerTrace);
}

int LoggerFunctions::luaSpdlogInfo(lua_State* L) {
	// Spdlog.info(text)
	if (Lua::isString(L, 1)) {
		g_logger().info(Lua::getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogWarn(lua_State* L) {
	// Spdlog.warn(text)
	if (Lua::isString(L, 1)) {
		g_logger().warn(Lua::getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogError(lua_State* L) {
	// Spdlog.error(text)
	if (Lua::isString(L, 1)) {
		g_logger().error(Lua::getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int LoggerFunctions::luaSpdlogDebug(lua_State* L) {
	// Spdlog.debug(text)
	if (Lua::isString(L, 1)) {
		g_logger().debug(Lua::getString(L, 1));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

// Logger
int LoggerFunctions::luaLoggerInfo(lua_State* L) {
	// logger.info(text)
	if (Lua::isString(L, 1)) {
		g_logger().info(Lua::getFormatedLoggerMessage(L));
	} else {
		Lua::reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}

int LoggerFunctions::luaLoggerWarn(lua_State* L) {
	// logger.warn(text)
	if (Lua::isString(L, 1)) {
		g_logger().warn(Lua::getFormatedLoggerMessage(L));
	} else {
		Lua::reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}

int LoggerFunctions::luaLoggerError(lua_State* L) {
	// logger.error(text)
	if (Lua::isString(L, 1)) {
		g_logger().error(Lua::getFormatedLoggerMessage(L));
	} else {
		Lua::reportErrorFunc("First parameter needs to be a string");
	}

	return 1;
}

int LoggerFunctions::luaLoggerDebug(lua_State* L) {
	// logger.debug(text)
	if (Lua::isString(L, 1)) {
		g_logger().debug(Lua::getFormatedLoggerMessage(L));
	} else {
		Lua::reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}

int LoggerFunctions::luaLoggerTrace(lua_State* L) {
	// logger.trace(text)
	if (Lua::isString(L, 1)) {
		g_logger().trace(Lua::getFormatedLoggerMessage(L));
	} else {
		Lua::reportErrorFunc("First parameter needs to be a string");
	}
	return 1;
}
