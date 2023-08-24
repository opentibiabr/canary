/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lua/global/baseevents.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "utils/tools.hpp"

bool BaseEvents::loadFromXml() {
	if (loaded) {
		g_logger().error("[BaseEvents::loadFromXml] - It's already loaded.");
		return false;
	}

	std::string scriptsName = getScriptBaseName();
	std::string basePath = g_configManager().getString(CORE_DIRECTORY) + "/" + scriptsName + "/";
	if (getScriptInterface().loadFile(
			basePath + "lib/" + scriptsName + ".lua",
			scriptsName + ".lua"
		)
		== -1) {
		g_logger().warn(__FUNCTION__, scriptsName, scriptsName);
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
			g_logger().warn("[BaseEvents::loadFromXml] - Failed to configure event");
			continue;
		}

		bool success;

		pugi::xml_attribute scriptAttribute = node.attribute("script");
		if (scriptAttribute) {
			std::string scriptFile = "scripts/" + std::string(scriptAttribute.as_string());
			success = event->checkScript(basePath, scriptsName, scriptFile)
				&& event->loadScript(basePath + scriptFile, scriptAttribute.as_string());
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

void BaseEvents::reInitState() {
	getScriptInterface().reInitState();
}

Event::Event(LuaScriptInterface* interface) :
	scriptInterface(interface) { }

bool Event::checkScript(const std::string &basePath, const std::string &scriptsName, const std::string &scriptFile) const {
	LuaScriptInterface* testInterface = g_luaEnvironment().getTestInterface();
	testInterface->reInitState();

	if (testInterface->loadFile(basePath + "lib/" + scriptsName + ".lua", scriptsName + ".lua") == -1) {
		g_logger().warn("[Event::checkScript] - Can not load {}lib/{}.lua", scriptsName, scriptsName);
	}

	if (scriptId != 0) {
		g_logger().warn("[Event::checkScript] - Can not load scriptid: {}", scriptId);
		return false;
	}

	if (testInterface->loadFile(basePath + scriptFile, scriptsName + ".lua") == -1) {
		g_logger().warn("[Event::checkScript] - Can not load script: {}", scriptFile);
		g_logger().error(testInterface->getLastLuaError());
		return false;
	}

	int32_t id = testInterface->getEvent(getScriptEventName());
	if (id == -1) {
		g_logger().warn("[Event::checkScript] - Event "
						"{} not found {}",
						getScriptEventName(), scriptFile);
		return false;
	}
	return true;
}

bool Event::loadScript(const std::string &scriptFile, const std::string &scriptName) {
	if ((scriptInterface == nullptr) || scriptId != 0) {
		g_logger().warn(
			"[{}] - ScriptInterface (nullptr), can not load scriptid: {}",
			__FUNCTION__, scriptId
		);
		return false;
	}

	if (scriptInterface->loadFile(scriptFile, scriptName) == -1) {
		g_logger().warn("[Event::loadScript] - Can not load script: {}", scriptFile);
		g_logger().warn(scriptInterface->getLastLuaError());
		return false;
	}

	int32_t id = scriptInterface->getEvent(getScriptEventName());
	if (id == -1) {
		g_logger().warn(
			"[Event::loadScript] - Event {} not found {}",
			getScriptEventName(),
			scriptFile
		);
		return false;
	}

	scripted = true;
	scriptId = id;
	return true;
}

bool CallBack::loadCallBack(LuaScriptInterface* interface, const std::string &name) {
	if (interface == nullptr) {
		g_logger().warn("[{}] - ScriptInterface (nullptr) for event: {}", __FUNCTION__, name);
		return false;
	}

	scriptInterface = interface;

	int32_t id = scriptInterface->getEvent(name.c_str());
	if (id == -1) {
		g_logger().warn("[{}] - Event {} not found", __FUNCTION__, name);
		return false;
	}

	scriptId = id;
	loaded = true;
	return true;
}
