/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#ifndef SRC_LUA_CALLBACKS_CREATURECALLBACK_H_
#define SRC_LUA_CALLBACKS_CREATURECALLBACK_H_

#include "pch.hpp"
#include "creatures/creature.h"

class Creature;

class CreatureCallback {
	public:
		CreatureCallback(LuaScriptInterface* scriptInterface, Creature* targetCreature)
			: scriptInterface(scriptInterface), targetCreature(targetCreature) {};
		~CreatureCallback() {}

		bool startScriptInterface(int32_t scriptId);

		void pushSpecificCreature(Creature *creature);

		bool persistLuaState() {
			return params > 0 && scriptInterface->callFunction(params);
		}

		void pushCreature(Creature *creature) {
			params++;
			LuaScriptInterface::pushUserdata<Creature>(L, creature);
			LuaScriptInterface::setCreatureMetatable(L, -1, creature);
		}

		void pushPosition(const Position &position, int32_t stackpos = 0) {
			params++;
			LuaScriptInterface::pushPosition(L, position, stackpos);
		}

		void pushNumber(int32_t number) {
			params++;
			lua_pushnumber(L, number);
		}

		void pushString(const std::string& str) {
			params++;
			LuaScriptInterface::pushString(L, str);
		}

		void pushBoolean(const bool str) {
			params++;
			LuaScriptInterface::pushBoolean(L, str);
		}

	protected:
		static std::string getCreatureClass(Creature *creature);

	private:
		LuaScriptInterface* scriptInterface;
		Creature* targetCreature;
		uint32_t params = 0;
		lua_State* L;
};

#endif  // SRC_LUA_CALLBACKS_CREATURECALLBACK_H_
