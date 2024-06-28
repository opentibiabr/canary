/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "database/database.hpp"

#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "lib/metrics/metrics.hpp"
#include "utils/tools.hpp"

/*
PreparedStatement::PreparedStatement(MYSQL* db, const std::string &query) {
	stmt = mysql_stmt_init(db);
	if (!stmt) {
		g_logger().error("Failed to initialize statement handle.");
		return;
	}

	if (mysql_stmt_prepare(stmt, query.c_str(), query.length())) {
		mysql_stmt_close(stmt);
		stmt = nullptr;
		g_logger().error("Failed to prepare statement: " + std::string(mysql_stmt_error(stmt)));
	}
}

PreparedStatement::~PreparedStatement() {
	if (stmt) {
		mysql_stmt_close(stmt);
		stmt = nullptr;
	}
}

const char* PreparedStatement::getStream(const std::string &columnName, size_t &size) {
	auto it = columnMap.find(columnName);
	if (it == columnMap.end()) {
		g_logger().error("Column '{}' not found in result set.", columnName);
		size = 0;
		return nullptr;
	}

	if (it->second >= resultBuffers.size()) {
		g_logger().error("Index for column '{}' is out of range. Index: {}, Buffer Size: {}", columnName, it->second, resultBuffers.size());
		size = 0;
		return nullptr;
	}

	size = lengths[it->second];
	g_logger().info("Retrieved stream for column '{}'. Size: {}", columnName, size);
	return resultBuffers[it->second].data();
}

std::string PreparedStatement::getString(const std::string &columnName) {
	auto it = columnMap.find(columnName);
	if (it == columnMap.end() || it->second >= resultBuffers.size()) {
		g_logger().error("Column name not found or index out of range.");
		return {};
	}
	return std::string(resultBuffers[it->second].begin(), resultBuffers[it->second].begin() + lengths[it->second]);
}

void PreparedStatement::initializeColumnMap() {
}

void PreparedStatement::fetchResults() {
	g_logger().info("Fetching results...");

	MYSQL_RES* meta = mysql_stmt_result_metadata(stmt);
	if (!meta) {
		g_logger().error("Failed to retrieve result metadata.");
		return;
	}

	MYSQL_FIELD* fields = mysql_fetch_fields(meta);
	auto columnCount = mysql_num_fields(meta);
	for (unsigned int i = 0; i < columnCount; ++i) {
		g_logger().info("Mapping column '{}' to index {}", fields[i].name, i);
		columnMap[fields[i].name] = i;
	}

	resultBuffers.resize(columnCount);
	lengths.resize(columnCount);
	m_columnCount = columnCount;

	g_logger().info("Total columns in SELECT statement: {}", m_columnCount);

	std::vector<MYSQL_BIND> result(m_columnCount);
	std::vector<std::unique_ptr<char[]>> buffers(columnCount);
	std::vector<unsigned long> real_lengths(m_columnCount, 0);
	std::vector<my_bool> is_null(m_columnCount, 0);
	std::vector<my_bool> error(m_columnCount, 0);
	for (unsigned int i = 0; i < m_columnCount; ++i) {
		buffers[i] = std::make_unique<char[]>(fields[i].length);
		memset(buffers[i].get(), 0, fields[i].length);

		result[i].buffer_length = fields[i].length;
		// The long needs to be interpreted as a string, there is some problem with this data reading that I was unable to identify
		if (fields[i].type >= MYSQL_TYPE_DECIMAL && fields[i].type <= MYSQL_TYPE_BIT) {
			result[i].buffer_type = MYSQL_TYPE_STRING;
		} else {
			result[i].buffer_type = fields[i].type;
		}
		result[i].buffer = buffers[i].get();
		result[i].length = &real_lengths[i];
		result[i].is_null = &is_null[i];
		result[i].error = &error[i];
		g_logger().info("Configuring column {}: Type = {}, Buffer Length = {}", fields[i].name, result[i].buffer_type, result[i].buffer_length);
	}

	if (mysql_stmt_bind_result(stmt, result.data())) {
		g_logger().error("Failed to bind result buffers: {}", mysql_stmt_error(stmt));
		return;
	}

	int row_count = 0;
	while (mysql_stmt_fetch(stmt) == 0) {
		row_count++;
		g_logger().info("Row {}", row_count);
		for (unsigned int i = 0; i < m_columnCount; ++i) {
			if (!is_null[i]) {
				g_logger().info("Column {}: Value: {}, Length: {}", fields[i].name, std::string(buffers[i].get(), real_lengths[i]), real_lengths[i]);
				resultBuffers[i].assign(buffers[i].get(), buffers[i].get() + real_lengths[i]);
				lengths[i] = real_lengths[i];
			} else {
				g_logger().info("Column {}: Value is NULL.", i);
				resultBuffers[i].clear();
			}
		}
	}

	mysql_free_result(meta);
	g_logger().info("Total rows fetched: {}", row_count);
}
*/

