/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <string>
#include <cstdint>

class Benchmark {
public:
	Benchmark() noexcept;

	void start() noexcept;
	void end() noexcept;
	double duration() noexcept;
	double min() const noexcept;
	double max() const noexcept;
	double avg() const noexcept;
	void reset() noexcept;
	void log(std::string_view message) noexcept;
	void logInfo(std::string_view message) noexcept;

private:
	static int64_t time() noexcept;

	int64_t startTime = -1;
	double minTime = -1;
	double maxTime = -1;
	double last = -1;
	double total = 0;
	uint_fast32_t totalExecs = 0;
};
