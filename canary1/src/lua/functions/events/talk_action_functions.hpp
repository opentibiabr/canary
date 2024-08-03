/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class TalkActionFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerSharedClass(L, "TalkAction", "", TalkActionFunctions::luaCreateTalkAction);
		registerMethod(L, "TalkAction", "onSay", TalkActionFunctions::luaTalkActionOnSay);
		registerMethod(L, "TalkAction", "groupType", TalkActionFunctions::luaTalkActionGroupType);
		registerMethod(L, "TalkAction", "register", TalkActionFunctions::luaTalkActionRegister);
		registerMethod(L, "TalkAction", "separator", TalkActionFunctions::luaTalkActionSeparator);
		registerMethod(L, "TalkAction", "getName", TalkActionFunctions::luaTalkActionGetName);
		registerMethod(L, "TalkAction", "getDescription", TalkActionFunctions::luaTalkActionGetDescription);
		registerMethod(L, "TalkAction", "setDescription", TalkActionFunctions::luaTalkActionSetDescription);
		registerMethod(L, "TalkAction", "getGroupType", TalkActionFunctions::luaTalkActionGetGroupType);
	}

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
