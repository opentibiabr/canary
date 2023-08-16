/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_GAME_TASK_H_
#define SRC_GAME_TASK_H_

#include "utils/thread_holder_base.h"

class Task {
	public:
		// DO NOT allocate this class on the stack
		Task(std::function<void(void)> &&f, uint32_t delay = 0) :
			func(std::move(f)), delay(delay) { }

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

	private:
		uint32_t delay = 0;
		uint64_t eventId = 0;
		std::function<void(void)> func {};
};

#endif // SRC_GAME_TASK_H_