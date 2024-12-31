/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/callbacks/creaturecallback.hpp"

#include "creatures/creature.hpp"
#include "lua/scripts/luascript.hpp"

bool CreatureCallback::startScriptInterface(int32_t scriptId) {
	if (scriptId == -1) {
		return false;
	}

	if (!LuaScriptInterface::reserveScriptEnv()) {
		const auto targetCreature = m_targetCreature.lock();
		g_logger().error(
			"[CreatureCallback::startScriptInterface] - {} {} Call stack overflow. Too many lua script calls being nested.",
			getCreatureClass(targetCreature),
			targetCreature->getName()
		);
		return false;
	}

	LuaScriptInterface::getScriptEnv()
		->setScriptId(scriptId, scriptInterface);

	L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);

	return true;
}

void CreatureCallback::pushSpecificCreature(const std::shared_ptr<Creature> &creature) {
	if (const auto &npc = creature->getNpc()) {
		LuaScriptInterface::pushUserdata<Npc>(L, npc);
	} else if (const auto &monster = creature->getMonster()) {
		LuaScriptInterface::pushUserdata<Monster>(L, monster);
	} else if (const auto &player = creature->getPlayer()) {
		LuaScriptInterface::pushUserdata<Player>(L, player);
	} else {
		return;
	}

	params++;
	LuaScriptInterface::setMetatable(L, -1, getCreatureClass(creature));
}

bool CreatureCallback::persistLuaState() const {
	return params > 0 && scriptInterface->callFunction(params);
}

void CreatureCallback::pushCreature(const std::shared_ptr<Creature> &creature) {
	params++;
	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);
}

void CreatureCallback::pushPosition(const Position &position, int32_t stackpos) {
	params++;
	LuaScriptInterface::pushPosition(L, position, stackpos);
}

void CreatureCallback::pushNumber(int32_t number) {
	params++;
	lua_pushnumber(L, number);
}

void CreatureCallback::pushString(const std::string &str) {
	params++;
	LuaScriptInterface::pushString(L, str);
}

void CreatureCallback::pushBoolean(const bool str) {
	params++;
	LuaScriptInterface::pushBoolean(L, str);
}

std::string CreatureCallback::getCreatureClass(const std::shared_ptr<Creature> &creature) {
	if (!creature) {
		return "";
	}
	if (creature->getNpc()) {
		return "Npc";
	}
	if (creature->getMonster()) {
		return "Monster";
	}
	if (creature->getPlayer()) {
		return "Player";
	}

	return "";
}
