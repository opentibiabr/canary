#pragma once

#include <cstdio>
#include <exception>
#include <functional>
#include <typeinfo>

#include "database/database.hpp"
#include "test_database.hpp"

inline auto databaseTest(Database &db, const std::function<void(void)> &load) {
	return [&db, load] {
		TestDatabase::init();
		db.executeQuery("BEGIN");

		std::exception_ptr ep {};
		try {
			load();
		} catch (const DatabaseException &) {
			ep = std::current_exception();
		} catch (const std::exception &e) {
			std::fprintf(stderr, "[databaseTest] std::exception: %s\n", e.what());
			std::fflush(stderr);
			ep = std::current_exception();
		} catch (...) {
			std::fprintf(stderr, "[databaseTest] non-std exception\n");
			std::fflush(stderr);
			ep = std::current_exception();
		}

		db.executeQuery("ROLLBACK");
		if (ep) {
			std::rethrow_exception(ep);
		}
	};
}
