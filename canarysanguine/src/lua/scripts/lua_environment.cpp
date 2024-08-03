/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "declarations.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "lua/scripts/script_environment.hpp"
#include "lua/global/lua_timer_event_descr.hpp"

bool LuaEnvironment::shuttingDown = false;

static const std::unique_ptr<AreaCombat> &AreaCombatNull {};

LuaEnvironment::LuaEnvironment() :
	LuaScriptInterface("Main Interface") { }

LuaEnvironment::~LuaEnvironment() {
	if (!testInterface) {
	}

	LuaEnvironment::shuttingDown = true;
	closeState();
}

lua_State* LuaEnvironment::getLuaState() {
	if (LuaEnvironment::isShuttingDown()) {
		return luaState;
	}

	if (luaState == nullptr) {
		initState();
	}

	return luaState;
}

bool LuaEnvironment::initState() {
	luaState = luaL_newstate();
	LuaFunctionsLoader::load(luaState);
	runningEventId = EVENT_ID_USER;

	return true;
}

bool LuaEnvironment::reInitState() {
	// TODO(lgrossi): get children, reload children
	closeState();
	return initState();
}

bool LuaEnvironment::closeState() {
	if (!luaState) {
		return false;
	}

	for (const auto &combatEntry : combatIdMap) {
		clearCombatObjects(combatEntry.first);
	}

	for (const auto &areaEntry : areaIdMap) {
		clearAreaObjects(areaEntry.first);
	}

	for (auto &timerEntry : timerEvents) {
		LuaTimerEventDesc timerEventDesc = std::move(timerEntry.second);
		for (int32_t parameter : timerEventDesc.parameters) {
			luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
		}
		luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	}

	combatIdMap.clear();
	areaIdMap.clear();
	timerEvents.clear();
	cacheFiles.clear();

	lua_close(luaState);
	luaState = nullptr;
	return true;
}

LuaScriptInterface* LuaEnvironment::getTestInterface() {
	if (!testInterface) {
		testInterface = new LuaScriptInterface("Test Interface");
		testInterface->initState();
	}
	return testInterface;
}

std::shared_ptr<Combat> LuaEnvironment::getCombatObject(uint32_t id) const {
	auto it = combatMap.find(id);
	if (it == combatMap.end()) {
		return nullptr;
	}
	return it->second;
}

std::shared_ptr<Combat> LuaEnvironment::createCombatObject(LuaScriptInterface* interface) {
	auto combat = std::make_shared<Combat>();
	combatMap[++lastCombatId] = combat;
	combatIdMap[interface].push_back(lastCombatId);
	return combat;
}

void LuaEnvironment::clearCombatObjects(LuaScriptInterface* interface) {
	auto it = combatIdMap.find(interface);
	if (it == combatIdMap.end()) {
		return;
	}

	it->second.clear();
	combatMap.clear();
}

const std::unique_ptr<AreaCombat> &LuaEnvironment::getAreaObject(uint32_t id) const {
	auto it = areaMap.find(id);
	if (it == areaMap.end()) {
		return AreaCombatNull;
	}
	return it->second;
}

uint32_t LuaEnvironment::createAreaObject(LuaScriptInterface* interface) {
	areaMap[++lastAreaId] = std::make_unique<AreaCombat>();
	areaIdMap[interface].push_back(lastAreaId);
	return lastAreaId;
}

void LuaEnvironment::clearAreaObjects(LuaScriptInterface* interface) {
	auto it = areaIdMap.find(interface);
	if (it == areaIdMap.end()) {
		return;
	}

	for (uint32_t id : it->second) {
		auto itt = areaMap.find(id);
		if (itt != areaMap.end()) {
			areaMap.erase(itt);
		}
	}
	it->second.clear();
}

void LuaEnvironment::executeTimerEvent(uint32_t eventIndex) {
	auto it = timerEvents.find(eventIndex);
	if (it == timerEvents.end()) {
		return;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it->second);
	timerEvents.erase(it);

	// push function
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);

	// push parameters
	for (auto parameter : std::views::reverse(timerEventDesc.parameters)) {
		lua_rawgeti(luaState, LUA_REGISTRYINDEX, parameter);
	}

	// call the function
	if (reserveScriptEnv()) {
		ScriptEnvironment* env = getScriptEnv();
		env->setTimerEvent();
		env->setScriptId(timerEventDesc.scriptId, this);
		callFunction(timerEventDesc.parameters.size());
	} else {
		g_logger().error("[LuaEnvironment::executeTimerEvent - Lua file {}] "
		                 "Call stack overflow. Too many lua script calls being nested",
		                 getLoadingFile());
	}

	// free resources
	luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	for (auto parameter : timerEventDesc.parameters) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
	}
}

void LuaEnvironment::collectGarbage() const {
	// prevents recursive collects
	static bool collecting = false;
	if (!collecting) {
		collecting = true;

		// we must collect two times because __gc metamethod
		// is called on uservalues only the second time
		for (int i = -1; ++i < 2;) {
			lua_gc(luaState, LUA_GCCOLLECT, 0);
		}

		collecting = false;
	}
}
