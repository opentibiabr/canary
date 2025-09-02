#pragma once

#include <exception>
#include <functional>
#include <string>

#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_database.hpp"

struct TestEnv final {
	di::extension::injector<> injector {};
	InMemoryLogger* logger { nullptr };
	Database* db { nullptr };

	TestEnv() {
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);
		logger = &dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());
		TestDatabase::init();
		db = &g_database();
	}

	static TestEnv &instance() {
		static TestEnv env;
		return env;
	}
};

inline auto databaseTest(Database &db, const std::function<void(void)> &load) {
	return [&db, load] {
		db.executeQuery("BEGIN");

		std::exception_ptr ep {};
		try {
			load();
		} catch (const DatabaseException &) {
			ep = std::current_exception();
		}

		db.executeQuery("ROLLBACK");
		if (ep) {
			std::rethrow_exception(ep);
		}
	};
}
