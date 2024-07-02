/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"
#include "lib/logging/log_with_spd_log.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <mutex>
#endif

#include <mysqlx/xdevapi.h>
#include <boost/lexical_cast.hpp>

class DBResult;

using DBResult_ptr = std::shared_ptr<DBResult>;
/*
class PreparedStatement {
public:
	PreparedStatement(MYSQL* db, const std::string &query);
	~PreparedStatement();

	template <typename... Args>
	void execute(Args &&... args) {
		MYSQL_BIND bind[sizeof...(Args)];
		std::memset(bind, 0, sizeof(bind));
		std::vector<std::unique_ptr<void, std::function<void(void*)>>> buffers;
		bindParams(bind, buffers, std::forward<Args>(args)...);

		if (mysql_stmt_bind_param(stmt, bind)) {
			g_logger().error("Failed to bind parameters: {}", std::string(mysql_stmt_error(stmt)));
			return;
		}
		if (mysql_stmt_execute(stmt)) {
			g_logger().error("Execution failed: {}", std::string(mysql_stmt_error(stmt)));
			return;
		}

		fetchResults();
	}

	bool next();

	template <typename T>
	void setBindParam(MYSQL_BIND &bind, T value, std::vector<std::unique_ptr<void, std::function<void(void*)>>> &buffers) {
		std::memset(&bind, 0, sizeof(bind));

		g_logger().info("Setting bind param for value: {}", value);
		if constexpr (std::is_integral_v<T> && !std::is_same_v<T, bool>) {
			bind.buffer_type = MYSQL_TYPE_LONGLONG;
			auto buffer = std::make_unique<long long>(value);
			bind.buffer = buffer.get();
			bind.is_unsigned = true;
			buffers.push_back({ buffer.release(), [](void* ptr) { delete static_cast<long long*>(ptr); } });
			g_logger().info("Integer value: {}", value);
		} else if constexpr (std::is_same_v<T, std::string>) {
			bind.buffer_type = MYSQL_TYPE_STRING;
			auto buffer = std::make_unique<char[]>(value.size() + 1);
			std::strcpy(buffer.get(), value.c_str());
			bind.buffer = buffer.get();
			bind.buffer_length = value.size();
			buffers.push_back({ buffer.release(), [](void* ptr) { delete[] static_cast<char*>(ptr); } });
			g_logger().info("String value: {}", value);
		} else if constexpr (std::is_floating_point_v<T>) {
			bind.buffer_type = MYSQL_TYPE_DOUBLE;
			auto buffer = std::make_unique<double>(value);
			bind.buffer = buffer.get();
			buffers.push_back({ buffer.release(), [](void* ptr) { delete static_cast<double*>(ptr); } });
			g_logger().info("Floating-point value: {}", value);
		} else if constexpr (std::is_same_v<T, bool>) {
			bind.buffer_type = MYSQL_TYPE_TINY;
			auto buffer = std::make_unique<bool>(value);
			bind.buffer = buffer.get();
			buffers.push_back({ buffer.release(), [](void* ptr) { delete static_cast<bool*>(ptr); } });
			g_logger().info("Boolean value: {}", value);
		} else if constexpr (std::is_same_v<T, std::vector<char>>) {
			bind.buffer_type = MYSQL_TYPE_BLOB;
			auto buffer = std::make_unique<char[]>(value.size());
			std::memcpy(buffer.get(), value.data(), value.size());
			bind.buffer = buffer.get();
			bind.buffer_length = value.size();
			buffers.push_back({ buffer.release(), [](void* ptr) { delete[] static_cast<char*>(ptr); } });
			g_logger().info("Blob value: {}", value.size());
		} else {
			g_logger().error("[Database::setBindParam] Unsupported type");
		}
	}

	template <typename... Args>
	void bindParams(MYSQL_BIND* binds, std::vector<std::unique_ptr<void, std::function<void(void*)>>> &buffers, Args... args) {
		int i = 0;
		(setBindParam(binds[i++], std::forward<Args>(args), buffers), ...);
	}

	const char* getStream(const std::string &columnName, size_t &size);

	std::string getString(const std::string &columnName);

	template <typename T>
	T getNumber(const std::string &columnName) {
		auto it = columnMap.find(columnName);
		if (it == columnMap.end() || it->second >= resultBuffers.size()) {
			g_logger().error("[DBResult::getNumber] - Column '{}' doesn't exist in the result set", columnName);
			return {};
		}

		const auto &columnData = resultBuffers[it->second];
		if (columnData.empty()) {
			g_logger().error("Data for column '{}' is NULL or empty.", columnName);
			return {};
		}

		std::string valueStr(columnData.begin(), columnData.end());
		T data = 0;
		try {
			if constexpr (std::is_signed_v<T>) {
				data = static_cast<T>(std::stoll(valueStr));
			} else if constexpr (std::is_floating_point_v<T>) {
				data = static_cast<T>(std::stod(valueStr));
			} else if constexpr (std::is_same_v<T, bool>) {
				data = static_cast<T>(std::stoi(valueStr) != 0);
			} else if constexpr (std::is_unsigned_v<T>) {
				data = static_cast<T>(std::stoull(valueStr));
			} else {
				g_logger().error("Unsupported number type for getNumber");
			}
		} catch (const std::invalid_argument &e) {
			g_logger().error("Column '{}' has an invalid value set, error code: {}", columnName, e.what());
		} catch (const std::out_of_range &e) {
			g_logger().error("Column '{}' has a value out of range, error code: {}", columnName, e.what());
		}
		return data;
	}

private:
	MYSQL_STMT* stmt;
	std::vector<std::vector<char>> resultBuffers;
	std::vector<unsigned long> lengths;
	std::map<std::string, size_t> columnMap;

	uint16_t m_columnCount = 0;

	void initializeColumnMap();

	void fetchResults();
};
*/
class Database {
private:
	std::unique_ptr<mysqlx::Session> m_databaseSession;

public:
	static const size_t MAX_QUERY_SIZE = 8 * 1024 * 1024; // 8 Mb -- half the default MySQL max_allowed_packet size

