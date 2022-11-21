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

#ifndef SRC_LUA_FUNCTIONS_LUA_FUNCTIONS_LOADER_HPP_
#define SRC_LUA_FUNCTIONS_LUA_FUNCTIONS_LOADER_HPP_

#include "declarations.hpp"
#include "lua/scripts/luajit_sync.hpp"
#include "game/movement/position.h"
#include "lua/scripts/script_environment.hpp"

class Combat;
class Creature;
class Cylinder;
class Game;
class InstantSpell;
class Item;
class Player;
class Thing;

#define reportErrorFunc(a)  reportError(__FUNCTION__, a, true)

class LuaFunctionsLoader {
	public:
		static void load(lua_State* L);

		static std::string getErrorDesc(ErrorCode_t code);

		static void reportError(const char* function, const std::string& error_desc, bool stack_trace = false);
		static int luaErrorHandler(lua_State* L);

		static void pushThing(lua_State* L, Thing* thing);
		static void pushVariant(lua_State* L, const LuaVariant& var);
		static void pushString(lua_State* L, const std::string& value);
		static void pushCallback(lua_State* L, int32_t callback);
		static void pushCylinder(lua_State* L, Cylinder* cylinder);

		static std::string popString(lua_State* L);
		static int32_t popCallback(lua_State* L);

		template<class T>
		static void pushUserdata(lua_State* L, T* value)
		{
			T** userdata = static_cast<T**>(lua_newuserdata(L, sizeof(T*)));
			*userdata = value;
		}

		static void setMetatable(lua_State* L, int32_t index, const std::string& name);
		static void setWeakMetatable(lua_State* L, int32_t index, const std::string& name);
		static void setItemMetatable(lua_State* L, int32_t index, const Item* item);
		static void setCreatureMetatable(lua_State* L, int32_t index, const Creature* creature);

		template<typename T>
		static typename std::enable_if<std::is_enum<T>::value, T>::type
		getNumber(lua_State* L, int32_t arg)
		{
			return static_cast<T>(static_cast<int64_t>(lua_tonumber(L, arg)));
		}
		template<typename T>
		static typename std::enable_if<std::is_integral<T>::value || std::is_floating_point<T>::value, T>::type
		getNumber(lua_State* L, int32_t arg)
		{
			return static_cast<T>(lua_tonumber(L, arg));
		}
		template<typename T>
		static T getNumber(lua_State *L, int32_t arg, T defaultValue)
		{
			const auto parameters = lua_gettop(L);
			if (parameters == 0 || arg > parameters) {
				return defaultValue;
			}
			return getNumber<T>(L, arg);
		}
		template<class T>
		static T* getUserdata(lua_State* L, int32_t arg)
		{
			T** userdata = getRawUserdata<T>(L, arg);
			if (!userdata) {
				return nullptr;
			}
			return *userdata;
		}
		template<class T>
		static T** getRawUserdata(lua_State* L, int32_t arg)
		{
			return static_cast<T**>(lua_touserdata(L, arg));
		}

		static bool getBoolean(lua_State* L, int32_t arg)
		{
			return lua_toboolean(L, arg) != 0;
		}
		static bool getBoolean(lua_State* L, int32_t arg, bool defaultValue)
		{
			const auto parameters = lua_gettop(L);
			if (parameters == 0 || arg > parameters) {
				return defaultValue;
			}
			return lua_toboolean(L, arg) != 0;
		}

		static std::string getString(lua_State* L, int32_t arg);
		static CombatDamage getCombatDamage(lua_State* L);
		static Position getPosition(lua_State* L, int32_t arg, int32_t& stackpos);
		static Position getPosition(lua_State* L, int32_t arg);
		static Outfit_t getOutfit(lua_State* L, int32_t arg);
		static LuaVariant getVariant(lua_State* L, int32_t arg);

		static Thing* getThing(lua_State* L, int32_t arg);
		static Creature* getCreature(lua_State* L, int32_t arg);
		static Player* getPlayer(lua_State* L, int32_t arg);

		template<typename T>
		static T getField(lua_State* L, int32_t arg, const std::string& key)
		{
			lua_getfield(L, arg, key.c_str());
			return getNumber<T>(L, -1);
		}

		static std::string getFieldString(lua_State* L, int32_t arg, const std::string& key);

		static LuaDataType getUserdataType(lua_State* L, int32_t arg);

		static bool isNumber(lua_State* L, int32_t arg)
		{
			return lua_type(L, arg) == LUA_TNUMBER;
		}
		static bool isString(lua_State* L, int32_t arg)
		{
			return lua_isstring(L, arg) != 0;
		}
		static bool isBoolean(lua_State* L, int32_t arg)
		{
			return lua_isboolean(L, arg);
		}
		static bool isTable(lua_State* L, int32_t arg)
		{
			return lua_istable(L, arg);
		}
		static bool isFunction(lua_State* L, int32_t arg)
		{
			return lua_isfunction(L, arg);
		}
		static bool isUserdata(lua_State* L, int32_t arg)
		{
			return lua_isuserdata(L, arg) != 0;
		}

		static void pushBoolean(lua_State* L, bool value);
		static void pushCombatDamage(lua_State* L, const CombatDamage& damage);
		static void pushInstantSpell(lua_State* L, const InstantSpell& spell);
		static void pushPosition(lua_State* L, const Position& position, int32_t stackpos = 0);
		static void pushOutfit(lua_State* L, const Outfit_t& outfit);

		static void setField(lua_State* L, const char* index, lua_Number value)
		{
			lua_pushnumber(L, value);
			lua_setfield(L, -2, index);
		}

		static void setField(lua_State* L, const char* index, const std::string& value)
		{
			pushString(L, value);
			lua_setfield(L, -2, index);
		}

		static std::string escapeString(const std::string& string);

		static int protectedCall(lua_State* L, int nargs, int nresults);

		static ScriptEnvironment* getScriptEnv() {
			assert(scriptEnvIndex >= 0 && scriptEnvIndex < 16);
			return scriptEnv + scriptEnvIndex;
		}

		static bool reserveScriptEnv() {
			return ++scriptEnvIndex < 16;
		}

		static void resetScriptEnv() {
			assert(scriptEnvIndex >= 0);
			scriptEnv[scriptEnvIndex--].resetEnv();
		}

	protected:
		static void registerClass(lua_State* L, const std::string& className, const std::string& baseClass, lua_CFunction newFunction = nullptr);
		static void registerMethod(lua_State* L, const std::string& globalName, const std::string& methodName, lua_CFunction func);
		static void registerMetaMethod(lua_State* L, const std::string& className, const std::string& methodName, lua_CFunction func);
		static void registerTable(lua_State* L, const std::string& tableName);
		static void registerVariable(lua_State* L, const std::string& tableName, const std::string& name, lua_Number value);

		static void registerGlobalBoolean(lua_State* L, const std::string& name, bool value);
		static void registerGlobalMethod(lua_State* L, const std::string& functionName, lua_CFunction func);
		static void registerGlobalVariable(lua_State* L, const std::string& name, lua_Number value);
		static void registerGlobalString(lua_State* L, const std::string& variable, const std::string &name);

		static int luaUserdataCompare(lua_State* L);

		static ScriptEnvironment scriptEnv[16];
		static int32_t scriptEnvIndex;
};

#endif
