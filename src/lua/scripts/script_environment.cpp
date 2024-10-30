/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/scripts/script_environment.hpp"

#include "creatures/creature.hpp"
#include "game/game.hpp"
#include "lua/scripts/luascript.hpp"

ScriptEnvironment::ScriptEnvironment() {
	resetEnv();
}

ScriptEnvironment::~ScriptEnvironment() {
	resetEnv();
}

void ScriptEnvironment::resetEnv() {
	scriptId = 0;
	callbackId = 0;
	timerEvent = false;
	interface = nullptr;
	localMap.clear();
	tempResults.clear();

	const auto [fst, snd] = tempItems.equal_range(this);
	auto it = fst;
	while (it != snd) {
		const auto item = it->second;
		it = tempItems.erase(it);
	}
}

bool ScriptEnvironment::setCallbackId(int32_t newCallbackId, LuaScriptInterface* scriptInterface) {
	if (this->callbackId != 0) {
		// nested callbacks are not allowed
		if (interface) {
			LuaScriptInterface::reportErrorFunc("Nested callbacks!");
		}
		return false;
	}

	this->callbackId = newCallbackId;
	interface = scriptInterface;
	return true;
}

void ScriptEnvironment::getEventInfo(int32_t &retScriptId, LuaScriptInterface*&retScriptInterface, int32_t &retCallbackId, bool &retTimerEvent) const {
	retScriptId = this->scriptId;
	retScriptInterface = interface;
	retCallbackId = this->callbackId;
	retTimerEvent = this->timerEvent;
}

uint32_t ScriptEnvironment::addThing(const std::shared_ptr<Thing> &thing) {
	if (!thing || thing->isRemoved()) {
		return 0;
	}

	const auto &creature = thing->getCreature();
	if (creature) {
		return creature->getID();
	}

	const auto &item = thing->getItem();
	if (item && item->hasAttribute(ItemAttribute_t::UNIQUEID)) {
		return item->getAttribute<uint32_t>(ItemAttribute_t::UNIQUEID);
	}

	for (const auto &[itemId, itemPtr] : localMap) {
		if (itemPtr == item) {
			return itemId;
		}
	}

	localMap[++lastUID] = item;
	return lastUID;
}

void ScriptEnvironment::insertItem(uint32_t uid, std::shared_ptr<Item> item) {
	const auto [fst, snd] = localMap.emplace(uid, item);
	if (!snd) {
		g_logger().error("Thing uid already taken: {}", uid);
	}
}

std::shared_ptr<Thing> ScriptEnvironment::getThingByUID(uint32_t uid) {
	if (uid >= 0x10000000) {
		return g_game().getCreatureByID(uid);
	}

	if (uid <= std::numeric_limits<uint16_t>::max()) {
		const auto &item = g_game().getUniqueItem(static_cast<uint16_t>(uid));
		if (item && !item->isRemoved()) {
			return item;
		}
		return nullptr;
	}

	const auto it = localMap.find(uid);
	if (it != localMap.end()) {
		const auto &item = it->second;
		if (!item->isRemoved()) {
			return item;
		}
	}
	return nullptr;
}

std::shared_ptr<Item> ScriptEnvironment::getItemByUID(uint32_t uid) {
	const auto &thing = getThingByUID(uid);
	if (!thing) {
		return nullptr;
	}
	return thing->getItem();
}

std::shared_ptr<Container> ScriptEnvironment::getContainerByUID(uint32_t uid) {
	const auto &item = getItemByUID(uid);
	if (!item) {
		return nullptr;
	}
	return item->getContainer();
}

void ScriptEnvironment::removeItemByUID(uint32_t uid) {
	if (uid <= std::numeric_limits<uint16_t>::max()) {
		g_game().removeUniqueItem(static_cast<uint16_t>(uid));
		return;
	}

	const auto it = localMap.find(uid);
	if (it != localMap.end()) {
		localMap.erase(it);
	}
}

void ScriptEnvironment::addTempItem(const std::shared_ptr<Item> &item) {
	tempItems.emplace(this, item);
}

void ScriptEnvironment::removeTempItem(const std::shared_ptr<Item> &item) {
	for (auto it = tempItems.begin(), end = tempItems.end(); it != end; ++it) {
		if (it->second == item) {
			tempItems.erase(it);
			break;
		}
	}
}

uint32_t ScriptEnvironment::addResult(DBResult_ptr res) {
	tempResults[++lastResultId] = std::move(res);
	return lastResultId;
}

bool ScriptEnvironment::removeResult(uint32_t id) {
	const auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return false;
	}

	tempResults.erase(it);
	return true;
}

DBResult_ptr ScriptEnvironment::getResultByID(uint32_t id) {
	const auto it = tempResults.find(id);
	if (it == tempResults.end()) {
		return nullptr;
	}
	return it->second;
}
