/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "database/database.hpp"
#include "lib/thread/thread_pool.hpp"

class DatabaseTasks {
public:
	DatabaseTasks(ThreadPool &threadPool, Database &db);

	// Ensures that we don't accidentally copy it
	DatabaseTasks(const DatabaseTasks &) = delete;
	DatabaseTasks &operator=(const DatabaseTasks &) = delete;

	static DatabaseTasks &getInstance();

	void execute(const std::string &query, std::function<void(DBResult_ptr, bool)> callback = nullptr);
	void store(const std::string &query, std::function<void(DBResult_ptr, bool)> callback = nullptr);

private:
	Database &db;
	ThreadPool &threadPool;
};

constexpr auto g_databaseTasks = DatabaseTasks::getInstance;
