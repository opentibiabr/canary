/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <ctime>
#include <cstdint>
#include <chrono>

class Benchmark {
public:
	Benchmark() noexcept {
		start();
	}

	void start() noexcept {
		startTime = time();
	}

	void end() noexcept {
		if (startTime == -1) {
			return;
		}

		last = static_cast<double>(time() - startTime) / 1000.f;

		startTime = -1;

		if (minTime == -1 || minTime > last) {
			minTime = last;
		}

		if (maxTime == -1 || maxTime < last) {
			maxTime = last;
		}

		total += last;
		++totalExecs;
	}

	double duration() noexcept {
		if (startTime > -1) {
			end();
		}

		return last;
	}

	double min() const noexcept {
		return minTime;
	}

	double max() const noexcept {
		return maxTime;
	}

	double avg() const noexcept {
		return total / totalExecs;
	}

	void reset() noexcept {
		startTime = -1;
		minTime = -1;
		maxTime = -1;
		last = -1;
		total = 0;
		totalExecs = 0;
	}

private:
	int64_t time() const noexcept {
		return std::chrono::duration_cast<std::chrono::microseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	}

	int64_t startTime = -1;
	double minTime = -1;
	double maxTime = -1;
	double last = -1;
	double total = 0;
	uint_fast32_t totalExecs = 0;
};
