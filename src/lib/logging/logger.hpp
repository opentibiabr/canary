/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#define LOG_LEVEL_TRACE \
	std::string {       \
		"trace"         \
	}
#define LOG_LEVEL_DEBUG \
	std::string {       \
		"debug"         \
	}
#define LOG_LEVEL_INFO \
	std::string {      \
		"info"         \
	}
#define LOG_LEVEL_WARNING \
	std::string {         \
		"warning"         \
	}
#define LOG_LEVEL_ERROR \
	std::string {       \
		"error"         \
	}
#define LOG_LEVEL_CRITICAL \
	std::string {          \
		"critical"         \
	}

class Logger {
public:
	Logger() = default;
	virtual ~Logger() = default;

	// Ensures that we don't accidentally copy it
	Logger(const Logger &) = delete;
	virtual Logger &operator=(const Logger &) = delete;

	virtual void setLevel(const std::string &name) = 0;
	[[nodiscard]] virtual std::string getLevel() const = 0;
	virtual void log(std::string lvl, fmt::basic_string_view<char> msg) const = 0;

	template <typename... Args>
	void trace(const fmt::format_string<Args...> &fmt, Args &&... args) {
		trace(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void debug(const fmt::format_string<Args...> &fmt, Args &&... args) {
		debug(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void info(fmt::format_string<Args...> fmt, Args &&... args) {
		info(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void warn(const fmt::format_string<Args...> &fmt, Args &&... args) {
		warn(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void error(const fmt::format_string<Args...> fmt, Args &&... args) {
		error(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void critical(const fmt::format_string<Args...> fmt, Args &&... args) {
		critical(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename T>
	void trace(const T &msg) {
		log(LOG_LEVEL_TRACE, msg);
	}

	template <typename T>
	void debug(const T &msg) {
		log(LOG_LEVEL_DEBUG, msg);
	}

	template <typename T>
	void info(const T &msg) {
		log(LOG_LEVEL_INFO, msg);
	}

	template <typename T>
	void warn(const T &msg) {
		log(LOG_LEVEL_WARNING, msg);
	}

	template <typename T>
	void error(const T &msg) {
		log(LOG_LEVEL_ERROR, msg);
	}

	template <typename T>
	void critical(const T &msg) {
		log(LOG_LEVEL_CRITICAL, msg);
	}
};
