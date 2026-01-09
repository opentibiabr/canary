/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/scripts/luascript.hpp"

class Scripts {
public:
	// non-copyable
	Scripts(const Scripts &) = delete;
	Scripts &operator=(const Scripts &) = delete;

	static Scripts &getInstance();

	void clearAllScripts() const;

	bool loadEventSchedulerScripts(const std::filesystem::path &filePath);
	bool loadScripts(std::string_view folderName, bool isLib, bool reload);
	LuaScriptInterface &getScriptInterface() {
		return scriptInterface;
	}

private:
	LuaScriptInterface scriptInterface;
	Scripts();
};

constexpr auto g_scripts = Scripts::getInstance;
