/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_FUNCTIONS_EVENTS_TALK_ACTION_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_EVENTS_TALK_ACTION_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class TalkActionFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "TalkAction", "", TalkActionFunctions::luaCreateTalkAction);
			registerMethod(L, "TalkAction", "onSay", TalkActionFunctions::luaTalkActionOnSay);
			registerMethod(L, "TalkAction", "register", TalkActionFunctions::luaTalkActionRegister);
			registerMethod(L, "TalkAction", "separator", TalkActionFunctions::luaTalkActionSeparator);
		}

	private:
		static int luaCreateTalkAction(lua_State* L);
		static int luaTalkActionOnSay(lua_State* L);
		static int luaTalkActionRegister(lua_State* L);
		static int luaTalkActionSeparator(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_EVENTS_TALK_ACTION_FUNCTIONS_HPP_