	Database() = default;
	~Database();

	// Singleton - ensures we don't accidentally copy it.
	Database(const Database &) = delete;
	Database &operator=(const Database &) = delete;

	static Database &getInstance();

	bool connect();

	bool connect(const std::string* host, const std::string* user, const std::string* password, const std::string* database, uint32_t port, const std::string* sock);

	bool retryQuery(const std::string_view query, int retries);
	bool executeQuery(const std::string_view query);

	DBResult_ptr storeQuery(const std::string_view query);

	std::string escapeString(const std::string &s) const;

	std::string escapeBlob(const char* s, uint32_t length) const;

	/**
	 * @brief Updates blob data in a specified column and table.
	 *
	 * This method updates a BLOB column in a specified table using a provided blob of data. It logs
	 * the number of affected rows or any errors encountered during the update.
	 *
	 * @param tableName Name of the table to update.
	 * @param columnName Name of the BLOB column to update.
	 * @param recordId ID of the record to update.
	 * @param blobData Pointer to the blob data to be updated.
	 * @param size Size of the blob data.
	 * @param idColumnName Name of the column used as the identifier.
	 * @return true if the update is successful, false otherwise.
	 */
	bool updateBlobData(const std::string &tableName, const std::string &columnName, uint32_t recordId, const char* blobData, size_t size, const std::string &idColumnName = "id");

	/**
	 * @brief Inserts data into a specified table.
	 *
	 * This method inserts a new row into a table with specified columns and values. It checks and logs
	 * the number of affected rows to ensure that the insert operation was successful.
	 *
	 * @param tableName Name of the table where data will be inserted.
	 * @param columns Vector of strings containing the names of the columns to insert data into.
	 * @param values Vector of mysqlx::Value containing the data to be inserted.
	 * @return true if the insert is successful, false otherwise.
	 */
	bool insertTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values);

	/**
	 * @brief Updates or inserts data into a table based on the existence of a record.
	 *
	 * This method checks if a record exists and updates it. If the record does not exist, it inserts a new record.
	 * The method logs actions taken (update or insert) and any errors encountered.
	 *
	 * @param tableName Name of the table to update.
	 * @param columns Names of the columns to update.
	 * @param values Values corresponding to the columns.
	 * @param whereColumnName The column name used in the WHERE clause to locate the record.
	 * @param whereValue The value used in the WHERE clause to locate the record.
	 * @return true if the operation was successful, false otherwise.
	 */
	bool updateTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values, const std::vector<std::string> &whereColumnNames, const std::vector<mysqlx::Value> &whereValues);

	/**
	 * @brief Updates or inserts data into a table based on complex WHERE conditions.
	 *
	 * This method performs an update or insert operation based on complex WHERE conditions specified by multiple columns.
	 * It handles both single and multiple records and logs detailed information about the operations and any exceptions.
	 *
	 * @param tableName Name of the table to update or insert into.
	 * @param columns Vector of column names to be updated or inserted.
	 * @param values Vector of values corresponding to the columns.
	 * @param whereColumnNames Vector of column names used for the WHERE clause to locate the record.
	 * @param whereValues Vector of values used for the WHERE clause to locate the record.
	 * @return true if the update or insert is successful, false otherwise.
	 */
	bool updateTable(const std::string &tableName, const std::vector<std::string> &columns, const std::vector<mysqlx::Value> &values, const std::string &whereColumnName, const mysqlx::Value &whereValue);

	uint64_t getMaxPacketSize() const {
		return maxPacketSize;
	}

	mysqlx::Schema getDatabaseSchema();

	mysqlx::Table getTable(const std::string &tableName);

