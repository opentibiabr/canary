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

DatabaseTasks::DatabaseTasks() {
	db_ = &Database::getInstance();
}

DatabaseTasks &DatabaseTasks::getInstance() {
	return inject<DatabaseTasks>();
}

void DatabaseTasks::addTask(std::string query, std::function<void(DBResult_ptr, bool)> callback /* = nullptr*/, bool store /* = false*/) {
	addLoad([this, query, callback, store]() {
		if (db_ == nullptr) {
			return;
		}

		bool success;
		DBResult_ptr result;
		if (store) {
			result = db_->storeQuery(query);
			success = true;
		} else {
			result = nullptr;
			success = db_->executeQuery(query);
		}

		if (callback) {
			g_dispatcher().addTask(
				[callback, result, success]() { callback(result, success); }
			);
		}
	});
}
