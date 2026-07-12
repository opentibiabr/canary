/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/instance/instance_manager.hpp"

InstanceManager::InstanceManager(std::size_t slotCount) :
	slotReserved(slotCount, false) {
}

std::optional<InstanceSlotId> InstanceManager::reserveSlotLocked() {
	for (std::size_t index = 0; index < slotReserved.size(); ++index) {
		if (!slotReserved[index]) {
			slotReserved[index] = true;
			return toSlotId(static_cast<uint32_t>(index));
		}
	}
	return std::nullopt;
}

void InstanceManager::releaseSlotLocked(InstanceSlotId slot) {
	const auto index = toIndex(slot);
	if (index < slotReserved.size()) {
		slotReserved[index] = false;
	}
}

InstanceManager::CreateResult InstanceManager::createInstance(const InstanceDefinition &definition) {
	std::scoped_lock lock(mutex);

	const auto slot = reserveSlotLocked();
	if (!slot) {
		return { .ok = false, .id = InstanceId::Invalid, .error = "no available instance slots" };
	}

	InstanceRecord record;
	record.id = static_cast<InstanceId>(nextInstanceId++);
	record.slot = *slot;
	record.state = InstanceState::Creating;
	record.definition = definition;
	if (definition.timeout.count() > 0) {
		record.expiresAt = std::chrono::steady_clock::now() + definition.timeout;
	}

	const auto id = record.id;
	instances.emplace(id, std::move(record));
	return { .ok = true, .id = id, .error = {} };
}

bool InstanceManager::activate(InstanceId id) {
	std::scoped_lock lock(mutex);
	const auto it = instances.find(id);
	if (it == instances.end() || it->second.state != InstanceState::Creating) {
		return false;
	}
	it->second.state = InstanceState::Active;
	return true;
}

bool InstanceManager::close(InstanceId id) {
	InstanceCleanupCallback callback;
	InstanceSlotId slot = InstanceSlotId::Invalid;

	{
		std::scoped_lock lock(mutex);
		const auto it = instances.find(id);
		if (it == instances.end()) {
			return false;
		}
		if (it->second.state == InstanceState::Closing || it->second.state == InstanceState::Destroyed) {
			// Idempotent: whoever got here first already owns (or already
			// finished) the teardown. Nothing left for us to do.
			return true;
		}

		it->second.state = InstanceState::Closing;
		callback = it->second.cleanupCallback;
		slot = it->second.slot;
	}

	// Run the callback outside the lock: it's caller-supplied code that may
	// take arbitrary time or (once later PRs wire this into the scheduler)
	// call back into this manager, which would deadlock if we still held it.
	if (callback) {
		callback(id, slot);
	}

	{
		std::scoped_lock lock(mutex);
		const auto it = instances.find(id);
		if (it != instances.end()) {
			it->second.state = InstanceState::Destroyed;
		}
		releaseSlotLocked(slot);
	}

	return true;
}

void InstanceManager::setCleanupCallback(InstanceId id, InstanceCleanupCallback callback) {
	std::scoped_lock lock(mutex);
	const auto it = instances.find(id);
	if (it != instances.end()) {
		it->second.cleanupCallback = std::move(callback);
	}
}

std::optional<InstanceState> InstanceManager::getState(InstanceId id) const {
	std::scoped_lock lock(mutex);
	const auto it = instances.find(id);
	if (it == instances.end()) {
		return std::nullopt;
	}
	return it->second.state;
}

std::optional<InstanceSlotId> InstanceManager::getSlot(InstanceId id) const {
	std::scoped_lock lock(mutex);
	const auto it = instances.find(id);
	if (it == instances.end()) {
		return std::nullopt;
	}
	return it->second.slot;
}

std::size_t InstanceManager::closeExpiredInstances(std::chrono::steady_clock::time_point now) {
	std::vector<InstanceId> expired;
	{
		std::scoped_lock lock(mutex);
		for (const auto &[id, record] : instances) {
			if (record.definition.timeout.count() <= 0) {
				continue;
			}
			if (record.state == InstanceState::Closing || record.state == InstanceState::Destroyed) {
				continue;
			}
			if (now >= record.expiresAt) {
				expired.push_back(id);
			}
		}
	}

	for (const auto id : expired) {
		close(id);
	}
	return expired.size();
}

std::size_t InstanceManager::activeInstanceCount() const {
	std::scoped_lock lock(mutex);
	std::size_t count = 0;
	for (const auto &[id, record] : instances) {
		if (record.state == InstanceState::Creating || record.state == InstanceState::Active) {
			++count;
		}
	}
	return count;
}

std::size_t InstanceManager::availableSlotCount() const {
	std::scoped_lock lock(mutex);
	std::size_t available = 0;
	for (const bool reserved : slotReserved) {
		if (!reserved) {
			++available;
		}
	}
	return available;
}

std::size_t InstanceManager::totalSlotCount() const {
	return slotReserved.size();
}
