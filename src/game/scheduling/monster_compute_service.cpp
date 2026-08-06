/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/monster_compute_service.hpp"

#include "lib/di/container.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <cassert>
	#include <utility>
#endif

namespace {
	constexpr size_t MAX_MONSTER_COMPUTE_CAPACITY = 2048;
	constexpr size_t MAX_MONSTER_COMPUTE_WORKERS = 4;
}

MonsterComputeService::~MonsterComputeService() {
	shutdown();
}

MonsterComputeService &MonsterComputeService::getInstance() {
	return inject<MonsterComputeService>();
}

void MonsterComputeService::setCompletionNotifier(CompletionNotifier notifier) {
	std::scoped_lock lock(mutex);
	completionNotifier = std::move(notifier);
}

size_t MonsterComputeService::resolveWorkerCount(uint32_t configuredThreads, uint32_t hardwareConcurrency) {
	if (hardwareConcurrency <= 2) {
		return 0;
	}
	if (configuredThreads != 0) {
		return std::clamp<size_t>(configuredThreads, 1, MAX_MONSTER_COMPUTE_WORKERS);
	}

	const auto automatic = static_cast<size_t>((hardwareConcurrency - 2) / 2);
	return std::clamp<size_t>(automatic, 1, MAX_MONSTER_COMPUTE_WORKERS);
}

std::optional<MonsterComputePriority> MonsterComputeService::selectNextPriority(bool hasVisible, bool hasBackground, uint8_t &visibleStreak) {
	if (!hasVisible && !hasBackground) {
		return std::nullopt;
	}
	if (hasVisible && (!hasBackground || visibleStreak < 3)) {
		visibleStreak = std::min<uint8_t>(3, visibleStreak + 1);
		return MonsterComputePriority::Visible;
	}

	visibleStreak = 0;
	return MonsterComputePriority::Background;
}

void MonsterComputeService::start(MonsterComputeConfig config) {
	std::unique_lock lock(mutex);
	if (state == State::Running) {
		return;
	}
	if (state == State::Stopping) {
		throw std::logic_error("Cannot start monster compute service while it is stopping");
	}

	capacity = std::clamp<size_t>(config.capacity, 1, MAX_MONSTER_COMPUTE_CAPACITY);
	// Background work may use most of the service, but it must leave admission
	// headroom for monsters that are currently visible to a player.
	visibleReserve = capacity / 4;
	workerCount = resolveWorkerCount(config.configuredThreads, config.hardwareConcurrency);
	inlineMode = workerCount == 0;
	visibleStreak = 0;
	completionVisibleStreak = 0;
	state = State::Running;
	try {
		workers.reserve(workerCount);
		for (size_t index = 0; index < workerCount; ++index) {
			workers.emplace_back([this](std::stop_token stopToken) {
				workerLoop(stopToken);
			});
		}
	} catch (...) {
		state = State::Stopping;
		lock.unlock();
		for (auto &worker : workers) {
			worker.request_stop();
		}
		workAvailable.notify_all();
		workers.clear();
		lock.lock();
		workerCount = 0;
		state = State::Stopped;
		lifecycleChanged.notify_all();
		throw;
	}
}

MonsterComputeSubmission MonsterComputeService::submit(MonsterComputePriority priority, Work work, std::string_view context, Completion failureCompletion) {
	if (!work || context.empty()) {
		return { MonsterComputeSubmitStatus::Invalid, 0 };
	}

	Request request;
	request.priority = priority;
	request.work = std::move(work);
	request.failureCompletion = std::move(failureCompletion);
	request.context = context;
	bool runInline = false;
	MonsterComputeToken token = 0;
	{
		std::scoped_lock lock(mutex);
		if (state != State::Running) {
			++rejectedCount;
			return { MonsterComputeSubmitStatus::Stopping, 0 };
		}
		const auto backgroundCapacity = capacity - visibleReserve;
		if (outstanding >= capacity || (priority == MonsterComputePriority::Background && backgroundOutstanding >= backgroundCapacity)) {
			++rejectedCount;
			return { MonsterComputeSubmitStatus::QueueFull, 0 };
		}

		request.token = nextToken();
		token = request.token;
		++outstanding;
		if (priority == MonsterComputePriority::Visible) {
			++visibleOutstanding;
		} else {
			++backgroundOutstanding;
		}
		++acceptedCount;
		runInline = inlineMode;
		if (runInline) {
			++activeRequests;
		} else {
			auto &queue = priority == MonsterComputePriority::Visible ? visibleRequests : backgroundRequests;
			queue.emplace_back(std::move(request));
		}
	}

	if (runInline) {
		executeRequest(std::move(request), std::stop_token {});
		return { MonsterComputeSubmitStatus::RanInline, token };
	}

	workAvailable.notify_one();
	return { MonsterComputeSubmitStatus::Accepted, token };
}

