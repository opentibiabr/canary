/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <mysql/mysql.h>
	#include <cassert>
	#include <memory>
	#include <mutex>
	#include <optional>
	#include <utility>
	#include <vector>
#endif

class DBResult;
using DBResult_ptr = std::shared_ptr<DBResult>;

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

	/**
	 * @brief Creates a backup of the database.
	 *
	 * This function generates a backup of the database, with options for compression.
	 * The backup can be triggered periodically or during specific events like server loading.
	 *
	 * The backup operation will only execute if the configuration option `MYSQL_DB_BACKUP`
	 * is set to true in the `config.lua` file. If this configuration is disabled, the function
	 * will return without performing any action.
	 *
	 * @param compress Indicates whether the backup should be compressed.
	 * - If `compress` is true, the backup is created during an interval-based save, which occurs every 2 hours.
	 *   This helps prevent excessive growth in the number of backup files.
	 * - If `compress` is false, the backup is created during the global save, which is triggered once a day when the server loads.
	 */
	void createDatabaseBackup(bool compress) const;

	bool retryQuery(std::string_view query, int retries);
	bool executeQuery(std::string_view query);

	DBResult_ptr storeQuery(std::string_view query);

	std::string escapeString(const std::string &s) const;

	std::string escapeBlob(const char* s, uint32_t length) const;

	uint64_t getLastInsertId() const;

	static const char* getClientVersion() {
		return mysql_get_client_info();
	}

	uint64_t getMaxPacketSize() const;

	// True when the calling thread's last failed query was an InnoDB deadlock or
	// lock-wait timeout — i.e. a transient error worth retrying the transaction.
	[[nodiscard]] bool lastQueryWasDeadlock() const;

	// Query capture (record-replay). While active on the calling thread,
	// executeQuery() appends its SQL to `buffer` and returns true WITHOUT
	// executing. This lets a player save be serialized on the dispatcher (reading
	// the live Player consistently) and replayed on a pool thread. storeQuery()
	// is never captured. Not reentrant per thread. Use QueryCaptureScope (below).
	void beginQueryCapture(std::vector<std::string>* buffer);
	void endQueryCapture();

private:
	bool beginTransaction();
	bool rollback();
	bool commit();

	static bool isRecoverableError(unsigned int error);

	// State that must be private to each MySQL connection. A context belongs to a
	// single thread (reached only through that thread's thread_local cache), so
	// all queries from a given thread — and therefore a whole player load or
	// transaction — share the same handle: getLastInsertId and BEGIN/COMMIT keep
	// connection affinity for free, and the handle needs no lock because no other
	// thread can ever touch it.
	struct ConnectionContext {
		MYSQL* handle = nullptr;
		uint64_t maxPacketSize = 1048576;
		// Error code of the last failed query on this connection. Kept here (not
		// read via mysql_errno) so it survives an intervening rollback and can be
		// inspected by the transaction retry logic.
		unsigned int lastErrno = 0;

		ConnectionContext() = default;
		// Owns the raw MYSQL* handle, so it is non-copyable/non-movable (always
		// held inside a unique_ptr in the registry).
		ConnectionContext(const ConnectionContext &) = delete;
		ConnectionContext &operator=(const ConnectionContext &) = delete;
		~ConnectionContext();
	};

	// Returns the calling thread's connection, establishing it lazily on first
	// use from the parameters captured by connect(). Fast path is a thread_local
	// pointer lookup with no locking.
	ConnectionContext &getContext() const;
	bool establishConnection(ConnectionContext &ctx) const;

	// Connection parameters captured on the first connect(), reused to spin up a
	// fresh connection for every thread that touches the database.
	struct ConnectionParams {
		std::string host;
		std::string user;
		std::string password;
		std::string database;
		std::string sock;
		uint32_t port = 0;
	};

	mutable std::optional<ConnectionParams> connectionParams;
	mutable std::mutex connectionsMutex;
	mutable std::vector<std::unique_ptr<ConnectionContext>> connections;
	// Set when this instance initialized the MySQL client library, so its
	// destructor pairs the single mysql_library_end(). Set/read single-threaded
	// (startup / shutdown), so no atomic is needed.
	bool m_libraryInitialized = false;

	friend class DBTransaction;
};

constexpr auto g_database = Database::getInstance;

// RAII wrapper for Database query capture. While in scope, executeQuery() on the
// calling thread records into `buffer` instead of executing.
class QueryCaptureScope {
public:
	explicit QueryCaptureScope(std::vector<std::string> &buffer) {
		Database::getInstance().beginQueryCapture(&buffer);
	}
	~QueryCaptureScope() {
		Database::getInstance().endQueryCapture();
	}