private:
	bool beginTransaction();
	bool rollback();
	bool commit();

	std::recursive_mutex databaseLock;
	uint64_t maxPacketSize = 1048576;

	friend class DBTransaction;
};

constexpr auto g_database = Database::getInstance;

class DBResult {
public:
	explicit DBResult(mysqlx::SqlResult &&result, const std::string_view query);
	~DBResult();

	// Non copyable
	DBResult(const DBResult &) = delete;
	DBResult &operator=(const DBResult &) = delete;

	uint8_t getU8(const std::string &columnName) const;
	uint16_t getU16(const std::string &columnName) const;
	uint32_t getU32(const std::string &columnName) const;
	uint64_t getU64(const std::string &columnName) const;

	int8_t getI8(const std::string &columnName) const;
	int16_t getI16(const std::string &columnName) const;
	int32_t getI32(const std::string &columnName) const;
	int64_t getI64(const std::string &columnName) const;

	time_t getTime(const std::string &columnName) const;
	float getFloat(const std::string &columnName) const;
	double getDouble(const std::string &columnName) const;
	bool getBool(const std::string &columnName) const;

	std::string getString(const std::string_view columnName) const;
	const std::vector<uint8_t> getStream(const std::string_view columnName) const;

	size_t countResults();
	bool hasNext() const;
	bool next();

private:
	mysqlx::SqlResult m_result;
	mysqlx::Row m_currentRow;
	mysqlx::col_count_t m_columnCount;
	bool m_hasMoreRows;

	std::string m_query;

	std::unordered_map<std::string, size_t> listNames;

	friend class Database;
};

/**
 * INSERT statement.
 */
class DBInsert {
public:
	explicit DBInsert(std::string query);
	void upsert(const std::vector<std::string> &columns);
	bool addRow(const std::string_view row);
	bool addRow(std::ostringstream &row);
	bool execute();

private:
	std::vector<std::string> upsertColumns;
	std::string query;
	std::string values;
	size_t length;
};

class DBTransaction {
public:
	explicit DBTransaction() = default;

	~DBTransaction() = default;

	// non-copyable
	DBTransaction(const DBTransaction &) = delete;
	DBTransaction &operator=(const DBTransaction &) = delete;

	// non-movable
	DBTransaction(const DBTransaction &&) = delete;
	DBTransaction &operator=(const DBTransaction &&) = delete;

	template <typename Func>
	static bool executeWithinTransaction(const Func &toBeExecuted) {
		DBTransaction transaction;
		try {
			transaction.begin();
			bool result = toBeExecuted();
			transaction.commit();
			return result;
		} catch (const std::exception &exception) {
			transaction.rollback();
			g_logger().error("[{}] Error occurred committing transaction, error: {}", __FUNCTION__, exception.what());
			return false;
		}
	}

private:
	bool begin() {
		// Ensure that the transaction has not already been started
		if (state != STATE_NO_START) {
			return false;
		}

		try {
			// Start the transaction
			state = STATE_START;
			return g_database().beginTransaction();
		} catch (const std::exception &exception) {
			// An error occurred while starting the transaction
			state = STATE_NO_START;
			g_logger().error("[{}] An error occurred while starting the transaction, error: {}", __FUNCTION__, exception.what());
			return false;
		}
	}

	void rollback() {
		// Ensure that the transaction has been started
		if (state != STATE_START) {
			return;
		}

		try {
			// Rollback the transaction
			state = STATE_NO_START;
			g_database().rollback();
		} catch (const std::exception &exception) {
			// An error occurred while rolling back the transaction
			g_logger().error("[{}] An error occurred while rolling back the transaction, error: {}", __FUNCTION__, exception.what());
		}
	}

	void commit() {
		// Ensure that the transaction has been started
		if (state != STATE_START) {
			g_logger().error("Transaction not started");
			return;
		}

		try {
			// Commit the transaction
			state = STATE_COMMIT;
			g_database().commit();
		} catch (const std::exception &exception) {
			// An error occurred while committing the transaction
			state = STATE_NO_START;
			g_logger().error("[{}] An error occurred while committing the transaction, error: {}", __FUNCTION__, exception.what());
		}
	}

	bool isStarted() const {
		return state == STATE_START;
	}
	bool isCommitted() const {
		return state == STATE_COMMIT;
	}
	bool isRolledBack() const {
		return state == STATE_NO_START;
	}

	TransactionStates_t state = STATE_NO_START;
};

class DatabaseException : public std::exception {
public:
	explicit DatabaseException(const std::string &message) :
		message(message) { }

	virtual const char* what() const throw() {
		return message.c_str();
	}

private:
	std::string message;
};
