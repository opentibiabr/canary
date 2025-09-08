/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "utils/benchmark.hpp"

#include "lib/logging/log_with_spd_log.hpp"

Benchmark::Benchmark() noexcept {
	start();
}

void Benchmark::start() noexcept {
	startTime = time();
}

void Benchmark::end() noexcept {
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

double Benchmark::duration() noexcept {
	if (startTime > -1) {
		end();
	}

	return last;
}

double Benchmark::min() const noexcept {
	return minTime;
}

double Benchmark::max() const noexcept {
	return maxTime;
}

double Benchmark::avg() const noexcept {
	return total / totalExecs;
}

void Benchmark::reset() noexcept {
	startTime = -1;
	minTime = -1;
	maxTime = -1;
	last = -1;
	total = 0;
	totalExecs = 0;
}

void Benchmark::log(std::string_view message) noexcept {
	end();
	if (last > 1000.0) {
		g_logger().debug("{} took {:.3f} seconds.", message, last / 1000.0);
	} else {
		g_logger().debug("{} took {:.3f} milliseconds.", message, last);
	}
}

void Benchmark::logInfo(std::string_view message) noexcept {
	end();
	if (last > 1000.0) {
		g_logger().info("{} took {:.3f} seconds.", message, last / 1000.0);
	} else {
		g_logger().info("{} took {:.3f} milliseconds.", message, last);
	}
}

int64_t Benchmark::time() noexcept {
	return std::chrono::duration_cast<std::chrono::microseconds>(
			   std::chrono::system_clock::now().time_since_epoch()
	)
		.count();
}
