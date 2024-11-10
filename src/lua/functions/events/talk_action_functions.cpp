/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/events/talk_action_functions.hpp"

#include "account/account.hpp"
#include "lua/creature/talkaction.hpp"
#include "utils/tools.hpp"

#include "enums/account_group_type.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "lua/scripts/luascript.hpp"

void TalkActionFunctions::init(lua_State* L) {
	Lua::registerSharedClass(L, "TalkAction", "", TalkActionFunctions::luaCreateTalkAction);
	Lua::registerMethod(L, "TalkAction", "onSay", TalkActionFunctions::luaTalkActionOnSay);
	Lua::registerMethod(L, "TalkAction", "groupType", TalkActionFunctions::luaTalkActionGroupType);
	Lua::registerMethod(L, "TalkAction", "register", TalkActionFunctions::luaTalkActionRegister);
	Lua::registerMethod(L, "TalkAction", "separator", TalkActionFunctions::luaTalkActionSeparator);
	Lua::registerMethod(L, "TalkAction", "getName", TalkActionFunctions::luaTalkActionGetName);
	Lua::registerMethod(L, "TalkAction", "getDescription", TalkActionFunctions::luaTalkActionGetDescription);
	Lua::registerMethod(L, "TalkAction", "setDescription", TalkActionFunctions::luaTalkActionSetDescription);
	Lua::registerMethod(L, "TalkAction", "getGroupType", TalkActionFunctions::luaTalkActionGetGroupType);
}

int TalkActionFunctions::luaCreateTalkAction(lua_State* L) {
	// TalkAction(words) or TalkAction(word1, word2, word3)
	std::vector<std::string> wordsVector;
	for (int i = 2; i <= lua_gettop(L); i++) {
		wordsVector.push_back(Lua::getString(L, i));
	}

	const auto talkactionSharedPtr = std::make_shared<TalkAction>();
	talkactionSharedPtr->setWords(wordsVector);
	Lua::pushUserdata<TalkAction>(L, talkactionSharedPtr);
	Lua::setMetatable(L, -1, "TalkAction");
	return 1;
}

int TalkActionFunctions::luaTalkActionOnSay(lua_State* L) {
	// talkAction:onSay(callback)
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (!talkactionSharedPtr->loadScriptId()) {
		Lua::pushBoolean(L, false);
		return 1;
	}
	Lua::pushBoolean(L, true);
	return 1;
}

int TalkActionFunctions::luaTalkActionGroupType(lua_State* L) {
	// talkAction:groupType(GroupType = GROUP_TYPE_NORMAL)
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	GroupType groupType;
	const int type = lua_type(L, 2);
	if (type == LUA_TNUMBER) {
		groupType = enumFromValue<GroupType>(Lua::getNumber<uint8_t>(L, 2));
	} else if (type == LUA_TSTRING) {
		std::string strValue = Lua::getString(L, 2);
		if (strValue == "normal") {
			groupType = GROUP_TYPE_NORMAL;
		} else if (strValue == "tutor") {
			groupType = GROUP_TYPE_TUTOR;
		} else if (strValue == "seniortutor" || strValue == "senior tutor") {
			groupType = GROUP_TYPE_SENIORTUTOR;
		} else if (strValue == "gamemaster" || strValue == "gm") {
			groupType = GROUP_TYPE_GAMEMASTER;
		} else if (strValue == "communitymanager" || strValue == "cm" || strValue == "community manager") {
			groupType = GROUP_TYPE_COMMUNITYMANAGER;
		} else if (strValue == "god") {
			groupType = GROUP_TYPE_GOD;
		} else {
			const auto string = fmt::format("Invalid group type string value {} for group type for script: {}", strValue, Lua::getScriptEnv()->getScriptInterface()->getLoadingScriptName());
			Lua::reportErrorFunc(string);
			Lua::pushBoolean(L, false);
			return 1;
		}
	} else {
		const auto string = fmt::format("Expected number or string value for group type for script: {}", Lua::getScriptEnv()->getScriptInterface()->getLoadingScriptName());
		Lua::reportErrorFunc(string);
		Lua::pushBoolean(L, false);
		return 1;
	}

	talkactionSharedPtr->setGroupType(groupType);
	Lua::pushBoolean(L, true);
	return 1;
}

int TalkActionFunctions::luaTalkActionRegister(lua_State* L) {
	// talkAction:register()
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (!talkactionSharedPtr->isLoadedScriptId()) {
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (talkactionSharedPtr->getGroupType() == GROUP_TYPE_NONE) {
		const auto string = fmt::format("TalkAction with name {} does't have groupType", talkactionSharedPtr->getWords());
		Lua::reportErrorFunc(string);
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushBoolean(L, g_talkActions().registerLuaEvent(talkactionSharedPtr));
	return 1;
}

int TalkActionFunctions::luaTalkActionSeparator(lua_State* L) {
	// talkAction:separator(sep)
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	talkactionSharedPtr->setSeparator(Lua::getString(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int TalkActionFunctions::luaTalkActionGetName(lua_State* L) {
	// local name = talkAction:getName()
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushString(L, talkactionSharedPtr->getWords());
	return 1;
}

int TalkActionFunctions::luaTalkActionGetDescription(lua_State* L) {
	// local description = talkAction:getDescription()
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	Lua::pushString(L, talkactionSharedPtr->getDescription());
	return 1;
}

int TalkActionFunctions::luaTalkActionSetDescription(lua_State* L) {
	// local description = talkAction:setDescription()
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	talkactionSharedPtr->setDescription(Lua::getString(L, 2));
	Lua::pushBoolean(L, true);
	return 1;
}

int TalkActionFunctions::luaTalkActionGetGroupType(lua_State* L) {
	// local groupType = talkAction:getGroupType()
	const auto &talkactionSharedPtr = Lua::getUserdataShared<TalkAction>(L, 1);
	if (!talkactionSharedPtr) {
		Lua::reportErrorFunc(Lua::getErrorDesc(LUA_ERROR_TALK_ACTION_NOT_FOUND));
		Lua::pushBoolean(L, false);
		return 1;
	}

	lua_pushnumber(L, static_cast<lua_Number>(talkactionSharedPtr->getGroupType()));
	return 1;
}
