/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/creature/events.hpp"

#include "config/configmanager.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/grouping/party.hpp"
#include "creatures/players/player.hpp"
#include "game/movement/position.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

Events::Events() :
	scriptInterface("Event Interface") {
	scriptInterface.initState();
}

bool Events::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/events/events.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	info = {};

	phmap::flat_hash_set<std::string> classes;
	for (const auto &eventNode : doc.child("events").children()) {
		if (!eventNode.attribute("enabled").as_bool()) {
			continue;
		}

		const std::string &className = eventNode.attribute("class").as_string();
		const auto res = classes.emplace(className);
		if (res.second) {
			const std::string &lowercase = asLowerCaseString(className);
			const std::string &scriptName = lowercase + ".lua";
			auto coreFolder = g_configManager().getString(CORE_DIRECTORY);
			if (scriptInterface.loadFile(coreFolder + "/events/scripts/" + scriptName, scriptName) != 0) {
				g_logger().warn("{} - Can not load script: {}.lua", __FUNCTION__, lowercase);
				g_logger().warn(scriptInterface.getLastLuaError());
			}
		}

		const std::string &methodName = eventNode.attribute("method").as_string();
		const int32_t event = scriptInterface.getMetaEvent(className, methodName);
		if (className == "Creature") {
			if (methodName == "onChangeOutfit") {
				info.creatureOnChangeOutfit = event;
			} else if (methodName == "onAreaCombat") {
				info.creatureOnAreaCombat = event;
			} else if (methodName == "onTargetCombat") {
				info.creatureOnTargetCombat = event;
			} else if (methodName == "onDrainHealth") {
				info.creatureOnDrainHealth = event;
			} else {
				g_logger().warn("{} - Unknown creature method: {}", __FUNCTION__, methodName);
			}
		} else if (className == "Party") {
			if (methodName == "onJoin") {
				info.partyOnJoin = event;
			} else if (methodName == "onLeave") {
				info.partyOnLeave = event;
			} else if (methodName == "onDisband") {
				info.partyOnDisband = event;
			} else if (methodName == "onShareExperience") {
				info.partyOnShareExperience = event;
			} else {
				g_logger().warn("{} - Unknown party method: {}", __FUNCTION__, methodName);
			}
		} else if (className == "Player") {
			if (methodName == "onBrowseField") {
				info.playerOnBrowseField = event;
			} else if (methodName == "onLook") {
				info.playerOnLook = event;
			} else if (methodName == "onLookInBattleList") {
				info.playerOnLookInBattleList = event;
			} else if (methodName == "onLookInTrade") {
				info.playerOnLookInTrade = event;
			} else if (methodName == "onLookInShop") {
				info.playerOnLookInShop = event;
			} else if (methodName == "onTradeRequest") {
				info.playerOnTradeRequest = event;
			} else if (methodName == "onTradeAccept") {
				info.playerOnTradeAccept = event;
			} else if (methodName == "onMoveItem") {
				info.playerOnMoveItem = event;
			} else if (methodName == "onInventoryUpdate") {
				info.playerOnInventoryUpdate = event;
			} else if (methodName == "onItemMoved") {
				info.playerOnItemMoved = event;
			} else if (methodName == "onChangeZone") {
				info.playerOnChangeZone = event;
			} else if (methodName == "onChangeHazard") {
				info.playerOnChangeHazard = event;
			} else if (methodName == "onMoveCreature") {
				info.playerOnMoveCreature = event;
			} else if (methodName == "onReportRuleViolation") {
				info.playerOnReportRuleViolation = event;
			} else if (methodName == "onReportBug") {
				info.playerOnReportBug = event;
			} else if (methodName == "onTurn") {
				info.playerOnTurn = event;
			} else if (methodName == "onGainExperience") {
				info.playerOnGainExperience = event;
			} else if (methodName == "onLoseExperience") {
				info.playerOnLoseExperience = event;
			} else if (methodName == "onGainSkillTries") {
				info.playerOnGainSkillTries = event;
			} else if (methodName == "onRequestQuestLog") {
				info.playerOnRequestQuestLog = event;
			} else if (methodName == "onRequestQuestLine") {
				info.playerOnRequestQuestLine = event;
			} else if (methodName == "onStorageUpdate") {
				info.playerOnStorageUpdate = event;
			} else if (methodName == "onRemoveCount") {
				info.playerOnRemoveCount = event;
			} else if (methodName == "onCombat") {
				info.playerOnCombat = event;
			} else {
				g_logger().warn("{} - Unknown player method: {}", __FUNCTION__, methodName);
			}
		} else if (className == "Monster") {
			if (methodName == "onDropLoot") {
				info.monsterOnDropLoot = event;
			} else {
				g_logger().warn("{} - Unknown monster method: {}", __FUNCTION__, methodName);
			}
		} else {
			g_logger().warn("{} - Unknown class: {}", __FUNCTION__, className);
		}
	}
	return true;
}

