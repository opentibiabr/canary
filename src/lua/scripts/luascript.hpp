/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/functions/lua_functions_loader.hpp"
#include "lua/scripts/script_environment.hpp"

class LuaScriptInterface : public Lua {
public:
	explicit LuaScriptInterface(std::string interfaceName);
	virtual ~LuaScriptInterface();

	// non-copyable
	LuaScriptInterface(const LuaScriptInterface &) = delete;
	LuaScriptInterface &operator=(const LuaScriptInterface &) = delete;

	virtual bool initState();
	virtual bool reInitState();

	int32_t loadFile(const std::string &file, const std::string &scriptName);

	const std::string &getFileById(int32_t scriptId);
	int32_t getEvent(const std::string &eventName);
	int32_t getEvent();
	int32_t getMetaEvent(const std::string &globalName, const std::string &eventName);

	const std::string &getInterfaceName() const {
		return interfaceName;
	}
	const std::string &getLastLuaError() const {
		return lastLuaError;
	}
	const std::string &getLoadingFile() const {
		return loadingFile;
	}

	const std::string &getLoadingScriptName() const {
		// If scripty name is empty, return warning informing
		if (loadedScriptName.empty()) {
			g_logger().warn("[LuaScriptInterface::getLoadingScriptName] - Script name is empty");
		}

		return loadedScriptName;
	}
	void setLoadingScriptName(const std::string &scriptName) {
		loadedScriptName = scriptName;
	}

	virtual lua_State* getLuaState() {
		return luaState;
	}

	bool pushFunction(int32_t functionId) const;

	bool callFunction(int params) const;
	void callVoidFunction(int params) const;

	std::string getStackTrace(const std::string &error_desc) const;

protected:
	virtual bool closeState();
	lua_State* luaState = nullptr;
	int32_t eventTableRef = -1;
	int32_t runningEventId = EVENT_ID_USER;
	std::map<int32_t, std::string> cacheFiles;

private:
	std::string getMetricsScope() const;

	std::string lastLuaError;
	std::string interfaceName;
	std::string loadingFile;
	std::string loadedScriptName;
};
