/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "creatures/players/player.hpp"
#include "lua/scripts/scripts.hpp"
#include "lua/creature/talkaction.hpp"

TalkActions::TalkActions() = default;
TalkActions::~TalkActions() = default;

void TalkActions::clear() {
	talkActions.clear();
}

bool TalkActions::registerLuaEvent(const TalkAction_ptr &talkAction) {
	auto [iterator, inserted] = talkActions.try_emplace(talkAction->getWords(), talkAction);
	return inserted;
}

bool TalkActions::checkWord(std::shared_ptr<Player> player, SpeakClasses type, const std::string &words, const std::string_view &word, const TalkAction_ptr &talkActionPtr) const {
	auto spacePos = std::ranges::find_if(words.begin(), words.end(), ::isspace);
	std::string firstWord = words.substr(0, spacePos - words.begin());

	// Check for exact equality from saying word and talkaction stored word
	if (firstWord != word) {
		return false;
	}

	auto groupId = player->getGroup()->id;
	if (groupId < talkActionPtr->getGroupType()) {
		return false;
	}

	std::string param;
	size_t wordPos = words.find(word);
	size_t talkactionLength = word.length();
	if (wordPos != std::string::npos && wordPos + talkactionLength < words.length()) {
		param = words.substr(wordPos + talkactionLength);
		trim_left(param, ' ');
	}

	std::string separator = talkActionPtr->getSeparator();
	if (separator != " ") {
		if (!param.empty()) {
			if (param != separator) {
				return false;
			} else {
				param.erase(param.begin());
			}
		}
	}

	return talkActionPtr->executeSay(player, words, param, type);
}

TalkActionResult_t TalkActions::checkPlayerCanSayTalkAction(std::shared_ptr<Player> player, SpeakClasses type, const std::string &words) const {
	for (const auto &[talkactionWords, talkActionPtr] : talkActions) {
		if (talkactionWords.find(',') != std::string::npos) {
			auto wordsList = split(talkactionWords);
			for (const auto &word : wordsList) {
				if (checkWord(player, type, words, word, talkActionPtr)) {
					return TALKACTION_BREAK;
				}
			}
		} else {
			if (checkWord(player, type, words, talkactionWords, talkActionPtr)) {
				return TALKACTION_BREAK;
			}
		}
	}
	return TALKACTION_CONTINUE;
}

bool TalkAction::executeSay(std::shared_ptr<Player> player, const std::string &words, const std::string &param, SpeakClasses type) const {
	// onSay(player, words, param, type)
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[TalkAction::executeSay - Player {} words {}] "
						 "Call stack overflow. Too many lua script calls being nested. Script name {}",
						 player->getName(), getWords(), getScriptInterface()->getLoadingScriptName());
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
