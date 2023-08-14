/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#ifndef CANARY_ILOGGER_HPP
#define CANARY_ILOGGER_HPP

#include <fmt/core.h>
#include <string>

class Logger {
	public:
		virtual ~Logger() = default;

		// Ensures that we don't accidentally copy it
		virtual Logger &operator=(const Logger &) = delete;

		template <typename... Args>
		void trace(const std::string &format, Args &&... args) {
			_trace(_format(format, args...));
		}

		template <typename... Args>
		void debug(const std::string &format, Args &&... args) {
			_debug(_format(format, args...));
		}

		template <typename... Args>
		void info(const std::string &format, Args &&... args) {
			_info(_format(format, args...));
		}

		template <typename... Args>
		void warn(auto &format, Args &&... args) {
			_warn(_format(format, args...));
		}

		template <typename... Args>
		void error(const std::string &format, Args &&... args) {
			_error(_format(format, args...));
		}

		template <typename... Args>
		void critical(const std::string &format, Args &&... args) {
			_critical(_format(format, args...));
		}

	private:
		template <typename... Args>
		std::string _format(const std::string &format, Args &&... args) const {
			return fmt::format(fmt::runtime(format), args...);
		}

		virtual void _trace(const std::string &format) = 0;
		virtual void _debug(const std::string &format) = 0;
		virtual void _info(const std::string &format) = 0;
		virtual void _warn(const std::string &format) = 0;
		virtual void _error(const std::string &format) = 0;
		virtual void _critical(const std::string &format) = 0;
};

#endif // CANARY_ILOGGER_HPP