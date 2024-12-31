/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/task.hpp"

#include "lib/metrics/metrics.hpp"

#include "utils/tools.hpp"

std::atomic_uint_fast64_t Task::LAST_EVENT_ID = 0;

Task::Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context) :
	func(std::move(f)), context(context), utime(OTSYS_TIME()),
	expiration(expiresAfterMs > 0 ? OTSYS_TIME() + expiresAfterMs : 0) {
	if (this->context.empty()) {
		g_logger().error("[{}]: task context cannot be empty!", __FUNCTION__);
		return;
	}

	assert(!this->context.empty() && "Context cannot be empty!");
}

Task::Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle /* = false*/, bool log /*= true*/) :
	func(std::move(f)), context(context), utime(OTSYS_TIME() + delay), delay(delay),
	cycle(cycle), log(log) {
	if (this->context.empty()) {
		g_logger().error("[{}]: task context cannot be empty!", __FUNCTION__);
		return;
	}

	assert(!this->context.empty() && "Context cannot be empty!");
}

[[nodiscard]] bool Task::hasExpired() const {
	return expiration != 0 && expiration < OTSYS_TIME();
}

bool Task::execute() const {
	metrics::task_latency measure(context);
	if (isCanceled()) {
		return false;
	}

	if (hasExpired()) {
		g_logger().info("The task '{}' has expired, it has not been executed in {}.", getContext(), expiration - utime);
		return false;
	}

	if (log) {
		if (hasTraceableContext()) {
			g_logger().trace("Executing task {}.", getContext());
		} else {
			g_logger().debug("Executing task {}.", getContext());
		}
	}

	func();
	return true;
}

void Task::updateTime() {
	utime = OTSYS_TIME() + delay;
}
