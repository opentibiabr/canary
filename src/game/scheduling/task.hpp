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

class Task {
public:
	// DO NOT allocate this class on the stack
	Task(std::function<void(void)> &&f, std::string context) :
		context(std::move(context)), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	Task(std::function<void(void)> &&f, std::string context, uint32_t delay) :
		delay(delay), utime(std::chrono::system_clock::now() + std::chrono::milliseconds(delay)), context(std::move(context)), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	Task(std::function<void(void)> &&f, std::string context, uint32_t delay, bool cycle) :
		delay(delay), utime(std::chrono::system_clock::now() + std::chrono::milliseconds(delay)), cycle(cycle), context(std::move(context)), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	virtual ~Task() = default;

	void setEventId(uint64_t id) {
		eventId = id;
	}

	uint64_t getEventId() const {
		return eventId;
	}

	uint32_t getDelay() const {
		return delay;
	}

	std::string getContext() const {
		return context;
	}

	std::chrono::system_clock::time_point getTime() const {
		return utime;
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

	void execute() {
		if (func) {
			func();

			if (cycle) {
				utime = std::chrono::system_clock::now() + std::chrono::milliseconds(delay);
			}
		}
	}

	bool hasTraceableContext() const {
		const static auto tasksContext = phmap::flat_hash_set<std::string>({
			"Creature::checkCreatureWalk",
			"Decay::checkDecay",
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
			"sendRecvMessageCallback",
		});

		return tasksContext.contains(context);
	}

	struct Compare {
		bool operator()(const std::shared_ptr<Task> &a, const std::shared_ptr<Task> &b) const {
			return b->utime < a->utime;
		}
	};

private:
	bool canceled = false;
	bool cycle = false;

	uint32_t delay = 0;
	std::chrono::system_clock::time_point utime;
	uint64_t eventId = 0;
	std::string context {};
	std::function<void(void)> func {};
};
