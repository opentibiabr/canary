/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "lib/thread/thread_pool.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/scheduling/task.hpp"

Dispatcher::Dispatcher(ThreadPool &threadPool) :
	threadPool(threadPool) { }

Dispatcher &Dispatcher::getInstance() {
	return inject<Dispatcher>();
}

void Dispatcher::addTask(std::function<void(void)> f, uint32_t expiresAfterMs /* = 0*/) {
	addTask(std::make_shared<Task>(std::move(f)), expiresAfterMs);
}

void Dispatcher::addTask(const std::shared_ptr<Task> &task, uint32_t expiresAfterMs /* = 0*/) {
	if (expiresAfterMs == 0) {
		threadPool.addLoad([this, task]() {
			std::lock_guard lockClass(threadSafetyMutex);
			++dispatcherCycle;
			(*task)();
		});

		return;
	};

	auto timer = std::make_shared<asio::steady_timer>(threadPool.getIoContext());
	timer->expires_after(std::chrono::milliseconds(expiresAfterMs));

	timer->async_wait([task, expiresAfterMs](const std::error_code &error) {
		if (error == asio::error::operation_aborted) {
			return;
		}

		g_logger().info("Task was not executed within {} ms, so it was cancelled.", expiresAfterMs);
	});

	threadPool.addLoad([this, task, timer]() {
		std::lock_guard lockClass(threadSafetyMutex);
		if (timer->cancel() <= 0) {
			return;
		}

		++dispatcherCycle;
		(*task)();
	});
}