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
#ifdef DEBUG_LOG
	SPDLOG_DEBUG("[CANARY] SPDLOG LOG DEBUG ENABLED");
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [file %@] [func %!] [thread %t] [%^%l%$] %v ");
#else
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [%^%l%$] %v ");
#endif
}

void LogWithSpdLog::_trace(const std::string &format) {
	SPDLOG_TRACE(format);
}

void LogWithSpdLog::_debug(const std::string &format) {
	SPDLOG_DEBUG(format);
}

void LogWithSpdLog::_info(const std::string &format) {
	SPDLOG_INFO(format);
}

void LogWithSpdLog::_warn(const std::string &format) {
	SPDLOG_WARN(format);
}

void LogWithSpdLog::_error(const std::string &format) {
	SPDLOG_ERROR(format);
}

void LogWithSpdLog::_critical(const std::string &format) {
	SPDLOG_CRITICAL(format);
}