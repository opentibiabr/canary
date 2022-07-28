/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#include "otpch.h"

#include "database/database.h"
#include "utils/lexical_cast.hpp"

#include <mysql/errmsg.h>

Database::~Database()
{
	if (handle != nullptr) {
		mysql_close(handle);
	}
}

bool Database::connect()
{
	// connection handle initialization
	handle = mysql_init(nullptr);
	if (!handle) {
		SPDLOG_ERROR("Failed to initialize MySQL connection handle");
		return false;
	}

	// automatic reconnect
	bool reconnect = true;
	mysql_options(handle, MYSQL_OPT_RECONNECT, &reconnect);

	// connects to database
	if (!mysql_real_connect(handle, g_configManager().getString(MYSQL_HOST).c_str(), g_configManager().getString(MYSQL_USER).c_str(), g_configManager().getString(MYSQL_PASS).c_str(), g_configManager().getString(MYSQL_DB).c_str(), g_configManager().getNumber(SQL_PORT), g_configManager().getString(MYSQL_SOCK).c_str(), 0)) {
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		return false;
	}

	DBResult_ptr result = storeQuery("SHOW VARIABLES LIKE 'max_allowed_packet'");
	if (result) {
		maxPacketSize = result->getU64("Value");
	}
	return true;
}

bool Database::connect(const char *host, const char *user, const char *password,
                      const char *database, uint32_t port, const char *sock) {
	// connection handle initialization
	handle = mysql_init(nullptr);
	if (!handle) {
		SPDLOG_ERROR("Failed to initialize MySQL connection handle.");
		return false;
	}

	// automatic reconnect
	bool reconnect = true;
	mysql_options(handle, MYSQL_OPT_RECONNECT, &reconnect);

	// connects to database
	if (!mysql_real_connect(handle, host, user, password, database, port, sock,
                          0)) {
		SPDLOG_ERROR("MySQL Error Message: {}", mysql_error(handle));
		return false;
	}

	DBResult_ptr result = storeQuery("SHOW VARIABLES LIKE 'max_allowed_packet'");
	if (result) {
		maxPacketSize = result->getU64("Value");
	}
	return true;
}

bool Database::beginTransaction()
{
	if (!executeQuery("BEGIN")) {
		return false;
	}

	databaseLock.lock();
	return true;
}

