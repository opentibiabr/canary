/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

enum ReturnValue : uint16_t;
enum SpeakClasses : uint8_t;
enum TextColor_t : uint8_t;
enum CombatType_t : uint8_t;
enum Direction : uint8_t;
enum skills_t : int8_t;
enum Slots_t : uint8_t;
enum ZoneType_t : uint8_t;
struct Position;
struct Outfit_t;
struct CombatDamage;
class Party;
class ItemType;
class Imbuements;
class Monster;
class Player;
class Item;
class Creature;
class Npc;
class Tile;
class Thing;
class Cylinder;
class Container;

class Events {
	struct EventsInfo {
		// Creature
		int32_t creatureOnChangeOutfit = -1;
		int32_t creatureOnAreaCombat = -1;
		int32_t creatureOnTargetCombat = -1;
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
		int32_t playerOnChangeHazard = -1;
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
		int32_t playerOnInventoryUpdate = -1;

		// Monster
		int32_t monsterOnDropLoot = -1;
	};

public:
	Events();

	bool loadFromXml();

	// non-copyable
	Events(const Events &) = delete;
	void operator=(const Events &) = delete;

	static Events &getInstance();

	// Creature
	bool eventCreatureOnChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit);
	ReturnValue eventCreatureOnAreaCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, bool aggressive);
	ReturnValue eventCreatureOnTargetCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target);
	void eventCreatureOnDrainHealth(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary);

	// Party
	bool eventPartyOnJoin(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player);
	bool eventPartyOnLeave(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player);
	bool eventPartyOnDisband(const std::shared_ptr<Party> &party);
	void eventPartyOnShareExperience(const std::shared_ptr<Party> &party, uint64_t &exp);

	// Player
	bool eventPlayerOnBrowseField(const std::shared_ptr<Player> &player, const Position &position);
	void eventPlayerOnLook(const std::shared_ptr<Player> &player, const Position &position, const std::shared_ptr<Thing> &thing, uint8_t stackpos, int32_t lookDistance);
	void eventPlayerOnLookInBattleList(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, int32_t lookDistance);
	void eventPlayerOnLookInTrade(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partner, const std::shared_ptr<Item> &item, int32_t lookDistance);
	bool eventPlayerOnLookInShop(const std::shared_ptr<Player> &player, const ItemType* itemType, uint8_t count);
	bool eventPlayerOnMoveItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder);
	void eventPlayerOnItemMoved(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder);
	void eventPlayerOnChangeZone(const std::shared_ptr<Player> &player, ZoneType_t zone);
	bool eventPlayerOnMoveCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, const Position &fromPosition, const Position &toPosition);
	void eventPlayerOnReportRuleViolation(const std::shared_ptr<Player> &player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation);
	bool eventPlayerOnReportBug(const std::shared_ptr<Player> &player, const std::string &message, const Position &position, uint8_t category);
	bool eventPlayerOnTurn(const std::shared_ptr<Player> &player, Direction direction);
	bool eventPlayerOnTradeRequest(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item);
	bool eventPlayerOnTradeAccept(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &targetItem);
	void eventPlayerOnGainExperience(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint64_t &exp, uint64_t rawExp);
	void eventPlayerOnLoseExperience(const std::shared_ptr<Player> &player, uint64_t &exp);
	void eventPlayerOnGainSkillTries(const std::shared_ptr<Player> &player, skills_t skill, uint64_t &tries);
	bool eventPlayerOnRemoveCount(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item);
	void eventPlayerOnRequestQuestLog(const std::shared_ptr<Player> &player);
	void eventPlayerOnRequestQuestLine(const std::shared_ptr<Player> &player, uint16_t questId);
	void eventOnStorageUpdate(const std::shared_ptr<Player> &player, uint32_t key, int32_t value, int32_t oldValue, uint64_t currentTime);
	void eventPlayerOnCombat(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item, CombatDamage &damage);
	void eventPlayerOnInventoryUpdate(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool equip);

	// Monster
	void eventMonsterOnDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse);

private:
	LuaScriptInterface scriptInterface;
	EventsInfo info;
};

constexpr auto g_events = Events::getInstance;
