/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/batch_update.hpp"

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"

BatchUpdate::BatchUpdate(const std::shared_ptr<Player> &actor) :
	m_actor(actor) {
	if (auto actorLocked = m_actor.lock()) {
		actorLocked->beginBatchUpdate();
	}
}

bool BatchUpdate::add(const std::shared_ptr<Container> &container) {
	if (!container) {
		return false;
	}

	for (auto it = m_cached.begin(); it != m_cached.end();) {
		if (auto existing = it->lock()) {
			if (existing.get() == container.get()) {
				return false;
			}
			++it;
		} else {
			it = m_cached.erase(it);
		}
	}

	m_cached.emplace_back(container);
	container->beginBatchUpdate();
	return true;
}

void BatchUpdate::addContainers(const std::vector<std::shared_ptr<Container>> &containers) {
	for (const auto &container : containers) {
		add(container);
	}
}

BatchUpdate::~BatchUpdate() {
	const auto actorLocked = m_actor.lock();
	auto* actor = actorLocked.get();
	for (const auto &containerWeak : m_cached) {
		if (auto container = containerWeak.lock()) {
			container->endBatchUpdate(actor);
		}
	}
	if (actorLocked) {
		actorLocked->endBatchUpdate();
	}
}
