/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "game/game.h"
#include "game/scheduling/tasks.h"

Task* createTask(std::function<void(void)> f) {
	return new Task(std::move(f));
}

void Dispatcher::threadMain()
{
	io_service.run();
	g_database.disconnect();
}

void Dispatcher::addTask(std::function<void (void)> functor)
{
	asio::post(io_service, [this, functor]() {
		++dispatcherCycle;

		// execute it
		(functor)();
	});
}

void Dispatcher::addTask(Task* task)
{
	asio::post(io_service, [this, task]() {
		++dispatcherCycle;

		// execute it
		(*task)();
		delete task;
	});
}

void Dispatcher::shutdown()
{
	asio::post(io_service, [this]() {
		setState(THREAD_STATE_TERMINATED);
		io_service.stop();
	});
}
