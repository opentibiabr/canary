/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_DATABASE_DATABASETASKS_H_
#define SRC_DATABASE_DATABASETASKS_H_

#include "database/database.h"
#include "utils/thread_holder_base.h"

struct DatabaseTask {
	DatabaseTask(std::string&& initQuery, std::function<void(DBResult_ptr, bool)>&& initCallback, bool initStore) :
		query(std::move(initQuery)), callback(std::move(initCallback)), store(initStore) {}

	std::string query;
	std::function<void(DBResult_ptr, bool)> callback;
	bool store;
};

class DatabaseTasks : public ThreadHolder<DatabaseTasks>
{
	public:
		DatabaseTasks();

		// non-copyable
		DatabaseTasks(DatabaseTasks const&) = delete;
		void operator=(DatabaseTasks const&) = delete;

		static DatabaseTasks& getInstance() {
			// Guaranteed to be destroyed
			static DatabaseTasks instance;
			// Instantiated on first use
			return instance;
		}

		bool SetDatabaseInterface(Database *database);
		void start();
		void startThread();
		void flush();
		void shutdown();

		void addTask(std::string query, std::function<void(DBResult_ptr, bool)> callback = nullptr, bool store = false);

		void threadMain();
	private:
		void runTask(const DatabaseTask& task);

		Database *db_;
		std::thread thread;
		std::list<DatabaseTask> tasks;
		std::mutex taskLock;
		std::condition_variable taskSignal;
		std::condition_variable flushSignal;
		bool flushTasks = false;
};

constexpr auto g_databaseTasks = &DatabaseTasks::getInstance;

#endif  // SRC_DATABASE_DATABASETASKS_H_
