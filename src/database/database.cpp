/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
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

#include <iterator>

#ifndef USE_PRECOMPILED_HEADERS
	#include <fmt/format.h>
	#include <string_view>
#endif

namespace {
	// Per-thread query capture buffer. When non-null, executeQuery records into
	// it instead of executing. See Database::beginQueryCapture.
	thread_local std::vector<std::string>* tlsQueryCapture = nullptr;

	// Calls mysql_thread_end() when a thread that opened a connection exits, so
	// libmysqlclient's thread-local state is released (no per-thread TLS leak).
	struct ThreadCleanup {
		ThreadCleanup() = default;
		ThreadCleanup(const ThreadCleanup &) = delete;
		ThreadCleanup &operator=(const ThreadCleanup &) = delete;
		~ThreadCleanup() {
			mysql_thread_end();
		}
	};

	void appendInsertBaseQuery(std::string &sql, std::string_view baseQuery, bool baseHasSpace) {
		sql += baseQuery;
		if (!baseHasSpace) {
			sql.push_back(' ');
		}
	}
}

Database::ConnectionContext::~ConnectionContext() {
	if (handle != nullptr) {
		mysql_close(handle);
	}
}

void Database::beginQueryCapture(std::vector<std::string>* buffer) {
	// Not reentrant: a nested capture would silently steal the outer buffer.
	assert(tlsQueryCapture == nullptr && "nested query capture is not supported");
	tlsQueryCapture = buffer;
}

void Database::endQueryCapture() {
	assert(tlsQueryCapture != nullptr && "endQueryCapture without a matching begin");
	tlsQueryCapture = nullptr;
}

Database::~Database() {
	// Every per-thread connection is owned here; their destructors call
	// mysql_close. The pool threads are already joined by this point (the thread
	// pool shuts down before the Database singleton is torn down), so no other
	// thread can be using a context while we clear them.
	{
		std::scoped_lock lock { connectionsMutex };
		if (!connections.empty()) {
			g_logger().info("Database: closing {} MySQL connection(s).", connections.size());
		}
		connections.clear();
	}

	// Pair mysql_library_init(): release the client library after every per-thread
	// connection is closed (and each thread's mysql_thread_end() has run). Only the
	// instance that initialized the library (single-threaded at startup) does this.
	if (m_libraryInitialized) {
		m_libraryInitialized = false;
		mysql_library_end();
	}
}

Database &Database::getInstance() {
	return inject<Database>();
}

bool Database::connect() {
	return connect(&g_configManager().getString(MYSQL_HOST), &g_configManager().getString(MYSQL_USER), &g_configManager().getString(MYSQL_PASS), &g_configManager().getString(MYSQL_DB), g_configManager().getNumber(SQL_PORT), &g_configManager().getString(MYSQL_SOCK));
}

bool Database::connect(const std::string* host, const std::string* user, const std::string* password, const std::string* database, uint32_t port, const std::string* sock) {
	// Initialize the MySQL client library exactly once, on this (startup) thread,
	// before any other thread opens its own connection. mysql_init() would do it
	// implicitly, but that implicit init is not thread-safe if two threads race
	// to open their first connection — doing it here up front removes that risk.
	static std::once_flag libraryInitFlag;
	std::call_once(libraryInitFlag, [this]() {
		if (mysql_library_init(0, nullptr, nullptr) != 0) {
			g_logger().error("Failed to initialize the MySQL client library.");
		} else {
			m_libraryInitialized = true;
			g_logger().info("Database running in per-thread connection mode (one MySQL connection per worker thread).");
		}
	});

	if (host->empty() || user->empty() || password->empty() || database->empty() || port <= 0) {
		g_logger().warn("MySQL host, user, password, database or port not provided");
	}

	// Capture the parameters once; every thread reuses them to open its own
	// connection lazily on first query.
	connectionParams = ConnectionParams {
		*host, *user, *password, *database, *sock, port
	};

	// Establish the connection for the calling (startup) thread so credential
	// errors surface immediately instead of on the first asynchronous query.
	return getContext().handle != nullptr;
}

