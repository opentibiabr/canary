/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/di/container.hpp"
#include "lua/global/baseevents.hpp"
#include "lua/scripts/luascript.hpp"
#include "server/network/message/networkmessage.hpp"

class Module;
using Module_ptr = std::shared_ptr<Module>;

class Module final : public Event {
public:
	explicit Module(LuaScriptInterface* interface);

	bool configureEvent(const pugi::xml_node &node) override;

	ModuleType_t getEventType() const {
		return type;
	}
	bool isLoaded() const {
		return loaded;
	}

	void clearEvent();
	void copyEvent(const Module_ptr &creatureEvent);

	// scripting
	void executeOnRecvbyte(const std::shared_ptr<Player> &player, NetworkMessage &msg) const;
	//

	uint8_t getRecvbyte() const {
		return recvbyte;
	}

	int16_t getDelay() const {
		return delay;
	}

protected:
	std::string getScriptEventName() const override;

	ModuleType_t type;
	uint8_t recvbyte {};
	int16_t delay {};
	bool loaded;
};

class Modules final : public BaseEvents {
public:
	Modules();

	// non-copyable
	Modules(const Modules &) = delete;
	Modules &operator=(const Modules &) = delete;

	static Modules &getInstance() {
		return inject<Modules>();
	}

	void executeOnRecvbyte(uint32_t playerId, NetworkMessage &msg, uint8_t byte) const;
	Module_ptr getEventByRecvbyte(uint8_t recvbyte, bool force);

protected:
	LuaScriptInterface &getScriptInterface() override;
	std::string getScriptBaseName() const override;
	Event_ptr getEvent(const std::string &nodeName) override;
	bool registerEvent(const Event_ptr &event, const pugi::xml_node &node) override;
	void clear() override;

	using ModulesList = std::map<uint8_t, Module_ptr>;
	ModulesList recvbyteList;

	LuaScriptInterface scriptInterface;
};

constexpr auto g_modules = Modules::getInstance;
