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

#ifndef SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_
#define SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_

#include "creatures/combat/combat.h"
#include "declarations.hpp"
#include "lua/scripts/luascript.h"

class AreaCombat;
class Combat;
class Cylinder;
class Game;
class GlobalFunctions;

class LuaEnvironment: public LuaScriptInterface {
	public:
		LuaEnvironment();
		~LuaEnvironment();

		// non-copyable
		LuaEnvironment(const LuaEnvironment &) = delete;
		LuaEnvironment & operator = (const LuaEnvironment &) = delete;

		bool initState() override;
		bool reInitState();
		bool closeState() override;

		LuaScriptInterface * getTestInterface();

		Combat * getCombatObject(uint32_t id) const;
		Combat * createCombatObject(LuaScriptInterface * interface);
		void clearCombatObjects(LuaScriptInterface * interface);

		AreaCombat * getAreaObject(uint32_t id) const;
		uint32_t createAreaObject(LuaScriptInterface * interface);
		void clearAreaObjects(LuaScriptInterface * interface);

	private:
		void executeTimerEvent(uint32_t eventIndex);

		phmap::flat_hash_map < uint32_t,
		LuaTimerEventDesc > timerEvents;
		phmap::flat_hash_map < uint32_t,
		Combat * > combatMap;
		phmap::flat_hash_map < uint32_t,
		AreaCombat * > areaMap;

		phmap::flat_hash_map < LuaScriptInterface * ,
		std::vector < uint32_t >> combatIdMap;
		phmap::flat_hash_map < LuaScriptInterface * ,
		std::vector < uint32_t >> areaIdMap;

		LuaScriptInterface * testInterface = nullptr;

		uint32_t lastEventTimerId = 1;
		uint32_t lastCombatId = 0;
		uint32_t lastAreaId = 0;

		friend class LuaScriptInterface;
				friend class GlobalFunctions;
		friend class CombatSpell;
};

inline LuaEnvironment g_luaEnvironment;

#endif  // SRC_LUA_SCRIPTS_LUA_ENVIRONMENT_HPP_
