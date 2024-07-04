/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/callbacks/event_callback.hpp"

#include "utils/tools.hpp"
#include "items/item.hpp"
#include "creatures/players/player.hpp"
#include "game/zones/zone.hpp"

/**
 * @class EventCallback
 * @brief Class representing an event callback.
 *
 * @note This class is used to encapsulate the logic of a Lua event callback.
 * @details It is derived from the Script class and includes additional information specific to event callbacks.
 *
 * @see Script
 */
EventCallback::EventCallback(LuaScriptInterface* scriptInterface) :
	Script(scriptInterface) {
}

std::string EventCallback::getScriptTypeName() const {
	return m_scriptTypeName;
}

void EventCallback::setScriptTypeName(const std::string_view newName) {
	m_scriptTypeName = newName;
}

EventCallback_t EventCallback::getType() const {
	return m_callbackType;
}

void EventCallback::setType(EventCallback_t type) {
	m_callbackType = type;
}

// Lua functions
// Creature
bool EventCallback::creatureOnChangeOutfit(std::shared_ptr<Creature> creature, const Outfit_t &outfit) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnChangeOutfit - Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushOutfit(L, outfit);

	return getScriptInterface()->callFunction(2);
}

ReturnValue EventCallback::creatureOnAreaCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Tile> tile, bool aggressive) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnAreaCombat - "
		                 "Creature {} on tile position {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), tile->getPosition().toString());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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
	if (getScriptInterface()->protectedCall(L, 3, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
	return returnValue;
}

ReturnValue EventCallback::creatureOnTargetCombat(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> target) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnTargetCombat - "
		                 "Creature {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), target->getName());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	if (creature) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	ReturnValue returnValue;
	if (getScriptInterface()->protectedCall(L, 2, 1) != 0) {
		returnValue = RETURNVALUE_NOTPOSSIBLE;
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		returnValue = LuaScriptInterface::getNumber<ReturnValue>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
	return returnValue;
}

void EventCallback::creatureOnHear(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> speaker, const std::string &words, SpeakClasses type) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnHear - "
		                 "Creature {} speaker {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), speaker->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, speaker);
	LuaScriptInterface::setCreatureMetatable(L, -1, speaker);

	LuaScriptInterface::pushString(L, words);
	lua_pushnumber(L, type);

	getScriptInterface()->callVoidFunction(4);
}

void EventCallback::creatureOnDrainHealth(std::shared_ptr<Creature> creature, std::shared_ptr<Creature> attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnDrainHealth - "
		                 "Creature {} attacker {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), attacker->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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

	if (getScriptInterface()->protectedCall(L, 8, 6) != 0) {
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

	getScriptInterface()->resetScriptEnv();
}

// Party
bool EventCallback::partyOnJoin(std::shared_ptr<Party> party, std::shared_ptr<Player> player) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnJoin - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::partyOnLeave(std::shared_ptr<Party> party, std::shared_ptr<Player> player) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnLeave - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::partyOnDisband(std::shared_ptr<Party> party) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnDisband - Party leader {}] Call stack "
		                 "overflow. Too many lua script calls being nested.",
		                 party->getLeader() ? party->getLeader()->getName() : "unknown");
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	return getScriptInterface()->callFunction(1);
}

void EventCallback::partyOnShareExperience(std::shared_ptr<Party> party, uint64_t &exp) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("Party leader {}. Call stack overflow. Too many lua script calls being nested.", party->getLeader() ? party->getLeader()->getName() : "unknown");
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	lua_pushnumber(L, exp);

	if (getScriptInterface()->protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

// Player
bool EventCallback::playerOnBrowseField(std::shared_ptr<Player> player, const Position &position) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnBrowseField - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	return getScriptInterface()->callFunction(2);
}

void EventCallback::playerOnLook(std::shared_ptr<Player> player, const Position &position, std::shared_ptr<Thing> thing, uint8_t stackpos, int32_t lookDistance) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLook - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (std::shared_ptr<Creature> creature = thing->getCreature()) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else if (std::shared_ptr<Item> item = thing->getItem()) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushPosition(L, position, stackpos);
	lua_pushnumber(L, lookDistance);

	getScriptInterface()->callVoidFunction(4);
}

