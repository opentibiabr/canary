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
 * @brief Represents an individual event callback within the game.
 *
 * @details This class encapsulates a specific event callback, allowing for the definition,
 * registration, and execution of custom behavior tied to specific game events.
 * @note It inherits from the Script class, providing scripting capabilities.
 */
class EventCallback : public Script {
	private:
		EventCallback_t m_callbackType = EventCallback_t::None; ///< The type of the event callback.
		std::string m_scriptTypeName; ///< The name associated with the script type.

	public:
		/**
		 * @brief Constructor that initializes the EventCallback with a given script interface.
		 * @param scriptInterface Pointer to the LuaScriptInterface object.
		 */
		explicit EventCallback(LuaScriptInterface* scriptInterface);

		/**
		 * @brief Retrieves the script type name.
		 * @return The script type name as a string.
		 */
		std::string getScriptTypeName() const override;

		/**
		 * @brief Sets a new script type name.
		 * @param newName The new name to set for the script type.
		 */
		void setScriptTypeName(const std::string_view newName);

		/**
		 * @brief Retrieves the type of the event callback.
		 * @return The type of the event callback as defined in the EventCallback_t enumeration.
		 */
		EventCallback_t getType() const;

		/**
		 * @brief Sets the type of the event callback.
		 * @param type The new type to set, as defined in the EventCallback_t enumeration.
		 */
		void setType(EventCallback_t type);

		/**
		 * @defgroup EventCallbacks Event Callback Functions
		 * @brief These functions are called in response to specific game events.
		 *
		 * These functions serve as the entry points for various event types in the game. They are triggered by specific game events related to Creatures, Players, Parties, Monsters, and NPCs. Depending on the event, different parameters are passed to these functions, allowing custom behavior to be defined for each event type.
		 *
		 * The functions may return a boolean value or be void. Boolean-returning functions allow for conditional control over the execution of associated actions on the C++ side, while void functions simply execute the custom behavior without altering the flow of the program.
		 *
		 * @note here start the lua binder functions {
		 */

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

		// Npc
		void npcOnSpawn(Npc* npc, const Position &position) const;

		/**
		 * @note here end the lua binder functions }
		 */
};

#endif // SRC_LUA_CALLBACKS_EVENT_CALLBACK__HPP_
