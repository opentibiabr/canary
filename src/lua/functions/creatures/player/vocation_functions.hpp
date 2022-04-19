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

#ifndef SRC_LUA_FUNCTIONS_CREATURES_PLAYER_VOCATION_FUNCTIONS_HPP_
#define SRC_LUA_FUNCTIONS_CREATURES_PLAYER_VOCATION_FUNCTIONS_HPP_

#include "lua/scripts/luascript.h"

class VocationFunctions final : LuaScriptInterface {
	public:
		static void init(lua_State* L) {
			registerClass(L, "Vocation", "", VocationFunctions::luaVocationCreate);
			registerMetaMethod(L, "Vocation", "__eq", VocationFunctions::luaUserdataCompare);

			registerMethod(L, "Vocation", "getId", VocationFunctions::luaVocationGetId);
			registerMethod(L, "Vocation", "getClientId", VocationFunctions::luaVocationGetClientId);
			registerMethod(L, "Vocation", "getBaseId", VocationFunctions::luaVocationGetBaseId);
			registerMethod(L, "Vocation", "getName", VocationFunctions::luaVocationGetName);
			registerMethod(L, "Vocation", "getDescription", VocationFunctions::luaVocationGetDescription);

			registerMethod(L, "Vocation", "getRequiredSkillTries", VocationFunctions::luaVocationGetRequiredSkillTries);
			registerMethod(L, "Vocation", "getRequiredManaSpent", VocationFunctions::luaVocationGetRequiredManaSpent);

			registerMethod(L, "Vocation", "getCapacityGain", VocationFunctions::luaVocationGetCapacityGain);

			registerMethod(L, "Vocation", "getHealthGain", VocationFunctions::luaVocationGetHealthGain);
			registerMethod(L, "Vocation", "getHealthGainTicks", VocationFunctions::luaVocationGetHealthGainTicks);
			registerMethod(L, "Vocation", "getHealthGainAmount", VocationFunctions::luaVocationGetHealthGainAmount);

			registerMethod(L, "Vocation", "getManaGain", VocationFunctions::luaVocationGetManaGain);
			registerMethod(L, "Vocation", "getManaGainTicks", VocationFunctions::luaVocationGetManaGainTicks);
			registerMethod(L, "Vocation", "getManaGainAmount", VocationFunctions::luaVocationGetManaGainAmount);

			registerMethod(L, "Vocation", "getMaxSoul", VocationFunctions::luaVocationGetMaxSoul);
			registerMethod(L, "Vocation", "getSoulGainTicks", VocationFunctions::luaVocationGetSoulGainTicks);

			registerMethod(L, "Vocation", "getBaseAttackSpeed", VocationFunctions::luaVocationGetBaseAttackSpeed);
			registerMethod(L, "Vocation", "getAttackSpeed", VocationFunctions::luaVocationGetAttackSpeed);
			registerMethod(L, "Vocation", "getBaseSpeed", VocationFunctions::luaVocationGetBaseSpeed);

			registerMethod(L, "Vocation", "getDemotion", VocationFunctions::luaVocationGetDemotion);
			registerMethod(L, "Vocation", "getPromotion", VocationFunctions::luaVocationGetPromotion);
		}

	private:
		static int luaVocationCreate(lua_State* L);

		static int luaVocationGetId(lua_State* L);
		static int luaVocationGetClientId(lua_State* L);
		static int luaVocationGetBaseId(lua_State* L);
		static int luaVocationGetName(lua_State* L);
		static int luaVocationGetDescription(lua_State* L);

		static int luaVocationGetRequiredSkillTries(lua_State* L);
		static int luaVocationGetRequiredManaSpent(lua_State* L);

		static int luaVocationGetCapacityGain(lua_State* L);

		static int luaVocationGetHealthGain(lua_State* L);
		static int luaVocationGetHealthGainTicks(lua_State* L);
		static int luaVocationGetHealthGainAmount(lua_State* L);

		static int luaVocationGetManaGain(lua_State* L);
		static int luaVocationGetManaGainTicks(lua_State* L);
		static int luaVocationGetManaGainAmount(lua_State* L);

		static int luaVocationGetMaxSoul(lua_State* L);
		static int luaVocationGetSoulGainTicks(lua_State* L);

		static int luaVocationGetBaseAttackSpeed(lua_State* L);
		static int luaVocationGetAttackSpeed(lua_State* L);
		static int luaVocationGetBaseSpeed(lua_State* L);

		static int luaVocationGetDemotion(lua_State* L);
		static int luaVocationGetPromotion(lua_State* L);
};

#endif  // SRC_LUA_FUNCTIONS_CREATURES_PLAYER_VOCATION_FUNCTIONS_HPP_
