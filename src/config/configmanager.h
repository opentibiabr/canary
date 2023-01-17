/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_CONFIG_CONFIGMANAGER_H_
#define SRC_CONFIG_CONFIGMANAGER_H_

#include "declarations.hpp"

class ConfigManager
{
	public:
		ConfigManager() = default;

		// Singleton - ensures we don't accidentally copy it
		ConfigManager(ConfigManager const&) = delete;
		void operator=(ConfigManager const&) = delete;

		static ConfigManager& getInstance() {
			// Guaranteed to be destroyed
			static ConfigManager instance;
			// Instantiated on first use
			return instance;
		}
	
		bool load();
		bool reload();

		const std::string& getString(stringConfig_t what) const;
		int32_t getNumber(integerConfig_t what) const;
		int16_t getShortNumber(integerConfig_t what) const;
		bool getBoolean(booleanConfig_t what) const;
		float getFloat(floatingConfig_t what) const;

		std::string const& setConfigFileLua(const std::string& what) {
			configFileLua = { what };
			return configFileLua;
		};
		std::string const& getConfigFileLua() const {
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

constexpr auto g_configManager = &ConfigManager::getInstance;

#endif  // SRC_CONFIG_CONFIGMANAGER_H_
