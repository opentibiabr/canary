/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/callbacks/event_callback.hpp"

#include "creatures/players/grouping/party.hpp"
#include "creatures/players/player.hpp"
#include "game/zones/zone.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"

/**
 * @class EventCallback
 * @brief Class representing an event callback.
 *
 * @note This class is used to encapsulate the logic of a Lua event callback.
 * @details It is derived from the Script class and includes additional information specific to event callbacks.
 *
 * @see Script
 */
EventCallback::EventCallback(LuaScriptInterface* scriptInterface, const std::string &callbackName, bool skipDuplicationCheck) :
	Script(scriptInterface), m_callbackName(callbackName), m_skipDuplicationCheck(skipDuplicationCheck) {
}

std::string EventCallback::getName() const {
	return m_callbackName;
}

bool EventCallback::skipDuplicationCheck() const {
	return m_skipDuplicationCheck;
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
bool EventCallback::creatureOnChangeOutfit(const std::shared_ptr<Creature> &creature, const Outfit_t &outfit) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnChangeOutfit - Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushOutfit(L, outfit);

	return getScriptInterface()->callFunction(2);
}

ReturnValue EventCallback::creatureOnAreaCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &tile, bool aggressive) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnAreaCombat - "
		                 "Creature {} on tile position {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), tile->getPosition().toString());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

ReturnValue EventCallback::creatureOnTargetCombat(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &target) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnTargetCombat - "
		                 "Creature {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), target->getName());
		return RETURNVALUE_NOTPOSSIBLE;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::creatureOnDrainHealth(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Creature> &attacker, CombatType_t &typePrimary, int32_t &damagePrimary, CombatType_t &typeSecondary, int32_t &damageSecondary, TextColor_t &colorPrimary, TextColor_t &colorSecondary) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::creatureOnDrainHealth - "
		                 "Creature {} attacker {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 creature->getName(), attacker->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::creatureOnCombat(std::shared_ptr<Creature> attacker, std::shared_ptr<Creature> target, CombatDamage &damage) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[{} - "
		                 "Creature {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 __FUNCTION__, attacker->getName(), target->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, attacker);
	LuaScriptInterface::setCreatureMetatable(L, -1, attacker);

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	LuaScriptInterface::pushCombatDamage(L, damage);

	if (getScriptInterface()->protectedCall(L, 7, 4) != 0) {
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
		if (damage.origin == ORIGIN_SPELL && attacker) {
			const auto &player = attacker->getPlayer();
			if (player && player->getVocationId() != 4 && player->getVocationId() != 8) {
				damage.primary.value = damage.primary.value + damage.secondary.value;
				damage.secondary.type = COMBAT_NONE;
				damage.secondary.value = 0;
			}
		}
	}

	getScriptInterface()->resetScriptEnv();
}

// Party
bool EventCallback::partyOnJoin(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnJoin - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::partyOnLeave(const std::shared_ptr<Party> &party, const std::shared_ptr<Player> &player) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnLeave - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::partyOnDisband(const std::shared_ptr<Party> &party) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::partyOnDisband - Party leader {}] Call stack "
		                 "overflow. Too many lua script calls being nested.",
		                 party->getLeader() ? party->getLeader()->getName() : "unknown");
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	return getScriptInterface()->callFunction(1);
}

void EventCallback::partyOnShareExperience(const std::shared_ptr<Party> &party, uint64_t &exp) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("Party leader {}. Call stack overflow. Too many lua script calls being nested.", party->getLeader() ? party->getLeader()->getName() : "unknown");
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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
bool EventCallback::playerOnBrowseField(const std::shared_ptr<Player> &player, const Position &position) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnBrowseField - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	return getScriptInterface()->callFunction(2);
}

void EventCallback::playerOnLook(const std::shared_ptr<Player> &player, const Position &position, const std::shared_ptr<Thing> &thing, uint8_t stackpos, int32_t lookDistance) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLook - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (const auto &creature = thing->getCreature()) {
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

	getScriptInterface()->callVoidFunction(4);
}

void EventCallback::playerOnLookInBattleList(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, int32_t lookDistance) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInBattleList - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnLookInTrade(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &partner, const std::shared_ptr<Item> &item, int32_t lookDistance) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInTrade - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

bool EventCallback::playerOnLookInShop(const std::shared_ptr<Player> &player, const ItemType* itemType, uint8_t count) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLookInShop - "
		                 "Player {} itemType {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), itemType->getPluralName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnRemoveCount(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnMove - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	getScriptInterface()->callFunction(2);
}

