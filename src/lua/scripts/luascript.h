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

#ifndef SRC_LUA_SCRIPTS_LUASCRIPT_H_
#define SRC_LUA_SCRIPTS_LUASCRIPT_H_

#include "lua/functions/lua_functions_loader.hpp"
#include "lua/scripts/script_environment.hpp"

class LuaScriptInterface : public LuaFunctionsLoader {
	public:
		explicit LuaScriptInterface(std::string interfaceName);
		virtual ~LuaScriptInterface();

		// non-copyable
		LuaScriptInterface(const LuaScriptInterface&) = delete;
		LuaScriptInterface& operator=(const LuaScriptInterface&) = delete;

		virtual bool initState();
		bool reInitState();

		int32_t loadFile(const std::string& file);

		const std::string& getFileById(int32_t scriptId);
		int32_t getEvent(const std::string& eventName);
		int32_t getEvent();
		int32_t getMetaEvent(const std::string& globalName, const std::string& eventName);

		const std::string& getInterfaceName() const {
			return interfaceName;
		}
		const std::string& getLastLuaError() const {
			return lastLuaError;
		}
		const std::string& getLoadingFile() const {
			return loadingFile;
		}

		lua_State* getLuaState() const {
			return luaState;
		}

		bool pushFunction(int32_t functionId);

		bool callFunction(int params);
		void callVoidFunction(int params);

		std::string getStackTrace(const std::string& error_desc);

	protected:
		virtual bool closeState();
		lua_State* luaState = nullptr;
		int32_t eventTableRef = -1;
		int32_t runningEventId = EVENT_ID_USER;
		std::map<int32_t, std::string> cacheFiles;

	private:
		std::string lastLuaError;
		std::string interfaceName;
		std::string loadingFile;
};

#endif  // SRC_LUA_SCRIPTS_LUASCRIPT_H_
