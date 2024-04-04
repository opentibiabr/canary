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

	void setLevel(const std::string &name) override {
		// For the stub, setting a level might not have any behavior.
		// But you can implement level filtering if you like.
	}

	std::string getLevel() const override {
		// For simplicity, let's just return a default level. You can adjust as needed.
		return "DEBUG";
	}

	virtual void log(const std::string &lvl, fmt::basic_string_view<char> msg) const override {
		logs.push_back({ lvl, { msg.data(), msg.size() } });
	}

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
