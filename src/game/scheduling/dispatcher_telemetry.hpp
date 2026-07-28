/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <atomic>
	#include <chrono>
	#include <cmath>
	#include <cstddef>
	#include <cstdint>
	#include <mutex>
	#include <string>
	#include <string_view>
	#include <utility>
#endif

namespace dispatcher::telemetry {
	using Duration = std::chrono::microseconds;

	inline constexpr std::array<int64_t, 18> LATENCY_BUCKET_UPPER_BOUNDS_US = {
		50,
		100,
		250,
		500,
		1000,
		2000,
		5000,
		10000,
		20000,
		50000,
		100000,
		250000,
		500000,
		1000000,
		2000000,
		5000000,
		10000000,
		30000000,
	};

	struct LatencySnapshot {
		std::array<uint64_t, LATENCY_BUCKET_UPPER_BOUNDS_US.size() + 1> buckets {};
		uint64_t samples = 0;
		int64_t totalUs = 0;
		int64_t maxUs = 0;

		[[nodiscard]] bool empty() const {
			return samples == 0;
		}

		[[nodiscard]] Duration percentile(double percentileValue) const {
			if (empty()) {
				return Duration::zero();
			}

			const auto normalized = std::clamp(percentileValue, 0.0, 1.0);
			const auto rank = std::max<uint64_t>(1, static_cast<uint64_t>(std::ceil(normalized * static_cast<double>(samples))));
			uint64_t cumulative = 0;
			for (size_t index = 0; index < buckets.size(); ++index) {
				cumulative += buckets[index];
				if (cumulative < rank) {
					continue;
				}

				if (index < LATENCY_BUCKET_UPPER_BOUNDS_US.size()) {
					return Duration(LATENCY_BUCKET_UPPER_BOUNDS_US[index]);
				}
				return Duration(maxUs);
			}

			return Duration(maxUs);
		}

		[[nodiscard]] Duration mean() const {
			return empty() ? Duration::zero() : Duration(totalUs / static_cast<int64_t>(samples));
		}
	};

	class ConcurrentLatencyHistogram {
	public:
		void observe(Duration duration) noexcept {
			const auto value = std::max<int64_t>(0, duration.count());
			const auto bucket = static_cast<size_t>(std::lower_bound(LATENCY_BUCKET_UPPER_BOUNDS_US.begin(), LATENCY_BUCKET_UPPER_BOUNDS_US.end(), value) - LATENCY_BUCKET_UPPER_BOUNDS_US.begin());
			buckets[bucket].fetch_add(1, std::memory_order_relaxed);
			totalUs.fetch_add(value, std::memory_order_relaxed);

			auto currentMax = maxUs.load(std::memory_order_relaxed);
			while (value > currentMax && !maxUs.compare_exchange_weak(currentMax, value, std::memory_order_relaxed)) {
			}
		}

		[[nodiscard]] LatencySnapshot snapshotAndReset() noexcept {
			LatencySnapshot snapshot;
			for (size_t index = 0; index < buckets.size(); ++index) {
				snapshot.buckets[index] = buckets[index].exchange(0, std::memory_order_relaxed);
				snapshot.samples += snapshot.buckets[index];
			}
			snapshot.totalUs = totalUs.exchange(0, std::memory_order_relaxed);
			snapshot.maxUs = maxUs.exchange(0, std::memory_order_relaxed);
			return snapshot;
		}

		void reset() noexcept {
			(void)snapshotAndReset();
		}

	private:
		std::array<std::atomic_uint64_t, LATENCY_BUCKET_UPPER_BOUNDS_US.size() + 1> buckets {};
		std::atomic_int64_t totalUs = 0;
		std::atomic_int64_t maxUs = 0;
	};

	struct TimedWorkSnapshot {
		LatencySnapshot latency;
		uint64_t workUnits = 0;
		Duration longestDuration { 0 };
		std::string longestContext;

		[[nodiscard]] bool empty() const {
			return latency.empty();
		}
	};

	class ConcurrentTimedWork {
	public:
		void observe(Duration duration, uint64_t units = 1, std::string_view context = {}) noexcept {
			latency.observe(duration);
			workUnits.fetch_add(units, std::memory_order_relaxed);

			if (context.empty()) {
				return;
			}

			const auto value = std::max<int64_t>(0, duration.count());
			auto currentMax = longestContextDurationUs.load(std::memory_order_relaxed);
			while (value > currentMax) {
				if (!longestContextDurationUs.compare_exchange_weak(currentMax, value, std::memory_order_relaxed)) {
					continue;
				}

				std::scoped_lock lock(longestContextMutex);
				if (value >= longestContextDuration.count()) {
					try {
						longestContext.assign(context);
						longestContextDuration = Duration(value);
					} catch (...) {
						longestContext.clear();
						longestContextDuration = Duration::zero();
					}
				}
				break;
			}
		}

		[[nodiscard]] TimedWorkSnapshot snapshotAndReset() noexcept {
			TimedWorkSnapshot snapshot;
			snapshot.latency = latency.snapshotAndReset();
			snapshot.workUnits = workUnits.exchange(0, std::memory_order_relaxed);
			longestContextDurationUs.store(0, std::memory_order_relaxed);
			{
				std::scoped_lock lock(longestContextMutex);
				snapshot.longestDuration = longestContextDuration;
				snapshot.longestContext = std::move(longestContext);
				longestContextDuration = Duration::zero();
			}
			return snapshot;
		}

		void reset() noexcept {
			(void)snapshotAndReset();
		}

	private:
		ConcurrentLatencyHistogram latency;
		std::atomic_uint64_t workUnits = 0;
		std::atomic_int64_t longestContextDurationUs = 0;
		std::mutex longestContextMutex;
		Duration longestContextDuration { 0 };
		std::string longestContext;
	};
}
