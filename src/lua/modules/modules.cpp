/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/modules/modules.hpp"

#include "creatures/players/player.hpp"
#include "game/game.hpp"

Modules::Modules() :
	scriptInterface("Modules Interface") {
	scriptInterface.initState();
}

void Modules::clear() {
	// clear recvbyte list
	for (const auto &[moduleId, modulePtr] : recvbyteList) {
		if (moduleId == 0) {
			g_logger().error("Invalid module id 0.");
			continue;
		}

		modulePtr->clearEvent();
	}

	// clear lua state
	scriptInterface.reInitState();
}

LuaScriptInterface &Modules::getScriptInterface() {
	return scriptInterface;
}

std::string Modules::getScriptBaseName() const {
	return "modules";
}

Event_ptr Modules::getEvent(const std::string &nodeName) {
	if (strcasecmp(nodeName.c_str(), "module") != 0) {
		return nullptr;
	}
	return std::make_unique<Module>(&scriptInterface);
}

bool Modules::registerEvent(const Event_ptr &event, const pugi::xml_node &) {
	const auto &modulePtr = std::dynamic_pointer_cast<Module>(event);
	if (modulePtr->getEventType() == MODULE_TYPE_NONE) {
		g_logger().error("Trying to register event without type!");
		return false;
	}

	const auto oldModule = getEventByRecvbyte(modulePtr->getRecvbyte(), false);
	if (oldModule) {
		if (!oldModule->isLoaded() && oldModule->getEventType() == modulePtr->getEventType()) {
			oldModule->copyEvent(modulePtr);
			return true;
		}
		return false;
	}

	const auto it = recvbyteList.find(modulePtr->getRecvbyte());
	if (it != recvbyteList.end()) {
		it->second = modulePtr;
	} else {
		recvbyteList.try_emplace(modulePtr->getRecvbyte(), modulePtr);
	}
	return true;
}

Module_ptr Modules::getEventByRecvbyte(uint8_t recvbyte, bool force) {
	const auto it = recvbyteList.find(recvbyte);
	if (it != recvbyteList.end() && (!force || it->second->isLoaded())) {
		return it->second;
	}
	return nullptr;
}

void Modules::executeOnRecvbyte(uint32_t playerId, NetworkMessage &msg, uint8_t byte) const {
	const auto &player = g_game().getPlayerByID(playerId);
	if (!player) {
		return;
	}

	for (const auto &[moduleId, modulePtr] : recvbyteList) {
		if (moduleId == 0) {
			g_logger().error("Invalid module id 0.");
			continue;
		}
		if (modulePtr->getEventType() == MODULE_TYPE_RECVBYTE && modulePtr->getRecvbyte() == byte && player->canRunModule(modulePtr->getRecvbyte())) {
			player->setModuleDelay(modulePtr->getRecvbyte(), modulePtr->getDelay());
			modulePtr->executeOnRecvbyte(player, msg);
			return;
		}
	}
}

Module::Module(LuaScriptInterface* interface) :
	Event(interface), type(MODULE_TYPE_NONE), loaded(false) { }

bool Module::configureEvent(const pugi::xml_node &node) {
	delay = 0;

	const auto typeAttribute = node.attribute("type");
	if (!typeAttribute) {
		g_logger().error("Missing type for module.");
		return false;
	}

	const auto tmpStr = asLowerCaseString(typeAttribute.as_string());
	if (tmpStr == "recvbyte") {
		const auto byteAttribute = node.attribute("byte");
		if (!byteAttribute) {
			g_logger().error("Missing byte for module typed recvbyte.");
			return false;
		}

		recvbyte = static_cast<uint8_t>(byteAttribute.as_int());
		type = MODULE_TYPE_RECVBYTE;
	} else {
		g_logger().error("Invalid type for module.");
		return false;
	}

	const auto delayAttribute = node.attribute("delay");
	if (delayAttribute) {
		delay = static_cast<int16_t>(delayAttribute.as_uint());
	}

	loaded = true;
	return true;
}

std::string Module::getScriptEventName() const {
	switch (type) {
		case MODULE_TYPE_RECVBYTE:
			return "onRecvbyte";
		default:
			return {};
	}
}

void Module::copyEvent(const Module_ptr &modulePtr) {
	scriptId = modulePtr->scriptId;
	scriptInterface = modulePtr->scriptInterface;
	scripted = modulePtr->scripted;
	loaded = modulePtr->loaded;
}

void Module::clearEvent() {
	scriptId = 0;
	scriptInterface = nullptr;
	scripted = false;
	loaded = false;
}

void Module::executeOnRecvbyte(const std::shared_ptr<Player> &player, NetworkMessage &msg) const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("Call stack overflow. Too many lua script calls being nested {}", player->getName());
		return;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();

	scriptInterface->pushFunction(scriptId);
	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<NetworkMessage>(L, std::shared_ptr<NetworkMessage>(&msg));
	LuaScriptInterface::setWeakMetatable(L, -1, "NetworkMessage");

	lua_pushnumber(L, recvbyte);

	scriptInterface->callVoidFunction(3);
}
