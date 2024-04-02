/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/callbacks/callbacks_definitions.hpp"
#include "creatures/creatures_definitions.hpp"
#include "items/items_definitions.hpp"
#include "utils/utils_definitions.hpp"
#include "lua/scripts/scripts.hpp"

class Creature;
class Player;
class Tile;
class Party;
class ItemType;
class Monster;
class Zone;

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
	EventCallback_t m_callbackType = EventCallback_t::none; ///< The type of the event callback.
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
	bool creatureOnChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) const;
	ReturnValue creatureOnAreaCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Tile> tile, bool aggressive) const;
	ReturnValue creatureOnTargetCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const;
	void creatureOnHear(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> speaker, const std::string &words, SpeakClasses type) const;
	void creatureOnDrainHealth(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) const;

	// Party
	bool partyOnJoin(std::shared_ptr<Party> party, std::shared_ptr<Player> player) const;
	bool partyOnLeave(std::shared_ptr<Party> party, std::shared_ptr<Player> player) const;
	bool partyOnDisband(std::shared_ptr<Party> party) const;
	void partyOnShareExperience(std::shared_ptr<Party> party, uint64_t &exp) const;

	// Player
	bool playerOnBrowseField(std::shared_ptr<Player> player, const Position &position) const;
	void playerOnLook(std::shared_ptr<Player> player, const Position &position, std::shared_ptr<Thing> thing, uint8_t stackpos, int32_t lookDistance) const;
	void playerOnLookInBattleList(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, int32_t lookDistance) const;
	void playerOnLookInTrade(std::shared_ptr<Player> player, std::shared_ptr<Player> partner, std::shared_ptr<Item> item, int32_t lookDistance) const;
	bool playerOnLookInShop(std::shared_ptr<Player> player, const ItemType* itemType, uint8_t count) const;
	bool playerOnMoveItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPosition, const Position &toPosition, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder) const;
	void playerOnItemMoved(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPosition, const Position &toPosition, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder) const;
	void playerOnChangeZone(std::shared_ptr<Player> player, ZoneType_t zone) const;
	bool playerOnMoveCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, const Position &fromPosition, const Position &toPosition) const;
	void playerOnReportRuleViolation(std::shared_ptr<Player> player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) const;
	void playerOnReportBug(std::shared_ptr<Player> player, const std::string &message, const Position &position, uint8_t category) const;
	bool playerOnTurn(std::shared_ptr<Player> player, Direction direction) const;
	bool playerOnTradeRequest(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item) const;
	bool playerOnTradeAccept(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item, std::shared_ptr<Item> targetItem) const;
	void playerOnGainExperience(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, uint64_t &exp, uint64_t rawExp) const;
	void playerOnLoseExperience(std::shared_ptr<Player> player, uint64_t &exp) const;
	void playerOnGainSkillTries(std::shared_ptr<Player> player, skills_t skill, uint64_t &tries) const;
	void playerOnRemoveCount(std::shared_ptr<Player> player, std::shared_ptr<Item> item) const;
	void playerOnRequestQuestLog(std::shared_ptr<Player> player) const;
	void playerOnRequestQuestLine(std::shared_ptr<Player> player, uint16_t questId) const;
	void playerOnStorageUpdate(std::shared_ptr<Player> player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime) const;
	void playerOnCombat(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, CombatDamage &damage) const;
	void playerOnInventoryUpdate(std::shared_ptr<Player> player, std::shared_ptr<Item> item, Slots_t slot, bool equip) const;
	bool playerOnRotateItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item, const Position &position) const;
	void playerOnWalk(std::shared_ptr<Player> player, Direction &dir) const;

	// Monster
	void monsterOnDropLoot(std::shared_ptr<Monster> monster, std::shared_ptr<Container> corpse) const;
	void monsterPostDropLoot(std::shared_ptr<Monster> monster, std::shared_ptr<Container> corpse) const;
	void monsterOnSpawn(std::shared_ptr<Monster> monster, const Position &position) const;

	// Npc
	void npcOnSpawn(std::shared_ptr<Npc> npc, const Position &position) const;

	// Zone
	bool zoneBeforeCreatureEnter(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const;
	bool zoneBeforeCreatureLeave(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const;
	void zoneAfterCreatureEnter(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const;
	void zoneAfterCreatureLeave(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const;

	/**
	 * @note here end the lua binder functions }
	 */
};
