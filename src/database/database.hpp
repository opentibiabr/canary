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
	#include <mysql/mysql.h>
	#include <mutex>
#endif

class DBResult;

using DBResult_ptr = std::shared_ptr<DBResult>;

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

class Database {
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

	bool retryQuery(const std::string_view &query, int retries);
	bool executeQuery(const std::string_view &query);

	DBResult_ptr storeQuery(const std::string_view &query);

	template <typename... Args>
	std::shared_ptr<PreparedStatement> prepareAndExecute(const std::string &query, Args &&... args) {
		auto preparedStatement = std::make_shared<PreparedStatement>(handle, query);
		preparedStatement->execute(std::forward<Args>(args)...);
		return preparedStatement;
	}

	std::string escapeString(const std::string &s) const;

	std::string escapeBlob(const char* s, uint32_t length) const;

	uint64_t getLastInsertId() const {
		return static_cast<uint64_t>(mysql_insert_id(handle));
	}

	static const char* getClientVersion() {
		return mysql_get_client_info();
	}

	uint64_t getMaxPacketSize() const {
		return maxPacketSize;
	}

private:
	bool beginTransaction();
	bool rollback();
	bool commit();

	bool isRecoverableError(unsigned int error) const;

	MYSQL* handle = nullptr;
	std::recursive_mutex databaseLock;
	uint64_t maxPacketSize = 1048576;

	friend class DBTransaction;
};

constexpr auto g_database = Database::getInstance;

class DBResult {
public:
	explicit DBResult(MYSQL_RES* res);
	~DBResult();

	// Non copyable
	DBResult(const DBResult &) = delete;
	DBResult &operator=(const DBResult &) = delete;

	template <typename T>
	T getNumber(const std::string &s) const {
		auto it = listNames.find(s);
		if (it == listNames.end()) {
			g_logger().error("[DBResult::getNumber] - Column '{}' doesn't exist in the result set", s);
			return T();
		}

		if (row[it->second] == nullptr) {
			return T();
		}

		T data = 0;
		try {
			// Check if the type T is signed or unsigned
			if constexpr (std::is_signed_v<T>) {
				// Check if the type T is int8_t or int16_t
				if constexpr (std::is_same_v<T, int8_t> || std::is_same_v<T, int16_t>) {
					// Use std::stoi to convert string to int8_t
					data = static_cast<T>(std::stoi(row[it->second]));
				}
				// Check if the type T is int32_t
				else if constexpr (std::is_same_v<T, int32_t>) {
					// Use std::stol to convert string to int32_t
					data = static_cast<T>(std::stol(row[it->second]));
				}
				// Check if the type T is int64_t
				else if constexpr (std::is_same_v<T, int64_t>) {
					// Use std::stoll to convert string to int64_t
					data = static_cast<T>(std::stoll(row[it->second]));
				} else {
					// Throws exception indicating that type T is invalid
					g_logger().error("Invalid signed type T");
				}
			} else if (std::is_same<T, bool>::value) {
				data = static_cast<T>(std::stoi(row[it->second]));
			} else {
				// Check if the type T is uint8_t or uint16_t or uint32_t
				if constexpr (std::is_same_v<T, uint8_t> || std::is_same_v<T, uint16_t> || std::is_same_v<T, uint32_t>) {
					// Use std::stoul to convert string to uint8_t
					data = static_cast<T>(std::stoul(row[it->second]));
				}
				// Check if the type T is uint64_t
				else if constexpr (std::is_same_v<T, uint64_t>) {
					// Use std::stoull to convert string to uint64_t
					data = static_cast<T>(std::stoull(row[it->second]));
				} else {
					// Send log indicating that type T is invalid
					g_logger().error("Column '{}' has an invalid unsigned T is invalid", s);
				}
			}
		} catch (std::invalid_argument &e) {
			// Value of string is invalid
			g_logger().error("Column '{}' has an invalid value set, error code: {}", s, e.what());
			data = T();
		} catch (std::out_of_range &e) {
			// Value of string is too large to fit the range allowed by type T
			g_logger().error("Column '{}' has a value out of range, error code: {}", s, e.what());
			data = T();
		}

		return data;
	}

	std::string getString(const std::string &s) const;
	const char* getStream(const std::string &s, unsigned long &size) const;
	uint8_t getU8FromString(const std::string &string, const std::string &function) const;
	int8_t getInt8FromString(const std::string &string, const std::string &function) const;

	size_t countResults() const;
	bool hasNext() const;
	bool next();

private:
	MYSQL_RES* handle;
	MYSQL_ROW row;

	std::map<std::string_view, size_t> listNames;

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
			return Database::getInstance().beginTransaction();
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
			Database::getInstance().rollback();
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
			Database::getInstance().commit();
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
