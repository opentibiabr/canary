/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "database/database.hpp"

#include "config/configmanager.hpp"
#include "lib/di/container.hpp"
#include "lib/metrics/metrics.hpp"
#include "utils/tools.hpp"

Database::~Database() {
	if (handle != nullptr) {
		mysql_close(handle);
	}
}

Database &Database::getInstance() {
	return inject<Database>();
}

bool Database::connect() {
	return connect(&g_configManager().getString(MYSQL_HOST), &g_configManager().getString(MYSQL_USER), &g_configManager().getString(MYSQL_PASS), &g_configManager().getString(MYSQL_DB), g_configManager().getNumber(SQL_PORT), &g_configManager().getString(MYSQL_SOCK));
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

	// Remove ssl verification
	bool ssl_enabled = false;
	mysql_options(handle, MYSQL_OPT_SSL_VERIFY_SERVER_CERT, &ssl_enabled);

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

void Database::createDatabaseBackup(bool compress) const {
	if (!g_configManager().getBoolean(MYSQL_DB_BACKUP)) {
		return;
	}

	// Get current time for formatting
	auto now = std::chrono::system_clock::now();
	std::time_t now_c = std::chrono::system_clock::to_time_t(now);
	std::string formattedDate = fmt::format("{:%Y-%m-%d}", fmt::localtime(now_c));
	std::string formattedTime = fmt::format("{:%H-%M-%S}", fmt::localtime(now_c));

	// Create a backup directory based on the current date
	std::string backupDir = fmt::format("database_backup/{}/", formattedDate);
	std::filesystem::create_directories(backupDir);
	std::string backupFileName = fmt::format("{}backup_{}.sql", backupDir, formattedTime);

	// Create a temporary configuration file for MySQL credentials
	std::string tempConfigFile = "database_backup.cnf";
	std::ofstream configFile(tempConfigFile);
	if (configFile.is_open()) {
		configFile << "[client]\n";
		configFile << "user=" << g_configManager().getString(MYSQL_USER) << "\n";
		configFile << "password=" << g_configManager().getString(MYSQL_PASS) << "\n";
		configFile << "host=" << g_configManager().getString(MYSQL_HOST) << "\n";
		configFile << "port=" << g_configManager().getNumber(SQL_PORT) << "\n";
		configFile.close();
	} else {
		g_logger().error("Failed to create temporary MySQL configuration file.");
		return;
	}

	// Execute mysqldump command to create backup file
	std::string command = fmt::format(
		"mysqldump --defaults-extra-file={} {} > {}",
		tempConfigFile, g_configManager().getString(MYSQL_DB), backupFileName
	);

	int result = std::system(command.c_str());
	std::filesystem::remove(tempConfigFile);

	if (result != 0) {
		g_logger().error("Failed to create database backup using mysqldump.");
		return;
	}

	// Compress the backup file if requested
	std::string compressedFileName;
	compressedFileName = backupFileName + ".gz";
	gzFile gzFile = gzopen(compressedFileName.c_str(), "wb9");
	if (!gzFile) {
		g_logger().error("Failed to open gzip file for compression.");
		return;
	}

	std::ifstream backupFile(backupFileName, std::ios::binary);
	if (!backupFile.is_open()) {
		g_logger().error("Failed to open backup file for compression: {}", backupFileName);
		gzclose(gzFile);
		return;
	}

	std::string buffer(8192, '\0');
	while (backupFile.read(&buffer[0], buffer.size()) || backupFile.gcount() > 0) {
		gzwrite(gzFile, buffer.data(), backupFile.gcount());
	}

	backupFile.close();
	gzclose(gzFile);
	std::filesystem::remove(backupFileName);

	g_logger().info("Database backup successfully compressed to: {}", compressedFileName);

	// Delete backups older than 7 days
	auto nowTime = std::chrono::system_clock::now();
	auto sevenDaysAgo = nowTime - std::chrono::hours(7 * 24); // 7 days in hours
	for (const auto &entry : std::filesystem::directory_iterator("database_backup")) {
		if (entry.is_directory()) {
			try {
				for (const auto &file : std::filesystem::directory_iterator(entry)) {
					if (file.path().extension() == ".gz") {
						auto fileTime = std::filesystem::last_write_time(file);
						auto fileTimeSystemClock = std::chrono::clock_cast<std::chrono::system_clock>(fileTime);

						if (fileTimeSystemClock < sevenDaysAgo) {
							std::filesystem::remove(file);
							g_logger().info("Deleted old backup file: {}", file.path().string());
						}
					}
				}
			} catch (const std::filesystem::filesystem_error &e) {
				g_logger().error("Failed to check or delete files in backup directory: {}. Error: {}", entry.path().string(), e.what());
			}
		}
	}
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

bool Database::isRecoverableError(unsigned int error) {
	return error == CR_SERVER_LOST || error == CR_SERVER_GONE_ERROR || error == CR_CONN_HOST_ERROR || error == 1053 /*ER_SERVER_SHUTDOWN*/ || error == CR_CONNECTION_ERROR;
}

bool Database::retryQuery(std::string_view query, int retries) {
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

bool Database::executeQuery(std::string_view query) {
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

DBResult_ptr Database::storeQuery(std::string_view query) {
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
		return {};
	}
	if (row[it->second] == nullptr) {
		return {};
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

uint8_t DBResult::getU8FromString(const std::string &string, const std::string &function) {
	auto result = static_cast<uint8_t>(std::atoi(string.c_str()));
	if (result > std::numeric_limits<uint8_t>::max()) {
		g_logger().error("[{}] Failed to get number value {} for tier table result, on function call: {}", __FUNCTION__, result, function);
		return 0;
	}

	return result;
}

int8_t DBResult::getInt8FromString(const std::string &string, const std::string &function) {
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
