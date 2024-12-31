/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class TalkActionFunctions {
public:
	static void init(lua_State* L);

private:
	static int luaCreateTalkAction(lua_State* L);
	static int luaTalkActionOnSay(lua_State* L);
	static int luaTalkActionGroupType(lua_State* L);
	static int luaTalkActionRegister(lua_State* L);
	static int luaTalkActionSeparator(lua_State* L);
	static int luaTalkActionGetName(lua_State* L);
	static int luaTalkActionGetDescription(lua_State* L);
	static int luaTalkActionSetDescription(lua_State* L);
	static int luaTalkActionGetGroupType(lua_State* L);
};
