/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/global/globalevent.hpp"

#include "utils/tools.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lua/scripts/scripts.hpp"
#include "lib/di/container.hpp"

GlobalEvents::GlobalEvents() = default;
GlobalEvents::~GlobalEvents() = default;

GlobalEvents &GlobalEvents::getInstance() {
	return inject<GlobalEvents>();
}

void GlobalEvents::clear() {
	// Stop events
	g_dispatcher().stopEvent(thinkEventId);
	thinkEventId = 0;
	g_dispatcher().stopEvent(timerEventId);
	timerEventId = 0;

	// Clear maps
	thinkMap.clear();
	serverMap.clear();
	timerMap.clear();
}

bool GlobalEvents::registerLuaEvent(const std::shared_ptr<GlobalEvent> &globalEvent) {
	if (globalEvent->getEventType() == GLOBALEVENT_TIMER) {
		const auto result = timerMap.emplace(globalEvent->getName(), globalEvent);
		if (result.second) {
			if (timerEventId == 0) {
				timerEventId = g_dispatcher().scheduleEvent(
					SCHEDULER_MINTICKS, [this] { timer(); }, "GlobalEvents::timer"
				);
			}
			return true;
		}
	} else if (globalEvent->getEventType() != GLOBALEVENT_NONE) {
		const auto result = serverMap.emplace(globalEvent->getName(), globalEvent);
		if (result.second) {
			return true;
		}
	} else { // think event
		const auto result = thinkMap.emplace(globalEvent->getName(), globalEvent);
		if (result.second) {
			if (thinkEventId == 0) {
				thinkEventId = g_dispatcher().scheduleEvent(
					SCHEDULER_MINTICKS, [this] { think(); }, "GlobalEvents::think"
				);
			}
			return true;
		}
	}

	g_logger().warn("Duplicate registered globalevent with name: {}", globalEvent->getName());
	return false;
}

void GlobalEvents::startup() const {
	execute(GLOBALEVENT_STARTUP);
}

void GlobalEvents::shutdown() const {
	execute(GLOBALEVENT_SHUTDOWN);
}

void GlobalEvents::save() const {
	execute(GLOBALEVENT_SAVE);
}

void GlobalEvents::timer() {
	const time_t now = time(nullptr);

	int64_t nextScheduledTime = std::numeric_limits<int64_t>::max();

	auto it = timerMap.begin();
	while (it != timerMap.end()) {
		const auto &globalEvent = it->second;

		int64_t nextExecutionTime = globalEvent->getNextExecution() - now;
		if (nextExecutionTime > 0) {
			if (nextExecutionTime < nextScheduledTime) {
				nextScheduledTime = nextExecutionTime;
			}

			++it;
			continue;
		}

		if (!globalEvent->executeEvent()) {
			it = timerMap.erase(it);
			continue;
		}

		nextExecutionTime = 86400;
		if (nextExecutionTime < nextScheduledTime) {
			nextScheduledTime = nextExecutionTime;
		}

		globalEvent->setNextExecution(globalEvent->getNextExecution() + nextExecutionTime);

		++it;
	}

	if (nextScheduledTime != std::numeric_limits<int64_t>::max()) {
		timerEventId = g_dispatcher().scheduleEvent(
			std::max<int64_t>(1000, nextScheduledTime * 1000), [this] { timer(); }, __FUNCTION__
		);
	}
}

void GlobalEvents::think() {
	const int64_t now = OTSYS_TIME();

	int64_t nextScheduledTime = std::numeric_limits<int64_t>::max();
	for (const auto &[globalEventName, globalEvent] : thinkMap) {
		int64_t nextExecutionTime = globalEvent->getNextExecution() - now;
		if (nextExecutionTime > 0) {
			if (nextExecutionTime < nextScheduledTime) {
				nextScheduledTime = nextExecutionTime;
			}
			continue;
		}

		g_logger().trace("[GlobalEvents::think] - Executing event: {}", globalEvent->getName());

		if (!globalEvent->executeEvent()) {
			g_logger().error("[GlobalEvents::think] - "
			                 "Failed to execute event: {}",
			                 globalEvent->getName());
		}

		nextExecutionTime = globalEvent->getInterval();
		if (nextExecutionTime < nextScheduledTime) {
			nextScheduledTime = nextExecutionTime;
		}

		globalEvent->setNextExecution(globalEvent->getNextExecution() + nextExecutionTime);
	}

	if (nextScheduledTime != std::numeric_limits<int64_t>::max()) {
		const auto delay = static_cast<uint32_t>(nextScheduledTime);
		thinkEventId = g_dispatcher().scheduleEvent(
			delay, [this] { think(); }, "GlobalEvents::think"
		);
	}
}

