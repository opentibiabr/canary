/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_DATABASE_DATABASE_H_
#define SRC_DATABASE_DATABASE_H_

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

		template<typename T>
		T getNumber(const std::string& s) const {
			auto it = listNames.find(s);
			if (it == listNames.end()) {
				SPDLOG_ERROR("[DBResult::getNumber] - Column '{}' doesn't exist in the result set", s);
				return static_cast<T>(0);
			}

			if (row[it->second] == nullptr) {
				return static_cast<T>(0);
			}

			T data = { 0 };
			try {
				data = boost::lexical_cast<T>(row[it->second]);
			}
			catch (boost::bad_lexical_cast&) {
				// overflow; tries to get it as uint64 (as big as possible);
				uint64_t u64data;
				try {
					u64data = boost::lexical_cast<uint64_t>(row[it->second]);
					if (u64data > 0) {
						// is a valid! thus truncate into int max for data type;
						data = std::numeric_limits<T>::max();
					}
				}
				catch (boost::bad_lexical_cast &e) {
					// invalid! discard value.
					SPDLOG_ERROR("Column '{}' has an invalid value set: {}", s, e.what());
					data = 0;
				}
			}
			return data;
		}

		std::string getString(const std::string& s) const;
		const char* getStream(const std::string& s, unsigned long& size) const;
		uint8_t getU8FromString(const std::string &string, const std::string &function) const;
		int8_t getInt8FromString(const std::string &string, const std::string &function) const;

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
