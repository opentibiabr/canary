/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_LUA_CREATURE_TALKACTION_H_
#define SRC_LUA_CREATURE_TALKACTION_H_

#include "lua/global/baseevents.h"
#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"
#include "lua/scripts/scripts.h"

class TalkAction;
using TalkAction_ptr = std::unique_ptr<TalkAction>;

class TalkAction : public Script {
	public:
		explicit TalkAction(LuaScriptInterface* interface) : Script(interface) {}

		const std::string& getWords() const {
			return words;
		}
		const std::vector<std::string>& getWordsMap() const {
			return wordsMap;
		}
		void setWords(std::string word) {
			words = word;
			wordsMap.push_back(word);
		}
		const std::string& getFileName() const {
			return fileName;
		}
		void setFileName(const std::string& scriptName) {
			fileName = scriptName;
		}
		std::string getSeparator() const {
			return separator;
		}
		void setSeparator(std::string sep) {
			separator = sep;
		}

		//scripting
		bool executeSay(Player* player, const std::string& words, const std::string& param, SpeakClasses type) const;
		//

	private:
		std::string getScriptTypeName() const override {
			return "onSay";
		}

		std::string words;
		std::string fileName;
		std::vector<std::string> wordsMap;
		std::string separator = "\"";
};

class TalkActions final : public Scripts {
	public:
		TalkActions() = default;

		// non-copyable
		TalkActions(const TalkActions&) = delete;
		TalkActions& operator=(const TalkActions&) = delete;

		static TalkActions& getInstance() {
			// Guaranteed to be destroyed
			static TalkActions instance;
			// Instantiated on first use
			return instance;
		}

		TalkActionResult_t playerSaySpell(Player* player, SpeakClasses type, const std::string& words) const;

		bool registerLuaEvent(TalkAction* event);
		void clear();

	private:
		std::map<std::string, TalkAction> talkActions;
};

constexpr auto g_talkActions = &TalkActions::getInstance;

#endif  // SRC_LUA_CREATURE_TALKACTION_H_
