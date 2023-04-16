/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/creature/creatureevent.h"
#include "utils/tools.h"
#include "creatures/players/player.h"

void CreatureEvents::clear() {
	for (auto &[name, event] : creatureEvents) {
		event.clearEvent();
	}
}

bool CreatureEvents::registerLuaEvent(CreatureEvent* event) {
	CreatureEvent_ptr creatureEvent { event };
	if (creatureEvent->getEventType() == CREATURE_EVENT_NONE) {
		SPDLOG_ERROR(
			"[{}] - Trying to register event without type for script: {}",
			__FUNCTION__,
			event->getScriptInterface()->getLoadingScriptName()
		);
		return false;
	}

	CreatureEvent* oldEvent = getEventByName(creatureEvent->getName(), false);
	if (oldEvent) {
		// if there was an event with the same that is not loaded
		//(happens when realoading), it is reused
		if (!oldEvent->isLoaded() && oldEvent->getEventType() == creatureEvent->getEventType()) {
			oldEvent->copyEvent(creatureEvent.get());
		}

		return false;
	} else {
		// if not, register it normally
		creatureEvents.emplace(creatureEvent->getName(), std::move(*creatureEvent));
		return true;
	}
}

CreatureEvent* CreatureEvents::getEventByName(const std::string &name, bool forceLoaded /*= true*/) {
	auto it = creatureEvents.find(name);
	if (it != creatureEvents.end()) {
		if (!forceLoaded || it->second.isLoaded()) {
			return &it->second;
		}
	}
	return nullptr;
}

bool CreatureEvents::playerLogin(Player* player) const {
	// fire global event if is registered
	for (const auto &it : creatureEvents) {
		if (it.second.getEventType() == CREATURE_EVENT_LOGIN) {
			if (!it.second.executeOnLogin(player)) {
				return false;
			}
		}
	}
	return true;
}

bool CreatureEvents::playerLogout(Player* player) const {
	// fire global event if is registered
	for (const auto &it : creatureEvents) {
		if (it.second.getEventType() == CREATURE_EVENT_LOGOUT) {
			if (!it.second.executeOnLogout(player)) {
				return false;
			}
		}
	}
	return true;
}

bool CreatureEvents::playerAdvance(
	Player* player,
	skills_t skill,
	uint32_t oldLevel,
	uint32_t newLevel
) const {
	for ([[maybe_unused]] const auto &[eventName, eventPtr] : creatureEvents) {
		if (eventPtr.getEventType() == CREATURE_EVENT_ADVANCE) {
			if (!eventPtr.executeAdvance(player, skill, oldLevel, newLevel)) {
				return false;
			}
		}
	}
	return true;
}

/*
 =======================
 CreatureEvent interface
 =======================
*/

CreatureEvent::CreatureEvent(LuaScriptInterface* interface) :
	Script(interface) { }

void CreatureEvents::removeInvalidEvents() {
	for (auto it = creatureEvents.begin(); it != creatureEvents.end(); ++it) {
		if (it->second.getScriptId() == 0) {
			creatureEvents.erase(it->second.getName());
		}
	}
}

std::string CreatureEvent::getScriptTypeName() const {
	// Depending on the type script event name is different
	switch (type) {
		case CREATURE_EVENT_LOGIN:
			return "onLogin";

		case CREATURE_EVENT_LOGOUT:
			return "onLogout";

		case CREATURE_EVENT_THINK:
			return "onThink";

		case CREATURE_EVENT_PREPAREDEATH:
			return "onPrepareDeath";

		case CREATURE_EVENT_DEATH:
			return "onDeath";

		case CREATURE_EVENT_KILL:
			return "onKill";

		case CREATURE_EVENT_ADVANCE:
			return "onAdvance";

		case CREATURE_EVENT_MODALWINDOW:
			return "onModalWindow";

		case CREATURE_EVENT_TEXTEDIT:
			return "onTextEdit";

		case CREATURE_EVENT_HEALTHCHANGE:
			return "onHealthChange";

		case CREATURE_EVENT_MANACHANGE:
			return "onManaChange";

		case CREATURE_EVENT_EXTENDED_OPCODE:
			return "onExtendedOpcode";

		case CREATURE_EVENT_NONE:
		default:
			return std::string();
	}
}

void CreatureEvent::copyEvent(const CreatureEvent* creatureEvent) {
	setScriptId(creatureEvent->getScriptId());
	setScriptInterface(creatureEvent->getScriptInterface());
	setLoadedCallback(creatureEvent->isLoadedCallback());
	loaded = creatureEvent->loaded;
}

void CreatureEvent::clearEvent() {
	setScriptId(0);
	setScriptInterface(nullptr);
	setLoadedCallback(false);
	loaded = false;
}

bool CreatureEvent::executeOnLogin(Player* player) const {
	// onLogin(player)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnLogin - Player {} event {}]"
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	return getScriptInterface()->callFunction(1);
}

bool CreatureEvent::executeOnLogout(Player* player) const {
	// onLogout(player)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnLogout - Player {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	return getScriptInterface()->callFunction(1);
}

bool CreatureEvent::executeOnThink(Creature* creature, uint32_t interval) const {
	// onThink(creature, interval)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnThink - Creature {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	lua_pushnumber(L, interval);

	return getScriptInterface()->callFunction(2);
}

