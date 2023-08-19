/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "database/databasetasks.h"
#include "game/scheduling/dispatcher.hpp"
#include "lib/thread/thread_pool.hpp"

DatabaseTasks::DatabaseTasks(ThreadPool &threadPool, Database &db) :
	db(db), threadPool(threadPool) {
}

DatabaseTasks &DatabaseTasks::getInstance() {
	return inject<DatabaseTasks>();
}

void DatabaseTasks::addTask(std::string query, std::function<void(DBResult_ptr, bool)> callback /* = nullptr*/, bool store /* = false*/) {
	threadPool.addLoad([this, query, callback, store]() {
		std::lock_guard lockClass(threadSafetyMutex);

		bool success;
		DBResult_ptr result;
		if (store) {
			result = db.storeQuery(query);
			success = true;
		} else {
			result = nullptr;
			success = db.executeQuery(query);
		}

		if (callback) {
			g_dispatcher().addTask(
				[callback, result, success]() { callback(result, success); }
			);
		}
	});
}
