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

#include "game/scheduling/tasks.h"
#include "utils/thread_holder_base.h"

static constexpr int32_t SCHEDULER_MINTICKS = 50;

class SchedulerTask : public Task {
	public:
		void setEventId(uint64_t id) {
			eventId = id;
		}
		uint64_t getEventId() const {
			return eventId;
		}

		uint32_t getDelay() const {
			return delay;
		}

	private:
		SchedulerTask(uint32_t delay, std::function<void (void)>&& f) : Task(std::move(f)), delay(delay) {}

		uint64_t eventId = 0;
		uint32_t delay = 0;

		friend SchedulerTask* createSchedulerTask(uint32_t, std::function<void(void)>);
};

SchedulerTask* createSchedulerTask(uint32_t delay, std::function<void(void)> f);


class Scheduler : public ThreadHolder<Scheduler> {
	public:
		Scheduler() = default;

		Scheduler(const Scheduler &) = delete;
		void operator=(const Scheduler &) = delete;

		static Scheduler &getInstance() {
			// Guaranteed to be destroyed
			static Scheduler instance;
			// Instantiated on first use
			return instance;
		}

		uint64_t addEvent(SchedulerTask* task);
		void stopEvent(uint64_t eventId);

		void shutdown();

		void threadMain();

	private:
		std::thread thread;
		std::atomic<uint64_t> lastEventId {0};
		phmap::flat_hash_map<uint64_t, asio::high_resolution_timer> eventIds;
		asio::io_service io_service;
		asio::io_service::work work{ io_service };
};

constexpr auto g_scheduler = &Scheduler::getInstance;

#endif // SRC_GAME_SCHEDULING_SCHEDULER_H_
