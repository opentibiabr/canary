/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "lua/creature/talkaction.h"
#include "lua/functions/events/talk_action_functions.hpp"

int TalkActionFunctions::luaCreateTalkAction(lua_State* L) {
	// TalkAction(words)
	TalkAction* talk = new TalkAction(getScriptEnv()->getScriptInterface());
	if (talk) {
		for (int i = 2; i <= lua_gettop(L); i++) {
			talk->setWords(getString(L, i));
		}
		pushUserdata<TalkAction>(L, talk);
		setMetatable(L, -1, "TalkAction");
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TalkActionFunctions::luaTalkActionOnSay(lua_State* L) {
	// talkAction:onSay(callback)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->loadCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TalkActionFunctions::luaTalkActionRegister(lua_State* L) {
	// talkAction:register()
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		if (!talk->isLoadedCallback()) {
			pushBoolean(L, false);
			return 1;
		}
		pushBoolean(L, g_talkActions().registerLuaEvent(talk));
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int TalkActionFunctions::luaTalkActionSeparator(lua_State* L) {
	// talkAction:separator(sep)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (talk) {
		talk->setSeparator(getString(L, 2).c_str());
		pushBoolean(L, true);
	} else {
		lua_pushnil(L);
	}
	return 1;
}
