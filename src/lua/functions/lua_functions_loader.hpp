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
#include "lua/scripts/luajit_sync.hpp"
#include "game/movement/position.hpp"
#include "lua/scripts/script_environment.hpp"

class Combat;
class Creature;
class Cylinder;
class Game;
class InstantSpell;
class Item;
class Player;
class Thing;
class Guild;
class Zone;
class KV;

using lua_Number = double;

struct LuaVariant;

#define reportErrorFunc(a) reportError(__FUNCTION__, a, true)

class Lua {
public:
	static void load(lua_State* L);

	static std::string getErrorDesc(ErrorCode_t code);

	static void reportError(const char* function, const std::string &error_desc, bool stack_trace = false);
	static int luaErrorHandler(lua_State* L);

	static void pushThing(lua_State* L, const std::shared_ptr<Thing> &thing);
	static void pushVariant(lua_State* L, const LuaVariant &var);
	static void pushString(lua_State* L, const std::string &value);
	static void pushNumber(lua_State* L, lua_Number value);
	static void pushCallback(lua_State* L, int32_t callback);
	static void pushCylinder(lua_State* L, const std::shared_ptr<Cylinder> &cylinder);

	static std::string popString(lua_State* L);
	static int32_t popCallback(lua_State* L);

	template <class T>
	static void pushUserdata(lua_State* L, T* value) {
		T** userdata = static_cast<T**>(lua_newuserdata(L, sizeof(T*)));
		*userdata = value;
	}

	static void setMetatable(lua_State* L, int32_t index, const std::string &name);
	static void setWeakMetatable(lua_State* L, int32_t index, const std::string &name);
	static void setItemMetatable(lua_State* L, int32_t index, const std::shared_ptr<Item> &item);
	static void setCreatureMetatable(lua_State* L, int32_t index, const std::shared_ptr<Creature> &creature);

	template <typename T>
	static T getNumber(lua_State* L, int32_t arg, std::source_location location = std::source_location::current()) {
		auto number = lua_tonumber(L, arg);

		if constexpr (std::is_enum_v<T>) {
			return static_cast<T>(static_cast<int64_t>(number));
		}

		if constexpr (std::is_integral_v<T>) {
			if constexpr (std::is_unsigned_v<T>) {
				if (number < 0) {
					g_logger().debug("[{}] overflow, setting to default unsigned value (0), called line: {}:{}, in {}", __FUNCTION__, location.line(), location.column(), location.function_name());
					return T(0);
				}
			}
			return static_cast<T>(number);
		}
		if constexpr (std::is_floating_point_v<T>) {
			return static_cast<T>(number);
		}

		return T {};
	}

	template <typename T>
	static T getNumber(lua_State* L, int32_t arg, T defaultValue) {
		const auto parameters = lua_gettop(L);
		if (parameters == 0 || arg > parameters) {
			return defaultValue;
		}
		return getNumber<T>(L, arg);
	}
	template <class T>
	static T* getUserdata(lua_State* L, int32_t arg) {
		T** userdata = getRawUserdata<T>(L, arg);
		if (!userdata) {
			return nullptr;
		}
		return *userdata;
	}
	template <class T>
	static T** getRawUserdata(lua_State* L, int32_t arg) {
		return static_cast<T**>(lua_touserdata(L, arg));
	}

	static bool getBoolean(lua_State* L, int32_t arg) {
		return lua_toboolean(L, arg) != 0;
	}
	static bool getBoolean(lua_State* L, int32_t arg, bool defaultValue) {
		const auto parameters = lua_gettop(L);
		if (parameters == 0 || arg > parameters) {
			return defaultValue;
		}
		return lua_toboolean(L, arg) != 0;
	}

	static std::string getFormatedLoggerMessage(lua_State* L);
	static std::string getString(lua_State* L, int32_t arg);
	static std::string getString(lua_State* L, int32_t arg, std::string defaultValue) {
		const auto parameters = lua_gettop(L);
		if (parameters == 0 || arg > parameters) {
			return defaultValue;
		}
		return getString(L, arg);
	}
	static CombatDamage getCombatDamage(lua_State* L);
	static Position getPosition(lua_State* L, int32_t arg, int32_t &stackpos);
	static Position getPosition(lua_State* L, int32_t arg);
	static Outfit_t getOutfit(lua_State* L, int32_t arg);
	static LuaVariant getVariant(lua_State* L, int32_t arg);

	static std::shared_ptr<Thing> getThing(lua_State* L, int32_t arg);
	static std::shared_ptr<Creature> getCreature(lua_State* L, int32_t arg);
	static std::shared_ptr<Player> getPlayer(lua_State* L, int32_t arg, bool allowOffline = false);
	static std::shared_ptr<Guild> getGuild(lua_State* L, int32_t arg, bool allowOffline = false);

