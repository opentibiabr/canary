/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <fmt/format.h>
#endif

#define LOG_LEVEL_TRACE "trace"
#define LOG_LEVEL_DEBUG "debug"
#define LOG_LEVEL_INFO "info"
#define LOG_LEVEL_WARNING "warning"
#define LOG_LEVEL_ERROR "error"
#define LOG_LEVEL_CRITICAL "critical"

class Logger {
public:
	Logger() = default;
	virtual ~Logger() = default;

	// Ensures that we don't accidentally copy it
	Logger(const Logger &) = delete;
	virtual Logger &operator=(const Logger &) = delete;

	virtual void setLevel(const std::string &name) = 0;
	[[nodiscard]] virtual std::string getLevel() const = 0;
	virtual void log(const std::string &lvl, fmt::basic_string_view<char> msg) const = 0;

	virtual bool shouldLog(const std::string &lvl) const = 0;
	virtual void logProfile(const std::string &name, double duration_ms) const = 0;

	std::tm get_local_time() const {
		const auto now = std::chrono::system_clock::now();
		std::time_t now_time = std::chrono::system_clock::to_time_t(now);
		std::tm local_tm {};

#if defined(_WIN32) || defined(_WIN64)
		localtime_s(&local_tm, &now_time);
#else
		localtime_r(&now_time, &local_tm);
#endif

		return local_tm;
	}

	template <typename Func>
	auto profile(const std::string &name, Func func) -> decltype(func()) {
		const auto start = std::chrono::high_resolution_clock::now();
		auto result = func();
		const auto end = std::chrono::high_resolution_clock::now();

		const std::chrono::duration<double, std::milli> duration = end - start;
		info("Function {} executed in {} ms", name, duration.count());

		logProfile(name, duration.count());

		return result;
	}

	template <typename... Args>
	void trace(const fmt::format_string<Args...> &fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_TRACE)) {
			trace(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename... Args>
	void debug(const fmt::format_string<Args...> &fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_DEBUG)) {
			debug(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename... Args>
	void info(fmt::format_string<Args...> fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_INFO)) {
			info(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename... Args>
	void warn(const fmt::format_string<Args...> &fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_WARNING)) {
			warn(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename... Args>
	void error(const fmt::format_string<Args...> fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_ERROR)) {
			error(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename... Args>
	void critical(const fmt::format_string<Args...> fmt, Args &&... args) {
		if (shouldLog(LOG_LEVEL_CRITICAL)) {
			critical(fmt::format(fmt, std::forward<Args>(args)...));
		}
	}

	template <typename T>
	void trace(const T &msg) {
		if (shouldLog(LOG_LEVEL_TRACE)) {
			log(LOG_LEVEL_TRACE, msg);
		}
	}

	template <typename T>
	void debug(const T &msg) {
		if (shouldLog(LOG_LEVEL_DEBUG)) {
			log(LOG_LEVEL_DEBUG, msg);
		}
	}

	template <typename T>
	void info(const T &msg) {
		if (shouldLog(LOG_LEVEL_INFO)) {
			log(LOG_LEVEL_INFO, msg);
		}
	}

	template <typename T>
	void warn(const T &msg) {
		if (shouldLog(LOG_LEVEL_WARNING)) {
			log(LOG_LEVEL_WARNING, msg);
		}
	}

	template <typename T>
	void error(const T &msg) {
		if (shouldLog(LOG_LEVEL_ERROR)) {
			log(LOG_LEVEL_ERROR, msg);
		}
	}

	template <typename T>
	void critical(const T &msg) {
		if (shouldLog(LOG_LEVEL_CRITICAL)) {
			log(LOG_LEVEL_CRITICAL, msg);
		}
	}
};