	QueryCaptureScope(const QueryCaptureScope &) = delete;
	QueryCaptureScope &operator=(const QueryCaptureScope &) = delete;
};

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

		T data {};
		try {
			// Check if the type T is a enum
			if constexpr (std::is_enum_v<T>) {
				using underlying_type = std::underlying_type_t<T>;
				underlying_type value = 0;
				if constexpr (std::is_signed_v<underlying_type>) {
					value = static_cast<underlying_type>(std::stoll(row[it->second]));
				} else {
					value = static_cast<underlying_type>(std::stoull(row[it->second]));
				}
				return static_cast<T>(value);
			}
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
				}
				// Check if the type T is time_t
				else if constexpr (std::is_same_v<T, time_t>) {
					// Use std::stoll to convert string to time_t (usually long long)
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
	static uint8_t getU8FromString(const std::string &string, const std::string &function);
	static int8_t getInt8FromString(const std::string &string, const std::string &function);

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
	bool addRow(std::string_view row);
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

	// Number of times a transaction is retried when it fails with a transient
	// InnoDB deadlock / lock-wait timeout before giving up.
	static constexpr uint8_t TRANSACTION_MAX_ATTEMPTS = 3;

	template <typename Func>
	static bool executeWithinTransaction(const Func &callback)
		requires std::invocable<Func>
	{
		for (uint8_t attempt = 1; attempt <= TRANSACTION_MAX_ATTEMPTS; ++attempt) {
			DBTransaction transaction;
			try {
				if (!transaction.begin()) {
					g_logger().error("[{}] Failed to begin transaction", __FUNCTION__);
					return false;
				}

				const bool result = callback();

				if (!transaction.commit()) {
					return false;
				}

				return result;
			} catch (const std::exception &exception) {
				transaction.rollback();
				if (Database::getInstance().lastQueryWasDeadlock() && attempt < TRANSACTION_MAX_ATTEMPTS) {
					g_logger().warn("[{}] Transaction hit a deadlock/lock timeout, retrying ({}/{})", __FUNCTION__, attempt, TRANSACTION_MAX_ATTEMPTS);
					continue;
				}
				g_logger().error("[{}] Error occurred during transaction, error: {}", __FUNCTION__, exception.what());
				return false;
			}
		}
		return false;
	}

	template <typename Func>
	static bool executeWithinTransactionRollbackOnFailure(const Func &callback)
		requires std::invocable<Func>
	{
		for (uint8_t attempt = 1; attempt <= TRANSACTION_MAX_ATTEMPTS; ++attempt) {
			DBTransaction transaction;
			try {
				if (!transaction.begin()) {
					g_logger().error("[{}] Failed to begin transaction", __FUNCTION__);
					return false;
				}

				if (!callback()) {
					transaction.rollback();
					if (Database::getInstance().lastQueryWasDeadlock() && attempt < TRANSACTION_MAX_ATTEMPTS) {
						g_logger().warn("[{}] Transaction hit a deadlock/lock timeout, retrying ({}/{})", __FUNCTION__, attempt, TRANSACTION_MAX_ATTEMPTS);
						continue;
					}
					return false;
				}

				return transaction.commit();
			} catch (const std::exception &exception) {
				transaction.rollback();
				if (Database::getInstance().lastQueryWasDeadlock() && attempt < TRANSACTION_MAX_ATTEMPTS) {
					g_logger().warn("[{}] Transaction hit a deadlock/lock timeout, retrying ({}/{})", __FUNCTION__, attempt, TRANSACTION_MAX_ATTEMPTS);
					continue;
				}
				g_logger().error("[{}] Error occurred during transaction, error: {}", __FUNCTION__, exception.what());
				return false;
			}
		}
		return false;
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

	bool commit() {
		// Ensure that the transaction has been started
		if (state != STATE_START) {
			g_logger().error("Transaction not started");
			return false;
		}

		try {
			// Commit the transaction
			state = STATE_COMMIT;
			if (!Database::getInstance().commit()) {
				state = STATE_NO_START;
				g_logger().error("[{}] Commit returned false", __FUNCTION__);
				return false;
			}

			return true;
		} catch (const std::exception &exception) {
			// An error occurred while committing the transaction
			state = STATE_NO_START;
			g_logger().error("[{}] An error occurred while committing the transaction, error: {}", __FUNCTION__, exception.what());
			return false;
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
	explicit DatabaseException(std::string message) :
		message(std::move(message)) { }

	const char* what() const noexcept override {
		return message.c_str();
	}

private:
	std::string message;
};
