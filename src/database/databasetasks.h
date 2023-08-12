/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_DATABASE_DATABASETASKS_H_
#define SRC_DATABASE_DATABASETASKS_H_

#include "database/database.h"
#include "utils/thread_holder_base.h"

class DatabaseTasks : public ThreadHolder<DatabaseTasks> {
	public:
		DatabaseTasks();

		// Ensures that we don't accidentally copy it
		DatabaseTasks(const DatabaseTasks &) = delete;
		DatabaseTasks &operator=(const DatabaseTasks &) = delete;

		static DatabaseTasks &getInstance();

		void addTask(std::string query, std::function<void(DBResult_ptr, bool)> callback = nullptr, bool store = false);

	private:
		Database* db_;
};

constexpr auto g_databaseTasks = DatabaseTasks::getInstance;

#endif // SRC_DATABASE_DATABASETASKS_H_
