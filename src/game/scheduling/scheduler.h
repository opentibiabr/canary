/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_GAME_SCHEDULING_SCHEDULER_H_
#define SRC_GAME_SCHEDULING_SCHEDULER_H_

#include "game/scheduling/tasks.h"
#include "utils/thread_holder_base.h"

static constexpr int32_t SCHEDULER_MINTICKS = 50;

class SchedulerTask : public Task
{
	public:
		void setEventId(uint32_t id) {
			eventId = id;
		}
		uint32_t getEventId() const {
			return eventId;
		}

		std::chrono::system_clock::time_point getCycle() const {
			return expiration;
		}

	private:
		SchedulerTask(uint32_t delay, std::function<void (void)>&& f) : Task(delay, std::move(f)) {}

		uint32_t eventId = 0;

		friend SchedulerTask* createSchedulerTask(uint32_t, std::function<void (void)>);
};

SchedulerTask* createSchedulerTask(uint32_t delay, std::function<void (void)> f);

struct TaskComparator {
	bool operator()(const SchedulerTask* lhs, const SchedulerTask* rhs) const {
		return lhs->getCycle() > rhs->getCycle();
	}
};

class Scheduler : public ThreadHolder<Scheduler>
{
	public:
		Scheduler() = default;
		
		Scheduler(Scheduler const&) = delete;
		void operator=(Scheduler const&) = delete;

		static Scheduler& getInstance() {
			// Guaranteed to be destroyed
			static Scheduler instance;
			// Instantiated on first use
			return instance;
		}

		uint32_t addEvent(SchedulerTask* task);
		bool stopEvent(uint32_t eventId);

		void shutdown();

		void threadMain();

	private:
		std::thread thread;
		std::mutex eventLock;
		std::condition_variable eventSignal;

		uint32_t lastEventId {0};
		std::priority_queue<SchedulerTask*, std::deque<SchedulerTask*>, TaskComparator> eventList;
		phmap::flat_hash_set<uint32_t> eventIds;
};

constexpr auto g_scheduler = &Scheduler::getInstance;

#endif  // SRC_GAME_SCHEDULING_SCHEDULER_H_
