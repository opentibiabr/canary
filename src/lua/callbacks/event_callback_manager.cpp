/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "lua/callbacks/event_callback_manager.hpp"

void EventCallbackManager::registerCallback(const CallbackPtr &callback) {
	const auto idx = static_cast<size_t>(callback->getType());
	auto &vec = m_callbacks[idx];

	const bool isDup = std::ranges::any_of(vec, [&](const CallbackPtr &cb) {
		return cb->getName() == callback->getName();
	});

	if (isDup) {
		if (!callback->skipDuplicationCheck()) {
			g_logger().warn("[EventCallbackManager::registerCallback] duplicate callback '{}'", callback->getName());
			return;
		}
	}

	if (vec.empty()) {
		vec.reserve(4);
	}

	auto it = std::ranges::find_if(vec, [&](const CallbackPtr &cb) {
		return cb->getPriority() < callback->getPriority();
	});
	vec.insert(it, callback);
}

void EventCallbackManager::unregisterCallback(const CallbackPtr &callback) {
	const auto idx = static_cast<size_t>(callback->getType());
	auto &vec = m_callbacks[idx];
	auto it = std::ranges::find(vec, callback);
	if (it != vec.end()) {
		vec.erase(it);
	}
}

const std::vector<EventCallbackManager::CallbackPtr> &EventCallbackManager::getCallbacks(EventCallback_t type) const noexcept {
	return m_callbacks[static_cast<size_t>(type)];
}
