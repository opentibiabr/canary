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

BatchUpdate::State::State(const std::shared_ptr<Player> &actor) :
	actor(actor) {
	if (auto actorLocked = this->actor.lock()) {
		actorLocked->beginBatchUpdate();
	}
}

BatchUpdate::BatchUpdate(const std::shared_ptr<Player> &actor) :
	m_state(actor) { }

BatchUpdate::~BatchUpdate() {
	const auto actorLocked = m_state.actor.lock();
	auto* actorPtr = actorLocked.get();
	for (const auto &containerWeak : m_state.cached) {
		if (auto container = containerWeak.lock()) {
			container->endBatchUpdate(actorPtr);
		}
	}
	if (actorLocked) {
		actorLocked->endBatchUpdate();
	}
}

bool BatchUpdate::add(const std::shared_ptr<Container> &container) {
	if (!container) {
		return false;
	}

	const auto cached = m_state.cachedLookup.find(container.get());
	if (cached != m_state.cachedLookup.end()) {
		if (!cached->second.expired()) {
			return false;
		}

		m_state.cachedLookup.erase(cached);
	}

	m_state.cachedLookup.emplace(container.get(), container);
	m_state.cached.emplace_back(container);
	container->beginBatchUpdate();
	return true;
}

void BatchUpdate::addContainers(const std::vector<std::shared_ptr<Container>> &containers) {
	for (const auto &container : containers) {
		add(container);
	}
}
