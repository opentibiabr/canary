/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class KVFunctions final : LuaScriptInterface {
public:
	static void init(lua_State* L) {
		registerTable(L, "kv");
		registerMethod(L, "kv", "scoped", KVFunctions::luaKVScoped);
		registerMethod(L, "kv", "set", KVFunctions::luaKVSet);
		registerMethod(L, "kv", "get", KVFunctions::luaKVGet);

		registerClass(L, "KV", "");
		registerMethod(L, "KV", "scoped", KVFunctions::luaKVScoped);
		registerMethod(L, "KV", "set", KVFunctions::luaKVSet);
		registerMethod(L, "KV", "get", KVFunctions::luaKVGet);
	}

private:
	static int luaKVScoped(lua_State* L);
	static int luaKVSet(lua_State* L);
	static int luaKVGet(lua_State* L);

	static std::optional<ValueWrapper> getValueWrapper(lua_State* L);
	static void pushStringValue(lua_State* L, const StringType &value);
	static void pushIntValue(lua_State* L, const IntType &value);
	static void pushDoubleValue(lua_State* L, const DoubleType &value);
	static void pushArrayValue(lua_State* L, const ArrayType &value);
	static void pushMapValue(lua_State* L, const MapType &value);
	static void pushValueWrapper(lua_State* L, const ValueWrapper &valueWrapper);
};
