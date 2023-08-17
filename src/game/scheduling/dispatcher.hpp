/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_DISPATCHER_H_
#define SRC_GAME_DISPATCHER_H_

#include "utils/thread_holder_base.h"

const int DISPATCHER_TASK_EXPIRATION = 2000;

class Task;

/**
 * Dispatcher allow you to dispatch a task async to be executed
 * in the dispatching thread. You can dispatch with an expiration
 * time, after which the task will be ignored.
 */
class Dispatcher : public ThreadHolder<Dispatcher> {
	public:
		Dispatcher() = default;

		// Ensures that we don't accidentally copy it
		Dispatcher(const Dispatcher &) = delete;
		Dispatcher operator=(const Dispatcher &) = delete;

		static Dispatcher &getInstance();

		void addTask(std::function<void(void)> f, uint32_t expiresAfterMs = 0);
		void addTask(const std::shared_ptr<Task> &task, uint32_t expiresAfterMs = 0);

		[[nodiscard]] uint64_t getDispatcherCycle() const {
			return dispatcherCycle;
		}

	private:
		uint64_t dispatcherCycle = 0;
};

constexpr auto g_dispatcher = Dispatcher::getInstance;

#endif // SRC_GAME_DISPATCHER_H_