#pragma once

#include "game/scheduling/dispatcher.hpp"

#include <chrono>
#include <future>
#include <stdexcept>
#include <string>

// Posts a callable onto the game dispatcher and synchronously waits for its result.
// API request handlers run on Crow worker threads; touching g_game() or Database from
// those threads races with the game loop. This helper marshals the call so it executes
// inside the dispatcher's serial event loop.
//
// Times out after `timeoutMs` to avoid blocking a Crow worker indefinitely if the
// dispatcher is wedged. On timeout, throws std::runtime_error.
template <typename F>
auto runOnDispatcher(F &&f, const std::string &context, uint32_t timeoutMs = 2000) {
	using R = std::invoke_result_t<F>;
	auto promise = std::make_shared<std::promise<R>>();
	auto future = promise->get_future();

	g_dispatcher().addEvent(
		[fn = std::forward<F>(f), promise]() mutable {
			try {
				if constexpr (std::is_void_v<R>) {
					fn();
					promise->set_value();
				} else {
					promise->set_value(fn());
				}
			} catch (...) {
				promise->set_exception(std::current_exception());
			}
		},
		context
	);

	if (future.wait_for(std::chrono::milliseconds(timeoutMs)) != std::future_status::ready) {
		throw std::runtime_error("Dispatcher timeout");
	}
	if constexpr (std::is_void_v<R>) {
		future.get();
	} else {
		return future.get();
	}
}