bool Database::establishConnection(ConnectionContext &ctx) const {
	if (!connectionParams) {
		g_logger().error("Database connection parameters not initialized!");
		return false;
	}

	// Each thread must initialize the MySQL client library's thread-local state,
	// and release it when the thread exits (the thread_local destructor runs on
	// this very thread, which is where mysql_thread_end() must be called).
	(void)mysql_thread_init();
	static thread_local ThreadCleanup threadCleanup;

	ctx.handle = mysql_init(nullptr);
	if (!ctx.handle) {
		g_logger().error("Failed to initialize MySQL connection handle.");
		return false;
	}

	// automatic reconnect
	bool reconnect = true;
	(void)mysql_options(ctx.handle, MYSQL_OPT_RECONNECT, &reconnect);

	// Remove ssl verification
	bool ssl_enabled = false;
	(void)mysql_options(ctx.handle, MYSQL_OPT_SSL_VERIFY_SERVER_CERT, &ssl_enabled);

	const auto &p = *connectionParams;
	if (!mysql_real_connect(ctx.handle, p.host.c_str(), p.user.c_str(), p.password.c_str(), p.database.c_str(), p.port, p.sock.empty() ? nullptr : p.sock.c_str(), 0)) {
		g_logger().error("MySQL Error Message: {}", mysql_error(ctx.handle));
		mysql_close(ctx.handle);
		ctx.handle = nullptr;
		return false;
	}

	// Query max_allowed_packet straight on this handle — we already hold it, and
	// going through storeQuery() would just resolve back to this same context.
	if (mysql_query(ctx.handle, "SHOW VARIABLES LIKE 'max_allowed_packet'") == 0) {
		MYSQL_RES* res = mysql_store_result(ctx.handle);
		if (res != nullptr) {
			DBResult result(res);
			if (result.hasNext()) {
				ctx.maxPacketSize = result.getNumber<uint64_t>("Value");
			}
		}
	}
	return true;
}

Database::ConnectionContext &Database::getContext() const {
	thread_local ConnectionContext* tlsContext = nullptr;
	if (tlsContext != nullptr) {
		return *tlsContext;
	}

	auto context = std::make_unique<ConnectionContext>();
	ConnectionContext* contextPtr = context.get();
	size_t connectionNumber = 0;
	{
		std::scoped_lock lock { connectionsMutex };
		connections.push_back(std::move(context));
		connectionNumber = connections.size();
	}

	if (establishConnection(*contextPtr)) {
		// Cache in the thread_local only on success: a failed open is not cached,
		// so the next query on this thread retries with a fresh connection (e.g.
		// if MySQL was briefly unreachable) instead of being stuck with a null
		// handle forever.
		tlsContext = contextPtr;
		g_logger().info("Database: opened MySQL connection #{} (new worker thread reached the database).", connectionNumber);
	} else {
		g_logger().error("Database: failed to open MySQL connection #{} for a worker thread.", connectionNumber);
	}
	return *contextPtr;
}

void Database::createDatabaseBackup(bool compress) const {
	if (!g_configManager().getBoolean(MYSQL_DB_BACKUP)) {
		return;
	}

	// Get current time for formatting
	auto now = std::chrono::system_clock::now();
	std::string formattedDate = fmt::format("{:%Y-%m-%d}", now);
	std::string formattedTime = fmt::format("{:%H-%M-%S}", now);

	// Create a backup directory based on the current date
	std::string backupDir = fmt::format("database_backup/{}/", formattedDate);
	std::filesystem::create_directories(backupDir);
	std::string backupFileName = fmt::format("{}backup_{}.sql", backupDir, formattedTime);

	// Create a temporary configuration file for MySQL credentials
	std::string tempConfigFile = "database_backup.cnf";
	std::ofstream configFile(tempConfigFile);
	if (configFile.is_open()) {
		configFile << "[client]\n";
		configFile << "user=\"" << g_configManager().getString(MYSQL_USER) << "\"\n";
		configFile << "password=\"" << g_configManager().getString(MYSQL_PASS) << "\"\n";
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
						auto sctp = std::chrono::time_point_cast<std::chrono::system_clock::duration>(fileTime - std::filesystem::file_time_type::clock::now() + std::chrono::system_clock::now());
						auto fileTimeSystemClock = std::chrono::system_clock::time_point { sctp.time_since_epoch() };

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

// A transaction runs entirely on the calling thread, hence entirely on that
// thread's connection. Connection affinity alone provides exclusion, so there
// is no global lock to hold between BEGIN and COMMIT/ROLLBACK anymore.
bool Database::beginTransaction() {
	// Clear any stale error from a previous transaction so the retry logic only
	// reacts to a deadlock raised within this one.
	getContext().lastErrno = 0;
	return executeQuery("BEGIN");
}

bool Database::lastQueryWasDeadlock() const {
	const auto errorCode = getContext().lastErrno;
	// 1213 = ER_LOCK_DEADLOCK, 1205 = ER_LOCK_WAIT_TIMEOUT.
	return errorCode == 1213 || errorCode == 1205;
}

bool Database::rollback() {
	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database not initialized!");
		return false;
	}

	if (mysql_rollback(ctx.handle) != 0) {
		g_logger().error("Message: {}", mysql_error(ctx.handle));
		return false;
	}

	return true;
}

bool Database::commit() {
	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database not initialized!");
		return false;
	}
	if (mysql_commit(ctx.handle) != 0) {
		g_logger().error("Message: {}", mysql_error(ctx.handle));
		return false;
	}

	return true;
}

bool Database::isRecoverableError(unsigned int error) {
	return error == CR_SERVER_LOST || error == CR_SERVER_GONE_ERROR || error == CR_CONN_HOST_ERROR || error == 1053 /*ER_SERVER_SHUTDOWN*/ || error == CR_CONNECTION_ERROR;
}

