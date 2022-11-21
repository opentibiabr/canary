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

#include "pch.hpp"

#include "lua/global/baseevents.h"
#include "lua/scripts/lua_environment.hpp"
#include "utils/tools.h"

bool BaseEvents::loadFromXml() {
	if (loaded) {
		SPDLOG_ERROR("[BaseEvents::loadFromXml] - It's already loaded.");
		return false;
	}

	std::string scriptsName = getScriptBaseName();
	std::string basePath = g_configManager().getString(CORE_DIRECTORY) + "/" + scriptsName + "/";
	if (getScriptInterface().loadFile(basePath + "lib/" +
                                      scriptsName + ".lua") == -1) {
		SPDLOG_WARN(__FUNCTION__,
					scriptsName, scriptsName);
	}

	std::string filename = basePath + scriptsName + ".xml";

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, filename, result);
		return false;
	}

	loaded = true;

	for (auto node : doc.child(scriptsName.c_str()).children()) {
		Event_ptr event = getEvent(node.name());
		if (!event) {
			continue;
		}

		if (!event->configureEvent(node)) {
			SPDLOG_WARN("[BaseEvents::loadFromXml] - Failed to configure event");
			continue;
		}

		bool success;

		pugi::xml_attribute scriptAttribute = node.attribute("script");
		if (scriptAttribute) {
			std::string scriptFile = "scripts/" + std::string(
												scriptAttribute.as_string());
			success = event->checkScript(basePath, scriptsName, scriptFile)
									&& event->loadScript(basePath + scriptFile);
			if (node.attribute("function")) {
				event->loadFunction(node.attribute("function"), true);
			}
		} else {
			success = event->loadFunction(node.attribute("function"), false);
		}

		if (success) {
			registerEvent(std::move(event), node);
		}
	}
	return true;
}

bool BaseEvents::reload() {
	loaded = false;
	clear(false);
	return loadFromXml();
}

void BaseEvents::reInitState(bool fromLua) {
	if (!fromLua) {
		getScriptInterface().reInitState();
	}
}

Event::Event(LuaScriptInterface* interface) : scriptInterface(interface) {}

bool Event::checkScript(const std::string& basePath, const std::string&
							scriptsName, const std::string& scriptFile) const {
	LuaScriptInterface* testInterface = g_luaEnvironment.getTestInterface();
	testInterface->reInitState();

	if (testInterface->loadFile(std::string(basePath + "lib/" + scriptsName +
															".lua")) == -1) {
		SPDLOG_WARN("[Event::checkScript] - Can not load {}lib/{}.lua",
					scriptsName, scriptsName);
	}

	if (scriptId != 0) {
		SPDLOG_WARN("[Event::checkScript] - Can not load scriptid: {}", scriptId);
		return false;
	}

	if (testInterface->loadFile(basePath + scriptFile) == -1) {
		SPDLOG_WARN("[Event::checkScript] - Can not load script: {}",
					scriptFile);
		SPDLOG_ERROR(testInterface->getLastLuaError());
		return false;
	}

	int32_t id = testInterface->getEvent(getScriptEventName());
	if (id == -1) {
		SPDLOG_WARN("[Event::checkScript] - Event "
					"{} not found {}", getScriptEventName(), scriptFile);
		return false;
	}
	return true;
}

bool Event::loadScript(const std::string& scriptFile) {
	if ((scriptInterface == nullptr) || scriptId != 0) {
		SPDLOG_WARN("[Event::loadScript] - ScriptInterface (nullptr), "
					"can not load scriptid: {}", scriptId);
		return false;
	}

	if (scriptInterface->loadFile(scriptFile) == -1) {
		SPDLOG_WARN("[Event::loadScript] - Can not load script: {}",
					scriptFile);
		SPDLOG_WARN(scriptInterface->getLastLuaError());
		return false;
	}

	int32_t id = scriptInterface->getEvent(getScriptEventName());
	if (id == -1) {
		SPDLOG_WARN("[Event::loadScript] - Event {} not found {}",
					getScriptEventName(), scriptFile);
		return false;
	}

	scripted = true;
	scriptId = id;
	return true;
}

bool Event::loadCallback() {
	if ((scriptInterface == nullptr) || scriptId != 0) {
		SPDLOG_WARN("[Event::loadScript] - ScriptInterface (nullptr), "
					"can not load scriptid: {}", scriptId);
		return false;
	}

	int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		SPDLOG_WARN("[Event::loadScript] - Event {} not found",
					getScriptEventName());
		return false;
	}

	scripted = true;
	scriptId = id;
	return true;
}

bool CallBack::loadCallBack(LuaScriptInterface* interface, const std::string&
																		name) {
	if (interface == nullptr) {
		SPDLOG_WARN("[Event::loadScript] - ScriptInterface (nullptr)");
		return false;
	}

	scriptInterface = interface;

	int32_t id = scriptInterface->getEvent(name.c_str());
	if (id == -1) {
		SPDLOG_WARN("[Event::loadScript] - Event {} not found",
					name);
		return false;
	}

	scriptId = id;
	loaded = true;
	return true;
}
