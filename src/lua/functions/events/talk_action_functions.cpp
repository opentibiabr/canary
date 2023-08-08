/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/account/account.hpp"
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

int TalkActionFunctions::luaTalkActionGroupType(lua_State* L) {
	// talkAction:groupType(GroupType = GROUP_TYPE_NORMAL)
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (!talk) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	account::GroupType groupType;

	int type = lua_type(L, 2);
	if (type == LUA_TNUMBER) {
		groupType = static_cast<account::GroupType>(getNumber<uint8_t>(L, 2));
	} else if (type == LUA_TSTRING) {
		std::string strValue = getString(L, 2);
		if (strValue == "normal") {
			groupType = account::GROUP_TYPE_NORMAL;
		} else if (strValue == "tutor") {
			groupType = account::GROUP_TYPE_TUTOR;
		} else if (strValue == "seniortutor") {
			groupType = account::GROUP_TYPE_SENIORTUTOR;
		} else if (strValue == "gamemaster") {
			groupType = account::GROUP_TYPE_GAMEMASTER;
		} else if (strValue == "communitymanager") {
			groupType = account::GROUP_TYPE_COMMUNITYMANAGER;
		} else if (strValue == "god") {
			groupType = account::GROUP_TYPE_GOD;
		} else {
			reportErrorFunc("Invalid group type string value.");
			pushBoolean(L, false);
			return 1;
		}
	} else {
		reportErrorFunc("Expected number or string value for group type.");
		pushBoolean(L, false);
		return 1;
	}

	spdlog::info("registering group type {}", static_cast<uint8_t>(groupType));
	talk->setGroupType(groupType);
	pushBoolean(L, true);
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

int TalkActionFunctions::luaTalkActionGetName(lua_State* L) {
	// local name = talkAction:getName()
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (!talk) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	pushString(L, talk->getWordName());
	return 1;
}

int TalkActionFunctions::luaTalkActionGetGroupType(lua_State* L) {
	// local groupType = talkAction:getGroupType()
	TalkAction* talk = getUserdata<TalkAction>(L, 1);
	if (!talk) {
		reportErrorFunc(getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, static_cast<lua_Number>(talk->getGroupType()));
	return 1;
}
