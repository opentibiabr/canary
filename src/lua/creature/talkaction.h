/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_LUA_CREATURE_TALKACTION_H_
#define SRC_LUA_CREATURE_TALKACTION_H_

#include "creatures/players/account/account.hpp"
#include "lua/global/baseevents.h"
#include "utils/utils_definitions.hpp"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"
#include "lua/scripts/scripts.h"

class TalkAction;
using TalkAction_ptr = std::shared_ptr<TalkAction>;

class TalkAction : public Script {
	public:
		using Script::Script;

		const std::string &getWords() const {
			return m_word;
		}

		void setWords(const std::vector<std::string> &newWords) {
			for (const auto &word : newWords) {
				if (!m_word.empty()) {
					m_word.append(", ");
				}
				m_word.append(word);
			}
		}

		std::string getSeparator() const {
			return separator;
		}
		void setSeparator(std::string sep) {
			separator = sep;
		}

		// scripting
		bool executeSay(Player* player, const std::string &words, const std::string &param, SpeakClasses type) const;
		//

		void setGroupType(account::GroupType newGroupType) {
			m_groupType = newGroupType;
		}

		const account::GroupType &getGroupType() const {
			return m_groupType;
		}

	private:
		std::string getScriptTypeName() const override {
			return "onSay";
		}

		std::string m_word;
		std::string separator = "\"";
		account::GroupType m_groupType = account::GROUP_TYPE_NONE;
};

class TalkActions final : public Scripts {
	public:
		TalkActions();
		~TalkActions();

		// non-copyable
		TalkActions(const TalkActions &) = delete;
		TalkActions &operator=(const TalkActions &) = delete;

		static TalkActions &getInstance() {
			return inject<TalkActions>();
		}

		bool checkWord(Player* player, SpeakClasses type, const std::string &words, const std::string_view &word, const TalkAction_ptr &talkActionPtr) const;
		TalkActionResult_t checkPlayerCanSayTalkAction(Player* player, SpeakClasses type, const std::string &words) const;

		bool registerLuaEvent(TalkAction_ptr talkAction);
		void clear();

		const phmap::btree_map<std::string, std::shared_ptr<TalkAction>> &getTalkActionsMap() const {
			return talkActions;
		};

	private:
		phmap::btree_map<std::string, std::shared_ptr<TalkAction>> talkActions;
};

constexpr auto g_talkActions = TalkActions::getInstance;

#endif // SRC_LUA_CREATURE_TALKACTION_H_
