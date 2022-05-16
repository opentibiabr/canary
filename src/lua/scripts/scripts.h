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

#ifndef SRC_LUA_SCRIPTS_SCRIPTS_H_
#define SRC_LUA_SCRIPTS_SCRIPTS_H_

#include "declarations.hpp"
#include "lua/scripts/luascript.h"

class Scripts {
	public:
		Scripts();
		~Scripts();

		// non-copyable
		Scripts(const Scripts&) = delete;
		Scripts& operator=(const Scripts&) = delete;

		static Scripts& getInstance() {
			// Guaranteed to be destroyed
			static Scripts instance;
			// Instantiated on first use
			return instance;
		}

		bool loadEventSchedulerScripts(const std::string& fileName);
		bool loadScripts(std::string folderName, bool isLib, bool reload);
		LuaScriptInterface& getScriptInterface() {
			return scriptInterface;
		}
		/**
		 * @brief Get the Script Id object
		 *
		 * @return int32_t
		*/
		int32_t getScriptId() {
			return scriptId;
		}

	private:
		int32_t scriptId = 0;
		std::string scriptName;
		LuaScriptInterface scriptInterface;
};

constexpr auto g_scripts = &Scripts::getInstance;

class Script {
	public:
		/**
		 * @brief Explicit construtor
		 * explicit, that is, it cannot be used for implicit conversions and
		 * copy-initialization.
		 *
		 * @param interface Lua Script Interface
		*/
		explicit Script(LuaScriptInterface* interface) : scriptInterface(interface) {}
		virtual ~Script() = default;

		/**
		 * @brief Check if script is loaded
		 *
		 * @return true
		 * @return false
		*/
		bool isLoadedCallback() const {
			return loadedCallback;
		}
		void setLoadedCallback(bool loaded) {
			loadedCallback = loaded;
		}

		/**
		 * @brief Get the Script Id object
		 *
		 * @return int32_t
		*/
		int32_t getScriptId() {
			return scriptId;
		}

		// Load revscriptsys callback
		bool loadCallback() {
			if (!scriptInterface || scriptId != 0) {
				SPDLOG_ERROR("[Script::loadCallback] scriptInterface is nullptr, scriptid = {}, scriptName {}", scriptId, scriptInterface->getLoadingScriptName());
				return false;
			}

			int32_t id = scriptInterface->getEvent();
			if (id == -1) {
				SPDLOG_ERROR("[Script::loadCallback] Event {} not found for script with name {}", getScriptTypeName(), scriptInterface->getLoadingScriptName());
				return false;
			}

			setLoadedCallback(true);
			scriptId = id;
			return true;
		}


	protected:
		// If script is loaded callback
		bool loadedCallback = false;

		// Script type (Action, CreatureEvent, GlobalEvent, MoveEvent, Spell, Weapon)
		virtual std::string getScriptTypeName() const = 0;
		int32_t scriptId = 0;
		LuaScriptInterface* scriptInterface = nullptr;
};

#endif  // SRC_LUA_SCRIPTS_SCRIPTS_H_
