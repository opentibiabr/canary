#pragma once

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <stdexcept>
#include <string>
#include <string_view>
#include <functional>
#include <unordered_map>

#include "database/database.hpp"

// Loads DB test configuration from a .env-like file and/or OS env vars.
// Priority: OS env > file > default. Password is required.
class TestDatabase final {
	struct TransparentHash {
		using is_transparent = void;
		size_t operator()(std::string_view s) const noexcept {
			return std::hash<std::string_view> {}(s);
		}
	};
	struct TestEnvError : public std::runtime_error {
		using std::runtime_error::runtime_error;
	};
	using EnvMap = std::unordered_map<std::string, std::string, TransparentHash, std::equal_to<>>;

	static EnvMap
	loadEnvFile(const std::string &path) {
		EnvMap map;
		std::ifstream in(path);
		if (!in) {
			return map;
		}

		std::string line;
		while (std::getline(in, line)) {
			if (line.empty() || line[0] == '#') {
				continue;
			}
			const auto pos = line.find('=');
			if (pos == std::string::npos) {
				continue;
			}

			auto key = line.substr(0, pos);
			auto val = line.substr(pos + 1);

			// Strip surrounding quotes if present: KEY="value"
			if (!val.empty() && val.size() >= 2 && val.front() == '"' && val.back() == '"') {
				val = val.substr(1, val.size() - 2);
			}
			map[std::move(key)] = std::move(val);
		}
		return map;
	}

	static std::string pickEnvPath() {
		if (const char* p = std::getenv("TEST_ENV_FILE"); p && *p) {
			return p;
		}

#ifdef TESTS_ENV_DEFAULT
		if (std::filesystem::exists(TESTS_ENV_DEFAULT)) {
			return std::string { TESTS_ENV_DEFAULT };
		}
#endif

		// Try common relative locations from build or binary dirs.
		namespace fs = std::filesystem;
		for (const char* cand : { "tests/.env", "../tests/.env", "../../tests/.env" }) {
			if (fs::exists(cand)) {
				return cand;
			}
		}

		throw TestEnvError("Test .env file not found. Set TEST_ENV_FILE or define TESTS_ENV_DEFAULT.");
	}

	static std::string get(const EnvMap &m, const char* key, const char* def = nullptr, bool required = false) {
		if (const char* v = std::getenv(key); v && *v) {
			// OS env takes precedence
			return std::string { v };
		}
		if (auto it = m.find(std::string_view { key }); it != m.end() && !it->second.empty()) {
			return it->second;
		}
		if (required) {
			throw TestEnvError(std::string("Missing required key: ") + key);
		}

		return def ? std::string { def } : std::string {};
	}

public:
	static void init() {
		const auto envPath = pickEnvPath();
		const auto env = loadEnvFile(envPath);

		std::string host = get(env, "TEST_DB_HOST", "127.0.0.1");
		std::string user = get(env, "TEST_DB_USER", "root");
		std::string pass = get(env, "TEST_DB_PASSWORD", nullptr, /*required=*/true);
		std::string database = get(env, "TEST_DB_NAME", "otservbr-global");
		std::string portStr = get(env, "TEST_DB_PORT", "3306");
		auto port = static_cast<uint32_t>(std::strtoul(portStr.c_str(), nullptr, 10));
		std::string sock = get(env, "TEST_DB_SOCKET", "");

		g_database().connect(&host, &user, &pass, &database, port, &sock);
	}
};
