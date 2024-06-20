/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/metrics/metrics.hpp"

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

Database::~Database() {
	if (handle != nullptr) {
		mysql_close(handle);
	}
}

Database &Database::getInstance() {
	return inject<Database>();
}

bool Database::connect() {
	return connect(&g_configManager().getString(MYSQL_HOST, __FUNCTION__), &g_configManager().getString(MYSQL_USER, __FUNCTION__), &g_configManager().getString(MYSQL_PASS, __FUNCTION__), &g_configManager().getString(MYSQL_DB, __FUNCTION__), g_configManager().getNumber(SQL_PORT, __FUNCTION__), &g_configManager().getString(MYSQL_SOCK, __FUNCTION__));
}

bool Database::connect(const std::string* host, const std::string* user, const std::string* password, const std::string* database, uint32_t port, const std::string* sock) {
	// connection handle initialization
	handle = mysql_init(nullptr);
	if (!handle) {
		g_logger().error("Failed to initialize MySQL connection handle.");
		return false;
	}

	if (host->empty() || user->empty() || password->empty() || database->empty() || port <= 0) {
		g_logger().warn("MySQL host, user, password, database or port not provided");
	}

	// automatic reconnect
	bool reconnect = true;
	mysql_options(handle, MYSQL_OPT_RECONNECT, &reconnect);

	// connects to database
	if (!mysql_real_connect(handle, host->c_str(), user->c_str(), password->c_str(), database->c_str(), port, sock->c_str(), 0)) {
		g_logger().error("MySQL Error Message: {}", mysql_error(handle));
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
	if (!handle) {
		g_logger().error("Database not initialized!");
		return false;
	}

	if (mysql_rollback(handle) != 0) {
		g_logger().error("Message: {}", mysql_error(handle));
		databaseLock.unlock();
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::commit() {
	if (!handle) {
		g_logger().error("Database not initialized!");
		return false;
	}
	if (mysql_commit(handle) != 0) {
		g_logger().error("Message: {}", mysql_error(handle));
		databaseLock.unlock();
		return false;
	}

	databaseLock.unlock();
	return true;
}

bool Database::isRecoverableError(unsigned int error) const {
	return error == CR_SERVER_LOST || error == CR_SERVER_GONE_ERROR || error == CR_CONN_HOST_ERROR || error == 1053 /*ER_SERVER_SHUTDOWN*/ || error == CR_CONNECTION_ERROR;
}

bool Database::retryQuery(const std::string_view &query, int retries) {
	while (retries > 0 && mysql_query(handle, query.data()) != 0) {
		g_logger().error("Query: {}", query.substr(0, 256));
		g_logger().error("MySQL error [{}]: {}", mysql_errno(handle), mysql_error(handle));
		if (!isRecoverableError(mysql_errno(handle))) {
			return false;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
		retries--;
	}
	if (retries == 0) {
		g_logger().error("Query {} failed after {} retries.", query, 10);
		return false;
	}

	return true;
}

bool Database::executeQuery(const std::string_view &query) {
	if (!handle) {
		g_logger().error("Database not initialized!");
		return false;
	}

	g_logger().trace("Executing Query: {}", query);

	metrics::lock_latency measureLock("database");
	std::scoped_lock lock { databaseLock };
	measureLock.stop();

	metrics::query_latency measure(query.substr(0, 50));
	bool success = retryQuery(query, 10);
	mysql_free_result(mysql_store_result(handle));

	return success;
}

DBResult_ptr Database::storeQuery(const std::string_view &query) {
	if (!handle) {
		g_logger().error("Database not initialized!");
		return nullptr;
	}
	g_logger().trace("Storing Query: {}", query);

	metrics::lock_latency measureLock("database");
	std::scoped_lock lock { databaseLock };
	measureLock.stop();

	metrics::query_latency measure(query.substr(0, 50));
retry:
	if (mysql_query(handle, query.data()) != 0) {
		g_logger().error("Query: {}", query);
		g_logger().error("Message: {}", mysql_error(handle));
		if (!isRecoverableError(mysql_errno(handle))) {
			return nullptr;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
		goto retry;
	}

	// Retrieving results of query
	MYSQL_RES* res = mysql_store_result(handle);
	if (res != nullptr) {
		DBResult_ptr result = std::make_shared<DBResult>(res);
		if (!result->hasNext()) {
			return nullptr;
		}
		return result;
	}
	return nullptr;
}

std::string Database::escapeString(const std::string &s) const {
	std::string::size_type len = s.length();
	auto length = static_cast<uint32_t>(len);
	std::string escaped = escapeBlob(s.c_str(), length);
	if (escaped.empty()) {
		g_logger().warn("Error escaping string");
	}
	return escaped;
}

std::string Database::escapeBlob(const char* s, uint32_t length) const {
	size_t maxLength = (length * 2) + 1;

	std::string escaped;
	escaped.reserve(maxLength + 2);
	escaped.push_back('\'');

	if (length != 0) {
		std::string output(maxLength, '\0');
		size_t escapedLength = mysql_real_escape_string(handle, &output[0], s, length);
		output.resize(escapedLength);
		escaped.append(output);
	}

	escaped.push_back('\'');
	return escaped;
}

DBResult::DBResult(MYSQL_RES* res) {
	handle = res;

	int num_fields = mysql_num_fields(handle);

	const MYSQL_FIELD* fields = mysql_fetch_fields(handle);
	for (size_t i = 0; i < num_fields; i++) {
		listNames[fields[i].name] = i;
	}
	row = mysql_fetch_row(handle);
}

DBResult::~DBResult() {
	mysql_free_result(handle);
}

std::string DBResult::getString(const std::string &s) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		g_logger().error("Column '{}' does not exist in result set", s);
		return std::string();
	}
	if (row[it->second] == nullptr) {
		return std::string();
	}
	return std::string(row[it->second]);
}

const char* DBResult::getStream(const std::string &s, unsigned long &size) const {
	auto it = listNames.find(s);
	if (it == listNames.end()) {
		g_logger().error("Column '{}' doesn't exist in the result set", s);
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

uint8_t DBResult::getU8FromString(const std::string &string, const std::string &function) const {
	auto result = static_cast<uint8_t>(std::atoi(string.c_str()));
	if (result > std::numeric_limits<uint8_t>::max()) {
		g_logger().error("[{}] Failed to get number value {} for tier table result, on function call: {}", __FUNCTION__, result, function);
		return 0;
	}

	return result;
}

int8_t DBResult::getInt8FromString(const std::string &string, const std::string &function) const {
	auto result = static_cast<int8_t>(std::atoi(string.c_str()));
	if (result > std::numeric_limits<int8_t>::max()) {
		g_logger().error("[{}] Failed to get number value {} for tier table result, on function call: {}", __FUNCTION__, result, function);
		return 0;
	}

	return result;
}

size_t DBResult::countResults() const {
	return static_cast<size_t>(mysql_num_rows(handle));
}

bool DBResult::hasNext() const {
	return row != nullptr;
}

bool DBResult::next() {
	if (!handle) {
		g_logger().error("Database not initialized!");
		return false;
	}
	row = mysql_fetch_row(handle);
	return row != nullptr;
}

DBInsert::DBInsert(std::string insertQuery) :
	query(std::move(insertQuery)) {
	this->length = this->query.length();
}

bool DBInsert::addRow(std::string_view row) {
	const size_t rowLength = row.length();
	length += rowLength;
	auto max_packet_size = Database::getInstance().getMaxPacketSize();

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
		if (!Database::getInstance().executeQuery(query.str())) {
			return false;
		}
	}

	return true;
}
