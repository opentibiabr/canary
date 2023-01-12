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

		void clear() const;

		bool loadEventSchedulerScripts(const std::string& fileName);
		bool loadScripts(std::string folderName, bool isLib, bool reload);
		LuaScriptInterface& getScriptInterface() {
			return scriptInterface;
		}
	private:
		LuaScriptInterface scriptInterface;
};

constexpr auto g_scripts = &Scripts::getInstance;

#endif  // SRC_LUA_SCRIPTS_SCRIPTS_H_
