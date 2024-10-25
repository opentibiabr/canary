/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include "lib/di/container.hpp"

void Logger::setLevel(const std::string &name) const {
	debug("Setting log level to: {}.", name);
	const auto level = spdlog::level::from_str(name);
	spdlog::set_level(level);
}

std::string Logger::getLevel() const {
	const auto level = spdlog::level::to_string_view(spdlog::get_level());
	return std::string { level.begin(), level.end() };
}

void Logger::logProfile(const std::string &name, double duration_ms) const {
	std::string mutable_name = name;

	std::ranges::replace(mutable_name, ':', '_');
	std::ranges::replace(mutable_name, '\\', '_');
	std::ranges::replace(mutable_name, '/', '_');

	std::string filename = "log/profile_log-" + mutable_name + ".txt";

	const auto it = profile_loggers_.find(filename);
	if (it == profile_loggers_.end()) {
		try {
			auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, true);
			const auto profile_logger = std::make_shared<spdlog::logger>(mutable_name, file_sink);
			profile_loggers_[filename] = profile_logger;
			profile_logger->info("Function {} executed in {} ms", name, duration_ms);
		} catch (const spdlog::spdlog_ex &ex) {
			error("Profile log initialization failed: {}", ex.what());
		}
	} else {
		it->second->info("Function {} executed in {} ms", mutable_name, duration_ms);
	}
}

void Logger::cleanOldLogs(const std::string &logDirectory, int days) const {
	namespace fs = std::filesystem;

	const auto days_duration = std::chrono::hours(days * 24);

	for (const auto &entry : fs::directory_iterator(logDirectory)) {
		if (entry.is_regular_file()) {
			auto ftime = fs::last_write_time(entry);

			if (decltype(ftime)::clock::now() - ftime > days_duration) {
				try {
					fs::remove(entry.path());
					debug("Deleted old log file: {}", entry.path().string());
				} catch (const std::exception &e) {
					debug("Failed to delete old log file: {}", entry.path().string());
				}
			}
		}
	}
}

void Logger::info(const std::string &msg) const {
	SPDLOG_INFO(msg);
}

void Logger::warn(const std::string &msg) const {
	SPDLOG_WARN(msg);
}

void Logger::error(const std::string &msg) const {
	SPDLOG_WARN(msg);
}

void Logger::critical(const std::string &msg) const {
	SPDLOG_WARN(msg);
}

#if defined(DEBUG_LOG)
void Logger::debug(const std::string &msg) const {
	SPDLOG_DEBUG(msg);
}

void Logger::trace(const std::string &msg) const {
	SPDLOG_TRACE(msg);
}
#endif
