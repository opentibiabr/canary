/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/libs/kv_functions.hpp"

#include <variant>

#include "kv/kv.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/functions/lua_functions_loader.hpp"

void KVFunctions::init(lua_State* L) {
	Lua::registerTable(L, "kv");
	Lua::registerMethod(L, "kv", "scoped", KVFunctions::luaKVScoped);
	Lua::registerMethod(L, "kv", "set", KVFunctions::luaKVSet);
	Lua::registerMethod(L, "kv", "get", KVFunctions::luaKVGet);
	Lua::registerMethod(L, "kv", "keys", KVFunctions::luaKVKeys);
	Lua::registerMethod(L, "kv", "remove", KVFunctions::luaKVRemove);

	Lua::registerClass(L, "KV", "");
	Lua::registerMethod(L, "KV", "scoped", KVFunctions::luaKVScoped);
	Lua::registerMethod(L, "KV", "set", KVFunctions::luaKVSet);
	Lua::registerMethod(L, "KV", "get", KVFunctions::luaKVGet);
	Lua::registerMethod(L, "KV", "keys", KVFunctions::luaKVKeys);
	Lua::registerMethod(L, "KV", "remove", KVFunctions::luaKVRemove);
}

int KVFunctions::luaKVScoped(lua_State* L) {
	// KV.scoped(key) | KV:scoped(key)
	const auto key = Lua::getString(L, -1);

	if (Lua::isUserdata(L, 1)) {
		const auto &scopedKV = Lua::getUserdataShared<KV>(L, 1);
		const auto &newScope = scopedKV->scoped(key);
		Lua::pushUserdata<KV>(L, newScope);
		Lua::setMetatable(L, -1, "KV");
		return 1;
	}

	const auto &scopedKV = g_kv().scoped(key);
	Lua::pushUserdata<KV>(L, scopedKV);
	Lua::setMetatable(L, -1, "KV");
	return 1;
}

int KVFunctions::luaKVSet(lua_State* L) {
	// KV.set(key, value) | scopedKV:set(key, value)
	const auto key = Lua::getString(L, -2);
	const auto &valueWrapper = getValueWrapper(L);

	if (!valueWrapper) {
		g_logger().warn("[{}] invalid param type", __FUNCTION__);
		Lua::pushBoolean(L, false);
		return 1;
	}

	if (Lua::isUserdata(L, 1)) {
		const auto &scopedKV = Lua::getUserdataShared<KV>(L, 1);
		scopedKV->set(key, valueWrapper.value());
		Lua::pushBoolean(L, true);
		return 1;
	}

	g_kv().set(key, valueWrapper.value());
	Lua::pushBoolean(L, true);
	return 1;
}

int KVFunctions::luaKVGet(lua_State* L) {
	// KV.get(key[, forceLoad = false]) | scopedKV:get(key[, forceLoad = false])
	std::optional<ValueWrapper> valueWrapper;
	bool forceLoad = false;
	auto key = Lua::getString(L, -1);
	if (Lua::isBoolean(L, -1)) {
		forceLoad = Lua::getBoolean(L, -1);
		key = Lua::getString(L, -2);
	}
	if (Lua::isUserdata(L, 1)) {
		const auto &scopedKV = Lua::getUserdataShared<KV>(L, 1);
		valueWrapper = scopedKV->get(key, forceLoad);
	} else {
		valueWrapper = g_kv().get(key, forceLoad);
	}

	if (valueWrapper.has_value()) {
		pushValueWrapper(L, *valueWrapper);
	} else {
		lua_pushnil(L);
	}
	return 1;
}

int KVFunctions::luaKVRemove(lua_State* L) {
	// KV.remove(key) | scopedKV:remove(key)
	const auto key = Lua::getString(L, -1);
	if (Lua::isUserdata(L, 1)) {
		const auto &scopedKV = Lua::getUserdataShared<KV>(L, 1);
		scopedKV->remove(key);
	} else {
		g_kv().remove(key);
	}
	lua_pushnil(L);
	return 1;
}

