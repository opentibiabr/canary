/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_DATABASE_DATABASE_H_
#define SRC_DATABASE_DATABASE_H_

#include <mysql/mysql.h>
#include <memory>
#include <mutex>
#include <map>
#include <iostream>

#include "config/configmanager.h"
#include "declarations.hpp"

class DBResult;
using DBResult_ptr = std::shared_ptr<DBResult>;

class Database
{
	public:
		Database() = default;
		~Database();

		// Singleton - ensures we don't accidentally copy it.
		Database(const Database&) = delete;
		Database& operator=(const Database&) = delete;

		static Database& getInstance() {
			// Guaranteed to be destroyed.
			static Database instance;
			// Instantiated on first use.
			return instance;
		}

		bool connect();

		bool connect(const char *host, const char *user, const char *password,
                     const char *database, uint32_t port, const char *sock);

		bool executeQuery(const std::string& query);

		DBResult_ptr storeQuery(const std::string& query);

		std::string escapeString(const std::string& s) const;

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

	private:
		MYSQL* handle = nullptr;
		std::recursive_mutex databaseLock;
		uint64_t maxPacketSize = 1048576;

	friend class DBTransaction;
};

class DBResult
{
	public:
		explicit DBResult(MYSQL_RES* res);
		~DBResult();

		// non-copyable
		DBResult(const DBResult&) = delete;
		DBResult& operator=(const DBResult&) = delete;

		// Get size of the table
		size_t getResult(const std::string& string) const;
		// Get signed intenger
		int8_t get8(const std::string& tableName) const;
		int16_t get16(const std::string& tableName) const;
		int32_t get32(const std::string& tableName) const;
		int64_t get64(const std::string& tableName) const;
		// Get unsigned intenger
		uint8_t getU8(const std::string& tableName) const;
		uint16_t getU16(const std::string& tableName) const;
		uint32_t getU32(const std::string& tableName) const;
		uint64_t getU64(const std::string& tableName) const;
		// Others conversions
		time_t getTime(const std::string& tableName) const;
		bool getBoolean(const std::string& tableName) const;
		std::string getString(const std::string& s) const;
		const char* getStream(const std::string& s, unsigned long& size) const;

		size_t countResults() const;
		bool hasNext() const;
		bool next();

	private:
		MYSQL_RES* handle;
		MYSQL_ROW row;

		std::map<std::string, size_t> listNames;

	friend class Database;
};

/**
 * INSERT statement.
 */
class DBInsert
{
	public:
		explicit DBInsert(std::string query);
		bool addRow(const std::string& row);
		bool addRow(std::ostringstream& row);
		bool execute();

	private:
		std::string query;
		std::string values;
		size_t length;
};

class DBTransaction
{
	public:
		constexpr DBTransaction() = default;

		~DBTransaction() {
			if (state == STATE_START) {
				Database::getInstance().rollback();
			}
		}

		// non-copyable
		DBTransaction(const DBTransaction&) = delete;
		DBTransaction& operator=(const DBTransaction&) = delete;

		bool begin() {
			state = STATE_START;
			return Database::getInstance().beginTransaction();
		}

		bool commit() {
			if (state != STATE_START) {
				return false;
			}

			state = STATE_COMMIT;
			return Database::getInstance().commit();
		}

	private:
		TransactionStates_t state = STATE_NO_START;
};

#endif  // SRC_DATABASE_DATABASE_H_