namespace InternalDatabase {
	template <typename T>
	T getNumber(const std::string_view columnName, const std::string_view query, const std::unordered_map<std::string, size_t> &listNames, const mysqlx::Row &currentRow, bool hasMoreRows) {
		auto it = listNames.find(columnName.data());
		if (it == listNames.end()) {
			g_logger().error("[DBResult::getNumber] Column '{}' doesn't exist in the result set", columnName.data());
			return T();
		}

		if (!hasMoreRows) {
			g_logger().debug("[DBResult::getNumber] Initial row fetch resulted in a null row, no data available.");
			return T();
		}

		const auto &columnData = currentRow[it->second];
		try {
			auto type = columnData.getType();
			T data = 0;
			switch (type) {
				case mysqlx::Value::Type::INT64:
					data = boost::lexical_cast<T>(columnData.get<int64_t>());
					break;
				case mysqlx::Value::Type::UINT64:
					data = boost::lexical_cast<T>(columnData.get<uint64_t>());
					break;
				case mysqlx::Value::Type::FLOAT:
				case mysqlx::Value::Type::DOUBLE:
					data = boost::lexical_cast<T>(columnData.get<double>());
					break;
				case mysqlx::Value::Type::BOOL:
					data = boost::lexical_cast<T>(columnData.get<bool>());
					break;
				case mysqlx::Value::Type::STRING:
					data = boost::lexical_cast<T>(columnData.get<std::string>());
					break;
				case mysqlx::Value::Type::VNULL:
					break;
				default:
					g_logger().error("[DBResult::getNumber] query: {}", query.data());
					g_logger().error("Unsupported conversion for data type: {}", type);
					break;
			}

			return data;
		} catch (const std::exception &e) {
			g_logger().error("[DBResult::getNumber] Error converting column '{}': {}", columnName, e.what());
			return T();
		}
	}
}

