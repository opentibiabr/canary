/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

LogWithSpdLog::LogWithSpdLog() {
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [%^%l%$] %v ");

#ifdef DEBUG_LOG
	setLevel("debug");
#endif
}

LogWithSpdLog &LogWithSpdLog::getInstance() {
	return inject<LogWithSpdLog>();
}

void LogWithSpdLog::setLevel(const std::string &name) {
	info("Setting log level to {}.", name);
	auto level = spdlog::level::from_str(name);
	spdlog::set_level(level);

	if (spdlog::level::from_str(name) <= SPDLOG_LEVEL_DEBUG) {
		spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [file %@] [func %!] [thread %t] [%^%l%$] %v ");
	}
}

std::string LogWithSpdLog::getLevel() const {
	auto level = spdlog::level::to_string_view(spdlog::get_level());
	return std::string { level.begin(), level.end() };
}

void LogWithSpdLog::_trace(const std::string &format) {
	spdlog::trace(format);
}

void LogWithSpdLog::_debug(const std::string &format) {
	spdlog::debug(format);
}

void LogWithSpdLog::_info(const std::string &format) {
	spdlog::info(format);
}

void LogWithSpdLog::_warn(const std::string &format) {
	spdlog::warn(format);
}

void LogWithSpdLog::_error(const std::string &format) {
	spdlog::error(format);
}

void LogWithSpdLog::_critical(const std::string &format) {
	spdlog::critical(format);
}