/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_UTILS_THREAD_HOLDER_H_
#define SRC_UTILS_THREAD_HOLDER_H_

#include "declarations.hpp"

template <typename Derived>
class ThreadHolder {
	public:
		ThreadHolder() = default;

		// Ensures that we don't accidentally copy it
		ThreadHolder(const ThreadHolder &) = delete;
		ThreadHolder operator=(const ThreadHolder &) = delete;

		void start() {
			thread = std::thread(
				[this] { io_service.run(); }
			);
		}

		void addLoad(const std::function<void(void)> &load) {
			asio::post(io_service, [load]() { load(); });
		}

		void shutdown(const std::function<void(void)> &callback = []() {}) {
			asio::post(
				io_service,
				[this, callback]() { callback(); io_service.stop(); }
			);

			join();
		}

		void join() {
			if (!thread.joinable()) {
				return;
			}

			thread.join();
		}

	protected:
		asio::io_service io_service {};

	private:
		std::thread thread {};
		asio::io_service::work work { io_service };
};

#endif // SRC_UTILS_THREAD_HOLDER_H_
