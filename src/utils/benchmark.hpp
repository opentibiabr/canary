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
#include <vector>
#include <chrono>

class Benchmark {
public:
	Benchmark() noexcept {
		times.reserve(20);
		start();
	}

	void start() noexcept {
		startTime = time();
	}

	void end() noexcept {
		if (startTime == -1) {
			return;
		}

		endTime = time();
		last = static_cast<double>(endTime - startTime) / 1000.f;

		startTime = -1;

		if (minTime == -1 || minTime > last) {
			minTime = last;
		}

		if (maxTime == -1 || maxTime < last) {
			maxTime = last;
		}

		times.push_back(last);
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
		double total = 0.0;
		for (const auto v : times) {
			total += v;
		}

		return total / times.size();
	}

	void reset() noexcept {
		startTime = -1;
		endTime = -1;
		minTime = -1;
		maxTime = -1;
		last = -1;
		times.clear();
	}

private:
	int64_t time() const noexcept {
		return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
	}
	int64_t startTime = -1;
	int64_t endTime = -1;
	double minTime = -1;
	double maxTime = -1;
	double last = -1;

	std::vector<double> times;
};
