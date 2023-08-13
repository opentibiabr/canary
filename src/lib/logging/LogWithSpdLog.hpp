/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#ifndef CANARY_LOGWITHSPDLOG_HPP
#define CANARY_LOGWITHSPDLOG_HPP

class LogWithSpdLog final : public Logger {
	public:
		LogWithSpdLog();
		~LogWithSpdLog() override = default;

		// Ensures that we don't accidentally copy it
		LogWithSpdLog(const LogWithSpdLog &) = delete;
		LogWithSpdLog &operator=(const LogWithSpdLog &) = delete;

	private:
		void _trace(const std::string &format) override;
		void _debug(const std::string &format) override;
		void _info(const std::string &format) override;
		void _warn(const std::string &format) override;
		void _error(const std::string &format) override;
		void _critical(const std::string &format) override;
};

#endif // CANARY_LOGWITHSPDLOG_HPP