/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_SCHEDULING_PLAYER_TASKS_H_
#define SRC_GAME_SCHEDULING_PLAYER_TASKS_H_

#include "utils/player_thread_base.h"
#include <mutex>
#include <condition_variable>
#include <array>

const int PLAYER_DISPATCHER_TASK_EXPIRATION = 2000;
const auto PLAYER_SYSTEM_TIME_ZERO = std::chrono::system_clock::time_point(std::chrono::milliseconds(0));

class PlayerTask {
	public:
		// DO NOT allocate this class on the stack
		PlayerTask(std::function<void(void)> &&f) :
			func(std::move(f)) { }
		PlayerTask(uint32_t ms, std::function<void(void)> &&f) :
			expiration(std::chrono::system_clock::now() + std::chrono::milliseconds(ms)), func(std::move(f)) { }

		virtual ~PlayerTask() = default;
		void operator()() {
			func();
		}

		void setDontExpire() {
			expiration = PLAYER_SYSTEM_TIME_ZERO;
		}

		bool hasExpired() const {
			if (expiration == PLAYER_SYSTEM_TIME_ZERO) {
				return false;
			}
			return expiration < std::chrono::system_clock::now();
		}

	protected:
		std::chrono::system_clock::time_point expiration = PLAYER_SYSTEM_TIME_ZERO;

	private:
		// Expiration has another meaning for scheduler tasks,
		// then it is the time the task should be added to the
		// dispatcher
		std::function<void(void)> func;
};

PlayerTask* playerCreateTask(std::function<void(void)> f);
PlayerTask* playerCreateTask(uint32_t expiration, std::function<void(void)> f);

class PlayerDispatcher : public PlayerThreadHolder<PlayerDispatcher> {
	public:
		PlayerDispatcher() = default;
		PlayerDispatcher(const PlayerDispatcher &) = delete;
		void operator=(const PlayerDispatcher &) = delete;

		static PlayerDispatcher &getInstance() {
			// Guaranteed to be destroyed
			static PlayerDispatcher instance;
			// Instantiated on first use
			return instance;
		}

		void playerAddTask(PlayerTask* task, int index, bool push_front = false);

		void shutdown();

		uint64_t getDispatcherCycle() const {
			return dispatcherCycle;
		}

		void threadMain(int index);

	private:
		std::vector<std::thread> threads;

		std::array<std::mutex, 10> taskLock;
		std::array<std::condition_variable, 10> taskSignal;
		std::array<std::list<PlayerTask*>, 10> taskList;
		uint64_t dispatcherCycle = 0;
};

constexpr auto g_playerDispatcher = &PlayerDispatcher::getInstance;

#endif // SRC_GAME_SCHEDULING_PLAYER_TASKS_H_
