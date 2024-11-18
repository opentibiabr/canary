/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/scripts/luascript.hpp"

#include "lua/scripts/lua_environment.hpp"
#include "lib/metrics/metrics.hpp"

ScriptEnvironment::DBResultMap ScriptEnvironment::tempResults;
uint32_t ScriptEnvironment::lastResultId = 0;
std::multimap<ScriptEnvironment*, std::shared_ptr<Item>> ScriptEnvironment::tempItems;

ScriptEnvironment Lua::scriptEnv[16];
int32_t Lua::scriptEnvIndex = -1;

LuaScriptInterface::LuaScriptInterface(std::string initInterfaceName) :
	interfaceName(std::move(initInterfaceName)) {
}

LuaScriptInterface::~LuaScriptInterface() {
	LuaScriptInterface::closeState();
}

bool LuaScriptInterface::reInitState() {
	g_luaEnvironment().clearAreaObjects(this);

	closeState();
	return initState();
}

/// Same as lua_pcall, but adds stack trace to error strings in called function.
int32_t LuaScriptInterface::loadFile(const std::string &file, const std::string &scriptName) {
	// loads file as a chunk at stack top
	int ret = luaL_loadfile(luaState, file.c_str());
	if (ret != 0) {
		lastLuaError = popString(luaState);
		return -1;
	}

	// check that it is loaded as a function
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	loadingFile = file;
	setLoadingScriptName(scriptName);

	if (!reserveScriptEnv()) {
		return -1;
	}

	ScriptEnvironment* env = getScriptEnv();
	env->setScriptId(EVENT_ID_LOADING, this);
	// env->setNpc(npc);

	// execute it
	ret = protectedCall(luaState, 0, 0);
	if (ret != 0) {
		reportError(nullptr, popString(luaState));
		resetScriptEnv();
		return -1;
	}

	resetScriptEnv();
	return 0;
}

int32_t LuaScriptInterface::getEvent(const std::string &eventName) {
	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// get current event function pointer
	lua_getglobal(luaState, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -3, runningEventId);
	lua_pop(luaState, 2);

	// reset global value of this event
	lua_pushnil(luaState);
	lua_setglobal(luaState, eventName.c_str());

	cacheFiles[runningEventId] = loadingFile + ":" + eventName;
	return runningEventId++;
}

int32_t LuaScriptInterface::getEvent() {
	// check if function is on the stack
	if (!isFunction(luaState, -1)) {
		return -1;
	}

	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -2);
	lua_rawseti(luaState, -2, runningEventId);
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":callback";
	return runningEventId++;
}

int32_t LuaScriptInterface::getMetaEvent(const std::string &globalName, const std::string &eventName) {
	// get our events table
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		return -1;
	}

	// get current event function pointer
	lua_getglobal(luaState, globalName.c_str());
	lua_getfield(luaState, -1, eventName.c_str());
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 3);
		return -1;
	}

	// save in our events table
	lua_pushvalue(luaState, -1);
	lua_rawseti(luaState, -4, runningEventId);
	lua_pop(luaState, 1);

	// reset global value of this event
	lua_pushnil(luaState);
	lua_setfield(luaState, -2, eventName.c_str());
	lua_pop(luaState, 2);

	cacheFiles[runningEventId] = loadingFile + ":" + globalName + "@" + eventName;
	return runningEventId++;
}

const std::string &LuaScriptInterface::getFileById(int32_t scriptId) {
	if (scriptId == EVENT_ID_LOADING) {
		return loadingFile;
	}

	const auto it = cacheFiles.find(scriptId);
	if (it == cacheFiles.end()) {
		static const std::string &unk = "(Unknown scriptfile)";
		return unk;
	}
	return it->second;
}

std::string LuaScriptInterface::getStackTrace(const std::string &error_desc) const {
	lua_getglobal(luaState, "debug");
	if (!isTable(luaState, -1)) {
		lua_pop(luaState, 1);
		g_logger().error("Lua debug table not found.");
		return error_desc;
	}

	lua_getfield(luaState, -1, "traceback");
	if (!isFunction(luaState, -1)) {
		lua_pop(luaState, 2);
		g_logger().error("Lua traceback function not found.");
		return error_desc;
	}

	lua_replace(luaState, -2);
	pushString(luaState, error_desc);
	if (lua_pcall(luaState, 1, 1, 0) != LUA_OK) {
		std::string luaError = lua_tostring(luaState, -1);
		lua_pop(luaState, 1);
		g_logger().error("Error running Lua traceback: {}", luaError);
		return "Lua traceback failed: " + luaError;
	}

	std::string stackTrace = popString(luaState);

	return stackTrace;
}

bool LuaScriptInterface::pushFunction(int32_t functionId) const {
	lua_rawgeti(luaState, LUA_REGISTRYINDEX, eventTableRef);
	if (!isTable(luaState, -1)) {
		return false;
	}

	lua_rawgeti(luaState, -1, functionId);
	lua_replace(luaState, -2);
	return isFunction(luaState, -1);
}

bool LuaScriptInterface::initState() {
	luaState = g_luaEnvironment().getLuaState();
	if (!luaState) {
		return false;
	}

	lua_newtable(luaState);
	eventTableRef = luaL_ref(luaState, LUA_REGISTRYINDEX);
	runningEventId = EVENT_ID_USER;
	return true;
}

bool LuaScriptInterface::closeState() {
	if (LuaEnvironment::isShuttingDown()) {
		luaState = nullptr;
	}

	if (!luaState || !g_luaEnvironment().getLuaState()) {
		return false;
	}

	cacheFiles.clear();
	if (eventTableRef != -1) {
		luaL_unref(luaState, LUA_REGISTRYINDEX, eventTableRef);
		eventTableRef = -1;
	}

	luaState = nullptr;
	return true;
}

std::string LuaScriptInterface::getMetricsScope() const {
#ifdef FEATURE_METRICS
	metrics::method_latency measure(__METRICS_METHOD_NAME__);
	int32_t scriptId;
	int32_t callbackId;
	bool timerEvent;
	LuaScriptInterface* scriptInterface;
	getScriptEnv()->getEventInfo(scriptId, scriptInterface, callbackId, timerEvent);

	std::string name;
	if (scriptId == EVENT_ID_LOADING) {
		name = "loading";
	} else if (scriptId == EVENT_ID_USER) {
		name = "user";
	} else {
		name = scriptInterface->getFileById(scriptId);
		if (name.empty()) {
			return "unknown";
		}
		const auto pos = name.find("data");
		if (pos != std::string::npos) {
			name = name.substr(pos);
		}
	}

	return fmt::format("{}:{}", name, timerEvent ? "timer" : "<direct>");
#else
	return {};
#endif
}

bool LuaScriptInterface::callFunction(int params) const {
	metrics::lua_latency measure(getMetricsScope());
	bool result = false;
	const int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::getString(luaState, -1));
	} else {
		result = LuaScriptInterface::getBoolean(luaState, -1);
	}

	lua_pop(luaState, 1);
	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
	return result;
}

void LuaScriptInterface::callVoidFunction(int params) const {
	metrics::lua_latency measure(getMetricsScope());
	const int size = lua_gettop(luaState);
	if (protectedCall(luaState, params, 0) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(luaState));
	}

	if ((lua_gettop(luaState) + params + 1) != size) {
		LuaScriptInterface::reportError(nullptr, "Stack size changed!");
	}

	resetScriptEnv();
}