void GlobalEvents::execute(GlobalEvent_t type) const {
	for (const auto &[globalEventName, globalEvent] : serverMap) {
		if (globalEvent->getEventType() == type) {
			globalEvent->executeEvent();
		}
	}
}

GlobalEventMap GlobalEvents::getEventMap(GlobalEvent_t type) {
	// TODO: This should be better implemented. Maybe have a map for every type.
	switch (type) {
		case GLOBALEVENT_NONE:
			return thinkMap;
		case GLOBALEVENT_TIMER:
			return timerMap;
		case GLOBALEVENT_PERIODCHANGE:
		case GLOBALEVENT_STARTUP:
		case GLOBALEVENT_SHUTDOWN:
		case GLOBALEVENT_RECORD:
		case GLOBALEVENT_SAVE: {
			GlobalEventMap retMap;
			for (const auto &it : serverMap) {
				if (it.second->getEventType() == type) {
					retMap.emplace(it.first, it.second);
				}
			}
			return retMap;
		}
		default:
			return GlobalEventMap();
	}
}

GlobalEvent::GlobalEvent() = default;

LuaScriptInterface* GlobalEvent::getScriptInterface() const {
	return &g_scripts().getScriptInterface();
}

bool GlobalEvent::loadScriptId() {
	LuaScriptInterface &luaInterface = g_scripts().getScriptInterface();
	m_scriptId = luaInterface.getEvent();
	if (m_scriptId == -1) {
		g_logger().error("[MoveEvent::loadScriptId] Failed to load event. Script name: '{}', Module: '{}'", luaInterface.getLoadingScriptName(), luaInterface.getInterfaceName());
		return false;
	}

	return true;
}

int32_t GlobalEvent::getScriptId() const {
	return m_scriptId;
}

void GlobalEvent::setScriptId(int32_t newScriptId) {
	m_scriptId = newScriptId;
}

bool GlobalEvent::isLoadedScriptId() const {
	return m_scriptId != 0;
}

std::string GlobalEvent::getScriptTypeName() const {
	switch (eventType) {
		case GLOBALEVENT_STARTUP:
			return "onStartup";
		case GLOBALEVENT_SHUTDOWN:
			return "onShutdown";
		case GLOBALEVENT_RECORD:
			return "onRecord";
		case GLOBALEVENT_TIMER:
			return "onTime";
		case GLOBALEVENT_PERIODCHANGE:
			return "onPeriodChange";
		case GLOBALEVENT_ON_THINK:
			return "onThink";
		case GLOBALEVENT_SAVE:
			return "onSave";
		default:
			g_logger().error("[GlobalEvent::getScriptTypeName] - Invalid event type");
			return {};
	}
}

bool GlobalEvent::executePeriodChange(LightState_t lightState, LightInfo lightInfo) const {
	// onPeriodChange(lightState, lightTime)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[GlobalEvent::executePeriodChange - {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	lua_pushnumber(L, lightState);
	lua_pushnumber(L, lightInfo.level);
	return getScriptInterface()->callFunction(2);
}

bool GlobalEvent::executeRecord(uint32_t current, uint32_t old) const {
	// onRecord(current, old)
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[GlobalEvent::executeRecord - {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());

	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	lua_pushnumber(L, current);
	lua_pushnumber(L, old);
	return getScriptInterface()->callFunction(2);
}

bool GlobalEvent::executeEvent() const {
	if (!LuaScriptInterface::reserveScriptEnv()) {
		g_logger().error("[GlobalEvent::executeEvent - {}] "
		                 "Call stack overflow. Too many lua script calls being nested.",
		                 getName());
		return false;
	}

	ScriptEnvironment* env = LuaScriptInterface::getScriptEnv();
	env->setScriptId(getScriptId(), getScriptInterface());
	lua_State* L = getScriptInterface()->getLuaState();
	getScriptInterface()->pushFunction(getScriptId());

	int32_t params = 0;
	if (eventType == GLOBALEVENT_NONE || eventType == GLOBALEVENT_TIMER) {
		lua_pushnumber(L, interval);
		params = 1;
	}

	return getScriptInterface()->callFunction(params);
}
