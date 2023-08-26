/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/di/container.hpp"

class ConfigManager {
public:
	ConfigManager() = default;

	// Singleton - ensures we don't accidentally copy it
	ConfigManager(const ConfigManager &) = delete;
	void operator=(const ConfigManager &) = delete;

	static ConfigManager &getInstance() {
		return inject<ConfigManager>();
	}

	bool load();
	bool reload();

	const std::string &getString(stringConfig_t what) const;
	int32_t getNumber(integerConfig_t what) const;
	int16_t getShortNumber(integerConfig_t what) const;
	bool getBoolean(booleanConfig_t what) const;
	float getFloat(floatingConfig_t what) const;

	const std::string &setConfigFileLua(const std::string &what) {
		configFileLua = { what };
		return configFileLua;
	};
	const std::string &getConfigFileLua() const {
		return configFileLua;
	};

private:
	std::string configFileLua = { "config.lua" };

	std::string string[LAST_STRING_CONFIG] = {};
	int32_t integer[LAST_INTEGER_CONFIG] = {};
	bool boolean[LAST_BOOLEAN_CONFIG] = {};
	float floating[LAST_FLOATING_CONFIG] = {};

	bool loaded = false;
};

constexpr auto g_configManager = ConfigManager::getInstance;
