/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/scheduling/dispatcher_types.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <atomic>
	#include <chrono>
	#include <cstdint>
	#include <functional>
	#include <memory>
	#include <string_view>
	#include <unordered_set>
#endif

class Dispatcher;

class Task {
public:
	using Clock = std::chrono::steady_clock;

	Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context, Clock::time_point enqueuedAt = Clock::now());

	Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle = false, bool log = true, Clock::time_point enqueuedAt = Clock::now());

	Task(const Task &) = delete;
	Task &operator=(const Task &) = delete;
	Task(Task &&) noexcept = default;
	Task &operator=(Task &&) noexcept = default;
	~Task() = default;

	uint64_t getId() {
		if (id == 0) {
			if (++LAST_EVENT_ID == 0) {
				LAST_EVENT_ID = 1;
			}
			id = LAST_EVENT_ID;
		}
		return id;
	}

	[[nodiscard]] uint32_t getDelay() const {
		return delay;
	}

	[[nodiscard]] std::string_view getContext() const {
		return context;
	}

	[[nodiscard]] auto getTime() const {
		return utime;
	}

	[[nodiscard]] Clock::time_point getEnqueuedAt() const {
		return enqueuedAt;
	}

	[[nodiscard]] Clock::time_point getReadyAt() const {
		return meta.readyAt;
	}

	[[nodiscard]] const TaskMeta &getMeta() const {
		return meta;
	}

	void setLane(DispatcherLane lane) {
		if (dispatcherSlotReserved) {
			return;
		}
		meta.lane = lane;
		meta.executionMode = defaultExecutionMode(lane);
	}

	void setExecutionMode(ExecutionMode executionMode) {
		if (dispatcherSlotReserved) {
			return;
		}
		meta.executionMode = executionMode;
	}

	void setProducerToken(uint64_t producerToken) {
		if (dispatcherSlotReserved) {
			return;
		}
		meta.producerToken = producerToken;
	}

	void setGeneration(uint64_t generation) {
		if (dispatcherSlotReserved) {
			return;
		}
		meta.generation = generation;
	}

	void setEstimatedCost(uint32_t estimatedCost) {
		if (dispatcherSlotReserved) {
			return;
		}
		meta.estimatedCost = std::clamp<uint32_t>(estimatedCost, 1, DISPATCHER_MAX_TASK_COST);
	}

	[[nodiscard]] bool hasExpired() const;

	[[nodiscard]] bool isCycle() const {
		return cycle;
	}

	[[nodiscard]] bool isCanceled() const {
		return func == nullptr;
	}

	void cancel() {
		func = nullptr;
	}

	bool execute() const;

private:
	static std::atomic_uint_fast64_t LAST_EVENT_ID;
	/**
	 * @brief Returns a stable context view shared by tasks with the same name.
	 *
	 * Dispatcher hotpaths create many short-lived Task objects. Interning keeps
	 * the logging/metrics context stable without allocating a new string for
	 * every task.
	 */
	static std::string_view internContext(std::string_view context);

	void updateTime(Clock::time_point rescheduledAt = Clock::now());
	bool hasTraceableContext() const {
		const static std::unordered_set<std::string_view> tasksContext = {
			"Decay::checkDecay",
			"Creature::checkCreatureAttack",
			"Game::checkCreatureWalk",
			"Game::checkCreatures",
			"Game::checkLight",
			"Game::createFiendishMonsters",
			"Game::createInfluencedMonsters",
			"Game::updateForgeableMonsters",
			"Game::addCreatureCheck",
			"GlobalEvents::think",
			"LuaEnvironment::executeTimerEvent",
			"Modules::executeOnRecvbyte",
			"OutputMessagePool::sendAll",
			"ProtocolGame::addGameTask",
			"ProtocolGame::parsePacketFromDispatcher",
			"Raids::checkRaids",
			"SpawnMonster::checkSpawnMonster",
			"SpawnMonster::scheduleSpawn",
			"SpawnMonster::startup",
			"SpawnNpc::checkSpawnNpc",
			"Webhook::run",
			"Protocol::sendRecvMessageCallback",
			"Player::addInFightTicks",
			"Map::moveCreature",
			"Creature::goToFollowCreature_async"
		};

		return tasksContext.contains(context);
	}

	struct Compare {
		bool operator()(const std::shared_ptr<Task> &a, const std::shared_ptr<Task> &b) const {
			return a->getTime() < b->getTime();
		}
	};

	std::function<void(void)> func;
	std::string_view context;
	Clock::time_point enqueuedAt;
	TaskMeta meta;

	int64_t utime = 0;
	int64_t expiration = 0;
	uint64_t id = 0;
	uint32_t delay = 0;
	bool cycle = false;
	bool log = true;
	bool dispatcherSlotReserved = false;
	DispatcherLane reservedLane = DispatcherLane::WorldCommit;

	friend class Dispatcher;
};
