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
	Task(std::function<void(void)> &&f) :
		func(std::move(f)) { }

	Task(std::function<void(void)> &&f, uint32_t delay) :
		func(std::move(f)), delay(delay) { }

	Task(std::function<void(void)> &&f, std::string context) :
		func(std::move(f)), context(std::move(context)) { }

	Task(std::function<void(void)> &&f, uint32_t delay, std::string context) :
		func(std::move(f)), delay(delay), context(std::move(context)) { }

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

private:
	uint32_t delay = 0;
	uint64_t eventId = 0;
	std::string context = "anonymous";
	std::function<void(void)> func {};
};
