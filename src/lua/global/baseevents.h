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

#ifndef SRC_BASEEVENTS_H_
#define SRC_BASEEVENTS_H_

#include "lua/scripts/luascript.h"

class Event;
using Event_ptr = std::unique_ptr<Event>;

/**
 * @brief Class that describes an event
 *
 */
class Event
{
	public:
		/**
		 * @brief Explicit construtor
		 * explicit, that is, it cannot be used for implicit conversions and
		 * copy-initialization.
		 *
		 * @param interface Lua Script Interface
		 */
		explicit Event(LuaScriptInterface* interface);
		virtual ~Event() = default;

		virtual bool configureEvent(const pugi::xml_node& node) = 0;

		/**
		 * @brief Test if script can be found and loaded.
		 *
		 * E.g.: basePath = data/
		 * 		scriptsName = actions -> actions/lib/actions.lua
		 * 		scriptFile = A/X.lua -> actions/scripts/A/X.lua
		 *
		 * @param basePath Base path folder
		 * @param scriptsName Folder|Lib script name (without .lua)
		 * <scriptsName>/lib/<scriptsName>.lua
		 * @param scriptFile Path to script file
		 * <scriptsName>/scripts/<scriptFile>
		 * @return true Success, script can be loaded.
		 * @return false Fail, script not found or couldn't be loaded.
		 */
		bool checkScript(const std::string& basePath, const std::string&
							scriptsName, const std::string& scriptFile) const;

		/**
		 * @brief Load the script file.
		 *
		 * @param scriptFile Path to script file.
		 * @return true Success
		 * @return false Fail
		 */
		bool loadScript(const std::string& scriptFile);

		/**
		 * @brief Load script ID using the lua script interface
		 *
		 * @return true Success
		 * @return false Fail
		 */
		bool loadCallback();

		virtual bool loadFunction(const pugi::xml_attribute&, bool) {
			return false;
		}

		/**
		 * @brief Check if event is scripted
		 *
		 * @return true
		 * @return false
		 */
		bool isScripted() const {
			return scripted;
		}

		/**
		 * @brief Get the Script Id object
		 *
		 * @return int32_t
		 */
		int32_t getScriptId() {
			return scriptId;
		}

		bool scripted = false;
		bool fromLua = false;

	protected:
		virtual std::string getScriptEventName() const = 0;

		int32_t scriptId = 0;
		LuaScriptInterface* scriptInterface = nullptr;
};

/**
 * @brief Class that handles the load's of the XML file
 *
 */
class BaseEvents
{
	public:
		/**
		 * @brief The constexpr specifier declares that it is possible to
		 * 	evaluate the value of the function or variable at compile time.
		 *
		 */
		constexpr BaseEvents() = default;
		virtual ~BaseEvents() = default;

		/**
		 * @brief Load XML file
		 *
		 * @return true Success
		 * @return false Fail
		 */
		bool loadFromXml();

		/**
		 * @brief Reload XML file
		 *
		 * @return true Success
		 * @return false Fail
		 */
		bool reload();

		/**
		 * @brief Check if it is loaded
		 *
		 * @return true
		 * @return false
		 */
		bool isLoaded() const {
			return loaded;
		}

		/**
		 * @brief Restart the Lua interface state
		 *
		 * @param fromLua
		 */
		void reInitState(bool fromLua);

	private:
		virtual LuaScriptInterface& getScriptInterface() = 0;
		virtual std::string getScriptBaseName() const = 0;
		virtual Event_ptr getEvent(const std::string& nodeName) = 0;
		virtual bool registerEvent(Event_ptr event, const pugi::xml_node&
																	node) = 0;
		virtual void clear(bool) = 0;

		bool loaded = false;
};

/**
 * @brief
 *
 */
class CallBack
{
	public:
		CallBack() = default;

		/**
		 * @brief Set the scriptInterface according the event name.
		 *
		 * @param interface
		 * @param name
		 * @return true
		 * @return false
		 */
		bool loadCallBack(LuaScriptInterface* interface, const std::string&
																		name);

	protected:
		int32_t scriptId = 0;
		LuaScriptInterface* scriptInterface = nullptr;

	private:
		bool loaded = false;
};

#endif  // SRC_BASEEVENTS_H_