int KVFunctions::luaKVKeys(lua_State* L) {
	// KV.keys([prefix = ""]) | scopedKV:keys([prefix = ""])
	std::unordered_set<std::string> keys;
	std::string prefix;

	if (Lua::isString(L, -1)) {
		prefix = Lua::getString(L, -1);
	}

	if (Lua::isUserdata(L, 1)) {
		const auto &scopedKV = Lua::getUserdataShared<KV>(L, 1);
		keys = scopedKV->keys();
	} else {
		keys = g_kv().keys(prefix);
	}

	int index = 0;
	lua_createtable(L, static_cast<int>(keys.size()), 0);
	for (const auto &key : keys) {
		Lua::pushString(L, key);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

std::optional<ValueWrapper> KVFunctions::getValueWrapper(lua_State* L) {
	if (Lua::isBoolean(L, -1)) {
		return ValueWrapper(Lua::getBoolean(L, -1));
	}
	if (Lua::isNumber(L, -1)) {
		return ValueWrapper(Lua::getNumber<double>(L, -1));
	}
	if (Lua::isString(L, -1)) {
		return ValueWrapper(Lua::getString(L, -1));
	}

	if (Lua::isTable(L, -1) && lua_objlen(L, -1) > 0) {
		ArrayType array;
		for (int i = 1; i <= lua_objlen(L, -1); ++i) {
			lua_rawgeti(L, -1, i);
			const auto &value = getValueWrapper(L);
			if (!value) {
				g_logger().warn("[{}] invalid param type", __FUNCTION__);
				return std::nullopt;
			}
			array.push_back(value.value());
			lua_pop(L, 1);
		}
		return ValueWrapper(array);
	}

	if (Lua::isTable(L, -1)) {
		MapType map;
		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			const auto &value = getValueWrapper(L);
			if (!value) {
				g_logger().warn("[{}] invalid param type", __FUNCTION__);
				return std::nullopt;
			}
			map[Lua::getString(L, -2)] = std::make_shared<ValueWrapper>(value.value());
			lua_pop(L, 1);
		}
		return ValueWrapper(map);
	}

	if (Lua::isNil(L, -1)) {
		return std::nullopt;
	}

	g_logger().warn("[{}] invalid param type", __FUNCTION__);
	return std::nullopt;
}

void KVFunctions::pushStringValue(lua_State* L, const StringType &value) {
	Lua::pushString(L, value);
}

void KVFunctions::pushIntValue(lua_State* L, const IntType &value) {
	lua_pushnumber(L, value);
}

void KVFunctions::pushDoubleValue(lua_State* L, const DoubleType &value) {
	lua_pushnumber(L, value);
}

void KVFunctions::pushArrayValue(lua_State* L, const ArrayType &value) {
	lua_newtable(L);
	for (int i = 0; i < value.size(); ++i) {
		pushValueWrapper(L, value[i]);
		lua_rawseti(L, -2, i + 1);
	}
}

void KVFunctions::pushMapValue(lua_State* L, const MapType &value) {
	lua_newtable(L);
	for (const auto &[key, val] : value) {
		pushValueWrapper(L, *val);
		lua_setfield(L, -2, key.c_str());
	}
}

void KVFunctions::pushValueWrapper(lua_State* L, const ValueWrapper &valueWrapper) {
	std::visit(
		[L](const auto &arg) {
			using T = std::decay_t<decltype(arg)>;
			if constexpr (std::is_same_v<T, StringType>) {
				pushStringValue(L, arg);
			} else if constexpr (std::is_same_v<T, BooleanType>) {
				Lua::pushBoolean(L, arg);
			} else if constexpr (std::is_same_v<T, IntType>) {
				pushIntValue(L, arg);
			} else if constexpr (std::is_same_v<T, DoubleType>) {
				pushDoubleValue(L, arg);
			} else if constexpr (std::is_same_v<T, ArrayType>) {
				pushArrayValue(L, arg);
			} else if constexpr (std::is_same_v<T, MapType>) {
				pushMapValue(L, arg);
			}
		},
		valueWrapper.getVariant()
	);
}
