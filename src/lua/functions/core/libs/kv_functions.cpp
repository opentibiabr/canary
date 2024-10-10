/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <variant>

#include "kv/kv.hpp"
#include "lua/functions/core/libs/kv_functions.hpp"
#include "lua/scripts/lua_environment.hpp"

int KVFunctions::luaKVScoped(lua_State* L) {
	// KV.scoped(key) | KV:scoped(key)
	auto key = getString(L, -1);

	if (isUserdata(L, 1)) {
		auto scopedKV = getUserdataShared<KV>(L, 1);
		auto newScope = scopedKV->scoped(key);
		pushUserdata<KV>(L, newScope);
		setMetatable(L, -1, "KV");
		return 1;
	}

	auto scopedKV = g_kv().scoped(key);
	pushUserdata<KV>(L, scopedKV);
	setMetatable(L, -1, "KV");
	return 1;
}

int KVFunctions::luaKVSet(lua_State* L) {
	// KV.set(key, value) | scopedKV:set(key, value)
	auto key = getString(L, -2);
	auto valueWrapper = getValueWrapper(L);

	if (!valueWrapper) {
		g_logger().warn("[{}] invalid param type", __FUNCTION__);
		pushBoolean(L, false);
		return 1;
	}

	if (isUserdata(L, 1)) {
		auto scopedKV = getUserdataShared<KV>(L, 1);
		scopedKV->set(key, valueWrapper.value());
		pushBoolean(L, true);
		return 1;
	}

	g_kv().set(key, valueWrapper.value());
	pushBoolean(L, true);
	return 1;
}

int KVFunctions::luaKVGet(lua_State* L) {
	// KV.get(key[, forceLoad = false]) | scopedKV:get(key[, forceLoad = false])
	std::optional<ValueWrapper> valueWrapper;
	bool forceLoad = false;
	auto key = getString(L, -1);
	if (isBoolean(L, -1)) {
		forceLoad = getBoolean(L, -1);
		key = getString(L, -2);
	}
	if (isUserdata(L, 1)) {
		auto scopedKV = getUserdataShared<KV>(L, 1);
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
	auto key = getString(L, -1);
	if (isUserdata(L, 1)) {
		auto scopedKV = getUserdataShared<KV>(L, 1);
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
	std::string prefix = "";

	if (isString(L, -1)) {
		prefix = getString(L, -1);
	}

	if (isUserdata(L, 1)) {
		auto scopedKV = getUserdataShared<KV>(L, 1);
		keys = scopedKV->keys();
	} else {
		keys = g_kv().keys(prefix);
	}

	int index = 0;
	lua_createtable(L, static_cast<int>(keys.size()), 0);
	for (const auto &key : keys) {
		pushString(L, key);
		lua_rawseti(L, -2, ++index);
	}
	return 1;
}

std::optional<ValueWrapper> KVFunctions::getValueWrapper(lua_State* L) {
	if (isBoolean(L, -1)) {
		return ValueWrapper(getBoolean(L, -1));
	}
	if (isNumber(L, -1)) {
		return ValueWrapper(getNumber<double>(L, -1));
	}
	if (isString(L, -1)) {
		return ValueWrapper(getString(L, -1));
	}

	if (isTable(L, -1) && lua_objlen(L, -1) > 0) {
		ArrayType array;
		for (int i = 1; i <= lua_objlen(L, -1); ++i) {
			lua_rawgeti(L, -1, i);
			auto value = getValueWrapper(L);
			if (!value) {
				g_logger().warn("[{}] invalid param type", __FUNCTION__);
				return std::nullopt;
			}
			array.push_back(value.value());
			lua_pop(L, 1);
		}
		return ValueWrapper(array);
	}

	if (isTable(L, -1)) {
		MapType map;
		lua_pushnil(L);
		while (lua_next(L, -2) != 0) {
			auto value = getValueWrapper(L);
			if (!value) {
				g_logger().warn("[{}] invalid param type", __FUNCTION__);
				return std::nullopt;
			}
			map[getString(L, -2)] = std::make_shared<ValueWrapper>(value.value());
			lua_pop(L, 1);
		}
		return ValueWrapper(map);
	}

	if (isNil(L, -1)) {
		return std::nullopt;
	}

	g_logger().warn("[{}] invalid param type", __FUNCTION__);
	return std::nullopt;
}

void KVFunctions::pushStringValue(lua_State* L, const StringType &value) {
	pushString(L, value);
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
				pushBoolean(L, arg);
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
