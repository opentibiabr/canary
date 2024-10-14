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

void Modules::clear(bool) {
	// clear recvbyte list
	for (auto &it : recvbyteList) {
		it.second.clearEvent();
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
	return Event_ptr(new Module(&scriptInterface));
}

bool Modules::registerEvent(Event_ptr event, const pugi::xml_node &) {
	Module_ptr module { static_cast<Module*>(event.release()) };
	if (module->getEventType() == MODULE_TYPE_NONE) {
		g_logger().error("Trying to register event without type!");
		return false;
	}

	Module* oldModule = getEventByRecvbyte(module->getRecvbyte(), false);
	if (oldModule) {
		if (!oldModule->isLoaded() && oldModule->getEventType() == module->getEventType()) {
			oldModule->copyEvent(module.get());
		}
		return false;
	} else {
		auto it = recvbyteList.find(module->getRecvbyte());
		if (it != recvbyteList.end()) {
			it->second = *module;
		} else {
			recvbyteList.emplace(module->getRecvbyte(), std::move(*module));
		}
		return true;
	}
}

Module* Modules::getEventByRecvbyte(uint8_t recvbyte, bool force) {
	ModulesList::iterator it = recvbyteList.find(recvbyte);
	if (it != recvbyteList.end()) {
		if (!force || it->second.isLoaded()) {
			return &it->second;
		}
	}
	return nullptr;
}

void Modules::executeOnRecvbyte(uint32_t playerId, NetworkMessage &msg, uint8_t byte) const {
	std::shared_ptr<Player> player = g_game().getPlayerByID(playerId);
	if (!player) {
		return;
	}

	for (auto &it : recvbyteList) {
		Module module = it.second;
		if (module.getEventType() == MODULE_TYPE_RECVBYTE && module.getRecvbyte() == byte && player->canRunModule(module.getRecvbyte())) {
			player->setModuleDelay(module.getRecvbyte(), module.getDelay());
			module.executeOnRecvbyte(player, msg);
			return;
		}
	}
}

Module::Module(LuaScriptInterface* interface) :
	Event(interface), type(MODULE_TYPE_NONE), loaded(false) { }

bool Module::configureEvent(const pugi::xml_node &node) {
	delay = 0;

	pugi::xml_attribute typeAttribute = node.attribute("type");
	if (!typeAttribute) {
		g_logger().error("Missing type for module.");
		return false;
	}

	std::string tmpStr = asLowerCaseString(typeAttribute.as_string());
	if (tmpStr == "recvbyte") {
		pugi::xml_attribute byteAttribute = node.attribute("byte");
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

	pugi::xml_attribute delayAttribute = node.attribute("delay");
	if (delayAttribute) {
		delay = static_cast<uint16_t>(delayAttribute.as_uint());
	}

	loaded = true;
	return true;
}

std::string Module::getScriptEventName() const {
	switch (type) {
		case MODULE_TYPE_RECVBYTE:
			return "onRecvbyte";
		default:
			return std::string();
	}
}

void Module::copyEvent(Module* module) {
	scriptId = module->scriptId;
	scriptInterface = module->scriptInterface;
	scripted = module->scripted;
	loaded = module->loaded;
}

void Module::clearEvent() {
	scriptId = 0;
	scriptInterface = nullptr;
	scripted = false;
	loaded = false;
}

void Module::executeOnRecvbyte(std::shared_ptr<Player> player, NetworkMessage &msg) {
	// onRecvbyte(player, msg, recvbyte)
	if (!scriptInterface->reserveScriptEnv()) {
		g_logger().error("Call stack overflow. Too many lua script calls being nested {}", player->getName());
		return;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
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
