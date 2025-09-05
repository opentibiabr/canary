#pragma once

#include <exception>
#include <functional>

#include "database/database.hpp"

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
