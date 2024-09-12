/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "config_enums.hpp"

using ConfigValue = std::variant<std::string, int32_t, bool, float>;

class ConfigManager {
public:
	ConfigManager() = default;

	// Singleton - ensures we don't accidentally copy it
	ConfigManager(const ConfigManager &) = delete;
	void operator=(const ConfigManager &) = delete;

	static ConfigManager &getInstance();

	bool load();
	bool reload();

	void missingConfigWarning(const char* identifier);

	const std::string &setConfigFileLua(const std::string &what) {
		configFileLua = { what };
		return configFileLua;
	};
	[[nodiscard]] const std::string &getConfigFileLua() const {
		return configFileLua;
	};

	[[nodiscard]] const std::string &getString(const ConfigKey_t &key, std::string_view context) const;
	[[nodiscard]] int32_t getNumber(const ConfigKey_t &key, std::string_view context) const;
	[[nodiscard]] bool getBoolean(const ConfigKey_t &key, std::string_view context) const;

	/**
	 * @brief Retrieves a float configuration value from the configuration manager, with an optional rounding.
	 * 
	 * This function is a Lua binding used to get a float value from the configuration manager. It requires
	 * a key as the first argument, which should be a valid enumeration. An optional second boolean argument 
	 * specifies whether the retrieved float should be rounded to two decimal places.
	 * 
	 * @param L Pointer to the Lua state. The first argument must be a valid enum key, and the second argument (optional)
	 * can be a boolean indicating whether to round the result.
	 * 
	 * @return Returns 1 after pushing the result onto the Lua stack, indicating the number of return values.
	 * 
	 * @exception reportErrorFunc Throws an error if the first argument is not a valid enum.
	 * 
	 * Usage:
	 *  local result = ConfigManager.getFloat(ConfigKey.SomeKey)
	 *  local result_rounded = ConfigManager.getFloat(ConfigKey.SomeKey, false)
	 *
	 * Detailed behavior:
	 * 1. Extracts the key from the first Lua stack argument as an enumeration of type `ConfigKey_t`.
	 * 2. Checks if the second argument is provided; if not, defaults to true for rounding.
	 * 3. Retrieves the float value associated with the key from the configuration manager.
	 * 4. If rounding is requested, rounds the value to two decimal places.
	 * 5. Logs the method call and the obtained value using the debug logger.
	 * 6. Pushes the final value (rounded or original) back onto the Lua stack.
	 * 7. Returns 1 to indicate a single return value.
	 */
	[[nodiscard]] float getFloat(const ConfigKey_t &key, std::string_view context) const;

private:
	phmap::flat_hash_map<ConfigKey_t, ConfigValue> configs;
	std::string loadStringConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const std::string &defaultValue);
	int32_t loadIntConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const int32_t &defaultValue);
	bool loadBoolConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const bool &defaultValue);
	float loadFloatConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const float &defaultValue);

	std::string configFileLua = { "config.lua" };
	bool loaded = false;
};

constexpr auto g_configManager = ConfigManager::getInstance;
