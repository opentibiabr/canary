/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