bool CreatureEvent::executeOnPrepareDeath(Creature* creature, Creature* killer) const {
	// onPrepareDeath(creature, killer)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnPrepareDeath - Creature {} killer {}"
					 " event {}] Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), killer->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	if (killer) {
		LuaScriptInterface::pushUserdata<Creature>(L, killer);
		LuaScriptInterface::setCreatureMetatable(L, -1, killer);
	} else {
		lua_pushnil(L);
	}

	return getScriptInterface()->callFunction(2);
}

bool CreatureEvent::executeOnDeath(Creature* creature, Item* corpse, Creature* killer, Creature* mostDamageKiller, bool lastHitUnjustified, bool mostDamageUnjustified) const {
	// onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnDeath - Creature {} killer {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), killer->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushThing(L, corpse);

	if (killer) {
		LuaScriptInterface::pushUserdata<Creature>(L, killer);
		LuaScriptInterface::setCreatureMetatable(L, -1, killer);
	} else {
		lua_pushnil(L);
	}

	if (mostDamageKiller) {
		LuaScriptInterface::pushUserdata<Creature>(L, mostDamageKiller);
		LuaScriptInterface::setCreatureMetatable(L, -1, mostDamageKiller);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushBoolean(L, lastHitUnjustified);
	LuaScriptInterface::pushBoolean(L, mostDamageUnjustified);

	return getScriptInterface()->callFunction(6);
}

bool CreatureEvent::executeAdvance(Player* player, skills_t skill, uint32_t oldLevel, uint32_t newLevel) const {
	// onAdvance(player, skill, oldLevel, newLevel)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeAdvance - Player {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");
	lua_pushnumber(L, static_cast<uint32_t>(skill));
	lua_pushnumber(L, oldLevel);
	lua_pushnumber(L, newLevel);

	return getScriptInterface()->callFunction(4);
}

void CreatureEvent::executeOnKill(Creature* creature, Creature* target, bool lastHit) const {
	// onKill(creature, target, lastHit)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeOnKill - Creature {} target {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), target->getName(), getName());
		return;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());
	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);
	LuaScriptInterface::pushBoolean(L, lastHit);
	getScriptInterface()->callVoidFunction(3);
}

void CreatureEvent::executeModalWindow(Player* player, uint32_t modalWindowId, uint8_t buttonId, uint8_t choiceId) const {
	// onModalWindow(player, modalWindowId, buttonId, choiceId)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeModalWindow - "
					 "Player {} modaw window id {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), modalWindowId, getName());
		return;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, modalWindowId);
	lua_pushnumber(L, buttonId);
	lua_pushnumber(L, choiceId);

	getScriptInterface()->callVoidFunction(4);
}

bool CreatureEvent::executeTextEdit(Player* player, Item* item, const std::string &text) const {
	// onTextEdit(player, item, text)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeTextEdit - Player {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getName());
		return false;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushThing(L, item);
	LuaScriptInterface::pushString(L, text);

	return getScriptInterface()->callFunction(3);
}

void CreatureEvent::executeHealthChange(Creature* creature, Creature* attacker, CombatDamage &damage) const {
	// onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeHealthChange - "
					 "Creature {} attacker {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), attacker->getName(), getName());
		return;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	if (attacker) {
		LuaScriptInterface::pushUserdata(L, attacker);
		LuaScriptInterface::setCreatureMetatable(L, -1, attacker);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushCombatDamage(L, damage);

	if (getScriptInterface()->protectedCall(L, 7, 4) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		damage.primary.value = std::abs(LuaScriptInterface::getNumber<int64_t>(L, -4));
		damage.primary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -3);
		damage.secondary.value = std::abs(LuaScriptInterface::getNumber<int64_t>(L, -2));
		damage.secondary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -1);

		lua_pop(L, 4);
		if (damage.primary.type != COMBAT_HEALING) {
			damage.primary.value = -damage.primary.value;
			damage.secondary.value = -damage.secondary.value;
		}
	}

	getScriptInterface()->resetScriptEnv();
}

void CreatureEvent::executeManaChange(Creature* creature, Creature* attacker, CombatDamage &damage) const {
	// onManaChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeManaChange - "
					 "Creature {} attacker {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 creature->getName(), attacker->getName(), getName());
		return;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	if (attacker) {
		LuaScriptInterface::pushUserdata(L, attacker);
		LuaScriptInterface::setCreatureMetatable(L, -1, attacker);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushCombatDamage(L, damage);

	if (getScriptInterface()->protectedCall(L, 7, 4) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	} else {
		damage.primary.value = LuaScriptInterface::getNumber<int64_t>(L, -4);
		damage.primary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -3);
		damage.secondary.value = LuaScriptInterface::getNumber<int64_t>(L, -2);
		damage.secondary.type = LuaScriptInterface::getNumber<CombatType_t>(L, -1);
		lua_pop(L, 4);
	}

	getScriptInterface()->resetScriptEnv();
}

void CreatureEvent::executeExtendedOpcode(Player* player, uint8_t opcode, const std::string &buffer) const {
	// onExtendedOpcode(player, opcode, buffer)
	if (!getScriptInterface()->reserveScriptEnv()) {
		SPDLOG_ERROR("[CreatureEvent::executeExtendedOpcode - "
					 "Player {} event {}] "
					 "Call stack overflow. Too many lua script calls being nested.",
					 player->getName(), getName());
		return;
	}

	ScriptEnvironment* env = getScriptInterface()->getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();

	getScriptInterface()->pushFunction(getScriptId());

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, opcode);
	LuaScriptInterface::pushString(L, buffer);

	getScriptInterface()->callVoidFunction(3);
}