uint8_t DBResult::getU8(const std::string &columnName) const {
	return InternalDatabase::getNumber<uint8_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

uint16_t DBResult::getU16(const std::string &columnName) const {
	return InternalDatabase::getNumber<uint16_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

uint32_t DBResult::getU32(const std::string &columnName) const {
	return InternalDatabase::getNumber<uint32_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

uint64_t DBResult::getU64(const std::string &columnName) const {
	return InternalDatabase::getNumber<uint64_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

int8_t DBResult::getI8(const std::string &columnName) const {
	return InternalDatabase::getNumber<int8_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

int16_t DBResult::getI16(const std::string &columnName) const {
	return InternalDatabase::getNumber<int16_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

int32_t DBResult::getI32(const std::string &columnName) const {
	return InternalDatabase::getNumber<int32_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

int64_t DBResult::getI64(const std::string &columnName) const {
	return InternalDatabase::getNumber<int64_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

time_t DBResult::getTime(const std::string &columnName) const {
	return InternalDatabase::getNumber<time_t>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

float DBResult::getFloat(const std::string &columnName) const {
	return InternalDatabase::getNumber<float>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

double DBResult::getDouble(const std::string &columnName) const {
	return InternalDatabase::getNumber<double>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

bool DBResult::getBool(const std::string &columnName) const {
	return InternalDatabase::getNumber<bool>(columnName, m_query, listNames, m_currentRow, m_hasMoreRows);
}

Database::~Database() {
	if (m_databaseSession) {
		m_databaseSession->close();
	}
}

Database &Database::getInstance() {
	return inject<Database>();
}

bool Database::connect() {
	return connect(&g_configManager().getString(MYSQL_HOST, __FUNCTION__), &g_configManager().getString(MYSQL_USER, __FUNCTION__), &g_configManager().getString(MYSQL_PASS, __FUNCTION__), &g_configManager().getString(MYSQL_DB, __FUNCTION__), g_configManager().getNumber(SQL_PORT, __FUNCTION__), &g_configManager().getString(MYSQL_SOCK, __FUNCTION__));
}

bool Database::connect(const std::string* host, const std::string* user, const std::string* password, const std::string* database, uint32_t port, const std::string* sock) {
	g_logger().info("Attempting to connect to the database...");
	if (!host || !user || !password || !database) {
		g_logger().error("Database connection parameters cannot be null.");
		return false;
	}

	g_logger().debug("Host: {}, Port: {}, User: {}, Password: {}, Database: {}", *host, port, *user, *password, *database);
	if (sock && !sock->empty()) {
		g_logger().debug("Using socket: {}", *sock);
	}

	try {
		mysqlx::SessionSettings settings = mysqlx::SessionSettings(createMySQLXConnectionURL(*user, *password, *host, port, *database));
		m_databaseSession = std::make_unique<mysqlx::Session>(settings);
		g_logger().info("Database connection established successfully.");
	} catch (const mysqlx::Error &err) {
		g_logger().error("Error connecting with MySQL X DevAPI: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("Connection with MySQL x DevAPI, standard exception: {} ", ex.what());
		return false;
	}

	DBResult_ptr result = storeQuery("SHOW VARIABLES LIKE 'max_allowed_packet'");
	if (result) {
		maxPacketSize = result->getNumber<uint64_t>("Value");
	}

	return true;
}

bool Database::beginTransaction() {
	if (!executeQuery("BEGIN")) {
		return false;
	}
	metrics::lock_latency measureLock("database");
	databaseLock.lock();
	measureLock.stop();

	return true;
}

bool Database::rollback() {
	if (!m_databaseSession) {
		g_logger().error("Database not initialized!");
		return false;
	}

	databaseLock.unlock();
	try {
		m_databaseSession->rollback();
		g_logger().error("Transaction rollback occurred, please check logs for more details.");
		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("Failed to rollback transaction: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("Exception during transaction rollback: {}", ex.what());
		return false;
	}
}

bool Database::commit() {
	if (!m_databaseSession) {
		g_logger().error("Database not initialized!");
		return false;
	}

	databaseLock.unlock();
	try {
		m_databaseSession->commit();
		g_logger().debug("Transaction commit was successful");
		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("Failed to commit transaction, error: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("Exception during transaction commit, error: {}", ex.what());
		return false;
	}
}

bool Database::retryQuery(const std::string_view &query, int retries) {
	if (!m_databaseSession) {
		g_logger().error("Database not initialized!");
		return false;
	}

	while (retries > 0) {
		try {
			mysqlx::SqlResult result = m_databaseSession->sql(std::string(query)).execute();
			g_logger().debug("Successfully executed query: '{}'", query);
			return true;
		} catch (const mysqlx::Error &err) {
			g_logger().error("[Database::retryQuery] query: {}", query);
			g_logger().error("[MySQL X DevAPI error: {}", err.what());
			std::this_thread::sleep_for(std::chrono::seconds(1));
			retries--;
			return false;
		} catch (const std::exception &ex) {
			g_logger().error("[Database::retryQuery] query: {}", query);
			g_logger().error("Standard exception during query execution: {}", ex.what());
			return false;
		}
	}

	g_logger().error("[Database::retryQuery] retries is zero, query: {}", query);
	return false;
}

bool Database::executeQuery(const std::string_view &query) {
	if (!m_databaseSession) {
		g_logger().error("Database not initialized!");
		return false;
	}

	g_logger().trace("Executing Query: {}", query);

	metrics::lock_latency measureLock("database");
	std::scoped_lock lock { databaseLock };
	measureLock.stop();

	metrics::query_latency measure(query.substr(0, 50));

	try {
		mysqlx::SqlResult result = m_databaseSession->sql(std::string(query)).execute();
		if (result.getWarningsCount() > 0) {
			auto warnings = result.getWarnings();
			for (const auto &warning : warnings) {
				g_logger().debug("[{}] MySQL X DevAPI Warning: {}", __METHOD_NAME__, std::string(warning.getMessage()));
			}
		}

		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] failed to execute query: {}", __METHOD_NAME__, query);
		g_logger().error("Message: {}", err.what());
	} catch (const std::exception &ex) {
		g_logger().error("[{}] failed to execute query: {}", __METHOD_NAME__, query);
		g_logger().error("Standard exception: {}", ex.what());
	}
	return false;
}

DBResult_ptr Database::storeQuery(const std::string_view &query) {
	if (!m_databaseSession) {
		g_logger().error("Database not initialized!");
		return nullptr;
	}

	g_logger().trace("Storing Query: {}", query);

	metrics::lock_latency measureLock("database");
	std::scoped_lock lock { databaseLock };
	measureLock.stop();

	metrics::query_latency measure(query.substr(0, 50));
	try {
		mysqlx::SqlResult result = m_databaseSession->sql(std::string(query)).execute();
		if (!result.hasData()) {
			g_logger().error("[{}] no data returned from query: {}", __METHOD_NAME__, query);
			return nullptr;
		}

		auto dbResult = std::make_shared<DBResult>(std::move(result), std::move(query));
		if (!dbResult->hasNext()) {
			return nullptr;
		}

		return dbResult;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] query: {}", __METHOD_NAME__, query);
		g_logger().error("Message: {}", err.what());
		std::this_thread::sleep_for(std::chrono::seconds(1));
		return nullptr;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] query: {}", __METHOD_NAME__, query);
		g_logger().error("Standard exception: {}", ex.what());
		return nullptr;
	}
	return nullptr;
}

bool Database::updateBlobData(const std::string &tableName, const std::string &columnName, uint32_t recordId, const char* blobData, size_t size, const std::string &idColumnName) {
	try {
		mysqlx::Table table = getTable(tableName);
		mysqlx::Result result = table.update()
									.set(columnName, mysqlx::bytes(reinterpret_cast<const uint8_t*>(blobData), size))
									.where(idColumnName + " = :id")
									.bind("id", recordId)
									.execute();

		g_logger().debug("Updated {} in {}. Affected rows: {}", columnName, tableName, result.getAffectedItemsCount());
		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] error updating {}: {} ", __METHOD_NAME__, tableName, err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] exception while updating {}: {}", __METHOD_NAME__, tableName, ex.what());
		return false;
	}
}

bool Database::insertTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values) {
	try {
		mysqlx::Table table = getTable(tableName);
		mysqlx::Result result = table.insert(columns.begin(), columns.end())
									.values(values.begin(), values.end())
									.execute();

		if (result.getAffectedItemsCount() == 0) {
			g_logger().error("No rows affected in the insert operation for table: {}", tableName);
			return false;
		}
		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] error inserting into {}", __METHOD_NAME__, tableName);
		g_logger().error("Message: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] error inserting into {}", __METHOD_NAME__, tableName);
		g_logger().error("Exception: {}", ex.what());
		return false;
	}
}

bool Database::updateTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values, const std::string &whereColumnName, const mysqlx::Value &whereValue) {
	try {
		mysqlx::Table table = getTable(tableName);
		mysqlx::TableSelect select = table.select("*").where("`" + whereColumnName + "` = :whereValue");
		select.bind("whereValue", whereValue);

		mysqlx::RowResult result = select.execute();
		if (result.fetchOne()) {
			g_logger().trace("Updated existing record in {}", tableName);
			mysqlx::TableUpdate update = table.update();
			for (size_t i = 0; i < columns.size(); ++i) {
				update.set(columns[i], values[i]);
			}
			update.where("`" + whereColumnName + "` = :whereValue").bind("whereValue", whereValue);
			mysqlx::Result updateResult = update.execute();
			// Record does not exist, insert it
		} else {
			g_logger().trace("Inserted new record into {}", tableName);
			mysqlx::TableInsert insert = table.insert(columns.begin(), columns.end()).values(values.begin(), values.end());
			mysqlx::Result insertResult = insert.execute();
		}

		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] error updating into {}", __METHOD_NAME__, tableName);
		g_logger().error("Message: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] error updating into {}", __METHOD_NAME__, tableName);
		g_logger().error("Exception: {}", ex.what());
		return false;
	}
}

bool Database::updateTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values, const std::vector<std::string> &whereColumnNames, const std::vector<mysqlx::Value> &whereValues) {
	try {
		mysqlx::Table table = getTable(tableName);

		// Construct the WHERE condition with multiple clauses
		std::string whereClause;
		for (size_t i = 0; i < whereColumnNames.size(); ++i) {
			if (i > 0) {
				whereClause += " AND ";
			}
			whereClause += "`" + whereColumnNames[i] + "` = :whereValue" + std::to_string(i);
		}

		mysqlx::TableSelect select = table.select("*").where(whereClause);
		for (size_t i = 0; i < whereValues.size(); ++i) {
			select.bind("whereValue" + std::to_string(i), whereValues[i]);
		}

		mysqlx::RowResult result = select.execute();
		if (result.fetchOne()) {
			g_logger().trace("Updated existing record in {}", tableName);
			mysqlx::TableUpdate update = table.update();
			for (size_t i = 0; i < columns.size(); ++i) {
				update.set(columns[i], values[i]);
			}
			update.where(whereClause);
			for (size_t i = 0; i < whereValues.size(); ++i) {
				update.bind("whereValue" + std::to_string(i), whereValues[i]);
			}
			update.execute();
			// Record does not exist, insert it
		} else {
			g_logger().trace("Inserted new record into {}", tableName);
			mysqlx::TableInsert insert = table.insert(columns.begin(), columns.end()).values(values.begin(), values.end());
			insert.execute();
		}

		return true;
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] error updating into {}", __METHOD_NAME__, tableName);
		g_logger().error("Message: {}", err.what());
		return false;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] error updating into {}", __METHOD_NAME__, tableName);
		g_logger().error("Exception: {}", ex.what());
		return false;
	}
}

mysqlx::Schema Database::getDatabaseSchema() {
	if (!m_databaseSession) {
		throw std::exception("Database session is not initialized.");
	}

	return m_databaseSession->getSchema(g_configManager().getString(MYSQL_DB, __FUNCTION__));
}

mysqlx::Table Database::getTable(const std::string &tableName) {
	try {
		return getDatabaseSchema().getTable(tableName);
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] failed to get table '{}': {}", __METHOD_NAME__, tableName, err.what());
		throw;
	} catch (const std::exception &ex) {
		g_logger().error("[{}] an error occurred while getting table '{}': {}", __METHOD_NAME__, tableName, ex.what());
		throw;
	}
}

std::string Database::escapeString(const std::string &s) const {
	std::string::size_type len = s.length();
	auto length = static_cast<uint32_t>(len);
	std::string escaped = escapeBlob(s.c_str(), length);
	if (escaped.empty()) {
		g_logger().warn("Error escaping string: {}", s);
	}
	return escaped;
}

std::string Database::escapeBlob(const char* s, uint32_t length) const {
	std::ostringstream oss;
	oss << '\'';

	for (uint32_t i = 0; i < length; ++i) {
		char c = s[i];
		switch (c) {
			case '\0':
				oss << "\\0";
				break;
			case '\n':
				oss << "\\n";
				break;
			case '\r':
				oss << "\\r";
				break;
			case '\\':
				oss << "\\\\";
				break;
			case '\'':
				oss << "\\'";
				break;
			case '\"':
				oss << "\\\"";
				break;
			case '\032':
				oss << "\\Z";
				break; // Control-Z
			default:
				if (c < ' ') {
					oss << "\\x" << std::setw(2) << std::setfill('0') << std::hex << static_cast<int>(c);
				} else {
					oss << c;
				}
		}
	}

	oss << '\'';
	return oss.str();
}

DBResult::DBResult(mysqlx::SqlResult &&result, const std::string_view &query) :
	m_result(std::move(result)), m_hasMoreRows(result.hasData()), m_query(std::move(query)) {
	// Fetch the first row to start processing
	m_currentRow = m_result.fetchOne();
	if (m_currentRow.isNull()) {
		g_logger().trace("[DBResult::DBResult] query: {}", m_query);
		g_logger().trace("Initial row fetch resulted in a null row, no data available.");
		m_hasMoreRows = false;
		return;
	}

	// Retrieve column metadata
	const auto &columns = m_result.getColumns();
	m_columnCount = m_result.getColumnCount();
	// Iterate through each column, storing their names and indices
	g_logger().trace("[DBResult::DBResult] query: {}", m_query);
	g_logger().trace("Loading columns... Total count: {}", m_result.getColumnCount());
	for (size_t i = 0; i < m_columnCount; ++i) {
		const auto &columnData = columns[i];
		const auto &name = std::string(columnData.getColumnName());
		listNames[name] = i;
		g_logger().trace("Loaded column: {}", name);
	}
}

DBResult::~DBResult() = default;

std::string DBResult::getString(const std::string &s) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		g_logger().error("[DBResult::getString] query: {}", m_query);
		g_logger().error("Column '{}' doesn't exist in the result set", s);
		return {};
	}

	if (!m_hasMoreRows) {
		g_logger().debug("[DBResult::getString] query: {}", m_query);
		g_logger().debug("Initial row fetch resulted in a null row, no data available.");
		return {};
	}

	const auto &columnData = m_currentRow[it->second];
	if (columnData.isNull()) {
		g_logger().debug("[DBResult::getString] query: {}", m_query);
		g_logger().debug("Column '{}' is null", s);
		return nullptr;
	}

	g_logger().trace("[DBResult::getString] query: {}", m_query);
	g_logger().trace("Column '{}' type: {}", s, magic_enum::enum_name(columnData.getType()));
	try {
		auto string = columnData.get<std::string>();
		if (string.empty()) {
			g_logger().error("[DBResult::getString] query: {}", m_query);
			g_logger().error("Column '{}' is empty", s);
			return {};
		}

		return string;
	} catch (std::exception &e) {
		g_logger().error("[DBResult::getString] query: {}", m_query);
		g_logger().error("[DBResult::getString] error converting column '{}' to string: {}", s, e.what());
	}
	return {};
}

