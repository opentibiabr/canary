/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_LUA_SCRIPTS_SCRIPTS_H_
#define SRC_LUA_SCRIPTS_SCRIPTS_H_

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

		void clearAllScripts() const;

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
		int32_t getScriptId() const {
			return scriptId;
		}

	private:
		int32_t scriptId = 0;
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

		// Load revscriptsys callback
		bool loadCallback() {
			if (!scriptInterface || scriptId != 0) {
				SPDLOG_ERROR("[Script::loadCallback] scriptInterface is nullptr, scriptid = {}", scriptId);
				return false;
			}

			int32_t id = scriptInterface->getEvent();
			if (id == -1) {
				SPDLOG_ERROR("[Script::loadCallback] Event {} not found", getScriptTypeName());
				return false;
			}

			setLoadedCallback(true);
			scriptId = id;
			return true;
		}


	// NOTE: Pure virtual method ( = 0) that must be implemented in derived classes
	// Script type (Action, CreatureEvent, GlobalEvent, MoveEvent, Spell, Weapon)
	virtual std::string getScriptTypeName() const = 0;

	// Method to access the scriptInterface in derived classes
	virtual LuaScriptInterface* getScriptInterface() const {
		return scriptInterface;
	}
	
	virtual void setScriptInterface(LuaScriptInterface* newInterface) {
		scriptInterface = newInterface;
	}

	// Method to access the scriptId in derived classes
	virtual int32_t getScriptId() const {
		return scriptId;
	}
	virtual void setScriptId(int32_t newScriptId) {
		scriptId = newScriptId;
	}

	private:
	// If script is loaded callback
	bool loadedCallback = false;

	int32_t scriptId = 0;
	LuaScriptInterface* scriptInterface = nullptr;
};

#endif  // SRC_LUA_SCRIPTS_SCRIPTS_H_