void EventCallback::playerOnLookInBattleList(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, int32_t lookDistance) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInBattleList - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	lua_pushnumber(L, lookDistance);

	getScriptInterface()->callVoidFunction(3);
}

void EventCallback::playerOnLookInTrade(std::shared_ptr<Player> player, std::shared_ptr<Player> partner, std::shared_ptr<Item> item, int32_t lookDistance) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInTrade - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, partner);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, lookDistance);

	getScriptInterface()->callVoidFunction(4);
}

bool EventCallback::playerOnLookInShop(std::shared_ptr<Player> player, const ItemType* itemType, uint8_t count) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInShop - "
		                 "Player {} itemType {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), itemType->getPluralName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<const ItemType>(L, itemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	lua_pushnumber(L, count);

	return getScriptInterface()->callFunction(3);
}

void EventCallback::playerOnRemoveCount(std::shared_ptr<Player> player, std::shared_ptr<Item> item) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnMove - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	getScriptInterface()->callFunction(2);
}

bool EventCallback::playerOnMoveItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPos, const Position &toPos, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder) const {
	if (!getScriptInterface()) {
		g_logger().error("script interface nullptr");
		return false;
	}

	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[Action::executeUse - Player {}, on item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushThing(L, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPos);
	LuaScriptInterface::pushPosition(L, toPos);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	return getScriptInterface()->callFunction(7);
}

void EventCallback::playerOnItemMoved(std::shared_ptr<Player> player, std::shared_ptr<Item> item, uint16_t count, const Position &fromPosition, const Position &toPosition, std::shared_ptr<Cylinder> fromCylinder, std::shared_ptr<Cylinder> toCylinder) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnItemMoved - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	LuaScriptInterface::pushCylinder(L, fromCylinder);
	LuaScriptInterface::pushCylinder(L, toCylinder);

	getScriptInterface()->callVoidFunction(7);
}

void EventCallback::playerOnChangeZone(std::shared_ptr<Player> player, ZoneType_t zone) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnChangeZone - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, zone);
	getScriptInterface()->callVoidFunction(2);
}

bool EventCallback::playerOnMoveCreature(std::shared_ptr<Player> player, std::shared_ptr<Creature> creature, const Position &fromPosition, const Position &toPosition) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnMoveCreature - "
		                 "Player {} creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	return getScriptInterface()->callFunction(4);
}

void EventCallback::playerOnReportRuleViolation(std::shared_ptr<Player> player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnReportRuleViolation - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, targetName);

	lua_pushnumber(L, reportType);
	lua_pushnumber(L, reportReason);

	LuaScriptInterface::pushString(L, comment);
	LuaScriptInterface::pushString(L, translation);

	getScriptInterface()->callVoidFunction(6);
}

void EventCallback::playerOnReportBug(std::shared_ptr<Player> player, const std::string &message, const Position &position, uint8_t category) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnReportBug - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, message);
	LuaScriptInterface::pushPosition(L, position);
	lua_pushnumber(L, category);

	getScriptInterface()->callFunction(4);
}

bool EventCallback::playerOnTurn(std::shared_ptr<Player> player, Direction direction) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTurn - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, direction);

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::playerOnTradeRequest(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTradeRequest - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	return getScriptInterface()->callFunction(3);
}

bool EventCallback::playerOnTradeAccept(std::shared_ptr<Player> player, std::shared_ptr<Player> target, std::shared_ptr<Item> item, std::shared_ptr<Item> targetItem) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTradeAccept - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushUserdata<Item>(L, targetItem);
	LuaScriptInterface::setItemMetatable(L, -1, targetItem);

	return getScriptInterface()->callFunction(4);
}

