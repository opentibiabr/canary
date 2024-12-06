/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <spdlog/spdlog.h>
#include "lib/di/container.hpp"
#include <spdlog/sinks/stdout_color_sinks.h>
#include "gray_log_sink_options.hpp"
#include "gray_log_sink.hpp"

LogWithSpdLog::LogWithSpdLog() {
	setLevel("info");
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [%^%l%$] %v ");

#ifdef DEBUG_LOG
	spdlog::set_pattern("[%Y-%d-%m %H:%M:%S.%e] [thread %t] [%^%l%$] %v ");
#endif
}

Logger &LogWithSpdLog::getInstance() {
	return inject<Logger>();
}

void LogWithSpdLog::setLevel(const std::string &name) const {
	debug("Setting log level to: {}.", name);
	const auto level = spdlog::level::from_str(name);
	spdlog::set_level(level);
}

std::string LogWithSpdLog::getLevel() const {
	const auto level = spdlog::level::to_string_view(spdlog::get_level());
	return std::string { level.begin(), level.end() };
}

void LogWithSpdLog::info(const std::string &msg) const {
	SPDLOG_INFO(msg);
}

void LogWithSpdLog::warn(const std::string &msg) const {
	SPDLOG_WARN(msg);
}

void LogWithSpdLog::error(const std::string &msg) const {
	SPDLOG_ERROR(msg);
}

void LogWithSpdLog::critical(const std::string &msg) const {
	SPDLOG_CRITICAL(msg);
}

void LogWithSpdLog::enableGraylogSink(const GrayLogSinkOptions options) const {

	// Criação do sink do console (já existente no logger padrão)
	auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();

	// Criação do sink Graylog
	auto graylog_sink = std::make_shared<GrayLogSink>(options);

	// Combinar os dois sinks em um logger
	auto combined_logger = std::make_shared<spdlog::logger>(
		"",
		spdlog::sinks_init_list { console_sink, graylog_sink }
	);

	// Registrar o logger combinado como o logger padrão
	spdlog::set_default_logger(combined_logger);
}

#if defined(DEBUG_LOG)
void LogWithSpdLog::debug(const std::string &msg) const {
	SPDLOG_DEBUG(msg);
}

void LogWithSpdLog::trace(const std::string &msg) const {
	SPDLOG_TRACE(msg);
}
#endif
