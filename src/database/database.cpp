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

/**
 * @brief Retrieves a number from a database result set based on the column name.
 *
 * This template function fetches and converts a numeric value from a specified column in a MySQL X DevAPI Row object.
 * It handles type safety and range checking specifically for small numeric types such as int8_t and uint8_t
 * to prevent overflow issues. It uses lexical casting for other types.
 *
 * @tparam T The numeric type to which the database value will be converted.
 * @param columnName The name of the column in the database result set.
 * @param query The SQL query string used for logging purposes, especially in error messages.
 * @param listNames A mapping from column names to their respective indices in the result set.
 * @param currentRow The current row of the result set from which data will be fetched.
 * @param hasMoreRows Boolean indicating if the currentRow contains valid data.
 *
 * @return The value of the column converted to type T. Returns default-constructed T on any error or if the column does not exist.
 *
 * @note The specific handling for int8_t and uint8_t types is necessary due to their limited range:
 *	   - int8_t: Valid range from -128 to 127. Any value outside this range causes overflow.
 *	   - uint8_t: Valid range from 0 to 255. Any value outside this range causes overflow.
 *	   This function checks if the values are within these ranges before attempting a conversion to prevent data corruption.
 *	   For other types, boost::lexical_cast is used which provides safe conversions but does not inherently check for overflow.
 *
 * @details If the fetched data type does not match the expected template type T or if the data is out of range for the specified type T,
 *		  the function logs an error and returns a default value of type T. This function throws no exceptions but catches and logs them.
 */
namespace InternalDatabase {
	template <typename T>
	T getNumber(const std::string &columnName, const std::string &query, const std::unordered_map<std::string, size_t> &listNames, const mysqlx::Row &currentRow, bool hasMoreRows) {
		const auto it = listNames.find(columnName.data());
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
			g_logger().trace("[DBResult::getNumber] Column '{}' type: {}", columnName, type);
			switch (type) {
				case mysqlx::Value::Type::INT64: {
					//
					auto valueI64 = columnData.get<int64_t>();
					if constexpr (std::is_same_v<T, int8_t>) {
						if (valueI64 < std::numeric_limits<int8_t>::min() || valueI64 > std::numeric_limits<int8_t>::max()) {
							g_logger().error("[DBResult::getNumber] Column '{}', value out of range for int8_t: {}", columnName.data(), valueI64);
							return T();
						}
						return static_cast<int8_t>(valueI64);
					}

					data = boost::lexical_cast<T>(valueI64);
					break;
				}
				case mysqlx::Value::Type::UINT64: {
					auto valueU64 = columnData.get<uint64_t>();
					if constexpr (std::is_same_v<T, uint8_t>) {
						if (valueU64 > std::numeric_limits<uint8_t>::max()) {
							g_logger().error("[DBResult::getNumber] Column '{}', value out of range for uint8_t: {}", columnName.data(), valueU64);
							return T();
						}
						return static_cast<uint8_t>(valueU64);
					}

					data = boost::lexical_cast<T>(valueU64);
					break;
				}
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

std::shared_ptr<DBResult> Database::prepare(const std::string &query) {
	auto prepared = std::make_shared<DBResult>(*m_databaseSession, query);
	return prepared;
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
		maxPacketSize = result->getU64("Value");
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

bool Database::retryQuery(const std::string &query, int retries) {
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

bool Database::executeQuery(const std::string &query) {
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

DBResult_ptr Database::storeQuery(const std::string &query) {
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

		auto dbResult = std::make_shared<DBResult>(std::move(result), std::move(query), *m_databaseSession);
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
		throw std::runtime_error("Database session is not initialized.");
	}

	return m_databaseSession->getSchema(g_configManager().getString(MYSQL_DB, __FUNCTION__));
}

mysqlx::Table Database::getTable(const std::string &tableName) {
	try {
		return getDatabaseSchema().getTable(tableName);
	} catch (const mysqlx::Error &err) {
		g_logger().error("[{}] failed to get table '{}': {}", __METHOD_NAME__, tableName, err.what());
		throw;
	} catch (const std::runtime_error &ex) {
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

DBResult::DBResult(mysqlx::SqlResult &&result, const std::string &query, mysqlx::Session &session) :
	m_result(std::move(result)), m_hasMoreRows(result.hasData()), m_query(std::move(query.data())), m_session(session) {
	// Fetch the first row to start processing
	if (m_hasMoreRows) {
		m_currentRow = m_result.fetchOne();
	}

	if (m_currentRow.isNull()) {
		g_logger().trace("[DBResult::DBResult] query: {}", m_query);
		g_logger().trace("Initial row fetch resulted in a null row, no data available.");
		m_hasMoreRows = false;
		return;
	}

	initializeColumnMap();
}

DBResult::DBResult(mysqlx::Session &session, const std::string &query) :
	m_session(session), m_query(query) { }

DBResult::~DBResult() = default;

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

std::string DBResult::getString(const std::string &columnName) const {
	auto it = listNames.find(columnName);
	if (it == listNames.end()) {
		g_logger().error("[DBResult::getString] query: {}", m_query);
		g_logger().error("Column '{}' doesn't exist in the result set", columnName);
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
		g_logger().debug("Column '{}' is null", columnName);
		return nullptr;
	}

	g_logger().trace("[DBResult::getString] query: {}", m_query);
	g_logger().trace("Column '{}' type: {}", columnName, magic_enum::enum_name(columnData.getType()));
	try {
		auto string = columnData.get<std::string>();
		if (string.empty()) {
			g_logger().error("[DBResult::getString] query: {}", m_query);
			g_logger().error("Column '{}' is empty", columnName);
			return {};
		}

		return string;
	} catch (std::exception &e) {
		g_logger().error("[DBResult::getString] query: {}", m_query);
		g_logger().error("[DBResult::getString] error converting column '{}' to string: {}", columnName, e.what());
	}
	return {};
}

const std::vector<uint8_t> DBResult::getStream(const std::string &columnName) const {
	auto it = listNames.find(columnName);
	if (it == listNames.end()) {
		g_logger().error("[DBResult::getStream] query: {}", m_query);
		g_logger().error("Column '{}' doesn't exist in the result set", columnName);
		return {};
	}

	if (!m_hasMoreRows) {
		g_logger().debug("[DBResult::getStream] query: {}", m_query);
		g_logger().debug("Initial row fetch resulted in a null row, no data available.");
		return {};
	}

	const auto &columnData = m_currentRow[it->second];
	if (columnData.isNull()) {
		g_logger().debug("[DBResult::getStream] query: {}", m_query);
		g_logger().debug("Column '{}' is null", columnName);
		return {};
	}

	try {
		mysqlx::bytes blobData = columnData.get<mysqlx::bytes>();
		std::vector<uint8_t> data(blobData.begin(), blobData.end());

		g_logger().trace("[DBResult::getStream] Column '{}' type: {}", columnName, magic_enum::enum_name(columnData.getType()));
		g_logger().trace("[DBResult::getStream] Successfully retrieved blob data.");
		return data;
	} catch (const std::exception &e) {
		g_logger().error("[DBResult::getStream] query: {}", m_query);
		g_logger().error("Error getting stream data for column '{}': {}", columnName, e.what());
		return {};
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

DBInsert::DBInsert(const std::string &insertQuery) :
	query(std::move(insertQuery)) {
	this->length = this->query.length();
}

bool DBInsert::addRow(const std::string_view row) {
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
