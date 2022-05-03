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

#include "otpch.h"

#include "lua/global/globalevent.h"
#include "utils/tools.h"
#include "game/scheduling/scheduler.h"

void GlobalEvents::clear() {
	// Stop events
	g_scheduler().stopEvent(thinkEventId);
	thinkEventId = 0;
	g_scheduler().stopEvent(timerEventId);
	timerEventId = 0;

	// Clear maps
	thinkMap.clear();
	serverMap.clear();
	timerMap.clear();
}

bool GlobalEvents::registerLuaEvent(GlobalEvent* event) {
	GlobalEvent_ptr globalEvent{ event };
	if (globalEvent->getEventType() == GLOBALEVENT_TIMER) {
		auto result = timerMap.emplace(globalEvent->getName(), std::move(*globalEvent));
		if (result.second) {
			if (timerEventId == 0) {
				timerEventId = g_scheduler().addEvent(createSchedulerTask(SCHEDULER_MINTICKS, std::bind(&GlobalEvents::timer, this)));
			}
			return true;
		}
	} else if (globalEvent->getEventType() != GLOBALEVENT_NONE) {
		auto result = serverMap.emplace(globalEvent->getName(), std::move(*globalEvent));
		if (result.second) {
			return true;
		}
	} else { // think event
		auto result = thinkMap.emplace(globalEvent->getName(), std::move(*globalEvent));
		if (result.second) {
			if (thinkEventId == 0) {
				thinkEventId = g_scheduler().addEvent(createSchedulerTask(SCHEDULER_MINTICKS, std::bind(&GlobalEvents::think, this)));
			}
			return true;
		}
	}

	SPDLOG_WARN("Duplicate registered globalevent with name: {}", globalEvent->getName());
	return false;
}

void GlobalEvents::startup() const {
	execute(GLOBALEVENT_STARTUP);
}

void GlobalEvents::timer() {
	time_t now = time(nullptr);

	int64_t nextScheduledTime = std::numeric_limits<int64_t>::max();

	auto it = timerMap.begin();
	while (it != timerMap.end()) {
		GlobalEvent& globalEvent = it->second;

		int64_t nextExecutionTime = globalEvent.getNextExecution() - now;
		if (nextExecutionTime > 0) {
			if (nextExecutionTime < nextScheduledTime) {
				nextScheduledTime = nextExecutionTime;
			}

			++it;
			continue;
		}

		if (!globalEvent.executeEvent()) {
			it = timerMap.erase(it);
			continue;
		}

		nextExecutionTime = 86400;
		if (nextExecutionTime < nextScheduledTime) {
			nextScheduledTime = nextExecutionTime;
		}

		globalEvent.setNextExecution(globalEvent.getNextExecution() + nextExecutionTime);

		++it;
	}

	if (nextScheduledTime != std::numeric_limits<int64_t>::max()) {
		timerEventId = g_scheduler().addEvent(createSchedulerTask(std::max<int64_t>(1000, nextScheduledTime * 1000),
											std::bind(&GlobalEvents::timer, this)));
	}
}

void GlobalEvents::think() {
	int64_t now = OTSYS_TIME();

	int64_t nextScheduledTime = std::numeric_limits<int64_t>::max();
	for (auto& it : thinkMap) {
		GlobalEvent& globalEvent = it.second;

		int64_t nextExecutionTime = globalEvent.getNextExecution() - now;
		if (nextExecutionTime > 0) {
			if (nextExecutionTime < nextScheduledTime) {
				nextScheduledTime = nextExecutionTime;
			}
			continue;
		}

		if (!globalEvent.executeEvent()) {
			SPDLOG_ERROR("[GlobalEvents::think] - "
                         "Failed to execute event: {}", globalEvent.getName());
		}

		nextExecutionTime = globalEvent.getInterval();
		if (nextExecutionTime < nextScheduledTime) {
			nextScheduledTime = nextExecutionTime;
		}

		globalEvent.setNextExecution(globalEvent.getNextExecution() + nextExecutionTime);
	}

	if (nextScheduledTime != std::numeric_limits<int64_t>::max()) {
		thinkEventId = g_scheduler().addEvent(createSchedulerTask(nextScheduledTime, std::bind(&GlobalEvents::think, this)));
	}
}

void GlobalEvents::execute(GlobalEvent_t type) const {
	for (const auto& it : serverMap) {
		const GlobalEvent& globalEvent = it.second;
		if (globalEvent.getEventType() == type) {
			globalEvent.executeEvent();
		}
	}
}

GlobalEventMap GlobalEvents::getEventMap(GlobalEvent_t type) {
	// TODO: This should be better implemented. Maybe have a map for every type.
	switch (type) {
		case GLOBALEVENT_NONE: return thinkMap;
		case GLOBALEVENT_TIMER: return timerMap;
		case GLOBALEVENT_PERIODCHANGE:
		case GLOBALEVENT_STARTUP:
		case GLOBALEVENT_SHUTDOWN:
		case GLOBALEVENT_RECORD: {
			GlobalEventMap retMap;
			for (const auto& it : serverMap) {
				if (it.second.getEventType() == type) {
					retMap.emplace(it.first, it.second);
				}
			}
			return retMap;
		}
		default: return GlobalEventMap();
	}
}

GlobalEvent::GlobalEvent(LuaScriptInterface* interface) : Script(interface) {}

std::string GlobalEvent::getScriptTypeName() const {
	switch (eventType) {
		case GLOBALEVENT_STARTUP: return "onStartup";
		case GLOBALEVENT_SHUTDOWN: return "onShutdown";
		case GLOBALEVENT_RECORD: return "onRecord";
		case GLOBALEVENT_TIMER: return "onTime";
		case GLOBALEVENT_PERIODCHANGE: return "onPeriodChange";
		case GLOBALEVENT_ON_THINK: return "onThink";
		default:
			SPDLOG_ERROR("[GlobalEvent::getScriptTypeName] - Invalid event type for script with name {}", getFileName());
			return std::string();
	}
}

bool GlobalEvent::executePeriodChange(LightState_t lightState, LightInfo lightInfo) {
	//onPeriodChange(lightState, lightTime)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[GlobalEvent::executePeriodChange - {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();
	scriptInterface->pushFunction(scriptId);

	lua_pushnumber(L, lightState);
	lua_pushnumber(L, lightInfo.level);
	return scriptInterface->callFunction(2);
}

bool GlobalEvent::executeRecord(uint32_t current, uint32_t old) {
	//onRecord(current, old)
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[GlobalEvent::executeRecord - {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);

	lua_State* L = scriptInterface->getLuaState();
	scriptInterface->pushFunction(scriptId);

	lua_pushnumber(L, current);
	lua_pushnumber(L, old);
	return scriptInterface->callFunction(2);
}

bool GlobalEvent::executeEvent() const {
	if (!scriptInterface->reserveScriptEnv()) {
		SPDLOG_ERROR("[GlobalEvent::executeEvent - {}] "
                    "Call stack overflow. Too many lua script calls being nested.",
                    getName());
		return false;
	}

	ScriptEnvironment* env = scriptInterface->getScriptEnv();
	env->setScriptId(scriptId, scriptInterface);
	lua_State* L = scriptInterface->getLuaState();
	scriptInterface->pushFunction(scriptId);

	int32_t params = 0;
	if (eventType == GLOBALEVENT_NONE || eventType == GLOBALEVENT_TIMER) {
		lua_pushnumber(L, interval);
		params = 1;
	}

	return scriptInterface->callFunction(params);
}
