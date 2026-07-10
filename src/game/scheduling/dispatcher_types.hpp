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
	#include <cstdint>
#endif

inline constexpr uint32_t DISPATCHER_MAX_TASK_COST = 32;

enum class DispatcherLane : uint8_t {
	ProtocolInput,
	PlayerWalk,
	PlayerAction,
	WorldCommit,
	WorkerCompletion,
	VisibleMonster,
	MonsterAI,
	Deferred,
	Maintenance,
	GenericParallel,
	Last
};

enum class ExecutionMode : uint8_t {
	Serial,
	BarrierParallel,
	BackgroundCompletion
};

struct TaskMeta {
	DispatcherLane lane = DispatcherLane::WorldCommit;
	ExecutionMode executionMode = ExecutionMode::Serial;
	uint64_t producerToken = 0;
	std::chrono::steady_clock::time_point readyAt {};
	uint64_t generation = 0;
	uint32_t estimatedCost = 1;
};

[[nodiscard]] constexpr ExecutionMode defaultExecutionMode(const DispatcherLane lane) {
	if (lane == DispatcherLane::MonsterAI || lane == DispatcherLane::GenericParallel) {
		return ExecutionMode::BarrierParallel;
	}
	if (lane == DispatcherLane::WorkerCompletion) {
		return ExecutionMode::BackgroundCompletion;
	}
	return ExecutionMode::Serial;
}

[[nodiscard]] constexpr bool isMovementCommit(const DispatcherLane lane) {
	return lane == DispatcherLane::PlayerWalk || lane == DispatcherLane::VisibleMonster;
}

[[nodiscard]] constexpr bool isPlayerVisible(const DispatcherLane lane) {
	return lane == DispatcherLane::ProtocolInput || lane == DispatcherLane::PlayerWalk || lane == DispatcherLane::PlayerAction || lane == DispatcherLane::WorldCommit || lane == DispatcherLane::WorkerCompletion || lane == DispatcherLane::VisibleMonster;
}

[[nodiscard]] constexpr bool usesProducerFairness(const DispatcherLane lane) {
	return lane == DispatcherLane::ProtocolInput || lane == DispatcherLane::PlayerWalk || lane == DispatcherLane::PlayerAction;
}
