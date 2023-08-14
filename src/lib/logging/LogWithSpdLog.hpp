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

		static LogWithSpdLog &getInstance();

		void setLevel(const std::string &name) override;
		[[nodiscard]] virtual std::string getLevel() const override;

		void log(std::string lvl, fmt::basic_string_view<char> msg) const override;
};

constexpr auto g_logger = LogWithSpdLog::getInstance;

#endif // CANARY_LOGWITHSPDLOG_HPP