const char* DBResult::getStream(const std::string &s, unsigned long &size) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		g_logger().error("[DBResult::getStream] query: {}", m_query);
		g_logger().error("Column '{}' doesn't exist in the result set", s);
		size = 0;
		return nullptr;
	}

	if (!m_hasMoreRows) {
		g_logger().debug("[DBResult::getStream] query: {}", m_query);
		g_logger().debug("Initial row fetch resulted in a null row, no data available.");
		return nullptr;
	}

	const auto &columnData = m_currentRow[it->second];
	if (columnData.isNull()) {
		g_logger().debug("[DBResult::getStream] query: {}", m_query);
		g_logger().debug("Column '{}' is null", s);
		size = 0;
		return nullptr;
	}

	g_logger().trace("[DBResult::getStream] query: {}", m_query);
	g_logger().trace("Column '{}' type: {}", s, magic_enum::enum_name(columnData.getType()));

	try {
		// Get the binary data using mysqlx::bytes
		mysqlx::bytes blobData = columnData.get<mysqlx::bytes>();
		size = blobData.size();

		if (m_bufferStream != nullptr) {
			delete[] m_bufferStream; // Clear previous buffer
		}

		m_bufferStream = new char[size + 1];
		std::memcpy(m_bufferStream, blobData.begin(), size); // Copy binary data to the buffer

		g_logger().trace("[DBResult::getStream] Column '{}' type: {}", s, magic_enum::enum_name(columnData.getType()));
		g_logger().trace("[DBResult::getStream] Successfully retrieved blob data.");

		return m_bufferStream;
	} catch (const std::exception &e) {
		g_logger().error("[DBResult::getStream] query: {}", m_query);
		g_logger().error("Error getting stream data for column '{}': {}", s, e.what());
		size = 0;
		return nullptr;
	}
}

