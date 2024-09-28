/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "creatures/players/imbuements/imbuements.hpp"
#include "lua/scripts/luascript.hpp"
#include "creatures/combat/spells.hpp"

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
		int32_t monsterOnSpawn = -1;

		// Npc
		int32_t npcOnSpawn = -1;
	};

public:
	Events();

	bool loadFromXml();

	// non-copyable
	Events(const Events &) = delete;
	void operator=(const Events &) = delete;

	static Events &getInstance() {
		return inject<Events>();
	}

	// Creature
	bool eventCreatureOnChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit);
	ReturnValue eventCreatureOnAreaCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Tile> tile, bool aggressive);
	ReturnValue eventCreatureOnTargetCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target);
	void eventCreatureOnHear(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> speaker, const std::string &words, SpeakClasses type);
	void eventCreatureOnDrainHealth(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary);

	// Party
	bool eventPartyOnJoin(std::shared_ptr<Party> party, std::shared_ptr<Player> player);
	bool eventPartyOnLeave(std::shared_ptr<Party> party, std::shared_ptr<Player> player);
	bool eventPartyOnDisband(std::shared_ptr<Party> party);
	void eventPartyOnShareExperience(std::shared_ptr<Party> party, uint64_t &exp);

	// Player
	bool eventPlayerOnBrowseField(std::shared_ptr<Player> player, const Position &position);
	void eventPlayerOnLook(std::shared_ptr<Player> player, const Position &position, std::shared_ptr<Thing> thing, uint8_t stackpos, int32_t lookDistance);
	void eventPlayerOnLookInBattleList(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, int32_t lookDistance);
	void eventPlayerOnLookInTrade(std::shared_ptr<Player> player, std::shared_ptr<Player> partner, std::shared_ptr<Item> item, int32_t lookDistance);
	bool eventPlayerOnLookInShop(std::shared_ptr<Player> player, const ItemType* itemType, uint8_t count);
	bool eventPlayerOnMoveItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPosition, const Position &toPosition, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder);
	void eventPlayerOnItemMoved(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPosition, const Position &toPosition, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder);
	void eventPlayerOnChangeZone(std::shared_ptr<Player> player, ZoneType_t zone);
	bool eventPlayerOnMoveCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, const Position &fromPosition, const Position &toPosition);
	void eventPlayerOnReportRuleViolation(std::shared_ptr<Player> player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation);
	bool eventPlayerOnReportBug(std::shared_ptr<Player> player, const std::string &message, const Position &position, uint8_t category);
	bool eventPlayerOnTurn(std::shared_ptr<Player> player, Direction direction);
	bool eventPlayerOnTradeRequest(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item);
	bool eventPlayerOnTradeAccept(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item, std::shared_ptr<Item> targetItem);
	void eventPlayerOnGainExperience(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, uint64_t &exp, uint64_t rawExp);
	void eventPlayerOnLoseExperience(std::shared_ptr<Player> player, uint64_t &exp);
	void eventPlayerOnGainSkillTries(std::shared_ptr<Player> player, skills_t skill, uint64_t &tries);
	bool eventPlayerOnRemoveCount(std::shared_ptr<Player> player, std::shared_ptr<Item> item);
	void eventPlayerOnRequestQuestLog(std::shared_ptr<Player> player);
	void eventPlayerOnRequestQuestLine(std::shared_ptr<Player> player, uint16_t questId);
	void eventOnStorageUpdate(std::shared_ptr<Player> player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime);
	void eventPlayerOnCombat(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, CombatDamage &damage);
	void eventPlayerOnInventoryUpdate(std::shared_ptr<Player> player, std::shared_ptr<Item> item, Slots_t slot, bool equip);

	// Monster
	void eventMonsterOnDropLoot(std::shared_ptr<Monster> monster, std::shared_ptr<Container> corpse);
	void eventMonsterOnSpawn(std::shared_ptr<Monster> monster, const Position &position);

	// Monster
	void eventNpcOnSpawn(std::shared_ptr<Npc> npc, const Position &position);

private:
	LuaScriptInterface scriptInterface;
	EventsInfo info;
};

constexpr auto g_events = Events::getInstance;
