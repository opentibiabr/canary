/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/instance/instance_id.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <chrono>
	#include <cstdint>
	#include <functional>
	#include <mutex>
	#include <optional>
	#include <string>
	#include <unordered_map>
	#include <vector>
#endif

enum class InstanceState : uint8_t {
	Creating,
	Active,
	Closing,
	Destroyed,
};

// A slot is an opaque, reservable resource an instance holds for its
// lifetime. This foundation doesn't say what a slot physically is - a later
// PR (the map region pool) gives InstanceSlotId real map-region meaning and
// hands out pre-carved, physically separate map areas instead of copying
// the map per instance. Until then, a slot is just an index into a fixed
// pool, which is exactly what map-region assignment needs underneath it.
struct InstanceDefinition {
	std::string name;
	// 0 means no automatic timeout; the instance only closes when close()
	// is called explicitly.
	std::chrono::seconds timeout { 0 };
};

using InstanceCleanupCallback = std::function<void(InstanceId, InstanceSlotId)>;

// Owns a fixed pool of slots and the lifecycle of instances that reserve
// them. Deliberately a plain, constructor-instantiated class rather than a
// g_x() singleton - see docs/architecture/dependency-migration.md for why
// this workstream is trying to avoid adding new global singletons rather
// than migrating them later. How this gets wired into Game/the map/the
// scheduler is a later PR's decision, not this one's.
class InstanceManager {
public:
	explicit InstanceManager(std::size_t slotCount);

	// non-copyable: owns unique slot reservations and per-instance state.
	InstanceManager(const InstanceManager &) = delete;
	InstanceManager &operator=(const InstanceManager &) = delete;

	struct CreateResult {
		bool ok = false;
		InstanceId id = InstanceId::Invalid;
		std::string error;
	};

	// Reserves a free slot and creates the instance in the Creating state.
	// Fails (ok=false) if every slot is already reserved - this is the
	// instance-count limit, enforced by construction rather than a second,
	// separate counter.
	[[nodiscard]] CreateResult createInstance(const InstanceDefinition &definition);

	// Creating -> Active. Returns false without changing anything if the
	// instance is unknown or not currently Creating.
	bool activate(InstanceId id);

	// Idempotent: {Creating, Active} -> Closing -> Destroyed. Releases the
	// reserved slot and runs the cleanup callback exactly once, regardless
	// of how many times or how concurrently close() is called for the same
	// instance. Returns false only if the instance id was never known;
	// returns true (no-op) if it's already Closing or Destroyed.
	bool close(InstanceId id);

	// Replaces the cleanup callback for an instance. No-op if the instance
	// is unknown. Safe to call before or after activate().
	void setCleanupCallback(InstanceId id, InstanceCleanupCallback callback);

	[[nodiscard]] std::optional<InstanceState> getState(InstanceId id) const;
	[[nodiscard]] std::optional<InstanceSlotId> getSlot(InstanceId id) const;

	// Closes every instance whose definition timeout has elapsed as of
	// `now`. Instances with timeout == 0 are never touched. Goes through
	// the same idempotent close(), so this is safe to call repeatedly (e.g.
	// from a periodic sweep) without double-running cleanup.
	std::size_t closeExpiredInstances(std::chrono::steady_clock::time_point now = std::chrono::steady_clock::now());

	[[nodiscard]] std::size_t activeInstanceCount() const;
	[[nodiscard]] std::size_t availableSlotCount() const;
	[[nodiscard]] std::size_t totalSlotCount() const;

private:
	struct InstanceRecord {
		InstanceId id = InstanceId::Invalid;
		InstanceSlotId slot = InstanceSlotId::Invalid;
		InstanceState state = InstanceState::Creating;
		InstanceDefinition definition;
		std::chrono::steady_clock::time_point expiresAt {};
		InstanceCleanupCallback cleanupCallback;
	};

	[[nodiscard]] std::optional<InstanceSlotId> reserveSlotLocked();
	void releaseSlotLocked(InstanceSlotId slot);

	mutable std::mutex mutex;
	std::vector<bool> slotReserved;
	std::unordered_map<InstanceId, InstanceRecord> instances;
	uint32_t nextInstanceId = 1;
};
