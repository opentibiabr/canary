/**
 * @file modules.h
 *
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019 Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_LUA_MODULES_MODULES_H_
#define SRC_LUA_MODULES_MODULES_H_

#include "lua/global/baseevents.h"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"
#include "server/network/message/networkmessage.h"

class Module;
using Module_ptr = std::unique_ptr<Module>;

class Module final : public Event {
	public:
		explicit Module(LuaScriptInterface* interface);

		bool configureEvent(const pugi::xml_node& node) final;

		ModuleType_t getEventType() const {
			return type;
		}
		bool isLoaded() const {
			return loaded;
		}

		void clearEvent();
		void copyEvent(Module* creatureEvent);

		//scripting
		void executeOnRecvbyte(Player* player, NetworkMessage& msg);
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
		Modules(const Modules&) = delete;
		Modules& operator=(const Modules&) = delete;

		static Modules& getInstance() {
			// Guaranteed to be destroyed
			static Modules instance;
			// Instantiated on first use
			return instance;
		}

		void executeOnRecvbyte(uint32_t playerId, NetworkMessage& msg, uint8_t byte) const;
		Module* getEventByRecvbyte(uint8_t recvbyte, bool force);

	protected:
		LuaScriptInterface& getScriptInterface() override;
		std::string getScriptBaseName() const override;
		Event_ptr getEvent(const std::string& nodeName) override;
		bool registerEvent(Event_ptr  event, const pugi::xml_node& node) override;
		void clear(bool) override final;

		typedef std::map<uint8_t, Module> ModulesList;
		ModulesList recvbyteList;

		LuaScriptInterface scriptInterface;
};

constexpr auto g_modules = &Modules::getInstance;

#endif  // SRC_LUA_MODULES_MODULES_H_
