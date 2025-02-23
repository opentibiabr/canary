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

	[[nodiscard]] const std::string &getString(const ConfigKey_t &key, const std::source_location &location = std::source_location::current()) const;
	[[nodiscard]] int32_t getNumber(const ConfigKey_t &key, const std::source_location &location = std::source_location::current()) const;
	[[nodiscard]] bool getBoolean(const ConfigKey_t &key, const std::source_location &location = std::source_location::current()) const;
	[[nodiscard]] float getFloat(const ConfigKey_t &key, const std::source_location &location = std::source_location::current()) const;

private:
	mutable std::unordered_map<ConfigKey_t, std::string> m_configString;
	mutable std::unordered_map<ConfigKey_t, bool> m_configBoolean;
	mutable std::unordered_map<ConfigKey_t, int32_t> m_configInteger;
	mutable std::unordered_map<ConfigKey_t, float> m_configFloat;

	std::unordered_map<ConfigKey_t, ConfigValue> configs;
	std::string loadStringConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const std::string &defaultValue);
	int32_t loadIntConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const int32_t &defaultValue);
	bool loadBoolConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const bool &defaultValue);
	float loadFloatConfig(lua_State* L, const ConfigKey_t &key, const char* identifier, const float &defaultValue);

	std::string configFileLua = { "config.lua" };
	bool loaded = false;
};

constexpr auto g_configManager = ConfigManager::getInstance;
