/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_SCHEDULING_TASKS_H_
#define SRC_GAME_SCHEDULING_TASKS_H_

#include "utils/thread_holder_base.h"

static constexpr int32_t SERVER_BEAT_MILISECONDS = 50;
const int DISPATCHER_TASK_EXPIRATION = 2000;
const auto SYSTEM_TIME_ZERO = std::chrono::system_clock::time_point(std::chrono::milliseconds(0));

class Dispatcher : public ThreadHolder<Dispatcher> {
	public:
		Dispatcher() : work(asio::make_work_guard(io_service)) {}

		Dispatcher(const Dispatcher &) = delete;
		void operator=(const Dispatcher &) = delete;

		static Dispatcher &getInstance() {
			// Guaranteed to be destroyed
			static Dispatcher instance;
			// Instantiated on first use
			return instance;
		}

		void addTask(std::function<void (void)> functor);
		uint64_t addEvent(uint32_t delay, std::function<void (void)> functor);
		void stopEvent(uint64_t eventId);

		void shutdown();

		uint64_t getDispatcherCycle() const {
			return dispatcherCycle;
		}

		void threadMain();

	private:
		std::thread thread;
		uint64_t lastEventId = 0;
		uint64_t dispatcherCycle = 0;
		phmap::flat_hash_map<uint64_t, asio::high_resolution_timer> eventIds;
		asio::io_service io_service;
		asio::executor_work_guard<asio::io_context::executor_type> work;
};

constexpr auto g_dispatcher = &Dispatcher::getInstance;

#endif // SRC_GAME_SCHEDULING_TASKS_H_