size_t MonsterComputeService::drainCompletions(size_t maxCompletions, CompletionExecutor executor) {
	if (maxCompletions == 0) {
		return 0;
	}

	std::vector<CompletionRecord> pending;
	{
		std::scoped_lock lock(mutex);
		const auto completionCount = visibleCompletions.size() + backgroundCompletions.size();
		const auto count = std::min(maxCompletions, completionCount);
		pending.reserve(count);
		for (size_t index = 0; index < count; ++index) {
			const auto priority = selectNextPriority(!visibleCompletions.empty(), !backgroundCompletions.empty(), completionVisibleStreak);
			assert(priority.has_value());
			auto &queue = *priority == MonsterComputePriority::Visible ? visibleCompletions : backgroundCompletions;
			pending.emplace_back(std::move(queue.front()));
			queue.pop_front();
		}
		completionsInFlight += count;
	}

	for (auto &record : pending) {
		try {
			if (executor) {
				executor(record.context, record.completion);
			} else if (record.completion) {
				record.completion();
			}
		} catch (...) {
			std::scoped_lock lock(mutex);
			++failedCount;
		}

		std::scoped_lock lock(mutex);
		assert(outstanding > 0);
		--outstanding;
		if (record.priority == MonsterComputePriority::Visible) {
			assert(visibleOutstanding > 0);
			--visibleOutstanding;
		} else {
			assert(backgroundOutstanding > 0);
			--backgroundOutstanding;
		}
		assert(completionsInFlight > 0);
		--completionsInFlight;
		++completedCount;
		lifecycleChanged.notify_all();
	}

	return pending.size();
}

void MonsterComputeService::shutdown() {
	size_t queuedCanceled = 0;
	{
		std::unique_lock lock(mutex);
		if (state == State::Stopped) {
			return;
		}
		if (state == State::Stopping) {
			lifecycleChanged.wait(lock, [this] {
				return state == State::Stopped;
			});
			return;
		}
		state = State::Stopping;
		const auto visibleQueuedCanceled = visibleRequests.size();
		const auto backgroundQueuedCanceled = backgroundRequests.size();
		queuedCanceled = visibleQueuedCanceled + backgroundQueuedCanceled;
		visibleRequests.clear();
		backgroundRequests.clear();
		assert(outstanding >= queuedCanceled);
		outstanding -= queuedCanceled;
		assert(visibleOutstanding >= visibleQueuedCanceled);
		visibleOutstanding -= visibleQueuedCanceled;
		assert(backgroundOutstanding >= backgroundQueuedCanceled);
		backgroundOutstanding -= backgroundQueuedCanceled;
		canceledCount += queuedCanceled;
	}

	for (auto &worker : workers) {
		worker.request_stop();
	}
	workAvailable.notify_all();
	workers.clear();

	{
		std::unique_lock lock(mutex);
		lifecycleChanged.wait(lock, [this] {
			return activeRequests == 0 && completionsInFlight == 0;
		});
		const auto discardedVisibleCompletions = visibleCompletions.size();
		const auto discardedBackgroundCompletions = backgroundCompletions.size();
		const auto discardedCompletions = discardedVisibleCompletions + discardedBackgroundCompletions;
		assert(outstanding >= discardedCompletions);
		outstanding -= discardedCompletions;
		assert(visibleOutstanding >= discardedVisibleCompletions);
		visibleOutstanding -= discardedVisibleCompletions;
		assert(backgroundOutstanding >= discardedBackgroundCompletions);
		backgroundOutstanding -= discardedBackgroundCompletions;
		canceledCount += discardedCompletions;
		visibleCompletions.clear();
		backgroundCompletions.clear();
		assert(outstanding == 0);
		assert(visibleOutstanding == 0);
		assert(backgroundOutstanding == 0);
		workerCount = 0;
		state = State::Stopped;
		lifecycleChanged.notify_all();
	}
}

