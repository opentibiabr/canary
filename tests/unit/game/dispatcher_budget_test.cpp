/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/scheduling/dispatcher_budget.hpp"

using namespace std::chrono_literals;

TEST(DispatcherAdaptiveBudgetControllerTest, PreservesConfiguredBudgetsUnderSlo) {
	DispatcherAdaptiveBudgetController controller;
	const DispatcherBudgetSet configured;
	const auto decision = controller.update(configured, 20ms, 30ms);

	EXPECT_EQ(decision.state, DispatcherLoadState::Normal);
	EXPECT_EQ(decision.budgets, configured);
	EXPECT_EQ(decision.controlLatency, 30ms);
}

TEST(DispatcherAdaptiveBudgetControllerTest, ReducesBackgroundSlicesAtSloAndEmergency) {
	DispatcherAdaptiveBudgetController controller;
	const DispatcherBudgetSet configured;

	const auto constrained = controller.update(configured, 50ms, 10ms);
	EXPECT_EQ(constrained.state, DispatcherLoadState::Constrained);
	EXPECT_EQ(constrained.budgets.creatureWalkTasks, 64);
	EXPECT_EQ(constrained.budgets.walkParallelTasks, 4);
	EXPECT_EQ(constrained.budgets.creatureAsyncTasksPerBucket, 8);
	EXPECT_EQ(constrained.budgets.deferredGameplayTasks, 8);
	EXPECT_EQ(constrained.budgets.workerCompletions, 32);
	EXPECT_EQ(constrained.budgets.sliceRuntime, 1ms);

	const auto emergency = controller.update(configured, 20ms, 100ms);
	EXPECT_EQ(emergency.state, DispatcherLoadState::Emergency);
	EXPECT_EQ(emergency.budgets.creatureWalkTasks, 32);
	EXPECT_EQ(emergency.budgets.walkParallelTasks, 2);
	EXPECT_EQ(emergency.budgets.creatureAsyncTasksPerBucket, 4);
	EXPECT_EQ(emergency.budgets.deferredGameplayTasks, 4);
	EXPECT_EQ(emergency.budgets.workerCompletions, 16);
	EXPECT_EQ(emergency.budgets.sliceRuntime, 500us);
}

TEST(DispatcherAdaptiveBudgetControllerTest, RequiresHealthyWindowsBeforeRelaxing) {
	DispatcherAdaptiveBudgetController controller;
	const DispatcherBudgetSet configured;
	EXPECT_EQ(controller.update(configured, 100ms, 0ms).state, DispatcherLoadState::Emergency);

	for (int index = 0; index < 3; ++index) {
		EXPECT_EQ(controller.update(configured, 10ms, 0ms).state, DispatcherLoadState::Emergency);
	}
	EXPECT_EQ(controller.update(configured, 10ms, 0ms).state, DispatcherLoadState::Constrained);

	for (int index = 0; index < 3; ++index) {
		EXPECT_EQ(controller.update(configured, 10ms, 0ms).state, DispatcherLoadState::Constrained);
	}
	EXPECT_EQ(controller.update(configured, 10ms, 0ms).state, DispatcherLoadState::Normal);
}

TEST(DispatcherAdaptiveBudgetControllerTest, NeverRaisesSmallConfiguredMinimums) {
	DispatcherAdaptiveBudgetController controller;
	DispatcherBudgetSet configured;
	configured.creatureWalkTasks = 1;
	configured.walkParallelTasks = 1;
	configured.creatureAsyncTasksPerBucket = 1;
	configured.deferredGameplayTasks = 1;
	configured.workerCompletions = 1;
	configured.sliceRuntime = 100us;

	const auto decision = controller.update(configured, 200ms, 0ms);
	EXPECT_EQ(decision.state, DispatcherLoadState::Emergency);
	EXPECT_EQ(decision.budgets, configured);
}

TEST(DispatcherAdaptiveBudgetControllerTest, NormalizesInvalidZeroBudgetsToOne) {
	DispatcherAdaptiveBudgetController controller;
	DispatcherBudgetSet configured;
	configured.creatureWalkTasks = 0;
	configured.walkParallelTasks = 0;
	configured.creatureAsyncTasksPerBucket = 0;
	configured.deferredGameplayTasks = 0;
	configured.workerCompletions = 0;
	configured.sliceRuntime = 0us;

	const auto decision = controller.update(configured, 0us, 0us);
	EXPECT_EQ(decision.budgets.creatureWalkTasks, 1);
	EXPECT_EQ(decision.budgets.walkParallelTasks, 1);
	EXPECT_EQ(decision.budgets.creatureAsyncTasksPerBucket, 1);
	EXPECT_EQ(decision.budgets.deferredGameplayTasks, 1);
	EXPECT_EQ(decision.budgets.workerCompletions, 1);
	EXPECT_EQ(decision.budgets.sliceRuntime, 1us);
}
