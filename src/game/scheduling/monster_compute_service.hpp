/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <chrono>
	#include <condition_variable>
	#include <cstddef>
	#include <cstdint>
	#include <deque>
	#include <functional>
	#include <mutex>
	#include <optional>
	#include <stop_token>
	#include <stdexcept>
	#include <string>
	#include <string_view>
	#include <thread>
	#include <vector>
#endif

using MonsterComputeToken = uint64_t;

enum class MonsterComputePriority : uint8_t {
	Visible,
	Background
};

enum class MonsterComputeSubmitStatus : uint8_t {
	Accepted,
	RanInline,
	QueueFull,
	Stopping,
	Invalid
};

struct MonsterComputeSubmission {
	MonsterComputeSubmitStatus status = MonsterComputeSubmitStatus::Invalid;
	MonsterComputeToken token = 0;

	[[nodiscard]] bool accepted() const {
		return status == MonsterComputeSubmitStatus::Accepted || status == MonsterComputeSubmitStatus::RanInline;
	}
};

struct MonsterComputeConfig {
	uint32_t configuredThreads = 0;
	size_t capacity = 2048;
	uint32_t hardwareConcurrency = std::thread::hardware_concurrency();
};

struct MonsterComputeStats {
	size_t visibleQueued = 0;
	size_t backgroundQueued = 0;
	size_t completionsQueued = 0;
	size_t outstanding = 0;
	size_t active = 0;
	size_t completionsInFlight = 0;
	size_t capacity = 0;
	size_t workerCount = 0;
	std::chrono::microseconds oldestCompletionReadyAge { 0 };
	uint64_t accepted = 0;
	uint64_t rejected = 0;
	uint64_t completed = 0;
	uint64_t failed = 0;
	uint64_t canceled = 0;
	bool inlineMode = true;
	bool running = false;
};

class MonsterComputeService {
public:
	using Completion = std::function<void()>;
	// Work executes either on a dedicated worker or inline on small hosts. It may
	// read only captured values/immutable snapshots. Gameplay mutation belongs in
	// the returned completion, which the dispatcher consumes later.
	using Work = std::function<Completion(MonsterComputeToken, std::stop_token)>;
	using CompletionExecutor = std::function<void(std::string_view, Completion &)>;

	MonsterComputeService() = default;
	~MonsterComputeService();

	MonsterComputeService(const MonsterComputeService &) = delete;
	MonsterComputeService &operator=(const MonsterComputeService &) = delete;

	static MonsterComputeService &getInstance();

	void start(MonsterComputeConfig config);
	void shutdown();

	[[nodiscard]] MonsterComputeSubmission submit(MonsterComputePriority priority, Work work, std::string_view context);
	size_t drainCompletions(size_t maxCompletions, CompletionExecutor executor = {});

	[[nodiscard]] MonsterComputeStats getStats() const;
	[[nodiscard]] size_t getCompletionCount() const;

	[[nodiscard]] static size_t resolveWorkerCount(uint32_t configuredThreads, uint32_t hardwareConcurrency);
	[[nodiscard]] static std::optional<MonsterComputePriority> selectNextPriority(bool hasVisible, bool hasBackground, uint8_t &visibleStreak);

private:
	enum class State : uint8_t {
		Stopped,
		Running,
		Stopping
	};

	struct Request {
		MonsterComputeToken token = 0;
		Work work;
		std::string context;
	};

	struct CompletionRecord {
		MonsterComputeToken token = 0;
		Completion completion;
		std::string context;
		std::chrono::steady_clock::time_point readyAt {};
	};

	void workerLoop(std::stop_token stopToken);
	void executeRequest(Request request, std::stop_token stopToken);
	Request popNextRequest();
	void enqueueCompletion(CompletionRecord completion);
	MonsterComputeToken nextToken();

	mutable std::mutex mutex;
	std::condition_variable workAvailable;
	std::condition_variable lifecycleChanged;
	std::deque<Request> visibleRequests;
	std::deque<Request> backgroundRequests;
	std::deque<CompletionRecord> completions;
	std::vector<std::jthread> workers;

	State state = State::Stopped;
	size_t capacity = 0;
	size_t outstanding = 0;
	size_t activeRequests = 0;
	size_t completionsInFlight = 0;
	size_t workerCount = 0;
	MonsterComputeToken lastToken = 0;
	uint8_t visibleStreak = 0;
	uint64_t acceptedCount = 0;
	uint64_t rejectedCount = 0;
	uint64_t completedCount = 0;
	uint64_t failedCount = 0;
	uint64_t canceledCount = 0;
	bool inlineMode = true;
};

constexpr auto g_monsterComputeService = MonsterComputeService::getInstance;
