/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/functions/attribute_custom.hpp"

#include "lua/scripts/luascript.h"

CustomAttribute::CustomAttribute() = default;
CustomAttribute::~CustomAttribute() = default;

// Constructor for int64_t
CustomAttribute::CustomAttribute(const std::string& initStringKey,
	const std::int64_t& initInt64) : stringKey(initStringKey), int64Value(initInt64) {}
// Constructor for string
CustomAttribute::CustomAttribute(const std::string &initStringKey, const std::string &initStringValue) : stringKey(initStringKey), stringValue(initStringValue) {}
// Constructor for double
CustomAttribute::CustomAttribute(const std::string &initStringKey, const double &initDoubleValue) : stringKey(initStringKey), doubleValue(initDoubleValue) {}
// Constructor for boolean
CustomAttribute::CustomAttribute(const std::string &initStringKey, const bool &initBoolValue) : stringKey(initStringKey), boolValue(initBoolValue) {}

const std::string &CustomAttribute::getStringKey() const {
	return stringKey;
}

const std::int64_t &CustomAttribute::getInt64Value() const {
	return int64Value;
}

const std::string &CustomAttribute::getStringValue() const {
	return stringValue;
}

const double &CustomAttribute::getDoubleValue() const {
	return doubleValue;
}

const bool &CustomAttribute::getBoolValue() const {
	return boolValue;
}

void CustomAttribute::pushToLua(lua_State* L) const {
	if (int64Value != 0) {
		lua_pushnumber(L, static_cast<lua_Number>(int64Value));
	} else if (!stringValue.empty()) {
		LuaScriptInterface::pushString(L, stringValue);
	} else if (doubleValue != 0) {
		lua_pushnumber(L, doubleValue);
	} else if (boolValue) {
		LuaScriptInterface::pushBoolean(L, boolValue);
	} else {
		lua_pushnil(L);
	}
}
