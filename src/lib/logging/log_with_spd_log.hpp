/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "lib/logging/logger.hpp"

namespace spdlog {
	class logger; // Forward declaration
}

class LogWithSpdLog final : public Logger {
public:
	LogWithSpdLog();
	~LogWithSpdLog() override = default;

	static Logger &getInstance();

	void setLevel(const std::string &name) override;
	std::string getLevel() const override;
	bool shouldLog(const std::string &lvl) const override;
	void logProfile(const std::string &name, double duration_ms) const override;
	void setupLogger() const;

	void log(const std::string &lvl, fmt::basic_string_view<char> msg) const override;

private:
	mutable std::unordered_map<std::string, std::shared_ptr<spdlog::logger>> profile_loggers_;
};

constexpr auto g_logger = LogWithSpdLog::getInstance;
