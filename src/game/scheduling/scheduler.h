/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_SCHEDULING_SCHEDULER_H_
#define SRC_GAME_SCHEDULING_SCHEDULER_H_

#include "utils/thread_holder_base.h"

static constexpr int32_t SCHEDULER_MINTICKS = 50;

class Task;

/**
 * Scheduler allow you to schedule a task async to be executed after a
 * given period. Once the time has passed, scheduler calls the task.
 */
class Scheduler : public ThreadHolder<Scheduler> {
	public:
		Scheduler() = default;

		// Ensures that we don't accidentally copy it
		Scheduler(const Scheduler &) = delete;
		Scheduler operator=(const Scheduler &) = delete;

		static Scheduler &getInstance();

		uint64_t addEvent(uint32_t delay, std::function<void(void)> f);
		uint64_t addEvent(const std::shared_ptr<Task> &task);
		void stopEvent(uint64_t eventId);

	private:
		std::atomic<uint64_t> lastEventId { 0 };
		std::unordered_map<uint64_t, asio::steady_timer> eventIds;
};

constexpr auto g_scheduler = Scheduler::getInstance;

#endif // SRC_GAME_SCHEDULING_SCHEDULER_H_
