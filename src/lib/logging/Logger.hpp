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

		virtual void setLevel(const std::string &name) = 0;
		[[nodiscard]] virtual std::string getLevel() const = 0;

		template <typename... Args>
		void trace(const std::string &format, Args &&... args) {
			trace(_format(format, args...));
		}

		void trace(const std::string &msg) {
			_trace(msg);
		}

		template <typename... Args>
		void debug(const std::string &format, Args &&... args) {
			debug(_format(format, args...));
		}

		void debug(const std::string &msg) {
			_debug(msg);
		}

		template <typename... Args>
		void info(const std::string &format, Args &&... args) {
			info(_format(format, args...));
		}

		void info(const std::string &msg) {
			_info(msg);
		}

		template <typename... Args>
		void warn(auto &format, Args &&... args) {
			warn(_format(format, args...));
		}

		void warn(const std::string &msg) {
			_warn(msg);
		}

		template <typename... Args>
		void error(const std::string &format, Args &&... args) {
			error(_format(format, args...));
		}

		void error(const std::string &msg) {
			_error(msg);
		}

		template <typename... Args>
		void critical(const std::string &format, Args &&... args) {
			critical(_format(format, args...));
		}

		void critical(const std::string &msg) {
			_critical(msg);
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