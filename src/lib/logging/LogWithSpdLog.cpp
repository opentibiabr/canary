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

void LogWithSpdLog::log(const std::string lvl, const fmt::basic_string_view<char> msg) const {
	spdlog::log(spdlog::level::from_str(lvl), msg);
}