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

	Database db;
	test("Database::connect should establish a connection") = [&]() {
		// Configurações de teste
		std::string host = "localhost";
		std::string user = "otserver";
		std::string password = "otserver";
		std::string database = "otserver";
		uint32_t port = 33060;
		std::string sock = "";

		// Simula a conexão bem-sucedida
		expect(db.connect(&host, &user, &password, &database, port, &sock)) << "Deve conectar com sucesso ao banco de dados";

		// Verifica se a sessão foi inicializada
		expect(db.isValidSession()) << "A sessão do banco de dados deve ser válida após a conexão";
	};

	test("Database::executeQuery should execute a valid query") = [&]() {
		std::string query = "SELECT 1";

		// Simula a execução bem-sucedida da query
		expect(db.executeQuery(query)) << "Deve executar a query com sucesso";
	};

	test("Database::storeQuery should retrieve data from a valid query") = [&]() {
		std::string query = "SELECT 'test' AS value";

		// Simula o retorno de um resultado da query
		DBResult_ptr result = db.storeQuery(query);
		expect(result != nullptr) << "O resultado da query não deve ser nulo";
		std::string value = result->getString("value");
		expect(eq(value, std::string("test"))) << "O valor retornado deve ser 'test'";
	};

	test("Database should handle transactions correctly") = [&]() {
        // Como os métodos beginTransaction, commit e rollback são privados,
        // testaremos o comportamento de transações através de operações que os utilizam internamente.

        expect(db.transactionalExecute([&](Database& dbInstance) {
            std::string query = "INSERT INTO test_table (name) VALUES ('test')";
            expect(dbInstance.executeQuery(query)) << "Deve executar a query dentro da transação";

            return true;
        })) << "Deve comitar a transação com sucesso";
    };

    test("Database should revert transactions correctly") = [&]() {
        expect(db.transactionalExecute([&](Database& dbInstance) {
            std::string query = "INSERT INTO test_table (name) VALUES ('test')";
            expect(dbInstance.executeQuery(query)) << "Deve executar a query dentro da transação";

            return false;
        })) << "Deve reverter a transação com sucesso";
    };

	test("Database::escapeString should escape special characters") = [&]() {
		std::string unsafeString = "O'Reilly";
		std::string escapedString = db.escapeString(unsafeString);

		expect(eq(escapedString, std::string("'O\\'Reilly'"))) << "A string deve ser corretamente escapada";
	};

	test("Database::updateBlobData should update BLOB data") = [&]() {
		std::string tableName = "test_table";
		std::string columnName = "data";
		uint32_t recordId = 1;
		const char* blobData = "binary_data";
		size_t size = strlen(blobData);
		std::string idColumnName = "id";

		// Simula a atualização bem-sucedida do BLOB
		expect(db.updateBlobData(tableName, columnName, recordId, blobData, size, idColumnName)) << "Deve atualizar o BLOB com sucesso";
	};

	test("Database::insertTable should insert data into a table") = [&]() {
		std::string tableName = "test_table";
		std::vector<std::string> columns = { "name", "value" };
		std::vector<mysqlx::Value> values = { "test_name", 42 };

		// Simula a inserção bem-sucedida
		expect(db.insertTable(tableName, columns, values)) << "Deve inserir os dados na tabela com sucesso";
	};

	test("Database::updateTable should update existing records") = [&]() {
		std::string tableName = "test_table";
		std::vector<std::string> columns = { "value" };
		std::vector<mysqlx::Value> values = { 100 };
		std::string whereColumnName = "name";
		mysqlx::Value whereValue = "test_name";

		// Simula a atualização bem-sucedida
		expect(db.updateTable(tableName, columns, values, whereColumnName, whereValue)) << "Deve atualizar o registro existente com sucesso";
	};

	test("Database::updateTable should insert if record does not exist") = [&]() {
		std::string tableName = "test_table";
		std::vector<std::string> columns = { "name", "value" };
		std::vector<mysqlx::Value> values = { "new_name", 200 };
		std::string whereColumnName = "name";
		mysqlx::Value whereValue = "new_name";

		// Simula a inserção, já que o registro não existe
		expect(db.updateTable(tableName, columns, values, whereColumnName, whereValue)) << "Deve inserir um novo registro se não existir";
	};

	test("Database::retryQuery should retry on failure") = [&]() {
		std::string query = "INVALID QUERY";
		int retries = 3;

		// Simula o comportamento de retry
		expect(not db.retryQuery(query, retries)) << "Deve falhar após as tentativas de retry esgotarem";
	};

	test("DBInsert should construct and execute insert queries") = [&]() {
		std::string insertQuery = "INSERT INTO test_table (name, value) VALUES";
		DBInsert dbInsert(insertQuery);

		// Adiciona linhas ao insert
		dbInsert.addRow("'name1', 1");
		dbInsert.addRow("'name2', 2");

		// Executa o insert
		expect(dbInsert.execute()) << "Deve executar o insert com sucesso";
	};
};
