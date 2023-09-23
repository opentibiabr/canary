/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
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
using Module_ptr = std::unique_ptr<Module>;

class Module final : public Event {
public:
	explicit Module(LuaScriptInterface* interface);

	bool configureEvent(const pugi::xml_node &node) final;

	ModuleType_t getEventType() const {
		return type;
	}
	bool isLoaded() const {
		return loaded;
	}

	void clearEvent();
	void copyEvent(Module* creatureEvent);

	// scripting
	void executeOnRecvbyte(std::shared_ptr<Player> player, NetworkMessage &msg);
	//

	uint8_t getRecvbyte() {
		return recvbyte;
	}

	int16_t getDelay() {
		return delay;
	}

protected:
	std::string getScriptEventName() const final;

	ModuleType_t type;
	uint8_t recvbyte;
	int16_t delay;
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
	Module* getEventByRecvbyte(uint8_t recvbyte, bool force);

protected:
	LuaScriptInterface &getScriptInterface() override;
	std::string getScriptBaseName() const override;
	Event_ptr getEvent(const std::string &nodeName) override;
	bool registerEvent(Event_ptr event, const pugi::xml_node &node) override;
	void clear(bool) override final;

	typedef std::map<uint8_t, Module> ModulesList;
	ModulesList recvbyteList;

	LuaScriptInterface scriptInterface;
};

constexpr auto g_modules = Modules::getInstance;
