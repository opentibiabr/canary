/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_LUA_CALLBACKS_EVENT_CALLBACK__HPP_
#define SRC_LUA_CALLBACKS_EVENT_CALLBACK__HPP_

#include "lua/callbacks/callbacks_definitions.hpp"
#include "creatures/creatures_definitions.hpp"
#include "items/items_definitions.hpp"
#include "utils/utils_definitions.hpp"
#include "lua/scripts/scripts.h"

class Creature;
class Player;
class Tile;
class Party;
class ItemType;
class Monster;

/**
 * @class EventCallback
 * @brief Class representing an event callback.
 *
 * @note This class is used to encapsulate the logic of a Lua event callback.
 * @details It is derived from the Script class and includes additional information specific to event callbacks.
 *
 * @see Script
 */
class EventCallback : public Script {
	private:
		EventCallback_t m_callbackType = EventCallback_t::None;
		std::string m_scriptTypeName;

	public:
		explicit EventCallback(LuaScriptInterface* scriptInterface);

		std::string getScriptTypeName() const override;

		void setScriptTypeName(const std::string_view newName);

		EventCallback_t getType() const;

		void setType(EventCallback_t type);

		// Creature
		bool creatureOnChangeOutfit(Creature* creature, const Outfit_t &outfit) const;
		ReturnValue creatureOnAreaCombat(Creature* creature, Tile* tile, bool aggressive) const;
		ReturnValue creatureOnTargetCombat(Creature* creature, Creature* target) const;
		void creatureOnHear(Creature* creature, Creature* speaker, const std::string &words, SpeakClasses type) const;
		void creatureOnDrainHealth(Creature* creature, Creature* attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) const;

		// Party
		bool partyOnJoin(Party* party, Player* player) const;
		bool partyOnLeave(Party* party, Player* player) const;
		bool partyOnDisband(Party* party) const;
		void partyOnShareExperience(Party* party, uint64_t &exp) const;

		// Player
		bool playerOnBrowseField(Player* player, const Position &position) const;
		void playerOnLook(Player* player, const Position &position, Thing* thing, uint8_t stackpos, int32_t lookDistance) const;
		void playerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance) const;
		void playerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance) const;
		bool playerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count) const;
		bool playerOnMoveItem(Player* player, Item* item, uint16_t count, const Position &fromPosition, const Position &toPosition, Cylinder* fromCylinder, Cylinder* toCylinder) const;
		void playerOnItemMoved(Player* player, Item* item, uint16_t count, const Position &fromPosition, const Position &toPosition, Cylinder* fromCylinder, Cylinder* toCylinder) const;
		void playerOnChangeZone(Player* player, ZoneType_t zone) const;
		void playerOnChangeHazard(Player* player, bool isHazard) const;
		bool playerOnMoveCreature(Player* player, Creature* creature, const Position &fromPosition, const Position &toPosition) const;
		void playerOnReportRuleViolation(Player* player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) const;
		void playerOnReportBug(Player* player, const std::string &message, const Position &position, uint8_t category) const;
		bool playerOnTurn(Player* player, Direction direction) const;
		bool playerOnTradeRequest(Player* player, Player* target, Item* item) const;
		bool playerOnTradeAccept(Player* player, Player* target, Item* item, Item* targetItem) const;
		void playerOnGainExperience(Player* player, Creature* target, uint64_t &exp, uint64_t rawExp) const;
		void playerOnLoseExperience(Player* player, uint64_t &exp) const;
		void playerOnGainSkillTries(Player* player, skills_t skill, uint64_t &tries) const;
		void playerOnRemoveCount(Player* player, Item* item) const;
		void playerOnRequestQuestLog(Player* player) const;
		void playerOnRequestQuestLine(Player* player, uint16_t questId) const;
		void playerOnStorageUpdate(Player* player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime) const;
		void playerOnCombat(Player* player, Creature* target, Item* item, CombatDamage &damage) const;
		void playerOnInventoryUpdate(Player* player, Item* item, Slots_t slot, bool equip) const;

		// Monster
		void monsterOnDropLoot(Monster* monster, Container* corpse) const;
		void monsterOnSpawn(Monster* monster, const Position &position) const;

		// Monster
		void npcOnSpawn(Npc* npc, const Position &position) const;
};

#endif // SRC_LUA_CALLBACKS_EVENT_CALLBACK__HPP_
