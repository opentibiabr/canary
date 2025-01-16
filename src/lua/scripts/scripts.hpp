/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lib/di/container.hpp"
#include "lua/scripts/luascript.hpp"

class Scripts {
public:
	Scripts();

	// non-copyable
	Scripts(const Scripts &) = delete;
	Scripts &operator=(const Scripts &) = delete;

	static Scripts &getInstance() {
		return inject<Scripts>();
	}

	void clearAllScripts() const;

	bool loadEventSchedulerScripts(const std::string &fileName);
	bool loadScripts(std::string folderName, bool isLib, bool reload);
	LuaScriptInterface &getScriptInterface() {
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

constexpr auto g_scripts = Scripts::getInstance;

class Script {
public:
	/**
	 * @brief Explicit construtor
	 * explicit, that is, it cannot be used for implicit conversions and
	 * copy-initialization.
	 *
	 * @param interface Lua Script Interface
	 */
	explicit Script(LuaScriptInterface* interface) :
		scriptInterface(interface) { }
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
		if (!scriptInterface) {
			g_logger().error("[Script::loadCallback] scriptInterface is nullptr, scriptid = {}", scriptId);
			return false;
		}

		if (scriptId != 0) {
			g_logger().error("[Script::loadCallback] scriptid is not zero, scriptid = {}, scriptName {}", scriptId, scriptInterface->getLoadingScriptName());
			return false;
		}

		int32_t id = scriptInterface->getEvent();
		if (id == -1) {
			g_logger().error("[Script::loadCallback] Event {} not found for script with name {}", getScriptTypeName(), scriptInterface->getLoadingScriptName());
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
