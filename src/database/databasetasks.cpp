/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "database/databasetasks.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/thread/thread_pool.hpp"
#include "lib/di/container.hpp"

DatabaseTasks::DatabaseTasks(ThreadPool &threadPool, Database &db) :
	db(db), threadPool(threadPool) {
}

DatabaseTasks &DatabaseTasks::getInstance() {
	return inject<DatabaseTasks>();
}

void DatabaseTasks::execute(const std::string &query, std::function<void(DBResult_ptr, bool)> callback /* nullptr */) {
	threadPool.detach_task([this, query, callback]() {
		bool success = db.executeQuery(query);
		if (callback != nullptr) {
			g_dispatcher().addEvent([callback, success]() { callback(nullptr, success); }, "DatabaseTasks::execute");
		}
	});
}

void DatabaseTasks::store(const std::string &query, std::function<void(DBResult_ptr, bool)> callback /* nullptr */) {
	threadPool.detach_task([this, query, callback]() {
		DBResult_ptr result = db.storeQuery(query);
		if (callback != nullptr) {
			g_dispatcher().addEvent([callback, result]() { callback(result, true); }, "DatabaseTasks::store");
		}
	});
}
