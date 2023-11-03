/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once
#include "utils/tools.hpp"
#include <unordered_set>

static constexpr auto SYSTEM_TIME_ZERO = std::chrono::system_clock::time_point(std::chrono::milliseconds(0));

class Task {
public:
	static std::chrono::system_clock::time_point TIME_NOW;

	Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context) :
		func(std::move(f)), context(context), utime(TIME_NOW), expiration(expiresAfterMs > 0 ? TIME_NOW + std::chrono::milliseconds(expiresAfterMs) : SYSTEM_TIME_ZERO) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle = false, bool log = true) :
		func(std::move(f)), context(context), utime(TIME_NOW + std::chrono::milliseconds(delay)), delay(delay), cycle(cycle), log(log) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

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

	uint32_t getDelay() const {
		return delay;
	}

	std::string_view getContext() const {
		return context;
	}

	auto getTime() const {
		return utime;
	}

	bool hasExpired() const {
		return expiration != SYSTEM_TIME_ZERO && expiration < TIME_NOW;
	}

	bool isCycle() const {
		return cycle;
	}

	bool isCanceled() const {
		return func == nullptr;
	}

	void cancel() {
		func = nullptr;
	}

	bool execute() const;

private:
	static std::atomic_uint_fast64_t LAST_EVENT_ID;

	void updateTime() {
		utime = TIME_NOW + std::chrono::milliseconds(delay);
	}

	bool hasTraceableContext() const {
		const static auto tasksContext = std::unordered_set<std::string_view>({
			"Creature::checkCreatureWalk",
			"Decay::checkDecay",
			"Dispatcher::asyncEvent",
			"Game::checkCreatureAttack",
			"Game::checkCreatures",
			"Game::checkImbuements",
			"Game::checkLight",
			"Game::createFiendishMonsters",
			"Game::createInfluencedMonsters",
			"Game::updateCreatureWalk",
			"Game::updateForgeableMonsters",
			"GlobalEvents::think",
			"LuaEnvironment::executeTimerEvent",
			"Modules::executeOnRecvbyte",
			"OutputMessagePool::sendAll",
			"ProtocolGame::addGameTask",
			"ProtocolGame::parsePacketFromDispatcher",
			"Raids::checkRaids",
			"SpawnMonster::checkSpawnMonster",
			"SpawnMonster::scheduleSpawn",
			"SpawnNpc::checkSpawnNpc",
			"Webhook::run",
			"Protocol::sendRecvMessageCallback",
		});

		return tasksContext.contains(context);
	}

	struct Compare {
		bool operator()(const std::shared_ptr<Task> &a, const std::shared_ptr<Task> &b) const {
			return a->utime < b->utime;
		}
	};

	std::function<void(void)> func = nullptr;
	std::string_view context;

	std::chrono::system_clock::time_point utime = SYSTEM_TIME_ZERO;
	std::chrono::system_clock::time_point expiration = SYSTEM_TIME_ZERO;

	uint64_t id = 0;
	uint32_t delay = 0;

	bool cycle = false;
	bool log = true;

	friend class Dispatcher;
};