size_t DBResult::countResults() {
	return m_result.count();
}

bool DBResult::hasNext() const {
	return m_hasMoreRows;
}

bool DBResult::next() {
	if (!m_hasMoreRows) {
		return false;
	}

	m_currentRow = m_result.fetchOne();
	m_hasMoreRows = !m_currentRow.isNull();
	return m_hasMoreRows;
}

DBInsert::DBInsert(std::string insertQuery) :
	query(std::move(insertQuery)) {
	this->length = this->query.length();
}

bool DBInsert::addRow(std::string_view row) {
	const size_t rowLength = row.length();
	length += rowLength;
	auto max_packet_size = g_database().getMaxPacketSize();

	if (length > max_packet_size && !execute()) {
		return false;
	}

	if (values.empty()) {
		values.reserve(rowLength + 2);
		values.push_back('(');
		values.append(row);
		values.push_back(')');
	} else {
		values.reserve(values.length() + rowLength + 3);
		values.push_back(',');
		values.push_back('(');
		values.append(row);
		values.push_back(')');
	}
	return true;
}

bool DBInsert::addRow(std::ostringstream &row) {
	bool ret = addRow(row.str());
	row.str(std::string());
	return ret;
}

void DBInsert::upsert(const std::vector<std::string> &columns) {
	upsertColumns = columns;
}

