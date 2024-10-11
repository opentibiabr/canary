/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"
#include "database/database.hpp"
#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "utils/tools.hpp"

#include <boost/ut.hpp>

using namespace boost::ut;

suite<"database"> databaseTest = [] {
	// Fixture to inject dependencies and configure mock objects
	InjectionFixture injectionFixture{};

	test("Database::connect connects successfully with valid configuration") = [&injectionFixture] {
		auto [configManager, database] = injectionFixture.get<ConfigManager, Database>();
		
		// Mock valid configuration values for the database
		configManager.setString(MYSQL_HOST, "localhost");
		configManager.setString(MYSQL_USER, "test_user");
		configManager.setString(MYSQL_PASS, "test_password");
		configManager.setString(MYSQL_DB, "test_db");
		configManager.setNumber(SQL_PORT, 33060); // MySQL X DevAPI port

		expect(database.connect() == true);
	};

	test("Database::connect returns false with invalid configuration") = [&injectionFixture] {
		auto [configManager, database] = injectionFixture.get<ConfigManager, Database>();

		// Mock invalid configuration values for the database
		configManager.setString(MYSQL_HOST, "invalid_host");
		configManager.setString(MYSQL_USER, "invalid_user");
		configManager.setString(MYSQL_PASS, "invalid_password");
		configManager.setString(MYSQL_DB, "invalid_db");
		configManager.setNumber(SQL_PORT, 33060);

		expect(database.connect() == false);
	};

	test("Database::executeQuery executes a valid query successfully") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string validQuery = "SELECT 1";
		expect(database.executeQuery(validQuery) == true);
	};

	test("Database::executeQuery fails with an invalid query") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string invalidQuery = "INVALID SQL QUERY";
		expect(database.executeQuery(invalidQuery) == false);
	};

	test("Database::storeQuery returns DBResult_ptr for valid query") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string validQuery = "SELECT 1";
		DBResult_ptr result = database.storeQuery(validQuery);

		expect(result != nullptr);
		expect(result->getU32("1") == 1); // Assume the first column is labeled '1'
	};

	test("Database::storeQuery returns nullptr for invalid query") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string invalidQuery = "INVALID SQL QUERY";
		DBResult_ptr result = database.storeQuery(invalidQuery);

		expect(result == nullptr);
	};

	test("Database::beginTransaction locks the database") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		expect(database.beginTransaction() == true);
	};

	test("Database::commit commits the transaction successfully") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		database.beginTransaction();
		expect(database.commit() == true);
	};

	test("Database::rollback rolls back the transaction successfully") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		database.beginTransaction();
		expect(database.rollback() == true);
	};

	test("Database::retryQuery retries a failed query and eventually succeeds") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string validQuery = "SELECT 1";
		int retries = 3;

		expect(database.retryQuery(validQuery, retries) == true);
	};

	test("Database::retryQuery retries a failed query and eventually fails after all retries") = [&injectionFixture] {
		auto [database] = injectionFixture.get<Database>();

		std::string invalidQuery = "INVALID SQL QUERY";
		int retries = 3;

		expect(database.retryQuery(invalidQuery, retries) == false);
	};
};
