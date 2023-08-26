/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "lib/logging/logger.hpp"

class LogWithSpdLog final : public Logger {
public:
	LogWithSpdLog();
	~LogWithSpdLog() override = default;

	static Logger &getInstance();

	void setLevel(const std::string &name) override;
	[[nodiscard]] std::string getLevel() const override;

	void log(std::string lvl, fmt::basic_string_view<char> msg) const override;
};

constexpr auto g_logger = LogWithSpdLog::getInstance;
