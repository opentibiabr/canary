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

BatchUpdate::State::~State() {
	const auto actorLocked = actor.lock();
	auto* actorPtr = actorLocked.get();
	for (const auto &containerWeak : cached) {
		if (auto container = containerWeak.lock()) {
			container->endBatchUpdate(actorPtr);
		}
	}
	if (actorLocked) {
		actorLocked->endBatchUpdate();
	}
}

BatchUpdate::BatchUpdate(const std::shared_ptr<Player> &actor) :
	m_state(actor) { }

bool BatchUpdate::add(const std::shared_ptr<Container> &container) {
	if (!container) {
		return false;
	}

	for (auto it = m_state.cached.begin(); it != m_state.cached.end();) {
		if (auto existing = it->lock()) {
			if (existing.get() == container.get()) {
				return false;
			}
			++it;
		} else {
			it = m_state.cached.erase(it);
		}
	}

	const auto &added = m_state.cached.emplace_back(container);
	(void)added;
	container->beginBatchUpdate();
	return true;
}

void BatchUpdate::addContainers(const std::vector<std::shared_ptr<Container>> &containers) {
	for (const auto &container : containers) {
		const auto addResult = add(container);
		(void)addResult;
	}
}
