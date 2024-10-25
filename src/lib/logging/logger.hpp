/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "utils/transparent_string_hash.hpp"

namespace spdlog {
	class logger;
}

class Logger {
public:
	Logger() = default;
	virtual ~Logger() = default;

	// Ensures that we don't accidentally copy it
	Logger(const Logger &) = delete;
	virtual Logger &operator=(const Logger &) = delete;

	virtual void setLevel(const std::string &name) const = 0;
	virtual std::string getLevel() const = 0;

	/**
	 * @brief Logs the execution time of a given operation to a profile log file.
	 *
	 * This function records the duration of a named operation in a log file specific
	 * to that operation. If the log file doesn't exist, it creates a new one.
	 * The log file name is derived from the provided operation name.
	 *
	 * @param name Name of the operation to profile.
	 * @param duration_ms Execution duration in milliseconds.
	 *
	 * Example usage:
	 * @code
	 * class ExampleClass {
	 * public:
	 *     void run() {
	 *         g_logger().profile("quickTask", [this]() {
	 *             quickTask();
	 *         });
	 *     }
	 *
	 * private:
	 *     void quickTask() {
	 *         std::this_thread::sleep_for(std::chrono::milliseconds(100));
	 *     }
	 * };
	 * @endcode
	 */
	void logProfile(const std::string &name, double duration_ms) const;

	virtual void info(const std::string &msg) const;
	virtual void warn(const std::string &msg) const;
	virtual void error(const std::string &msg) const;
	virtual void critical(const std::string &msg) const;

	template <typename Func>
	auto profile(const std::string &name, Func func) -> decltype(func()) {
		const auto start = std::chrono::high_resolution_clock::now();
		auto result = func();
		const auto end = std::chrono::high_resolution_clock::now();

		const std::chrono::duration<double, std::milli> duration = end - start;
		logProfile(name, duration.count());
		info("Function {} executed in {} ms", name, duration.count());

		return result;
	}

#if defined(DEBUG_LOG)
	virtual void debug(const std::string &msg) const;

	template <typename... Args>
	void debug(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		debug(fmt::format(fmt, std::forward<Args>(args)...));
	}

	virtual void trace(const std::string &msg) const;

	template <typename... Args>
	void trace(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		trace(fmt::format(fmt, std::forward<Args>(args)...));
	}
#else
	virtual void debug(const std::string &) const { }

	template <typename... Args>
	void debug(const fmt::format_string<Args...> &, Args &&...) const { }

	virtual void trace(const std::string &) const { }

	template <typename... Args>
	void trace(const fmt::format_string<Args...> &, Args &&...) const { }
#endif

	template <typename... Args>
	void info(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		info(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void warn(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		warn(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void error(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		error(fmt::format(fmt, std::forward<Args>(args)...));
	}

	template <typename... Args>
	void critical(const fmt::format_string<Args...> &fmt, Args &&... args) const {
		critical(fmt::format(fmt, std::forward<Args>(args)...));
	}

private:
	mutable std::unordered_map<
		std::string,
		std::shared_ptr<spdlog::logger>,
		TransparentStringHasher,
		std::equal_to<>>
		profile_loggers_;

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
};