bool Database::rollback()
{
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}

	if (mysql_rollback(handle) != 0) {
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		databaseLock.unlock();
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::commit()
{
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}

	if (mysql_commit(handle) != 0) {
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		databaseLock.unlock();
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::executeQuery(const std::string& query)
{
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return false;
	}

	bool success = true;

	// executes the query
	databaseLock.lock();

	while (mysql_real_query(handle, query.c_str(), query.length()) != 0) {
		SPDLOG_ERROR("Query: {}", query.substr(0, 256));
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		auto error = mysql_errno(handle);
		if (error != CR_SERVER_LOST && error != CR_SERVER_GONE_ERROR && error != CR_CONN_HOST_ERROR && error != 1053/*ER_SERVER_SHUTDOWN*/ && error != CR_CONNECTION_ERROR) {
			success = false;
			break;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
	}

	MYSQL_RES* m_res = mysql_store_result(handle);
	databaseLock.unlock();

	if (m_res) {
		mysql_free_result(m_res);
	}

	return success;
}

DBResult_ptr Database::storeQuery(const std::string& query)
{
	if (!handle) {
		SPDLOG_ERROR("Database not initialized!");
		return nullptr;
	}

	databaseLock.lock();

	retry:
	while (mysql_real_query(handle, query.c_str(), query.length()) != 0) {
		SPDLOG_ERROR("Query: {}", query);
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		auto error = mysql_errno(handle);
		if (error != CR_SERVER_LOST && error != CR_SERVER_GONE_ERROR && error != CR_CONN_HOST_ERROR && error != 1053/*ER_SERVER_SHUTDOWN*/ && error != CR_CONNECTION_ERROR) {
			break;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
	}

	// we should call that every time as someone would call executeQuery('SELECT...')
	// as it is described in MySQL manual: "it doesn't hurt" :P
	MYSQL_RES* res = mysql_store_result(handle);
	if (res == nullptr) {
		SPDLOG_ERROR("Query: {}", query);
		SPDLOG_ERROR("Message: {}", mysql_error(handle));
		auto error = mysql_errno(handle);
		if (error != CR_SERVER_LOST && error != CR_SERVER_GONE_ERROR && error != CR_CONN_HOST_ERROR && error != 1053/*ER_SERVER_SHUTDOWN*/ && error != CR_CONNECTION_ERROR) {
			databaseLock.unlock();
			return nullptr;
		}
		goto retry;
	}
	databaseLock.unlock();

	// retrieving results of query
	DBResult_ptr result = std::make_shared<DBResult>(res);
	if (!result->hasNext()) {
		return nullptr;
	}
	return result;
}

std::string Database::escapeString(const std::string& s) const
{
	return escapeBlob(s.c_str(), s.length());
}

std::string Database::escapeBlob(const char* s, uint32_t length) const
{
	// the worst case is 2n + 1
	size_t maxLength = (length * 2) + 1;

	std::string escaped;
	escaped.reserve(maxLength + 2);
	escaped.push_back('\'');

	if (length != 0) {
		char* output = new char[maxLength];
		mysql_real_escape_string(handle, output, s, length);
		escaped.append(output);
		delete[] output;
	}

	escaped.push_back('\'');
	return escaped;
}

DBResult::DBResult(MYSQL_RES* res)
{
	handle = res;

	size_t i = 0;

	MYSQL_FIELD* field = mysql_fetch_field(handle);
	while (field) {
		listNames[field->name] = i++;
		field = mysql_fetch_field(handle);
	}

	row = mysql_fetch_row(handle);
}

DBResult::~DBResult()
{
	mysql_free_result(handle);
}

const char* DBResult::getResult(const std::string& string) const
{
	auto it = listNames.find(string);
	if (it == listNames.end()) {
		SPDLOG_ERROR("[DBResult::getResult] - Column '{}' doesn't exist in the result set", string);
		return nullptr;
	}

	if (row[it->second] == nullptr) {
		SPDLOG_DEBUG("Database result is nullptr");
		return nullptr;
	}

	// Return the table size
	SPDLOG_DEBUG("Database result founded: {}", it->second);
	return row[it->second];
}

int8_t DBResult::get8(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<int8_t>(rowResult);
}

int16_t DBResult::get16(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<int16_t>(rowResult);
}

int32_t DBResult::get32(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<int32_t>(rowResult);
}

int64_t DBResult::get64(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return std::atoll(rowResult);
}

uint8_t DBResult::getU8(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<uint8_t>(rowResult);
}

uint16_t DBResult::getU16(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<uint16_t>(rowResult);
}

uint32_t DBResult::getU32(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<uint32_t>(rowResult);
}

uint64_t DBResult::getU64(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return LexicalCast::stringToNumeric<uint64_t>(rowResult);
}

time_t DBResult::getTime(const std::string& tableName) const
{
	auto rowResult = getResult(tableName);
	if (rowResult == nullptr) {
		return 0;
	}

	return std::atoi(rowResult);
}

bool DBResult::getBoolean(const std::string& tableName) const
{
	if (auto value = getU8(tableName);
		std::cmp_equal(value, 0))
	{
		return false;
	}

	return true;
}

std::string DBResult::getString(const std::string& s) const
{
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		SPDLOG_ERROR("Column '{}' does not exist in result set", s);
		return std::string();
	}

	if (row[it->second] == nullptr) {
		return std::string();
	}

	return std::string(row[it->second]);
}

const char* DBResult::getStream(const std::string& s, unsigned long& size) const
{
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		SPDLOG_ERROR("Column '{}' doesn't exist in the result set", s);
		size = 0;
		return nullptr;
	}

	if (row[it->second] == nullptr) {
		size = 0;
		return nullptr;
	}

	size = mysql_fetch_lengths(handle)[it->second];
	return row[it->second];
}

size_t DBResult::countResults() const
{
	return static_cast<size_t>(mysql_num_rows(handle));
}

bool DBResult::hasNext() const
{
	return row != nullptr;
}

bool DBResult::next()
{
  if (!handle) {
    SPDLOG_ERROR("Database not initialized!");
    return false;
  }
	row = mysql_fetch_row(handle);
	return row != nullptr;
}

DBInsert::DBInsert(std::string insertQuery) : query(std::move(insertQuery))
{
	this->length = this->query.length();
}

bool DBInsert::addRow(const std::string& row)
{
	// adds new row to buffer
	const size_t rowLength = row.length();
	length += rowLength;
	if (length > Database::getInstance().getMaxPacketSize() && !execute()) {
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

bool DBInsert::addRow(std::ostringstream& row)
{
	bool ret = addRow(row.str());
	row.str(std::string());
	return ret;
}

bool DBInsert::execute()
{
	if (values.empty()) {
		return true;
	}

	// executes buffer
	bool res = Database::getInstance().executeQuery(query + values);
	values.clear();
	length = query.length();
	return res;
}
