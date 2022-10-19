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

#ifndef SRC_LUA_CREATURE_EVENTS_H_
#define SRC_LUA_CREATURE_EVENTS_H_

#include "creatures/players/imbuements/imbuements.h"
#include "lua/scripts/luascript.h"
#include "creatures/combat/spells.h"

class Party;
class ItemType;
class Tile;
class Imbuements;

class Events {
	struct EventsInfo {
		// Creature
		int32_t creatureOnChangeOutfit = -1;
		int32_t creatureOnAreaCombat = -1;
		int32_t creatureOnTargetCombat = -1;
		int32_t creatureOnHear = -1;
		int32_t creatureOnDrainHealth = -1;

		// Party
		int32_t partyOnJoin = -1;
		int32_t partyOnLeave = -1;
		int32_t partyOnDisband = -1;
		int32_t partyOnShareExperience = -1;

		// Player
		int32_t playerOnBrowseField = -1;
		int32_t playerOnLook = -1;
		int32_t playerOnLookInBattleList = -1;
		int32_t playerOnLookInTrade = -1;
		int32_t playerOnLookInShop = -1;
		int32_t playerOnMoveItem = -1;
		int32_t playerOnItemMoved = -1;
		int32_t playerOnChangeZone = -1;
		int32_t playerOnMoveCreature = -1;
		int32_t playerOnReportRuleViolation = -1;
		int32_t playerOnReportBug = -1;
		int32_t playerOnTurn = -1;
		int32_t playerOnTradeRequest = -1;
		int32_t playerOnTradeAccept = -1;
		int32_t playerOnGainExperience = -1;
		int32_t playerOnLoseExperience = -1;
		int32_t playerOnGainSkillTries = -1;
		int32_t playerOnRequestQuestLog = -1;
		int32_t playerOnRequestQuestLine = -1;
		int32_t playerOnStorageUpdate = -1;
		int32_t playerOnRemoveCount = -1;
		int32_t playerOnCombat = -1;

		// Monster
		int32_t monsterOnDropLoot = -1;
		int32_t monsterOnSpawn = -1;

		// Npc
		int32_t npcOnSpawn = -1;
	};

	public:
	
		Events();

		bool loadFromXml();

		// non-copyable
		Events(Events const&) = delete;
		void operator=(Events const&) = delete;

		static Events& getInstance() {
			// Guaranteed to be destroyed
			static Events instance;
			// Instantiated on first use
			return instance;
		}

		// Creature
		bool eventCreatureOnChangeOutfit(Creature* creature, const Outfit_t& outfit);
		ReturnValue eventCreatureOnAreaCombat(Creature* creature, Tile* tile, bool aggressive);
		ReturnValue eventCreatureOnTargetCombat(Creature* creature, Creature* target);
		void eventCreatureOnHear(Creature* creature, Creature* speaker, const std::string& words, SpeakClasses type);
		void eventCreatureOnDrainHealth(Creature* creature, Creature* attacker, CombatType_t& typePrimary, int64_t& damagePrimary, CombatType_t& typeSecondary, int64_t& damageSecondary, TextColor_t& colorPrimary, TextColor_t& colorSecondary);

		// Party
		bool eventPartyOnJoin(Party* party, Player* player);
		bool eventPartyOnLeave(Party* party, Player* player);
		bool eventPartyOnDisband(Party* party);
		void eventPartyOnShareExperience(Party* party, uint64_t& exp);

		// Player
		bool eventPlayerOnBrowseField(Player* player, const Position& position);
		void eventPlayerOnLook(Player* player, const Position& position, Thing* thing, uint8_t stackpos, int32_t lookDistance);
		void eventPlayerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance);
		void eventPlayerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance);
		bool eventPlayerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count);
		bool eventPlayerOnMoveItem(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition, Cylinder* fromCylinder, Cylinder* toCylinder);
		void eventPlayerOnItemMoved(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition, Cylinder* fromCylinder, Cylinder* toCylinder);
		void eventPlayerOnChangeZone(Player* player, ZoneType_t zone);
		bool eventPlayerOnMoveCreature(Player* player, Creature* creature, const Position& fromPosition, const Position& toPosition);
		void eventPlayerOnReportRuleViolation(Player* player, const std::string& targetName, uint8_t reportType, uint8_t reportReason, const std::string& comment, const std::string& translation);
		bool eventPlayerOnReportBug(Player* player, const std::string& message, const Position& position, uint8_t category);
		bool eventPlayerOnTurn(Player* player, Direction direction);
		bool eventPlayerOnTradeRequest(Player* player, Player* target, Item* item);
		bool eventPlayerOnTradeAccept(Player* player, Player* target, Item* item, Item* targetItem);
		void eventPlayerOnGainExperience(Player* player, Creature* target, uint64_t& exp, uint64_t rawExp);
		void eventPlayerOnLoseExperience(Player* player, uint64_t& exp);
		void eventPlayerOnGainSkillTries(Player* player, skills_t skill, uint64_t& tries);
		bool eventPlayerOnRemoveCount(Player* player, Item * item);
		void eventPlayerOnRequestQuestLog(Player* player);
		void eventPlayerOnRequestQuestLine(Player* player, uint16_t questId);
		void eventOnStorageUpdate(Player* player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime);
		void eventPlayerOnCombat(Player* player, Creature* target, Item* item, CombatDamage& damage);

		// Monster
		void eventMonsterOnDropLoot(Monster* monster, Container* corpse);
		void eventMonsterOnSpawn(Monster* monster, const Position& position);

		// Monster
		void eventNpcOnSpawn(Npc* npc, const Position& position);

	private:
		LuaScriptInterface scriptInterface;
		EventsInfo info;
};

constexpr auto g_events = &Events::getInstance;

#endif  // SRC_LUA_CREATURE_EVENTS_H_
