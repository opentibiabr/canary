/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class LoggerFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaSpdlogDebug(lua_State* L);
	static int luaSpdlogError(lua_State* L);
	static int luaSpdlogInfo(lua_State* L);
	static int luaSpdlogWarn(lua_State* L);

	static int luaLoggerDebug(lua_State* L);
	static int luaLoggerError(lua_State* L);
	static int luaLoggerInfo(lua_State* L);
	static int luaLoggerWarn(lua_State* L);
	static int luaLoggerTrace(lua_State* L);
};
