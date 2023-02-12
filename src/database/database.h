/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_DATABASE_DATABASE_H_
#define SRC_DATABASE_DATABASE_H_

#include "declarations.hpp"

class DBResult;
using DBResult_ptr = std::shared_ptr<DBResult>;

class Database {
	public:
		Database() = default;
		~Database();

		// Singleton - ensures we don't accidentally copy it.
		Database(const Database &) = delete;
		Database &operator=(const Database &) = delete;

		static Database &getInstance() {
			// Guaranteed to be destroyed.
			static Database instance;
			// Instantiated on first use.
			return instance;
		}

		bool connect();

		bool executeQuery(const std::string_view &query);

		DBResult_ptr storeQuery(const std::string_view &query);

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

		bool isRecoverableError(unsigned int error) {
			return error == CR_SERVER_LOST || error == CR_SERVER_GONE_ERROR || error == CR_CONN_HOST_ERROR || error == 1053 /*ER_SERVER_SHUTDOWN*/ || error == CR_CONNECTION_ERROR;
		}

	private:
		MYSQL* handle = nullptr;
		std::recursive_mutex databaseLock;
		uint64_t maxPacketSize = 1048576;

		friend class DBTransaction;
		friend class DBTransactionGuard;
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
				SPDLOG_ERROR("[DBResult::getNumber] - Column '{}' doesn't exist in the result set", s);
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
						SPDLOG_ERROR("Invalid signed type T");
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
						SPDLOG_ERROR("Column '{}' has an invalid unsigned T is invalid", s);
					}
				}
			} catch (std::invalid_argument &e) {
				// Value of string is invalid
				SPDLOG_ERROR("Column '{}' has an invalid value set, error code: {}", s, e.what());
				data = T();
			} catch (std::out_of_range &e) {
				// Value of string is too large to fit the range allowed by type T
				SPDLOG_ERROR("Column '{}' has a value out of range, error code: {}", s, e.what());
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

		phmap::flat_hash_map<std::string_view, size_t> listNames;

		friend class Database;
};

/**
 * INSERT statement.
 */
class DBInsert {
	public:
		explicit DBInsert(std::string query);
		bool addRow(const std::string_view row);
		bool addRow(std::ostringstream &row);
		bool execute();

	private:
		std::string query;
		std::string values;
		size_t length;
};

class DBTransaction {
	public:
		constexpr DBTransaction() = default;

		~DBTransaction() {
			if (state == STATE_START) {
				try {
					rollback();
				} catch (const std::exception &exception) {
					// Error occurred while rollback transaction
					SPDLOG_ERROR("Error occurred while rollback transaction", __FUNCTION__, exception.what());
				}
			}
		}

		// non-copyable
		DBTransaction(const DBTransaction &) = delete;
		DBTransaction &operator=(const DBTransaction &) = delete;

		bool start() {
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
				SPDLOG_ERROR("An error occurred while starting the transaction", __FUNCTION__, exception.what());
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
				// An error occurred while rollback the transaction
				SPDLOG_ERROR("An error occurred while rollback the transaction", __FUNCTION__, exception.what());
			}
		}

		bool commit() {
			// Ensure that the transaction has been started
			if (state != STATE_START) {
				SPDLOG_ERROR("Transaction not started");
				return false;
			}

			try {
				// Commit the transaction
				state = STATE_COMMIT;
				return Database::getInstance().commit();
			} catch (const std::exception &exception) {
				// An error occurred while starting the transaction
				state = STATE_NO_START;
				SPDLOG_ERROR("An error occurred while starting the transaction", __FUNCTION__, exception.what());
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

	private:
		TransactionStates_t state = STATE_NO_START;
};

class DBTransactionGuard {
	public:
		explicit DBTransactionGuard(DBTransaction &transaction) :
			transaction_(transaction) { }

		// non-copyable
		DBTransactionGuard(const DBTransactionGuard &) = delete;
		DBTransactionGuard &operator=(const DBTransactionGuard &) = delete;

		// non-movable
		DBTransactionGuard(DBTransactionGuard &&) = delete;
		DBTransactionGuard &operator=(DBTransactionGuard &&) = delete;

		~DBTransactionGuard() {
			// Commit the transaction if it was started successfully
			if (transaction_.isStarted()) {
				try {
					transaction_.commit();
				} catch (const std::exception &exception) {
					// Error occurred while committing transaction
					SPDLOG_ERROR("Error occurred while committing transaction", __FUNCTION__, exception.what());
					transaction_.rollback();
				}
			}
		}

		void rollback() {
			transaction_.rollback();
		}

	private:
		DBTransaction &transaction_;
};

#endif // SRC_DATABASE_DATABASE_H_
