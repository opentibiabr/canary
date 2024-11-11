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

class Creature;
class Player;
class Tile;
class Party;
class ItemType;
class Monster;
class Zone;
class LuaScriptInterface;
class Thing;
class Item;
class Cylinder;
class Npc;
class Container;

struct Position;
struct CombatDamage;
struct Outfit_t;

enum Direction : uint8_t;
enum ReturnValue : uint16_t;
enum SpeakClasses : uint8_t;
enum Slots_t : uint8_t;
enum ZoneType_t : uint8_t;
enum skills_t : int8_t;
enum CombatType_t : uint8_t;
enum TextColor_t : uint8_t;

/**
 * @class EventCallback
 * @brief Represents an individual event callback within the game.
 *
 * @details This class encapsulates a specific event callback, allowing for the definition,
 * registration, and execution of custom behavior tied to specific game events.
 * @note It inherits from the Script class, providing scripting capabilities.
 */
class EventCallback {
private:
	EventCallback_t m_callbackType = EventCallback_t::none; ///< The type of the event callback.
	std::string m_scriptTypeName; ///< The name associated with the script type.
	std::string m_callbackName; ///< The name of the callback.
	bool m_skipDuplicationCheck = false; ///< Whether the callback is silent error for already registered log error.

	int32_t m_scriptId {};

public:
	explicit EventCallback(const std::string &callbackName, bool silentAlreadyRegistered);

	LuaScriptInterface* getScriptInterface() const;
	bool loadScriptId();
	int32_t getScriptId() const;
	void setScriptId(int32_t newScriptId);
	bool isLoadedScriptId() const;

	/**
	 * @brief Retrieves the callback name.
	 * @return The callback name as a string.
	 */
	std::string getName() const;

	/**
	 * @brief Retrieves the skip registration status of the callback.
	 * @return True if the callback is true for skip duplication check and register again the event, false otherwise.
	 */
	bool skipDuplicationCheck() const;

	/**
	 * @brief Retrieves the script type name.
	 * @return The script type name as a string.
	 */
	std::string getScriptTypeName() const;

	/**
	 * @brief Sets a new script type name.
	 * @param newName The new name to set for the script type.
	 */
	void setScriptTypeName(std::string_view newName);

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
	bool creatureOnChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) const;
	ReturnValue creatureOnAreaCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, bool aggressive) const;
	ReturnValue creatureOnTargetCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const;
	void creatureOnDrainHealth(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) const;
	void creatureOnCombat(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target, CombatDamage &damage) const;

	// Party
	bool partyOnJoin(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) const;
	bool partyOnLeave(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) const;
	bool partyOnDisband(const std::shared_ptr<Party> &party) const;
	void partyOnShareExperience(const std::shared_ptr<Party> &party, uint64_t &exp) const;

	// Player
	bool playerOnBrowseField(const std::shared_ptr<Player> &player, const Position &position) const;
	void playerOnLook(const std::shared_ptr<Player> &player, const Position &position, const std::shared_ptr<Thing> &thing, uint8_t stackpos, int32_t lookDistance) const;
	void playerOnLookInBattleList(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, int32_t lookDistance) const;
	void playerOnLookInTrade(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partner, const std::shared_ptr<Item> &item, int32_t lookDistance) const;
	bool playerOnLookInShop(const std::shared_ptr<Player> &player, const ItemType* itemType, uint8_t count) const;
	bool playerOnMoveItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) const;
	void playerOnItemMoved(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) const;
	void playerOnChangeZone(const std::shared_ptr<Player> &player, ZoneType_t zone) const;
	bool playerOnMoveCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, const Position &fromPosition, const Position &toPosition) const;
	void playerOnReportRuleViolation(const std::shared_ptr<Player> &player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) const;
	void playerOnReportBug(const std::shared_ptr<Player> &player, const std::string &message, const Position &position, uint8_t category) const;
	bool playerOnTurn(const std::shared_ptr<Player> &player, Direction direction) const;
	bool playerOnTradeRequest(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item) const;
	bool playerOnTradeAccept(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &targetItem) const;
	void playerOnGainExperience(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint64_t &exp, uint64_t rawExp) const;
	void playerOnLoseExperience(const std::shared_ptr<Player> &player, uint64_t &exp) const;
	void playerOnGainSkillTries(const std::shared_ptr<Player> &player, skills_t skill, uint64_t &tries) const;
	void playerOnRemoveCount(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const;
	void playerOnRequestQuestLog(const std::shared_ptr<Player> &player) const;
	void playerOnRequestQuestLine(const std::shared_ptr<Player> &player, uint16_t questId) const;
	void playerOnStorageUpdate(const std::shared_ptr<Player> &player, uint32_t key, int32_t value, int32_t oldValue, uint64_t currentTime) const;
	void playerOnCombat(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item, CombatDamage &damage) const;
	void playerOnInventoryUpdate(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool equip) const;
	bool playerOnRotateItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &position) const;
	void playerOnWalk(const std::shared_ptr<Player> &player, const Direction &dir) const;
	void playerOnThink(std::shared_ptr<Player> player, uint32_t interval) const;

	// Monster
	void monsterOnDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse) const;
	void monsterPostDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse) const;

	// Zone
	bool zoneBeforeCreatureEnter(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const;
	bool zoneBeforeCreatureLeave(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const;
	void zoneAfterCreatureEnter(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const;
	void zoneAfterCreatureLeave(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const;

	void mapOnLoad(const std::string &mapFullPath) const;
};
