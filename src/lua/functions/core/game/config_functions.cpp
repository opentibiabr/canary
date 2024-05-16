/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/functions/core/game/config_functions.hpp"

#include "config/configmanager.hpp"

void ConfigFunctions::init(lua_State* L) {
	registerTable(L, "configManager");
	registerMethod(L, "configManager", "getString", luaConfigManagerGetString);
	registerMethod(L, "configManager", "getNumber", luaConfigManagerGetNumber);
	registerMethod(L, "configManager", "getBoolean", luaConfigManagerGetBoolean);
	registerMethod(L, "configManager", "getFloat", luaConfigManagerGetFloat);

#define registerMagicEnumIn(L, tableName, enumValue)         \
	do {                                                     \
		auto name = magic_enum::enum_name(enumValue).data(); \
		registerVariable(L, tableName, name, value);         \
	} while (0)
	registerTable(L, "configKeys");
	for (auto value : magic_enum::enum_values<ConfigKey_t>()) {
		auto enumName = magic_enum::enum_name(value).data();
		if (enumName) {
			registerMagicEnumIn(L, "configKeys", value);
			g_logger().debug("Registering ConfigManager enum name '{}' value '{}' to lua", enumName, fmt::underlying(value));
		}
	}
#undef registerMagicEnumIn
}

int ConfigFunctions::luaConfigManagerGetString(lua_State* L) {
	auto key = getNumber<ConfigKey_t>(L, -1);
	if (!key) {
		reportErrorFunc("Wrong enum");
		return 1;
	}

	pushString(L, g_configManager().getString(getNumber<ConfigKey_t>(L, -1), __FUNCTION__));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetNumber(lua_State* L) {
	auto key = getNumber<ConfigKey_t>(L, -1);
	if (!key) {
		reportErrorFunc("Wrong enum");
		return 1;
	}

	lua_pushnumber(L, g_configManager().getNumber(getNumber<ConfigKey_t>(L, -1), __FUNCTION__));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetBoolean(lua_State* L) {
	auto key = getNumber<ConfigKey_t>(L, -1);
	if (!key) {
		reportErrorFunc("Wrong enum");
		return 1;
	}

	pushBoolean(L, g_configManager().getBoolean(getNumber<ConfigKey_t>(L, -1), __FUNCTION__));
	return 1;
}

int ConfigFunctions::luaConfigManagerGetFloat(lua_State* L) {
	auto key = getNumber<ConfigKey_t>(L, -1);
	if (!key) {
		reportErrorFunc("Wrong enum");
		return 1;
	}

	lua_pushnumber(L, g_configManager().getFloat(key, __FUNCTION__));
	return 1;
}
