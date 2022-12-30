/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "pch.hpp"

#include "database/databasetasks.h"
#include "game/scheduling/tasks.h"

DatabaseTasks::DatabaseTasks() {
  db_ = &Database::getInstance();
}

bool DatabaseTasks::SetDatabaseInterface(Database *database) {
  if (database == nullptr) {
    return false;
  }

  db_ = database;
  return true;
}

void DatabaseTasks::start()
{
  if (db_ == nullptr) {
    return;
  }
	db_->connect();
	ThreadHolder::start();
}

void DatabaseTasks::startThread()
{
	ThreadHolder::start();
}

void DatabaseTasks::threadMain()
{
	std::unique_lock<std::mutex> taskLockUnique(taskLock, std::defer_lock);
	while (getState() != THREAD_STATE_TERMINATED) {
		taskLockUnique.lock();
		if (tasks.empty()) {
			if (flushTasks) {
				flushSignal.notify_one();
			}
			taskSignal.wait(taskLockUnique);
		}

		if (!tasks.empty()) {
			DatabaseTask task = std::move(tasks.front());
			tasks.pop_front();
			taskLockUnique.unlock();
			runTask(task);
		} else {
			taskLockUnique.unlock();
		}
	}
}

void DatabaseTasks::addTask(std::string query, std::function<void(DBResult_ptr, bool)> callback/* = nullptr*/, bool store/* = false*/)
{
	bool signal = false;
	taskLock.lock();
	if (getState() == THREAD_STATE_RUNNING) {
		signal = tasks.empty();
		tasks.emplace_back(std::move(query), std::move(callback), store);
	}
	taskLock.unlock();

	if (signal) {
		taskSignal.notify_one();
	}
}

void DatabaseTasks::runTask(const DatabaseTask& task)
{
  if (db_ == nullptr) {
    return;
  }
  bool success;
	DBResult_ptr result;
	if (task.store) {
		result = db_->storeQuery(task.query);
		success = true;
	} else {
		result = nullptr;
		success = db_->executeQuery(task.query);
	}

	if (task.callback) {
		g_dispatcher().addTask(createTask(std::bind(task.callback, result, success)));
	}
}

void DatabaseTasks::flush()
{
	std::unique_lock<std::mutex> guard{ taskLock };
	if (!tasks.empty()) {
		flushTasks = true;
		flushSignal.wait(guard);
		flushTasks = false;
	}
}

void DatabaseTasks::shutdown()
{
	taskLock.lock();
	setState(THREAD_STATE_TERMINATED);
	taskLock.unlock();
	flush();
	taskSignal.notify_one();
}