	template <typename T>
	static T getField(lua_State* L, int32_t arg, const std::string &key) {
		lua_getfield(L, arg, key.c_str());
		return getNumber<T>(L, -1);
	}

	static std::string getFieldString(lua_State* L, int32_t arg, const std::string &key);

	static LuaData_t getUserdataType(lua_State* L, int32_t arg);
	static std::string getUserdataTypeName(LuaData_t userType);

	static bool isNumber(lua_State* L, int32_t arg) {
		return lua_type(L, arg) == LUA_TNUMBER;
	}
	static bool isString(lua_State* L, int32_t arg) {
		return lua_isstring(L, arg) != 0;
	}
	static bool isBoolean(lua_State* L, int32_t arg) {
		return lua_isboolean(L, arg);
	}
	static bool isTable(lua_State* L, int32_t arg) {
		return lua_istable(L, arg);
	}
	static bool isFunction(lua_State* L, int32_t arg) {
		return lua_isfunction(L, arg);
	}
	static bool isNil(lua_State* L, int32_t arg) {
		return lua_isnil(L, arg);
	}
	static bool isUserdata(lua_State* L, int32_t arg) {
		return lua_isuserdata(L, arg) != 0;
	}

	static void pushBoolean(lua_State* L, bool value);
	static void pushCombatDamage(lua_State* L, const CombatDamage &damage);
	static void pushInstantSpell(lua_State* L, const InstantSpell &spell);
	static void pushPosition(lua_State* L, const Position &position, int32_t stackpos = 0);
	static void pushOutfit(lua_State* L, const Outfit_t &outfit);

	static void setField(lua_State* L, const char* index, lua_Number value) {
		lua_pushnumber(L, value);
		lua_setfield(L, -2, index);
	}

	static void setField(lua_State* L, const char* index, const std::string &value) {
		pushString(L, value);
		lua_setfield(L, -2, index);
	}

	static std::string escapeString(const std::string &string);

	static int protectedCall(lua_State* L, int nargs, int nresults);

	static ScriptEnvironment* getScriptEnv() {
		if (scriptEnvIndex < 0 || scriptEnvIndex >= 16) {
			g_logger().error("[{}]: scriptEnvIndex out of bounds!", __FUNCTION__);
			return nullptr;
		}

		assert(scriptEnvIndex >= 0 && scriptEnvIndex < 16);
		return scriptEnv + scriptEnvIndex;
	}

	static bool reserveScriptEnv() {
		return ++scriptEnvIndex < 16;
	}

	static void resetScriptEnv() {
		if (scriptEnvIndex < 0) {
			g_logger().error("[{}]: scriptEnvIndex out of bounds!", __FUNCTION__);
			return;
		}

		assert(scriptEnvIndex >= 0);
		scriptEnv[scriptEnvIndex--].resetEnv();
	}

	template <class T>
	static std::shared_ptr<T> getUserdataShared(lua_State* L, int32_t arg) {
		auto userdata = static_cast<std::shared_ptr<T>*>(lua_touserdata(L, arg));
		if (!userdata) {
			return nullptr;
		}
		return *userdata;
	}

	template <class T>
	static std::shared_ptr<T>* getRawUserDataShared(lua_State* L, int32_t arg) {
		return static_cast<std::shared_ptr<T>*>(lua_touserdata(L, arg));
	}

	template <class T>
	static void pushUserdata(lua_State* L, std::shared_ptr<T> value) {
		// This is basically malloc from C++ point of view.
		auto userData = static_cast<std::shared_ptr<T>*>(lua_newuserdata(L, sizeof(std::shared_ptr<T>)));
		// Copy constructor, bumps ref count.
		new (userData) std::shared_ptr<T>(value);
	}

	static void registerClass(lua_State* L, const std::string &className, const std::string &baseClass, lua_CFunction newFunction = nullptr);
	static void registerSharedClass(lua_State* L, const std::string &className, const std::string &baseClass, lua_CFunction newFunction = nullptr);
	static void registerMethod(lua_State* L, const std::string &globalName, const std::string &methodName, lua_CFunction func);
	static void registerMetaMethod(lua_State* L, const std::string &className, const std::string &methodName, lua_CFunction func);
	static void registerTable(lua_State* L, const std::string &tableName);
	static void registerVariable(lua_State* L, const std::string &tableName, const std::string &name, lua_Number value);

	static void registerGlobalBoolean(lua_State* L, const std::string &name, bool value);
	static void registerGlobalMethod(lua_State* L, const std::string &functionName, lua_CFunction func);
	static void registerGlobalVariable(lua_State* L, const std::string &name, lua_Number value);
	static void registerGlobalString(lua_State* L, const std::string &variable, const std::string &name);

	static int luaUserdataCompare(lua_State* L);
	static int luaGarbageCollection(lua_State* L);

	static ScriptEnvironment scriptEnv[16];
	static int32_t scriptEnvIndex;
	static int validateDispatcherContext(std::string_view fncName);
};