bool Database::retryQuery(std::string_view query, int retries) {
	auto &ctx = getContext();
	while (retries > 0 && mysql_query(ctx.handle, query.data()) != 0) {
		const unsigned int errorCode = mysql_errno(ctx.handle);
		g_logger().error("Query: {}", query.substr(0, 256));
		g_logger().error("MySQL error [{}]: {}", errorCode, mysql_error(ctx.handle));
		if (!isRecoverableError(errorCode)) {
			ctx.lastErrno = errorCode;
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
	// Record-replay: during a capture (player save build on the dispatcher), defer
	// the write by recording it; it will be replayed on a pool thread.
	if (tlsQueryCapture != nullptr) {
		tlsQueryCapture->push_back(std::string(query));
		return true;
	}

	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database not initialized!");
		return false;
	}

	g_logger().trace("Executing Query: {}", query);

	metrics::query_latency measure(query.substr(0, 50));
	bool success = retryQuery(query, 10);
	mysql_free_result(mysql_store_result(ctx.handle));

	return success;
}

DBResult_ptr Database::storeQuery(std::string_view query) {
	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database not initialized!");
		return nullptr;
	}
	g_logger().trace("Storing Query: {}", query);

	metrics::query_latency measure(query.substr(0, 50));
retry:
	if (mysql_query(ctx.handle, query.data()) != 0) {
		const unsigned int errorCode = mysql_errno(ctx.handle);
		g_logger().error("Query: {}", query);
		g_logger().error("Message: {}", mysql_error(ctx.handle));
		if (!isRecoverableError(errorCode)) {
			ctx.lastErrno = errorCode;
			return nullptr;
		}
		std::this_thread::sleep_for(std::chrono::seconds(1));
		goto retry;
	}

	// Retrieving results of query
	MYSQL_RES* res = mysql_store_result(ctx.handle);
	if (res != nullptr) {
		DBResult_ptr result = std::make_shared<DBResult>(res);
		if (!result->hasNext()) {
			return nullptr;
		}
		return result;
	}
	return nullptr;
}

uint64_t Database::getLastInsertId() const {
	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database connection not established, cannot get last insert id!");
		return 0;
	}
	return mysql_insert_id(ctx.handle);
}

uint64_t Database::getMaxPacketSize() const {
	return getContext().maxPacketSize;
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
	auto &ctx = getContext();
	if (!ctx.handle) {
		g_logger().error("Database connection not established, cannot escape blob!");
		return "''";
	}

	size_t maxLength = (length * 2) + 1;

	std::string escaped;
	escaped.reserve(maxLength + 2);
	escaped.push_back('\'');

	if (length != 0) {
		std::string output(maxLength, '\0');
		size_t escapedLength = mysql_real_escape_string(ctx.handle, &output[0], s, length);
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
	auto max_packet_size = Database::getInstance().getMaxPacketSize();
	size_t addedLength = values.empty() ? rowLength + 2 : rowLength + 3;

	if (length + addedLength > max_packet_size) {
		if (values.empty() || !execute()) {
			return false;
		}

		addedLength = rowLength + 2;
		if (length + addedLength > max_packet_size) {
			return false;
		}
	}

	length += addedLength;
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

	const std::string &baseQuery = this->query;
	std::string upsertQuery;

	if (!upsertColumns.empty()) {
		size_t estimatedSize = 32;
		for (const auto &column : upsertColumns) {
			estimatedSize += (column.size() * 2) + 16;
		}

		upsertQuery.reserve(estimatedSize);
		upsertQuery += " ON DUPLICATE KEY UPDATE ";
		auto upsertOutput = std::back_inserter(upsertQuery);
		for (size_t i = 0; i < upsertColumns.size(); ++i) {
			upsertOutput = fmt::format_to(upsertOutput, "`{0}` = VALUES(`{0}`)", upsertColumns[i]);
			if (i + 1 < upsertColumns.size()) {
				upsertQuery.push_back(',');
				upsertQuery.push_back(' ');
			}
		}
	}

	std::string currentBatch = values;
	const bool baseHasSpace = !baseQuery.empty() && baseQuery.back() == ' ';
	const size_t separatorSize = baseHasSpace ? 0U : 1U;
	const size_t queryPrefixSize = baseQuery.size() + separatorSize + upsertQuery.size();
	if (queryPrefixSize >= Database::MAX_QUERY_SIZE) {
		return false;
	}

	while (!currentBatch.empty()) {
		size_t cutPos = Database::MAX_QUERY_SIZE - queryPrefixSize;
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
		if (!batchValues.empty() && batchValues.back() == ',') {
			batchValues.pop_back();
		}
		currentBatch = currentBatch.substr(cutPos);

		std::string sql;
		sql.reserve(queryPrefixSize + batchValues.size());
		appendInsertBaseQuery(sql, baseQuery, baseHasSpace);
		sql += batchValues;
		sql += upsertQuery;

		if (!g_database().executeQuery(sql)) {
			return false;
		}
	}

	values.clear();
	length = this->query.length();
	return true;
}
