/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Dispatcher;

class Task {
public:
	Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context);

	Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle = false, bool log = true);

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

	void updateTime();

	bool hasTraceableContext() const {
		const static std::unordered_set<std::string_view> tasksContext = {
			"Decay::checkDecay",
			"Dispatcher::asyncEvent",
			"Game::checkCreatureAttack",
			"Game::checkCreatureWalk",
			"Game::checkCreatures",
			"Game::checkImbuements",
			"Game::checkLight",
			"Game::createFiendishMonsters",
			"Game::createInfluencedMonsters",
			"Game::updateCreatureWalk",
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
			"Player::addInFightTicks"
		};

		return tasksContext.contains(context);
	}

	struct Compare {
		bool operator()(const std::shared_ptr<Task> &a, const std::shared_ptr<Task> &b) const {
			return a->getTime() < b->getTime();
		}
	};

	std::function<void(void)> func;
	std::string context;

	int64_t utime = 0;
	int64_t expiration = 0;
	uint64_t id = 0;
	uint32_t delay = 0;
	bool cycle = false;
	bool log = true;

	friend class Dispatcher;
};
