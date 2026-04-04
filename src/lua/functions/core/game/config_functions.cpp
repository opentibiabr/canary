/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/functions/core/game/config_functions.hpp"

#include "config/configmanager.hpp"
#include "lua/functions/lua_functions_loader.hpp"

#include <sol/sol.hpp>

void ConfigFunctions::init(lua_State* L) {
	sol::state_view lua(L);

	auto configManager = lua.create_named_table("configManager");

	configManager.set_function("getString", [](uint32_t key) {
		return g_configManager().getString(static_cast<ConfigKey_t>(key));
	});

	configManager.set_function("getNumber", [](uint32_t key) {
		return g_configManager().getNumber(static_cast<ConfigKey_t>(key));
	});

	configManager.set_function("getBoolean", [](uint32_t key) {
		return g_configManager().getBoolean(static_cast<ConfigKey_t>(key));
	});

	configManager.set_function("getFloat", [](uint32_t key, sol::optional<bool> shouldRound) {
		float value = g_configManager().getFloat(static_cast<ConfigKey_t>(key));
		if (shouldRound.value_or(true)) {
			return static_cast<double>(std::round(value * 100.0) / 100.0);
		}
		return static_cast<double>(value);
	});

	auto configKeys = lua.create_named_table("configKeys");
	for (auto value : magic_enum::enum_values<ConfigKey_t>()) {
		auto enumName = magic_enum::enum_name(value);
		if (!enumName.empty()) {
			configKeys[enumName] = static_cast<uint32_t>(value);
		}
	}
}
