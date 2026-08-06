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
	#include <cstddef>
	#include <cstdint>
#endif

enum class DispatcherLoadState : uint8_t {
	Normal,
	Constrained,
	Emergency
};

struct DispatcherBudgetSet {
	size_t creatureWalkTasks = 128;
	size_t walkParallelTasks = 8;
	size_t creatureAsyncTasksPerBucket = 16;
	size_t deferredGameplayTasks = 16;
	size_t workerCompletions = 64;
	std::chrono::microseconds sliceRuntime { 2000 };

	bool operator==(const DispatcherBudgetSet &) const = default;
};

struct DispatcherBudgetDecision {
	DispatcherBudgetSet budgets;
	DispatcherLoadState state = DispatcherLoadState::Normal;
	std::chrono::microseconds controlLatency { 0 };
	bool stateChanged = false;
};

class DispatcherAdaptiveBudgetController final {
public:
	[[nodiscard]] DispatcherBudgetDecision update(
		const DispatcherBudgetSet &configured,
		std::chrono::microseconds visibleP99,
		std::chrono::microseconds oldestVisibleReadyAge,
		std::chrono::microseconds slo = std::chrono::milliseconds(50),
		std::chrono::microseconds emergency = std::chrono::milliseconds(100)
	);

	[[nodiscard]] DispatcherLoadState getState() const {
		return state;
	}

private:
	[[nodiscard]] static DispatcherBudgetSet budgetsForState(const DispatcherBudgetSet &configured, DispatcherLoadState state);

	DispatcherLoadState state = DispatcherLoadState::Normal;
	uint8_t healthyWindows = 0;
};
