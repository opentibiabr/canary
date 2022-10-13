/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "pch.hpp"

#include "creatures/players/player.h"
#include "lua/scripts/scripts.h"
#include "lua/creature/talkaction.h"

TalkActions::TalkActions() = default;
TalkActions::~TalkActions() = default;

void TalkActions::clear() {
	talkActions.clear();
}

bool TalkActions::registerLuaEvent(const TalkAction_ptr& event) {
	TalkAction_ptr talkAction{ event };
	std::vector<std::string> words = talkAction->getWordsMap();

	for (size_t i = 0; i < words.size(); i++) {
		if (i == words.size() - 1) {
			talkActions.emplace(words[i], std::move(*talkAction));
		} else {
			talkActions.emplace(words[i], *talkAction);
		}
	}

	return true;
}

TalkActionResult_t TalkActions::playerSaySpell(Player* player, SpeakClasses type, const std::string& words) const {
	std::string param;
	std::string instantWords = words;

	if (instantWords.size() >= 3 && instantWords.front() != ' ') {
		size_t param_find = instantWords.find(' ');
			if (param_find != std::string::npos) {
				param = instantWords.substr(param_find + 1);
				instantWords = instantWords.substr(0, param_find);
				trim_left(param, ' ');
			}
		}
		auto it = talkActions.find(instantWords);
		if (it != talkActions.end()) {
		char separator = it->second.getSeparator();
		if (separator != ' ' && !param.empty()) {
			return TALKACTION_CONTINUE;
		}

		if (it->second.executeSay(player, instantWords, param, type)) {
			return TALKACTION_CONTINUE;
		} else {
			return TALKACTION_BREAK;
		}
	}
	return TALKACTION_CONTINUE;
}

bool TalkAction::executeSay(Player* player, const std::string &words, const std::string &param, SpeakClasses type) const {
	// onSay(player, words, param, type)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[TalkAction::executeSay - Player {} words {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getWords());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, words);
	LuaScriptInterface::pushString(L, param);
	lua_pushnumber(L, type);

	return getScriptInterface()->callFunction(4);
}
