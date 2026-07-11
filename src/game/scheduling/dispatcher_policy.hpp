/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/scheduling/task.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <chrono>
	#include <cstddef>
	#include <cstdint>
	#include <deque>
	#include <functional>
	#include <limits>
	#include <optional>
	#include <string_view>
	#include <utility>
	#include <vector>
#endif

struct DispatcherQueueSnapshot {
	size_t queued = 0;
	std::chrono::microseconds oldestReadyAge { 0 };
	std::string_view oldestContext;
};

class DispatcherAdmissionCounter final {
public:
	[[nodiscard]] bool tryReserve(size_t capacity) {
		auto current = reserved.load(std::memory_order_relaxed);
		while (current < capacity) {
			if (reserved.compare_exchange_weak(current, current + 1, std::memory_order_acq_rel, std::memory_order_relaxed)) {
				return true;
			}
		}
		return false;
	}

	[[nodiscard]] bool release() {
		auto current = reserved.load(std::memory_order_relaxed);
		while (current > 0) {
			if (reserved.compare_exchange_weak(current, current - 1, std::memory_order_acq_rel, std::memory_order_relaxed)) {
				return true;
			}
		}
		return false;
	}

	[[nodiscard]] size_t size() const {
		return reserved.load(std::memory_order_relaxed);
	}

private:
	std::atomic_size_t reserved = 0;
};

class CoalescedTaskState {
public:
	using Clock = std::chrono::steady_clock;
	using TimePoint = Clock::time_point;

	bool tryEnqueue() {
		if (pending) {
			return false;
		}

		return tryEnqueue(Clock::now());
	}

	bool tryEnqueue(TimePoint readyAt) {
		if (pending) {
			return false;
		}

		pending = true;
		oldestReadyAt = readyAt;
		return true;
	}

	[[nodiscard]] bool isPending() const {
		return pending;
	}

	[[nodiscard]] TimePoint getOldestReadyAt() const {
		return oldestReadyAt;
	}

	std::optional<TimePoint> consume() {
		if (!pending) {
			return std::nullopt;
		}

		pending = false;
		const auto readyAt = oldestReadyAt;
		oldestReadyAt = {};
		return readyAt;
	}

private:
	TimePoint oldestReadyAt {};
	bool pending = false;
};

class DispatcherPolicy {
public:
	using Clock = Task::Clock;
	using TimePoint = Clock::time_point;
	using NowFunction = std::function<TimePoint()>;

	explicit DispatcherPolicy(NowFunction nowFunction = {}) :
		nowFunction(std::move(nowFunction)) { }

	[[nodiscard]] TimePoint now() const {
		return nowFunction ? nowFunction() : Clock::now();
	}

	template <typename TaskRange>
	[[nodiscard]] DispatcherQueueSnapshot inspectQueue(const TaskRange &tasks, TimePoint notBefore = TimePoint::min()) const {
		return inspectQueueAt(tasks, now(), notBefore);
	}

	template <typename TaskRange>
	[[nodiscard]] static DispatcherQueueSnapshot inspectQueueAt(const TaskRange &tasks, TimePoint currentTime, TimePoint notBefore = TimePoint::min()) {
		DispatcherQueueSnapshot snapshot;
		for (const auto &task : tasks) {
			if (task.getEnqueuedAt() < notBefore) {
				continue;
			}

			++snapshot.queued;
			const auto readyAge = elapsed(task.getReadyAt(), currentTime);
			if (readyAge > snapshot.oldestReadyAge) {
				snapshot.oldestReadyAge = readyAge;
				snapshot.oldestContext = task.getContext();
			}
		}
		return snapshot;
	}

	template <typename TaskRange>
	[[nodiscard]] static DispatcherQueueSnapshot inspectPlayerVisibleQueueAt(const TaskRange &tasks, TimePoint currentTime) {
		DispatcherQueueSnapshot snapshot;
		for (const auto &task : tasks) {
			if (!isPlayerVisible(task.getMeta().lane)) {
				continue;
			}

			++snapshot.queued;
			const auto readyAge = elapsed(task.getReadyAt(), currentTime);
			if (readyAge > snapshot.oldestReadyAge) {
				snapshot.oldestReadyAge = readyAge;
				snapshot.oldestContext = task.getContext();
			}
		}
		return snapshot;
	}

	[[nodiscard]] static std::chrono::microseconds elapsed(TimePoint startedAt, TimePoint finishedAt) {
		if (finishedAt <= startedAt) {
			return std::chrono::microseconds::zero();
		}
		return std::chrono::duration_cast<std::chrono::microseconds>(finishedAt - startedAt);
	}

	[[nodiscard]] std::chrono::microseconds elapsedSince(TimePoint startedAt) const {
		return elapsed(startedAt, now());
	}

	[[nodiscard]] static int64_t timestamp(TimePoint timePoint) {
		return std::chrono::duration_cast<std::chrono::microseconds>(timePoint.time_since_epoch()).count();
	}

	[[nodiscard]] static TimePoint fromTimestamp(int64_t timestamp) {
		return TimePoint(std::chrono::microseconds(timestamp));
	}

	[[nodiscard]] static size_t selectTaskCount(size_t available, size_t budget) {
		return std::min(available, budget);
	}

	template <typename TaskRange>
	[[nodiscard]] static size_t selectProducerFairIndex(const TaskRange &tasks, uint64_t lastProducerToken) {
		if (tasks.empty()) {
			return 0;
		}

		size_t nextIndex = 0;
		size_t wrappedIndex = 0;
		uint64_t nextToken = std::numeric_limits<uint64_t>::max();
		uint64_t wrappedToken = std::numeric_limits<uint64_t>::max();
		bool foundNext = false;
		for (size_t index = 0; index < tasks.size(); ++index) {
			const auto producerToken = tasks[index].getMeta().producerToken;
			if (producerToken > lastProducerToken && (!foundNext || producerToken < nextToken)) {
				nextToken = producerToken;
				nextIndex = index;
				foundNext = true;
			}
			if (producerToken <= lastProducerToken && producerToken < wrappedToken) {
				wrappedToken = producerToken;
				wrappedIndex = index;
			}
		}
		return foundNext ? nextIndex : wrappedIndex;
	}

	template <typename T>
	static size_t requeueUnprocessed(std::deque<T> &queue, std::vector<T> &slice, size_t consumed) {
		if (consumed >= slice.size()) {
			return 0;
		}

		const auto unprocessed = slice.size() - consumed;
		for (size_t index = slice.size(); index > consumed; --index) {
			queue.emplace_front(std::move(slice[index - 1]));
		}
		return unprocessed;
	}

	[[nodiscard]] bool deadlineReached(TimePoint deadline) const {
		return now() >= deadline;
	}

private:
	NowFunction nowFunction;
};