MonsterComputeStats MonsterComputeService::getStats() const {
	std::scoped_lock lock(mutex);
	MonsterComputeStats stats;
	stats.visibleQueued = visibleRequests.size();
	stats.backgroundQueued = backgroundRequests.size();
	stats.visibleCompletionsQueued = visibleCompletions.size();
	stats.backgroundCompletionsQueued = backgroundCompletions.size();
	stats.completionsQueued = stats.visibleCompletionsQueued + stats.backgroundCompletionsQueued;
	stats.visibleOutstanding = visibleOutstanding;
	stats.backgroundOutstanding = backgroundOutstanding;
	stats.outstanding = outstanding;
	stats.active = activeRequests;
	stats.completionsInFlight = completionsInFlight;
	stats.capacity = capacity;
	stats.visibleReserve = visibleReserve;
	stats.workerCount = workerCount;
	const auto now = std::chrono::steady_clock::now();
	if (!visibleCompletions.empty() && now > visibleCompletions.front().readyAt) {
		stats.oldestVisibleCompletionReadyAge = std::chrono::duration_cast<std::chrono::microseconds>(now - visibleCompletions.front().readyAt);
	}
	if (!backgroundCompletions.empty() && now > backgroundCompletions.front().readyAt) {
		stats.oldestBackgroundCompletionReadyAge = std::chrono::duration_cast<std::chrono::microseconds>(now - backgroundCompletions.front().readyAt);
	}
	stats.oldestCompletionReadyAge = std::max(stats.oldestVisibleCompletionReadyAge, stats.oldestBackgroundCompletionReadyAge);
	stats.accepted = acceptedCount;
	stats.rejected = rejectedCount;
	stats.completed = completedCount;
	stats.failed = failedCount;
	stats.canceled = canceledCount;
	stats.inlineMode = inlineMode;
	stats.running = state == State::Running;
	return stats;
}

size_t MonsterComputeService::getCompletionCount() const {
	std::scoped_lock lock(mutex);
	return visibleCompletions.size() + backgroundCompletions.size();
}

void MonsterComputeService::workerLoop(std::stop_token stopToken) {
	while (!stopToken.stop_requested()) {
		Request request;
		{
			std::unique_lock lock(mutex);
			workAvailable.wait(lock, [this, &stopToken] {
				return stopToken.stop_requested() || state != State::Running || !visibleRequests.empty() || !backgroundRequests.empty();
			});
			if (stopToken.stop_requested() || state != State::Running) {
				return;
			}
			request = popNextRequest();
		}

		executeRequest(std::move(request), stopToken);
	}
}

void MonsterComputeService::executeRequest(Request request, std::stop_token stopToken) {
	Completion completion;
	try {
		completion = request.work(request.token, stopToken);
	} catch (...) {
		std::scoped_lock lock(mutex);
		++failedCount;
		completion = std::move(request.failureCompletion);
	}

	enqueueCompletion({ request.token, request.priority, std::move(completion), std::move(request.context), {} });
}

MonsterComputeService::Request MonsterComputeService::popNextRequest() {
	const auto priority = selectNextPriority(!visibleRequests.empty(), !backgroundRequests.empty(), visibleStreak);
	assert(priority.has_value());
	auto &queue = *priority == MonsterComputePriority::Visible ? visibleRequests : backgroundRequests;
	Request request = std::move(queue.front());
	queue.pop_front();
	++activeRequests;
	return request;
}

void MonsterComputeService::enqueueCompletion(CompletionRecord completion) {
	CompletionNotifier notifier;
	{
		std::scoped_lock lock(mutex);
		assert(visibleCompletions.size() + backgroundCompletions.size() < capacity);
		completion.readyAt = std::chrono::steady_clock::now();
		auto &queue = completion.priority == MonsterComputePriority::Visible ? visibleCompletions : backgroundCompletions;
		queue.emplace_back(std::move(completion));
		assert(activeRequests > 0);
		--activeRequests;
		notifier = completionNotifier;
		lifecycleChanged.notify_all();
	}
	if (notifier) {
		notifier();
	}
}

MonsterComputeToken MonsterComputeService::nextToken() {
	if (++lastToken == 0) {
		lastToken = 1;
	}
	return lastToken;
}
