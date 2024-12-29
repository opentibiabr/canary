/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "database/databasemanager.hpp"

#include "config/configmanager.hpp"
#include "lua/functions/core/libs/core_libs_functions.hpp"
#include "lua/scripts/luascript.hpp"

namespace InternalDBManager {
	int32_t extractVersionFromFilename(const std::string &filename) {
		std::regex versionRegex(R"((\d+)\.lua)");
		std::smatch match;

		if (std::regex_search(filename, match, versionRegex) && match.size() > 1) {
			return std::stoi(match.str(1));
		}

		return -1;
	}
}

bool DatabaseManager::optimizeTables() {
	Database &db = Database::getInstance();
	std::ostringstream query;

	query << "SELECT `TABLE_NAME` FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB)) << " AND `DATA_FREE` > 0";
	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	do {
		std::string tableName = result->getString("TABLE_NAME");

		query.str(std::string());
		query << "OPTIMIZE TABLE `" << tableName << '`';

		std::string tableResult;
		if (db.executeQuery(query.str())) {
			tableResult = "[Success]";
		} else {
			tableResult = "[Failed]";
		}

		g_logger().info("Optimizing table {}... {}", tableName, tableResult);
	} while (result->next());

	return true;
}

bool DatabaseManager::tableExists(const std::string &tableName) {
	Database &db = Database::getInstance();

	std::ostringstream query;
	query << "SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB)) << " AND `TABLE_NAME` = " << db.escapeString(tableName) << " LIMIT 1";
	return db.storeQuery(query.str()).get() != nullptr;
}

bool DatabaseManager::isDatabaseSetup() {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = " << db.escapeString(g_configManager().getString(MYSQL_DB));
	return db.storeQuery(query.str()).get() != nullptr;
}

int32_t DatabaseManager::getDatabaseVersion() {
	if (!tableExists("server_config")) {
		Database &db = Database::getInstance();
		db.executeQuery("CREATE TABLE `server_config` (`config` VARCHAR(50) NOT NULL, `value` VARCHAR(256) NOT NULL DEFAULT '', UNIQUE(`config`)) ENGINE = InnoDB");
		db.executeQuery("INSERT INTO `server_config` VALUES ('db_version', 0)");
		return 0;
	}

	int32_t version = 0;
	if (getDatabaseConfig("db_version", version)) {
		return version;
	}
	return -1;
}

void DatabaseManager::updateDatabase() {
	Benchmark bm;
	lua_State* L = luaL_newstate();
	if (!L) {
		return;
	}

	luaL_openlibs(L);
	CoreLibsFunctions::init(L);

	int32_t currentVersion = getDatabaseVersion();
	std::string migrationDirectory = g_configManager().getString(DATA_DIRECTORY) + "/migrations/";

	std::vector<std::pair<int32_t, std::string>> migrations;

	for (const auto &entry : std::filesystem::directory_iterator(migrationDirectory)) {
		if (entry.is_regular_file()) {
			std::string filename = entry.path().filename().string();
			int32_t fileVersion = InternalDBManager::extractVersionFromFilename(filename);
			migrations.emplace_back(fileVersion, entry.path().string());
		}
	}

	std::sort(migrations.begin(), migrations.end());

	for (const auto &[fileVersion, scriptPath] : migrations) {
		if (fileVersion > currentVersion) {
			if (!LuaScriptInterface::reserveScriptEnv()) {
				break;
			}

			if (luaL_dofile(L, scriptPath.c_str()) != 0) {
				g_logger().error("DatabaseManager::updateDatabase - Version: {}] {}", fileVersion, lua_tostring(L, -1));
				continue;
			}

			lua_getglobal(L, "onUpdateDatabase");
			if (lua_pcall(L, 0, 1, 0) != 0) {
				LuaScriptInterface::resetScriptEnv();
				g_logger().warn("[DatabaseManager::updateDatabase - Version: {}] {}", fileVersion, lua_tostring(L, -1));
				continue;
			}

			currentVersion = fileVersion;
			g_logger().info("Database has been updated to version {}", currentVersion);
			registerDatabaseConfig("db_version", currentVersion);

			LuaScriptInterface::resetScriptEnv();
		}
	}

	double duration = bm.duration();
	if (duration < 1000.0) {
		g_logger().debug("Database update completed in {:.2f} ms", duration);
	} else {
		g_logger().debug("Database update completed in {:.2f} seconds", duration / 1000.0);
	}
	lua_close(L);
}

bool DatabaseManager::getDatabaseConfig(const std::string &config, int32_t &value) {
	Database &db = Database::getInstance();
	std::ostringstream query;
	query << "SELECT `value` FROM `server_config` WHERE `config` = " << db.escapeString(config);

	DBResult_ptr result = db.storeQuery(query.str());
	if (!result) {
		return false;
	}

	value = result->getNumber<int32_t>("value");
	return true;
}

void DatabaseManager::registerDatabaseConfig(const std::string &config, int32_t value) {
	Database &db = Database::getInstance();
	std::ostringstream query;

	int32_t tmp;

	if (!getDatabaseConfig(config, tmp)) {
		query << "INSERT INTO `server_config` VALUES (" << db.escapeString(config) << ", '" << value << "')";
	} else {
		query << "UPDATE `server_config` SET `value` = '" << value << "' WHERE `config` = " << db.escapeString(config);
	}

	db.executeQuery(query.str());
}