Events &Events::getInstance() {
	return inject<Events>();
}

// Creature
bool Events::eventCreatureOnChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) {
	// Creature:onChangeOutfit(outfit) or Creature.onChangeOutfit(self, outfit)
	if (info.creatureOnChangeOutfit == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventCreatureOnChangeOutfit - Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.creatureOnChangeOutfit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnChangeOutfit);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushOutfit(L, outfit);

	return scriptInterface.callFunction(2);
}

ReturnValue Events::eventCreatureOnAreaCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, bool aggressive) {
	// Creature:onAreaCombat(tile, aggressive) or Creature.onAreaCombat(self, tile, aggressive)
	if (info.creatureOnAreaCombat == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventCreatureOnAreaCombat - "
		                 "Creature {} on tile position {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), tile->getPosition().toString());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.creatureOnAreaCombat, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnAreaCombat);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushUserdata<Tile>(L, tile);
	LuaScriptInterface::setMetatable(L, -1, "Tile");

	LuaScriptInterface::pushBoolean(L, aggressive);

	ReturnValue returnValue;
	if (LuaScriptInterface::protectedCall(L, 3, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
	return returnValue;
}

ReturnValue Events::eventCreatureOnTargetCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) {
	// Creature:onTargetCombat(target) or Creature.onTargetCombat(self, target)
	if (info.creatureOnTargetCombat == -1) {
		return RETURNVALUE_NOERROR;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventCreatureOnTargetCombat - "
		                 "Creature {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), target->getName());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.creatureOnTargetCombat, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnTargetCombat);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	ReturnValue returnValue;
	if (LuaScriptInterface::protectedCall(L, 2, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
	return returnValue;
}

void Events::eventCreatureOnDrainHealth(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) {
	if (info.creatureOnDrainHealth == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventCreatureOnDrainHealth - "
		                 "Creature {} attacker {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), attacker->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.creatureOnDrainHealth, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.creatureOnDrainHealth);

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	if (attacker) {
		LuaScriptInterface::pushUserdata<Creature>(L, attacker);
		LuaScriptInterface::setCreatureMetatable(L, -1, attacker);
	} else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, typePrimary);
	lua_pushnumber(L, damagePrimary);
	lua_pushnumber(L, typeSecondary);
	lua_pushnumber(L, damageSecondary);
	lua_pushnumber(L, colorPrimary);
	lua_pushnumber(L, colorSecondary);

	if (LuaScriptInterface::protectedCall(L, 8, 6) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		typePrimary = LuaScriptInterface::getNumber<CombatType_t>(L, -6);
		damagePrimary = LuaScriptInterface::getNumber<int32_t>(L, -5);
		typeSecondary = LuaScriptInterface::getNumber<CombatType_t>(L, -4);
		damageSecondary = LuaScriptInterface::getNumber<int32_t>(L, -3);
		colorPrimary = LuaScriptInterface::getNumber<TextColor_t>(L, -2);
		colorSecondary = LuaScriptInterface::getNumber<TextColor_t>(L, -1);
		lua_pop(L, 6);
	}

	LuaScriptInterface::resetScriptEnv();
}

// Party
bool Events::eventPartyOnJoin(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) {
	// Party:onJoin(player) or Party.onJoin(self, player)
	if (info.partyOnJoin == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPartyOnJoin - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.partyOnJoin, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnJoin);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnLeave(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) {
	// Party:onLeave(player) or Party.onLeave(self, player)
	if (info.partyOnLeave == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPartyOnLeave - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.partyOnLeave, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnLeave);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnDisband(const std::shared_ptr<Party> &party) {
	// Party:onDisband() or Party.onDisband(self)
	if (info.partyOnDisband == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPartyOnDisband - Party leader {}] Call stack "
		                 "overflow. Too many lua script calls being nested.",
		                 party->getLeader() ? party->getLeader()->getName() : "unknown");
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.partyOnDisband, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnDisband);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	return scriptInterface.callFunction(1);
}

void Events::eventPartyOnShareExperience(const std::shared_ptr<Party> &party, uint64_t &exp) {
	// Party:onShareExperience(exp) or Party.onShareExperience(self, exp)
	if (info.partyOnShareExperience == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("Party leader {}. Call stack overflow. Too many lua script calls being nested.", party->getLeader() ? party->getLeader()->getName() : "unknown");
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.partyOnShareExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.partyOnShareExperience);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	lua_pushnumber(L, exp);

	if (LuaScriptInterface::protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
}

// Player
bool Events::eventPlayerOnBrowseField(const std::shared_ptr<Player> &player, const Position &position) {
	// Player:onBrowseField(position) or Player.onBrowseField(self, position)
	if (info.playerOnBrowseField == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnBrowseField - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnBrowseField, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnBrowseField);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	return scriptInterface.callFunction(2);
}

void Events::eventPlayerOnLook(const std::shared_ptr<Player> &player, const Position &position, const std::shared_ptr<Thing> &thing, uint8_t stackpos, int32_t lookDistance) {
	// Player:onLook(thing, position, distance) or Player.onLook(self, thing, position, distance)
	if (info.playerOnLook == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnLook - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnLook, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLook);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (const std::shared_ptr<Creature> &creature = thing->getCreature()) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else if (const auto &item = thing->getItem()) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushPosition(L, position, stackpos);
	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnLookInBattleList(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, int32_t lookDistance) {
	// Player:onLookInBattleList(creature, position, distance) or Player.onLookInBattleList(self, creature, position, distance)
	if (info.playerOnLookInBattleList == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnLookInBattleList - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnLookInBattleList, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInBattleList);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnLookInTrade(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partner, const std::shared_ptr<Item> &item, int32_t lookDistance) {
	// Player:onLookInTrade(partner, item, distance) or Player.onLookInTrade(self, partner, item, distance)
	if (info.playerOnLookInTrade == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnLookInTrade - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnLookInTrade, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInTrade);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, partner);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

bool Events::eventPlayerOnLookInShop(const std::shared_ptr<Player> &player, const ItemType* itemType, uint8_t count) {
	// Player:onLookInShop(itemType, count) or Player.onLookInShop(self, itemType, count)
	if (info.playerOnLookInShop == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnLookInShop - "
		                 "Player {} itemType {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), itemType->getPluralName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnLookInShop, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLookInShop);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<const ItemType>(L, itemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	lua_pushnumber(L, count);

	return scriptInterface.callFunction(3);
}

bool Events::eventPlayerOnRemoveCount(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) {
	// Player:onMove()
	if (info.playerOnRemoveCount == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnMove - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnRemoveCount, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnRemoveCount);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	return scriptInterface.callFunction(2);
}

bool Events::eventPlayerOnMoveItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) {
	// Player:onMoveItem(item, count, fromPosition, toPosition) or Player.onMoveItem(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if (info.playerOnMoveItem == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnMoveItem - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnMoveItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnMoveItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	return scriptInterface.callFunction(7);
}

void Events::eventPlayerOnItemMoved(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) {
	// Player:onItemMoved(item, count, fromPosition, toPosition) or Player.onItemMoved(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if (info.playerOnItemMoved == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnItemMoved - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnItemMoved, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnItemMoved);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	scriptInterface.callVoidFunction(7);
}

void Events::eventPlayerOnChangeZone(const std::shared_ptr<Player> &player, ZoneType_t zone) {
	// Player:onChangeZone(zone)
	if (info.playerOnChangeZone == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnChangeZone - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnChangeZone, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnChangeZone);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, zone);
	scriptInterface.callVoidFunction(2);
}

bool Events::eventPlayerOnMoveCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, const Position &fromPosition, const Position &toPosition) {
	// Player:onMoveCreature(creature, fromPosition, toPosition) or Player.onMoveCreature(self, creature, fromPosition, toPosition)
	if (info.playerOnMoveCreature == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnMoveCreature - "
		                 "Player {} creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnMoveCreature, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnMoveCreature);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	return scriptInterface.callFunction(4);
}

void Events::eventPlayerOnReportRuleViolation(const std::shared_ptr<Player> &player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) {
	// Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	if (info.playerOnReportRuleViolation == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnReportRuleViolation - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnReportRuleViolation, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnReportRuleViolation);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, targetName);

	lua_pushnumber(L, reportType);
	lua_pushnumber(L, reportReason);

	LuaScriptInterface::pushString(L, comment);
	LuaScriptInterface::pushString(L, translation);

	scriptInterface.callVoidFunction(6);
}

bool Events::eventPlayerOnReportBug(const std::shared_ptr<Player> &player, const std::string &message, const Position &position, uint8_t category) {
	// Player:onReportBug(message, position, category)
	if (info.playerOnReportBug == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnReportBug - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnReportBug, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnReportBug);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, message);
	LuaScriptInterface::pushPosition(L, position);
	lua_pushnumber(L, category);

	return scriptInterface.callFunction(4);
}

bool Events::eventPlayerOnTurn(const std::shared_ptr<Player> &player, Direction direction) {
	// Player:onTurn(direction) or Player.onTurn(self, direction)
	if (info.playerOnTurn == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnTurn - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnTurn, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTurn);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, direction);

	return scriptInterface.callFunction(2);
}

bool Events::eventPlayerOnTradeRequest(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item) {
	// Player:onTradeRequest(target, item)
	if (info.playerOnTradeRequest == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnTradeRequest - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnTradeRequest, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTradeRequest);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	return scriptInterface.callFunction(3);
}

bool Events::eventPlayerOnTradeAccept(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &targetItem) {
	// Player:onTradeAccept(target, item, targetItem)
	if (info.playerOnTradeAccept == -1) {
		return true;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnTradeAccept - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnTradeAccept, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnTradeAccept);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushUserdata<Item>(L, targetItem);
	LuaScriptInterface::setItemMetatable(L, -1, targetItem);

	return scriptInterface.callFunction(4);
}

void Events::eventPlayerOnGainExperience(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint64_t &exp, uint64_t rawExp) {
	// Player:onGainExperience(target, exp, rawExp)
	// rawExp gives the original exp which is not multiplied
	if (info.playerOnGainExperience == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnGainExperience - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnGainExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnGainExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, exp);
	lua_pushnumber(L, rawExp);

	if (LuaScriptInterface::protectedCall(L, 4, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
}

void Events::eventPlayerOnLoseExperience(const std::shared_ptr<Player> &player, uint64_t &exp) {
	// Player:onLoseExperience(exp)
	if (info.playerOnLoseExperience == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnLoseExperience - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnLoseExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnLoseExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, exp);

	if (LuaScriptInterface::protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
}

void Events::eventPlayerOnGainSkillTries(const std::shared_ptr<Player> &player, skills_t skill, uint64_t &tries) {
	// Player:onGainSkillTries(skill, tries)
	if (info.playerOnGainSkillTries == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnGainSkillTries - "
		                 "Player {} skill {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), fmt::underlying(skill));
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnGainSkillTries, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnGainSkillTries);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, skill);
	lua_pushnumber(L, tries);

	if (LuaScriptInterface::protectedCall(L, 3, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		tries = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
}

void Events::eventPlayerOnCombat(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item, CombatDamage &damage) {
	// Player:onCombat(target, item, primaryDamage, primaryType, secondaryDamage, secondaryType)
	if (info.playerOnCombat == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnCombat - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnCombat, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnCombat);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	} else {
		lua_pushnil(L);
	}

	if (item) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setMetatable(L, -1, "Item");
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushCombatDamage(L, damage);

	if (LuaScriptInterface::protectedCall(L, 8, 4) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		damage.primary.value = std::abs(LuaScriptInterface::getNumber<int32_t>(L, -4));
		damage.primary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -3);
		damage.secondary.value = std::abs(LuaScriptInterface::getNumber<int32_t>(L, -2));
		damage.secondary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -1);

		lua_pop(L, 4);
		if (damage.primary.type != COMBAT_HEALING) {
			damage.primary.value = -damage.primary.value;
			damage.secondary.value = -damage.secondary.value;
		}
	}

	LuaScriptInterface::resetScriptEnv();
}

void Events::eventPlayerOnRequestQuestLog(const std::shared_ptr<Player> &player) {
	// Player:onRequestQuestLog()
	if (info.playerOnRequestQuestLog == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnRequestQuestLog - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnRequestQuestLog, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnRequestQuestLog);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	scriptInterface.callVoidFunction(1);
}

void Events::eventPlayerOnRequestQuestLine(const std::shared_ptr<Player> &player, uint16_t questId) {
	// Player::onRequestQuestLine()
	if (info.playerOnRequestQuestLine == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventPlayerOnRequestQuestLine - "
		                 "Player {} questId {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), questId);
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnRequestQuestLine, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnRequestQuestLine);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, questId);

	scriptInterface.callVoidFunction(2);
}

void Events::eventPlayerOnInventoryUpdate(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool equip) {
	// Player:onInventoryUpdate(item, slot, equip)
	if (info.playerOnInventoryUpdate == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[{}] Call stack overflow", __FUNCTION__);
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnInventoryUpdate, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnInventoryUpdate);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, slot);
	LuaScriptInterface::pushBoolean(L, equip);

	scriptInterface.callVoidFunction(4);
}

void Events::eventOnStorageUpdate(const std::shared_ptr<Player> &player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime) {
	// Player::onStorageUpdate(key, value, oldValue, currentTime)
	if (info.playerOnStorageUpdate == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventOnStorageUpdate - "
		                 "Player {} key {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), key);
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.playerOnStorageUpdate, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.playerOnStorageUpdate);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, key);
	lua_pushnumber(L, value);
	lua_pushnumber(L, oldValue);
	lua_pushnumber(L, currentTime);

	scriptInterface.callVoidFunction(5);
}

// Monster
void Events::eventMonsterOnDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse) {
	// Monster:onDropLoot(corpse)
	if (info.monsterOnDropLoot == -1) {
		return;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Events::eventMonsterOnDropLoot - "
		                 "Monster corpse {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 corpse->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(info.monsterOnDropLoot, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(info.monsterOnDropLoot);

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return scriptInterface.callVoidFunction(2);
}
