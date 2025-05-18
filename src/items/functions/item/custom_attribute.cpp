/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "items/functions/item/custom_attribute.hpp"

#include "lua/scripts/luascript.hpp"

CustomAttribute::CustomAttribute() = default;
CustomAttribute::~CustomAttribute() = default;

// Constructor for int64_t
CustomAttribute::CustomAttribute(std::string initStringKey, const int64_t initInt64) :
	stringKey(std::move(initStringKey)), value(initInt64) {
}
// Constructor for string
CustomAttribute::CustomAttribute(std::string initStringKey, const std::string &initStringValue) :
	stringKey(std::move(initStringKey)), value(initStringValue) {
}
// Constructor for double
CustomAttribute::CustomAttribute(std::string initStringKey, const double initDoubleValue) :
	stringKey(std::move(initStringKey)), value(initDoubleValue) {
}
// Constructor for boolean
CustomAttribute::CustomAttribute(std::string initStringKey, const bool initBoolValue) :
	stringKey(std::move(initStringKey)), value(initBoolValue) {
}

const std::string &CustomAttribute::getStringKey() const {
	return stringKey;
}

const int64_t &CustomAttribute::getInteger() const {
	if (std::holds_alternative<int64_t>(value)) {
		return std::get<int64_t>(value);
	}

	static int64_t emptyValue;
	return emptyValue;
}

const std::string &CustomAttribute::getString() const {
	if (std::holds_alternative<std::string>(value)) {
		return std::get<std::string>(value);
	}

	static std::string emptyValue;
	return emptyValue;
}

const double &CustomAttribute::getDouble() const {
	if (std::holds_alternative<double>(value)) {
		return std::get<double>(value);
	}

	static double emptyValue;
	return emptyValue;
}

const bool &CustomAttribute::getBool() const {
	if (std::holds_alternative<bool>(value)) {
		return std::get<bool>(value);
	}

	static bool emptyValue;
	return emptyValue;
}

void CustomAttribute::pushToLua(lua_State* L) const {
	if (hasValue<std::string>()) {
		LuaScriptInterface::pushString(L, getString());
	} else if (hasValue<int64_t>()) {
		lua_pushnumber(L, static_cast<lua_Number>(getAttribute<int64_t>()));
	} else if (hasValue<double>()) {
		lua_pushnumber(L, getDouble());
	} else if (hasValue<bool>()) {
		LuaScriptInterface::pushBoolean(L, getBool());
	} else {
		lua_pushnil(L);
	}
}

void CustomAttribute::serialize(PropWriteStream &propWriteStream) const {

	if (hasValue<std::string>()) {
		propWriteStream.write<uint8_t>(1);
		propWriteStream.writeString(getString());
	} else if (hasValue<int64_t>()) {
		propWriteStream.write<uint8_t>(2);
		propWriteStream.write<int64_t>(getInteger());
	} else if (hasValue<double>()) {
		propWriteStream.write<uint8_t>(3);
		propWriteStream.write<double>(getDouble());
	} else if (hasValue<bool>()) {
		propWriteStream.write<uint8_t>(4);
		propWriteStream.write<bool>(getBool());
	}
}

bool CustomAttribute::unserialize(PropStream &propStream, const std::string &function) {
	uint8_t type;
	if (!propStream.read<uint8_t>(type)) {
		g_logger().error("[{}] Failed to read type", function);
		return false;
	}

	switch (type) {
		case 1: {
			std::string readString;
			if (!propStream.readString(readString)) {
				g_logger().error("[{}] failed to read string, call function: {}", __FUNCTION__, function);
				return false;
			}
			value = readString;
			break;
		}
		case 2: {
			int64_t readInt;
			if (!propStream.read<int64_t>(readInt)) {
				g_logger().error("[{}] failed to read int64, call function: {}", __FUNCTION__, function);
				return false;
			}
			value = readInt;
			break;
		}
		case 3: {
			double readDouble;
			if (!propStream.read<double>(readDouble)) {
				g_logger().error("[{}] failed to read double, call function: {}", __FUNCTION__, function);
				return false;
			}
			value = readDouble;
			break;
		}
		case 4: {
			bool readBoolean;
			if (!propStream.read<bool>(readBoolean)) {
				g_logger().error("[{}] failed to read boolean, call function: {}", __FUNCTION__, function);
				return false;
			}
			value = readBoolean;
			break;
		}
		default:
			return false;
	}
	return true;
}