void EventCallback::playerOnGainExperience(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, uint64_t &exp, uint64_t rawExp) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnGainExperience - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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

	if (getScriptInterface()->protectedCall(L, 4, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

void EventCallback::playerOnLoseExperience(std::shared_ptr<Player> player, uint64_t &exp) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLoseExperience - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, exp);

	if (getScriptInterface()->protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

void EventCallback::playerOnGainSkillTries(std::shared_ptr<Player> player, skills_t skill, uint64_t &tries) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnGainSkillTries - "
		                 "Player {} skill {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), fmt::underlying(skill));
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, skill);
	lua_pushnumber(L, tries);

	if (getScriptInterface()->protectedCall(L, 3, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		tries = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

void EventCallback::playerOnCombat(std::shared_ptr<Player> player, std::shared_ptr<Creature> target, std::shared_ptr<Item> item, CombatDamage &damage) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnCombat - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setMetatable(L, -1, "Creature");
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

	if (getScriptInterface()->protectedCall(L, 8, 4) != 0) {
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
		/*
		    Only EK with dealing physical damage will get elemental damage on skill
		*/
		if (damage.origin == ORIGIN_SPELL) {
			if (player->getVocationId() != 4 && player->getVocationId() != 8) {
				damage.primary.value = damage.primary.value + damage.secondary.value;
				damage.secondary.type = COMBAT_NONE;
				damage.secondary.value = 0;
			}
		}
	}

	getScriptInterface()->resetScriptEnv();
}

void EventCallback::playerOnRequestQuestLog(std::shared_ptr<Player> player) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnRequestQuestLog - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	getScriptInterface()->callVoidFunction(1);
}

void EventCallback::playerOnRequestQuestLine(std::shared_ptr<Player> player, uint16_t questId) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnRequestQuestLine - "
		                 "Player {} questId {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), questId);
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, questId);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::playerOnInventoryUpdate(std::shared_ptr<Player> player, std::shared_ptr<Item> item, Slots_t slot, bool equip) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[{}] Call stack overflow", __FUNCTION__);
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, slot);
	LuaScriptInterface::pushBoolean(L, equip);

	getScriptInterface()->callVoidFunction(4);
}

bool EventCallback::playerOnRotateItem(std::shared_ptr<Player> player, std::shared_ptr<Item> item, const Position &position) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[{}] Call stack overflow", __FUNCTION__);
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	LuaScriptInterface::pushPosition(L, position);

	return getScriptInterface()->callFunction(3);
}

void EventCallback::playerOnWalk(std::shared_ptr<Player> player, Direction &dir) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::eventOnWalk - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, dir);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::playerOnStorageUpdate(std::shared_ptr<Player> player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::eventOnStorageUpdate - "
		                 "Player {} key {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), key);
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, key);
	lua_pushnumber(L, value);
	lua_pushnumber(L, oldValue);
	lua_pushnumber(L, currentTime);

	getScriptInterface()->callVoidFunction(5);
}

// Monster
void EventCallback::monsterOnDropLoot(std::shared_ptr<Monster> monster, std::shared_ptr<Container> corpse) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::monsterOnDropLoot - "
		                 "Monster corpse {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 corpse->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return getScriptInterface()->callVoidFunction(2);
}

void EventCallback::monsterPostDropLoot(std::shared_ptr<Monster> monster, std::shared_ptr<Container> corpse) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::monsterPostDropLoot - "
		                 "Monster corpse {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 corpse->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return getScriptInterface()->callVoidFunction(2);
}

void EventCallback::monsterOnSpawn(std::shared_ptr<Monster> monster, const Position &position) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("{} - "
		                 "Position {}"
		                 ". Call stack overflow. Too many lua script calls being nested.",
		                 __FUNCTION__, position.toString());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");
	LuaScriptInterface::pushPosition(L, position);

	if (getScriptInterface()->protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

// Npc
void EventCallback::npcOnSpawn(std::shared_ptr<Npc> npc, const Position &position) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("{} - "
		                 "Position {}"
		                 ". Call stack overflow. Too many lua script calls being nested.",
		                 __FUNCTION__, position.toString());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Npc>(L, npc);
	LuaScriptInterface::setMetatable(L, -1, "Npc");
	LuaScriptInterface::pushPosition(L, position);

	if (getScriptInterface()->protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		lua_pop(L, 1);
	}

	getScriptInterface()->resetScriptEnv();
}

bool EventCallback::zoneBeforeCreatureEnter(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneBeforeCreatureEnter - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::zoneBeforeCreatureLeave(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneBeforeCreatureLeave - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	return getScriptInterface()->callFunction(2);
}

void EventCallback::zoneAfterCreatureEnter(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneAfterCreatureEnter - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::zoneAfterCreatureLeave(std::shared_ptr<Zone> zone, std::shared_ptr<Creature> creature) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneAfterCreatureLeave - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	getScriptInterface()->callVoidFunction(2);
}