bool DBInsert::execute() {
	if (values.empty()) {
		return true;
	}

	std::string baseQuery = this->query;
	std::string upsertQuery;

	if (!upsertColumns.empty()) {
		std::ostringstream upsertStream;
		upsertStream << " ON DUPLICATE KEY UPDATE ";
		for (size_t i = 0; i < upsertColumns.size(); ++i) {
			upsertStream << "`" << upsertColumns[i] << "` = VALUES(`" << upsertColumns[i] << "`)";
			if (i < upsertColumns.size() - 1) {
				upsertStream << ", ";
			}
		}
		upsertQuery = upsertStream.str();
	}

	std::string currentBatch = values;
	while (!currentBatch.empty()) {
		size_t cutPos = Database::MAX_QUERY_SIZE - baseQuery.size() - upsertQuery.size();
		if (cutPos < currentBatch.size()) {
			cutPos = currentBatch.rfind("),(", cutPos);
			if (cutPos == std::string::npos) {
				return false;
			}
			cutPos += 2;
		} else {
			cutPos = currentBatch.size();
		}

		std::string batchValues = currentBatch.substr(0, cutPos);
		if (batchValues.back() == ',') {
			batchValues.pop_back();
		}
		currentBatch = currentBatch.substr(cutPos);

		std::ostringstream query;
		query << baseQuery << " " << batchValues << upsertQuery;
		if (!g_database().executeQuery(query.str())) {
			return false;
		}
	}

	return true;
}
