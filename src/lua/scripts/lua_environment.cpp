/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#include "declarations.hpp"
#include "lua/scripts/lua_environment.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "lua/scripts/script_environment.hpp"

LuaEnvironment::LuaEnvironment(): LuaScriptInterface("Main Interface") {}

LuaEnvironment::~LuaEnvironment() {
	if (!testInterface) {
		delete testInterface;
	}
	closeState();
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

	for (const auto & combatEntry: combatIdMap) {
		clearCombatObjects(combatEntry.first);
	}

	for (const auto & areaEntry: areaIdMap) {
		clearAreaObjects(areaEntry.first);
	}

	for (auto & timerEntry: timerEvents) {
		LuaTimerEventDesc timerEventDesc = std::move(timerEntry.second);
		for (int32_t parameter: timerEventDesc.parameters) {
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

LuaScriptInterface * LuaEnvironment::getTestInterface() {
	if (!testInterface) {
		testInterface = new LuaScriptInterface("Test Interface");
		testInterface -> initState();
	}
	return testInterface;
}

Combat * LuaEnvironment::getCombatObject(uint32_t id) const {
	auto it = combatMap.find(id);
	if (it == combatMap.end()) {
		return nullptr;
	}
	return it -> second;
}

Combat * LuaEnvironment::createCombatObject(LuaScriptInterface * interface) {
	Combat * combat = new Combat;
	combatMap[++lastCombatId] = combat;
	combatIdMap[interface].push_back(lastCombatId);
	return combat;
}

void LuaEnvironment::clearCombatObjects(LuaScriptInterface * interface) {
	auto it = combatIdMap.find(interface);
	if (it == combatIdMap.end()) {
		return;
	}

	for (uint32_t id: it -> second) {
		auto itt = combatMap.find(id);
		if (itt != combatMap.end()) {
			delete itt -> second;
			combatMap.erase(itt);
		}
	}
	it -> second.clear();
}

AreaCombat * LuaEnvironment::getAreaObject(uint32_t id) const {
	auto it = areaMap.find(id);
	if (it == areaMap.end()) {
		return nullptr;
	}
	return it -> second;
}

uint32_t LuaEnvironment::createAreaObject(LuaScriptInterface * interface) {
	areaMap[++lastAreaId] = new AreaCombat;
	areaIdMap[interface].push_back(lastAreaId);
	return lastAreaId;
}

void LuaEnvironment::clearAreaObjects(LuaScriptInterface * interface) {
	auto it = areaIdMap.find(interface);
	if (it == areaIdMap.end()) {
		return;
	}

	for (uint32_t id: it -> second) {
		auto itt = areaMap.find(id);
		if (itt != areaMap.end()) {
			delete itt -> second;
			areaMap.erase(itt);
		}
	}
	it -> second.clear();
}

void LuaEnvironment::executeTimerEvent(uint32_t eventIndex) {
	auto it = timerEvents.find(eventIndex);
	if (it == timerEvents.end()) {
		return;
	}

	LuaTimerEventDesc timerEventDesc = std::move(it -> second);
	timerEvents.erase(it);

	// push function
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);

	// push parameters
	for (auto parameter: boost::adaptors::reverse(timerEventDesc.parameters)) {
		lua_rawgeti(luaState, LUA_REGISTRYINDEX, parameter);
	}

	// call the function
	if (reserveScriptEnv()) {
		ScriptEnvironment * env = getScriptEnv();
		env -> setTimerEvent();
		env -> setScriptId(timerEventDesc.scriptId, this);
		callFunction(timerEventDesc.parameters.size());
	} else {
		SPDLOG_ERROR("[LuaEnvironment::executeTimerEvent - Lua file {}] "
			"Call stack overflow. Too many lua script calls being nested",
			getLoadingFile());
	}

	// free resources
	luaL_unref(luaState, LUA_REGISTRYINDEX, timerEventDesc.function);
	for (auto parameter: timerEventDesc.parameters) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, parameter);
	}
}