bool EventCallback::playerOnMoveItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPos, const Position &toPos, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) const {
	if (!getScriptInterface()) {
		g_logger().error("script interface nullptr");
		return false;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[Action::executeUse - Player {}, on item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnItemMoved(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, uint16_t count, const Position &fromPosition, const Position &toPosition, const std::shared_ptr<Cylinder> &fromCylinder, const std::shared_ptr<Cylinder> &toCylinder) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnItemMoved - "
		                 "Player {} item {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), item->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnChangeZone(const std::shared_ptr<Player> &player, ZoneType_t zone) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnChangeZone - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, zone);
	getScriptInterface()->callVoidFunction(2);
}

bool EventCallback::playerOnMoveCreature(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &creature, const Position &fromPosition, const Position &toPosition) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnMoveCreature - "
		                 "Player {} creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnReportRuleViolation(const std::shared_ptr<Player> &player, const std::string &targetName, uint8_t reportType, uint8_t reportReason, const std::string &comment, const std::string &translation) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnReportRuleViolation - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnReportBug(const std::shared_ptr<Player> &player, const std::string &message, const Position &position, uint8_t category) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnReportBug - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

bool EventCallback::playerOnTurn(const std::shared_ptr<Player> &player, Direction direction) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTurn - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, direction);

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::playerOnTradeRequest(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTradeRequest - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

bool EventCallback::playerOnTradeAccept(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target, const std::shared_ptr<Item> &item, const std::shared_ptr<Item> &targetItem) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnTradeAccept - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnGainExperience(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, uint64_t &exp, uint64_t rawExp) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnGainExperience - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

	if (LuaScriptInterface::protectedCall(L, 4, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	LuaScriptInterface::resetScriptEnv();
}

void EventCallback::playerOnLoseExperience(const std::shared_ptr<Player> &player, uint64_t &exp) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnLoseExperience - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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

void EventCallback::playerOnGainSkillTries(const std::shared_ptr<Player> &player, skills_t skill, uint64_t &tries) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnGainSkillTries - "
		                 "Player {} skill {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), fmt::underlying(skill));
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

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

void EventCallback::playerOnCombat(const std::shared_ptr<Player> &player, const std::shared_ptr<Creature> &target, const std::shared_ptr<Item> &item, CombatDamage &damage) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnCombat - "
		                 "Player {} target {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), target->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

	LuaScriptInterface::resetScriptEnv();
}

void EventCallback::playerOnRequestQuestLog(const std::shared_ptr<Player> &player) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnRequestQuestLog - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	getScriptInterface()->callVoidFunction(1);
}

void EventCallback::playerOnRequestQuestLine(const std::shared_ptr<Player> &player, uint16_t questId) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::playerOnRequestQuestLine - "
		                 "Player {} questId {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), questId);
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, questId);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::playerOnInventoryUpdate(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, Slots_t slot, bool equip) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[{}] Call stack overflow", __FUNCTION__);
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

bool EventCallback::playerOnRotateItem(const std::shared_ptr<Player> &player, const std::shared_ptr<Item> &item, const Position &position) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[{}] Call stack overflow", __FUNCTION__);
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnWalk(const std::shared_ptr<Player> &player, const Direction &dir) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::eventOnWalk - "
		                 "Player {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, dir);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::playerOnStorageUpdate(const std::shared_ptr<Player> &player, const uint32_t key, const int32_t value, int32_t oldValue, uint64_t currentTime) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::eventOnStorageUpdate - "
		                 "Player {} key {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 player->getName(), key);
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
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

void EventCallback::playerOnThink(std::shared_ptr<Player> player, uint32_t interval) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[{}] player {}. Call stack overflow. Too many lua script calls being nested.", __FUNCTION__, player->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, interval);

	getScriptInterface()->callVoidFunction(2);
}

// Monster
void EventCallback::monsterOnDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::monsterOnDropLoot - "
		                 "Monster corpse {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 corpse->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return getScriptInterface()->callVoidFunction(2);
}

void EventCallback::monsterPostDropLoot(const std::shared_ptr<Monster> &monster, const std::shared_ptr<Container> &corpse) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::monsterPostDropLoot - "
		                 "Monster corpse {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 corpse->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Monster>(L, monster);
	LuaScriptInterface::setMetatable(L, -1, "Monster");

	LuaScriptInterface::pushUserdata<Container>(L, corpse);
	LuaScriptInterface::setMetatable(L, -1, "Container");

	return getScriptInterface()->callVoidFunction(2);
}

bool EventCallback::zoneBeforeCreatureEnter(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneBeforeCreatureEnter - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	return getScriptInterface()->callFunction(2);
}

bool EventCallback::zoneBeforeCreatureLeave(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneBeforeCreatureLeave - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return false;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	return getScriptInterface()->callFunction(2);
}

void EventCallback::zoneAfterCreatureEnter(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneAfterCreatureEnter - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::zoneAfterCreatureLeave(const std::shared_ptr<Zone> &zone, const std::shared_ptr<Creature> &creature) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[EventCallback::zoneAfterCreatureLeave - "
		                 "Zone {} Creature {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 zone->getName(), creature->getName());
		return;
	}

	ScriptEnvironment* scriptEnvironment = LuaScriptInterface::getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Zone>(L, zone);
	LuaScriptInterface::setMetatable(L, -1, "Zone");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	getScriptInterface()->callVoidFunction(2);
}

void EventCallback::mapOnLoad(const std::string &mapFullPath) const {
	if (!getScriptInterface()->reserveScriptEnv()) {
		g_logger().error("[{} - "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 __FUNCTION__);
		return;
	}

	ScriptEnvironment* scriptEnvironment = getScriptInterface()->getScriptEnv();
	scriptEnvironment->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushString(L, mapFullPath);

	getScriptInterface()->callVoidFunction(1);
}
