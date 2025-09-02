#pragma once

#include <string>

#include "database/database.hpp"

class TestDatabase final {
public:
	static void init() {
		struct Config {
			std::string host = "127.0.0.1";
			std::string user = "root";
			std::string password = "root";
			std::string database = "otservbr-global";
			uint32_t port = 3306;
			std::string sock;
		} config {};

		g_database().connect(
			&config.host,
			&config.user,
			&config.password,
			&config.database,
			config.port,
			&config.sock
		);
	}
};
