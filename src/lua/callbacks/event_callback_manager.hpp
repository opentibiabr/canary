/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "lua/callbacks/event_callback.hpp"

class EventCallbackManager {
public:
	using CallbackPtr = std::shared_ptr<EventCallback>;

	void registerCallback(const CallbackPtr &callback);
	void unregisterCallback(const CallbackPtr &callback);

	template <typename... Args>
	[[nodiscard]] bool checkCallback(EventCallback_t type, Args &&... args) const {
		const auto &vec = m_callbacks[static_cast<size_t>(type)];
		return std::ranges::all_of(vec, [&](const CallbackPtr &cb) {
			return !cb->canExecute() || cb->execute(std::forward<Args>(args)...);
		});
	}

	const std::vector<CallbackPtr> &getCallbacks(EventCallback_t type) const noexcept;

private:
	static constexpr size_t kEventTypeCount = static_cast<size_t>(EventCallback_t::last);
	static constexpr size_t kDefaultReserve = 4;
	std::array<std::vector<CallbackPtr>, kEventTypeCount> m_callbacks;
};
