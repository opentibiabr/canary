#include "utils/batch_update.hpp"

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"

BatchUpdate::BatchUpdate(Player* actor) :
	m_actor(actor) {
	if (m_actor) {
		m_actor->beginBatchUpdate();
	}
}

bool BatchUpdate::add(Container* rawContainer) {
	if (rawContainer && std::ranges::find(m_cached, rawContainer) == m_cached.end()) {
		m_cached.push_back(rawContainer);
		rawContainer->beginBatchUpdate();
		return true;
	}

	return false;
}

void BatchUpdate::addContainers(const std::vector<Container*> &cs) {
	for (auto* rawContainer : cs) {
		add(rawContainer);
	}
}

BatchUpdate::~BatchUpdate() {
	for (auto* containerRaw : m_cached) {
		containerRaw->endBatchUpdate(m_actor);
	}
	if (m_actor) {
		m_actor->endBatchUpdate();
	}
}
