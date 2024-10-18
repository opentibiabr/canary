/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include <vector>
#include <string>
#include <utility>

#include "test_injection.hpp"
#include "lib/di/container.hpp"

namespace di = boost::di;

class InMemoryLogger : public Logger {
private:
	struct LogEntry {
		std::string level;
		std::string message;
	};

public:
	mutable std::vector<LogEntry> logs;

	InMemoryLogger() = default;
	InMemoryLogger(const InMemoryLogger &) { }
	InMemoryLogger(const InMemoryLogger &&) { }

	static di::extension::injector<> &install(di::extension::injector<> &injector) {
		injector.install(di::bind<Logger>.to<InMemoryLogger>().in(di::singleton));
		return injector;
	}

	InMemoryLogger &reset() {
		logs.clear();
		return *this;
	}

	bool hasLogEntry(const std::string &lvl, const std::string &expectedMsg) const {
		for (const auto &entry : logs) {
			if (entry.level == lvl && entry.message == expectedMsg) {
				return true;
			}
		}

		return false;
	}

	void setLevel(const std::string &name) const override {
		// For the stub, setting a level might not have any behavior.
		// But you can implement level filtering if you like.
	}

	std::string getLevel() const override {
		// For simplicity, let's just return a default level. You can adjust as needed.
		return "DEBUG";
	}

	void info(const std::string &msg) const override {
		logs.push_back({ "info", msg });
	}

	void warn(const std::string &msg) const override {
		logs.push_back({ "warn", msg });
	}

	void error(const std::string &msg) const override {
		logs.push_back({ "error", msg });
	}

	void critical(const std::string &msg) const override {
		logs.push_back({ "critical", msg });
	}

#if defined(DEBUG_LOG)
	void debug(const std::string &msg) const override {
		logs.push_back({ "debug", msg });
	}

	void trace(const std::string &msg) const override {
		logs.push_back({ "trace", msg });
	}
#else
	void debug(const std::string &) const override { }
	void trace(const std::string &) const override { }
#endif
	// Helper methods for testing
	size_t logCount() const {
		return logs.size();
	}

	std::pair<std::string, std::string> getLogEntry(size_t index) const {
		if (index < logs.size()) {
			return { logs[index].level, logs[index].message };
		}
		return { "", "" }; // Return empty pair for out-of-bounds. Alternatively, you could throw an exception.
	}
};

template <>
struct TestInjection<Logger> {
	using type = InMemoryLogger;
};
