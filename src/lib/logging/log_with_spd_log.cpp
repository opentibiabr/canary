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

LogWithSpdLog::LogWithSpdLog() {
	setLevel("info");

#ifdef DEBUG_LOG
	spdlog::set_pattern("[%Y-%m-%d %H:%M:%S.%e] [thread %t] [%^%l%$] %v ");
#else
	spdlog::set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%^%l%$] %v ");
#endif

	const std::tm local_tm = get_local_time();

	std::ostringstream oss;
	oss << std::put_time(&local_tm, "%Y-%m-%d_%H-%M-%S");
	std::string filename = "log/server_log_" + oss.str() + ".txt";

	try {
		auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
		auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, true);

		const auto combined_logger = std::make_shared<spdlog::logger>(
			"",
			spdlog::sinks_init_list { console_sink, file_sink }
		);

		combined_logger->set_level(spdlog::get_level());
		combined_logger->flush_on(spdlog::level::info);

		set_default_logger(combined_logger);

		spdlog::info("Logger initialized and configured for console and file output.");
	} catch (const spdlog::spdlog_ex &ex) {
		std::cerr << "Log initialization failed: " << ex.what() << std::endl;
	}
}

Logger &LogWithSpdLog::getInstance() {
	return inject<Logger>();
}

void LogWithSpdLog::setLevel(const std::string &name) {
	debug("Setting log level to: {}.", name);
	const auto level = spdlog::level::from_str(name);
	spdlog::set_level(level);
}

std::string LogWithSpdLog::getLevel() const {
	const auto level = spdlog::level::to_string_view(spdlog::get_level());
	return std::string { level.begin(), level.end() };
}

void LogWithSpdLog::log(const std::string &lvl, const fmt::basic_string_view<char> msg) const {
	spdlog::log(spdlog::level::from_str(lvl), msg);
}

bool LogWithSpdLog::shouldLog(const std::string &lvl) const {
	const auto currentLevel = spdlog::get_level();
	const auto messageLevel = spdlog::level::from_str(lvl);
	return messageLevel >= currentLevel;
}

void LogWithSpdLog::logProfile(const std::string &name, double duration_ms) const {
	std::string filename = "log/profile_log-" + name + ".txt";

	const auto it = profile_loggers_.find(filename);
	if (it == profile_loggers_.end()) {
		try {
			auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, true);
			auto profile_logger = std::make_shared<spdlog::logger>("profile_logger_" + name, file_sink);
			profile_loggers_[filename] = profile_logger;
			profile_logger->info("Function {} executed in {} ms", name, duration_ms);
		} catch (const spdlog::spdlog_ex &ex) {
			std::cerr << "Profile log initialization failed: " << ex.what() << std::endl;
		}
	} else {
		it->second->info("Function {} executed in {} ms", name, duration_ms);
	}
}
