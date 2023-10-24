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

static constexpr auto SYSTEM_TIME_ZERO = std::chrono::system_clock::time_point(std::chrono::milliseconds(0));

class Task {
public:
	static std::chrono::system_clock::time_point TIME_NOW;

	Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context) :
		expiration(expiresAfterMs > 0 ? TIME_NOW + std::chrono::milliseconds(expiresAfterMs) : SYSTEM_TIME_ZERO),
		context(context), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle = false, bool log = true) :
		cycle(cycle), log(log), delay(delay), utime(TIME_NOW + std::chrono::milliseconds(delay)), context(context), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	~Task() = default;

	void setEventId(uint64_t id) {
		eventId = id;
	}

	uint64_t getEventId() const {
		return eventId;
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
		return canceled;
	}

	void cancel() {
		canceled = true;
		func = nullptr;
	}

	bool execute() const;

	void updateTime() {
		utime = TIME_NOW + std::chrono::milliseconds(delay);
	}

	uint64_t generateId() {
		if (eventId == 0) {
			if (++LAST_EVENT_ID == 0) {
				LAST_EVENT_ID = 1;
			}

			eventId = LAST_EVENT_ID;
		}

		return eventId;
	}

	struct Compare {
		bool operator()(const std::shared_ptr<Task> &a, const std::shared_ptr<Task> &b) const {
			return b->utime < a->utime;
		}
	};

private:
	static std::atomic_uint_fast64_t LAST_EVENT_ID;

	bool hasTraceableContext() const {
		const static auto tasksContext = phmap::flat_hash_set<std::string>({
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

	bool canceled = false;
	bool cycle = false;
	bool log = true;

	uint32_t delay = 0;
	uint64_t eventId = 0;

	std::chrono::system_clock::time_point utime = SYSTEM_TIME_ZERO;
	std::chrono::system_clock::time_point expiration = SYSTEM_TIME_ZERO;

	std::string_view context;
	std::function<void(void)> func = nullptr;
};
