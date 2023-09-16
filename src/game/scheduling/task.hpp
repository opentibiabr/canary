/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class Task {
public:
	// DO NOT allocate this class on the stack
	Task(std::function<void(void)> &&f, std::string context) :
		context(std::move(context)), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	Task(std::function<void(void)> &&f, std::string context, uint32_t delay) :
		delay(delay), context(std::move(context)), func(std::move(f)) {
		assert(!this->context.empty() && "Context cannot be empty!");
	}

	virtual ~Task() = default;
	void operator()() {
		func();
	}

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

	bool hasTraceableContext() const {
		return std::set<std::string> {
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
			"SpawnNpc::checkSpawnNpc",
			"Webhook::run",
			"sendRecvMessageCallback",
		}
			.contains(context);
	}

private:
	uint32_t delay = 0;
	uint64_t eventId = 0;
	std::string context {};
	std::function<void(void)> func {};
};
