/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_LUA_CALLBACKS_EVENTCALLBACK_FUNCTIONS_HPP_
#define SRC_LUA_CALLBACKS_EVENTCALLBACK_FUNCTIONS_HPP_

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

enum class EventCallback_t : int16_t {
	None,
	// Creature
	CreatureOnChangeOutfit,
	CreatureOnAreaCombat,
	CreatureOnTargetCombat,
	CreatureOnHear,
	CreatureOnDrainHealth,
	// Party
	PartyOnJoin,
	PartyOnLeave,
	PartyOnDisband,
	PartyOnShareExperience,
	// Player
	PlayerOnBrowseField,
	PlayerOnLook,
	PlayerOnLookInBattleList,
	PlayerOnLookInTrade,
	PlayerOnLookInShop,
	PlayerOnMoveItem,
	PlayerOnItemMoved,
	PlayerOnChangeZone,
	PlayerOnChangeHazard,
	PlayerOnMoveCreature,
	PlayerOnReportRuleViolation,
	PlayerOnReportBug,
	PlayerOnTurn,
	PlayerOnTradeRequest,
	PlayerOnTradeAccept,
	PlayerOnGainExperience,
	PlayerOnLoseExperience,
	PlayerOnGainSkillTries,
	PlayerOnRequestQuestLog,
	PlayerOnRequestQuestLine,
	PlayerOnStorageUpdate,
	PlayerOnRemoveCount,
	PlayerOnCombat,
	PlayerOnInventoryUpdate,
	// Monster
	MonsterOnDropLoot,
	MonsterOnSpawn,
	// Npc
	NpcOnSpawn,

	First = CreatureOnChangeOutfit,
	Last = NpcOnSpawn
};

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
	EventCallback(LuaScriptInterface* scriptInterface);

	std::string getScriptTypeName() const override;

	void setScriptTypeName(const std::string_view newName);

	EventCallback_t getType() const;

	void setType(EventCallback_t type);

	// Creature
	bool creatureOnChangeOutfit(Creature* creature, const Outfit_t &outfit);
	ReturnValue creatureOnAreaCombat(Creature* creature, Tile* tile, bool aggressive);
	ReturnValue creatureOnTargetCombat(Creature* creature, Creature* target);
	void creatureOnHear(Creature* creature, Creature* speaker, const std::string &words, SpeakClasses type);
	void creatureOnDrainHealth(Creature* creature, Creature* attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary);

	// Party
	bool partyOnJoin(Party* party, Player* player);
	bool partyOnLeave(Party* party, Player* player);
	bool partyOnDisband(Party* party);
	void partyOnShareExperience(Party* party, uint64_t &exp);

	// Player
	bool playerOnBrowseField(Player* player, const Position &position);
	void playerOnLook(Player* player, const Position &position, Thing* thing, uint8_t stackpos, int32_t lookDistance);
	void playerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance);
	void playerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance);
	bool playerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count);
	bool playerOnMoveItem(Player* player, Item* item, uint16_t count, const Position &fromPosition, const Position &toPosition, Cylinder* fromCylinder, Cylinder* toCylinder);
	void playerOnItemMoved(Player* player, Item* item, uint16_t count, const Position &fromPosition, const Position &toPosition, Cylinder* fromCylinder, Cylinder* toCylinder);
	void playerOnChangeZone(Player* player, ZoneType_t zone);
	void playerOnChangeHazard(Player* player, bool isHazard);
	bool playerOnMoveCreature(Player* player, Creature* creature, const Position &fromPosition, const Position &toPosition);
	void playerOnReportRuleViolation(Player* player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation);
	void playerOnReportBug(Player* player, const std::string &message, const Position &position, uint8_t category);
	bool playerOnTurn(Player* player, Direction direction);
	bool playerOnTradeRequest(Player* player, Player* target, Item* item);
	bool playerOnTradeAccept(Player* player, Player* target, Item* item, Item* targetItem);
	void playerOnGainExperience(Player* player, Creature* target, uint64_t &exp, uint64_t rawExp);
	void playerOnLoseExperience(Player* player, uint64_t &exp);
	void playerOnGainSkillTries(Player* player, skills_t skill, uint64_t &tries);
	void playerOnRemoveCount(Player* player, Item* item);
	void playerOnRequestQuestLog(Player* player);
	void playerOnRequestQuestLine(Player* player, uint16_t questId);
	void playerOnStorageUpdate(Player* player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime);
	void playerOnCombat(Player* player, Creature* target, Item* item, CombatDamage &damage);
	void playerOnInventoryUpdate(Player* player, Item* item, Slots_t slot, bool equip);

	// Monster
	void monsterOnDropLoot(Monster* monster, Container* corpse);
	void monsterOnSpawn(Monster* monster, const Position &position);

	// Monster
	void npcOnSpawn(Npc* npc, const Position &position);
};

#endif // SRC_LUA_CALLBACKS_EVENTCALLBACK_FUNCTIONS_HPP_
