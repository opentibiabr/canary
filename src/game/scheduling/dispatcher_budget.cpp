/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher_budget.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

namespace {
	constexpr uint8_t HEALTHY_WINDOWS_TO_RELAX = 4;

	size_t scaledBudget(size_t configured, size_t divisor, size_t minimum) {
		const auto scaled = std::max<size_t>(1, configured / divisor);
		return std::min(configured, std::max(minimum, scaled));
	}

	std::chrono::microseconds scaledRuntime(std::chrono::microseconds configured, int64_t divisor, std::chrono::microseconds minimum) {
		const auto scaled = std::max(std::chrono::microseconds(1), configured / divisor);
		return std::min(configured, std::max(minimum, scaled));
	}

	DispatcherBudgetSet normalizeBudgets(DispatcherBudgetSet budgets) {
		budgets.creatureWalkTasks = std::max<size_t>(1, budgets.creatureWalkTasks);
		budgets.walkParallelTasks = std::max<size_t>(1, budgets.walkParallelTasks);
		budgets.creatureAsyncTasksPerBucket = std::max<size_t>(1, budgets.creatureAsyncTasksPerBucket);
		budgets.deferredGameplayTasks = std::max<size_t>(1, budgets.deferredGameplayTasks);
		budgets.workerCompletions = std::max<size_t>(1, budgets.workerCompletions);
		budgets.sliceRuntime = std::max(std::chrono::microseconds(1), budgets.sliceRuntime);
		return budgets;
	}
}

DispatcherBudgetDecision DispatcherAdaptiveBudgetController::update(const DispatcherBudgetSet &configured, std::chrono::microseconds visibleP99, std::chrono::microseconds oldestVisibleReadyAge, std::chrono::microseconds slo, std::chrono::microseconds emergency) {
	slo = std::max(std::chrono::microseconds(1), slo);
	emergency = std::max(slo + std::chrono::microseconds(1), emergency);
	const auto controlLatency = std::max(visibleP99, oldestVisibleReadyAge);
	const auto previousState = state;

	if (controlLatency >= emergency) {
		state = DispatcherLoadState::Emergency;
		healthyWindows = 0;
	} else if (controlLatency >= slo) {
		if (state == DispatcherLoadState::Normal) {
			state = DispatcherLoadState::Constrained;
		}
		healthyWindows = 0;
	} else {
		const auto recoveryThreshold = state == DispatcherLoadState::Emergency ? slo : slo * 7 / 10;
		if (state != DispatcherLoadState::Normal && controlLatency <= recoveryThreshold) {
			if (++healthyWindows >= HEALTHY_WINDOWS_TO_RELAX) {
				state = state == DispatcherLoadState::Emergency ? DispatcherLoadState::Constrained : DispatcherLoadState::Normal;
				healthyWindows = 0;
			}
		} else {
			healthyWindows = 0;
		}
	}

	return {
		.budgets = budgetsForState(configured, state),
		.state = state,
		.controlLatency = controlLatency,
		.stateChanged = state != previousState,
	};
}

DispatcherBudgetSet DispatcherAdaptiveBudgetController::budgetsForState(const DispatcherBudgetSet &configured, DispatcherLoadState state) {
	const auto normalized = normalizeBudgets(configured);
	auto budgets = normalized;
	if (state == DispatcherLoadState::Normal) {
		return budgets;
	}

	const bool emergency = state == DispatcherLoadState::Emergency;
	const size_t divisor = emergency ? 4 : 2;
	budgets.creatureWalkTasks = scaledBudget(normalized.creatureWalkTasks, divisor, emergency ? 16 : 32);
	budgets.walkParallelTasks = scaledBudget(normalized.walkParallelTasks, divisor, emergency ? 1 : 2);
	budgets.creatureAsyncTasksPerBucket = scaledBudget(normalized.creatureAsyncTasksPerBucket, divisor, emergency ? 2 : 4);
	budgets.deferredGameplayTasks = scaledBudget(normalized.deferredGameplayTasks, divisor, emergency ? 1 : 4);
	budgets.workerCompletions = scaledBudget(normalized.workerCompletions, divisor, emergency ? 4 : 8);
	budgets.sliceRuntime = scaledRuntime(normalized.sliceRuntime, static_cast<int64_t>(divisor), emergency ? std::chrono::microseconds(250) : std::chrono::microseconds(500));
	return budgets;
}
