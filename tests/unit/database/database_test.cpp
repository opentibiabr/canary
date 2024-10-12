/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include <boost/ut.hpp>

#include "database/database.hpp"
#include "lib/logging/in_memory_logger.hpp"

using namespace boost::ut;

suite<"database"> databaseTest = [] {
	di::extension::injector<> injector {};
	DI::setTestContainer(&InMemoryLogger::install(injector));
	auto& logger = dynamic_cast<InMemoryLogger&>(injector.create<Logger&>());

	test("Database::connect should establish a connection") = [&]() {
		std::string host = "127.0.0.1";
		std::string user = "otserver";
		std::string password = "otserver";
		std::string database = "otservbr-global";
		uint32_t port = 33060;
		std::string sock;

		expect(g_database().connect(&host, &user, &password, &database, port, &sock)) << "Should successfully connect to the database";
		expect(g_database().isValidSession()) << "The database session should be valid after connection";
	};

	test("Database::executeQuery should execute a valid query") = [&]() {
		std::string query = "SELECT 1";
		expect(g_database().executeQuery(query)) << "Should successfully execute the query";
	};

	test("Database::storeQuery should retrieve all players from the table 'players'") = [&]() {
		std::string query = "SELECT * FROM players";
		DBResult_ptr result = g_database().storeQuery(query);
		expect(result != nullptr) << "The query result should not be null";

		int count = 0;
		while (result->next()) {
			auto playerId = result->getU16("id");
			std::string playerName = result->getString("name");
			auto playerLevel = result->getU16("level");
			logger.trace("Player ID: {}, name: {}, level: {}", playerId, playerName, playerLevel);
			count++;
		}

		expect(count > 0) << "The 'players' table should contain at least one player";
	};

	test("Database::escapeString should escape special characters") = [&]() {
		std::string unsafeString = "O'Reilly";
		std::string escapedString = g_database().escapeString(unsafeString);

		expect(eq(escapedString, std::string("'O\\'Reilly'"))) << "The string should be correctly escaped";
	};
};
