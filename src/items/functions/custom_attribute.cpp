/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "items/functions/custom_attribute.hpp"

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

void CustomAttribute::serialize(PropWriteStream& propWriteStream) const {
	if (int64Value != 0) {
		propWriteStream.write<uint8_t>(1);
		propWriteStream.write<int64_t>(int64Value);
	} else if (!stringValue.empty()) {
		propWriteStream.write<uint8_t>(2);
		propWriteStream.writeString(stringValue);
	} else if (doubleValue != 0) {
		propWriteStream.write<uint8_t>(3);
		propWriteStream.write<double>(doubleValue);
	} else if (boolValue) {
		propWriteStream.write<uint8_t>(4);
		propWriteStream.write<bool>(boolValue);
	} else {
		propWriteStream.write<uint8_t>(0);
	}
}

bool CustomAttribute::unserialize(PropStream& propStream, const std::string& function) {
	uint8_t type;
	if (!propStream.read<uint8_t>(type)) {
	SPDLOG_ERROR("[{}] Failed to read type", function);
		return false;
	}

	switch (type) {
		case 1: {
			int64_t readInt;
			if (!propStream.read<int64_t>(readInt)) {
				SPDLOG_ERROR("[{}] Failed to read int64", function);
				return false;
			}
			int64Value = readInt;
			break;
		}
		case 2: {
			std::string readString;
			if (!propStream.readString(readString)) {
				SPDLOG_ERROR("[{}] Failed to read string", function);
				return false;
			}
			stringValue = readString;
			break;
		}
		
		case 3: {
			double readDouble;
			if (!propStream.read<double>(readDouble)) {
				SPDLOG_ERROR("[{}] Failed to read double", function);
				return false;
			}
			doubleValue = readDouble;
			break;
		}
		case 4: {
			bool readBoolean;
			if (!propStream.read<bool>(readBoolean)) {
				SPDLOG_ERROR("[{}] Failed to read boolean", function);
				return false;
			}
			boolValue = readBoolean;
			break;
		}
		default:
			break;
	}
	return true;
}
