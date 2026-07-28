/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/task.hpp"

#include "lib/metrics/metrics.hpp"

#include "utils/tools.hpp"
#include "utils/transparent_string_hash.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <functional>
	#include <mutex>
	#include <string>
	#include <string_view>
	#include <unordered_set>
#endif

std::atomic_uint_fast64_t Task::LAST_EVENT_ID = 0;

Task::Task(uint32_t expiresAfterMs, std::function<void(void)> &&f, std::string_view context, Clock::time_point enqueuedAt) :
	func(std::move(f)), context(internContext(context)), enqueuedAt(enqueuedAt), utime(OTSYS_TIME()),
	expiration(expiresAfterMs > 0 ? OTSYS_TIME() + expiresAfterMs : 0) {
	meta.readyAt = enqueuedAt;
	if (this->context.empty()) {
		g_logger().error("[{}]: task context cannot be empty!", __FUNCTION__);
		return;
	}

	assert(!this->context.empty() && "Context cannot be empty!");
}

Task::Task(std::function<void(void)> &&f, std::string_view context, uint32_t delay, bool cycle /* = false*/, bool log /*= true*/, Clock::time_point enqueuedAt) :
	func(std::move(f)), context(internContext(context)), enqueuedAt(enqueuedAt), utime(OTSYS_TIME() + delay), delay(delay),
	cycle(cycle), log(log) {
	meta.readyAt = enqueuedAt + std::chrono::milliseconds(delay);
	if (this->context.empty()) {
		g_logger().error("[{}]: task context cannot be empty!", __FUNCTION__);
		return;
	}

	assert(!this->context.empty() && "Context cannot be empty!");
}

std::string_view Task::internContext(std::string_view context) {
	static std::mutex contextMutex;
	static std::unordered_set<std::string, TransparentStringHasher, std::equal_to<>> contexts;

	static thread_local std::array<std::string_view, 8> localContexts {};
	static thread_local size_t nextLocalContext = 0;

	for (const auto localContext : localContexts) {
		if (localContext == context) {
			return localContext;
		}
	}

	std::scoped_lock lock(contextMutex);
	auto it = contexts.find(context);
	if (it == contexts.end()) {
		it = contexts.emplace(context).first;
	}
	const std::string_view internedContext = *it;

	localContexts[nextLocalContext++ % localContexts.size()] = internedContext;
	return internedContext;
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

void Task::updateTime(Clock::time_point rescheduledAt) {
	enqueuedAt = rescheduledAt;
	meta.readyAt = rescheduledAt + std::chrono::milliseconds(delay);
	utime = OTSYS_TIME() + delay;
}
