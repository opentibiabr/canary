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
	InMemoryLogger* logger;
	Database* db;

	TestEnv();

	static TestEnv &instance();

private:
	InMemoryLogger* initLogger();
	Database* initDb();
};

inline TestEnv::TestEnv() :
	injector {}, logger(initLogger()), db(initDb()) { }

inline InMemoryLogger* TestEnv::initLogger() {
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);
	return &dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());
}

inline Database* TestEnv::initDb() {
	TestDatabase::init();
	return &g_database();
}

inline TestEnv testEnvInstance {};

inline TestEnv &TestEnv::instance() {
	return testEnvInstance;
}

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
