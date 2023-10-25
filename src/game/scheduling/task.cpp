/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"
#include "task.hpp"
#include "lib/logging/log_with_spd_log.hpp"

std::chrono::system_clock::time_point Task::TIME_NOW = SYSTEM_TIME_ZERO;
std::atomic_uint_fast64_t Task::LAST_EVENT_ID = 0;

bool Task::execute() const {
	if (isCanceled()) {
		return false;
	}

	if (hasExpired()) {
		g_logger().info("The task '{}' has expired, it has not been executed in {} ms.", getContext(), expiration - utime);
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
