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
