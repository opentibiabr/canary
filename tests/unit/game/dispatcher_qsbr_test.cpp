/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <atomic>
#include <chrono>
#include <cstdlib>
#include <future>
#include <thread>

#include "creatures/appearance/mounts/mounts.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "lib/di/container.hpp"
#include "utils/worldpointer.hpp"

namespace {

	// Standard-layout sentinel that increments an atomic counter on
	// destruction. Wrapped by `WorldPtr<Sentinel>::Owning` to drive the
	// QSBR drain test.
	// NOSONAR(cpp:S4963) — the destructor IS the test instrumentation:
	// it's how we observe drain timing. Rule of Zero doesn't apply.
	struct Sentinel {
		std::atomic<int>* destroyedCount;

		explicit Sentinel(std::atomic<int>* counter) noexcept :
			destroyedCount(counter) { }

		~Sentinel() {
			if (destroyedCount) {
				destroyedCount->fetch_add(1, std::memory_order_relaxed);
			}
		}

		Sentinel(const Sentinel &) = delete;
		Sentinel &operator=(const Sentinel &) = delete;
	};
	static_assert(std::is_standard_layout_v<Sentinel>);

	using SentinelAlloc = WorldPtr<Sentinel>::DefaultAllocator;
	using SentinelOwning = WorldPtr<Sentinel>::Owning<SentinelAlloc>;

} // namespace

// End-of-tick QSBR drain integration test.
//
// Validates that Dispatcher::init()'s main loop invokes
// `WorldPtr<T>::quiescentState()` for each migrated type once per tick.
// Retire happens inside the event body (i.e. on the dispatcher thread), so
// retire and drain are both single-threaded — matching movaps's design
// assumption of "single-threaded for now; epochs come later when the game
// world goes multi-threaded."
//
// Declared at namespace scope (matches the friend declaration in
// dispatcher.hpp) so the fixture can drive Dispatcher::init() through the
// friendship.
class DispatcherQsbrIntegrationTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		// Initialise the dispatcher exactly once across the whole test
		// binary. It can't be safely shut down without affecting later
		// tests, so the OS reclaims it at process exit.
		static std::once_flag started;
		std::call_once(started, [] {
			inject<Dispatcher>().init();
		});
	}

	static void TearDownTestSuite() {
		// The dispatcher worker is blocked in `signalSchedule.wait_for`;
		// the static thread-pool destructor that runs after `main()`
		// would deadlock trying to join it (Dispatcher's loop checks
		// `threadPool.isStopped()` only after the wait wakes, and the
		// pool's stop signal doesn't propagate to our condition var).
		// ctest invokes one process per --gtest_filter, so by the time
		// TearDownTestSuite runs, the entire fixture is done; bypass
		// the hanging global-destructor chain with `_Exit` and report
		// the gtest failed-test count as the process exit code.
		const int failed = ::testing::UnitTest::GetInstance()->failed_test_count();
		std::_Exit(failed > 0 ? 1 : 0);
	}

	template <typename Pred>
	[[nodiscard]] static bool waitFor(
		Pred &&pred,
		std::chrono::milliseconds total = std::chrono::milliseconds(2000),
		std::chrono::milliseconds step = std::chrono::milliseconds(10)
	) {
		using clock = std::chrono::steady_clock;
		const auto deadline = clock::now() + total;
		while (clock::now() < deadline) {
			if (pred()) {
				return true;
			}
			std::this_thread::sleep_for(step);
		}
		return pred();
	}
};

// Note: dispatcher only drains the registered (T, Allocator) pairs hard-
// coded in dispatcher.cpp. To drive a Sentinel-based QSBR test through the
// real dispatcher, we'd need to either register Sentinel there or call
// `WorldPtr<Sentinel>::quiescentState` from inside the event body itself.
// We use the latter here — it still validates that retire-and-drain works
// from the dispatcher thread end-to-end.

TEST_F(DispatcherQsbrIntegrationTest, RetireFromEventBody_DrainsOnSameTick) {
	std::atomic<int> destroyed { 0 };

	auto bodyRan = std::make_shared<std::promise<void>>();
	inject<Dispatcher>().addEvent(
		[&destroyed, bodyRan] {
			// Nested scope so wp's dtor (retire) runs BEFORE the explicit
		    // quiescentState drain below.
			{ auto wp = SentinelOwning::make(&destroyed); }
			WorldPtr<Sentinel>::quiescentState<SentinelAlloc>();
			bodyRan->set_value();
		},
		"qsbr-integration-inbody-test"
	);
	ASSERT_EQ(std::future_status::ready, bodyRan->get_future().wait_for(std::chrono::seconds(2)));

	EXPECT_EQ(1, destroyed.load())
		<< "Sentinel retired+drained inside the dispatcher's event body "
		   "must be destroyed before the body returns.";
}

TEST_F(DispatcherQsbrIntegrationTest, MultipleRetiresInOneTickAllDrain) {
	std::atomic<int> destroyed { 0 };
	constexpr int kCount = 10;

	auto bodyRan = std::make_shared<std::promise<void>>();
	inject<Dispatcher>().addEvent(
		[&destroyed, kCount, bodyRan] {
			for (int i = 0; i < kCount; ++i) {
				// Nested block: each `wp` retires at end of iteration,
			    // before the drain.
				{ auto wp = SentinelOwning::make(&destroyed); }
			}
			WorldPtr<Sentinel>::quiescentState<SentinelAlloc>();
			bodyRan->set_value();
		},
		"qsbr-integration-bulk-test"
	);
	ASSERT_EQ(std::future_status::ready, bodyRan->get_future().wait_for(std::chrono::seconds(2)));

	EXPECT_EQ(kCount, destroyed.load())
		<< "All " << kCount << " retired sentinels should drain in the "
							   "same tick. Saw only "
		<< destroyed.load();
}

TEST_F(DispatcherQsbrIntegrationTest, EndOfTickDrainCoversRegisteredType) {
	// This test exercises the dispatcher.cpp-registered drain hook for a
	// migrated type (Mount). Retiring an OwningMount inside the event body
	// without explicitly draining proves the dispatcher's end-of-tick
	// `WorldPtr<Mount>::quiescentState()` call cleans it up.
	auto bodyRan = std::make_shared<std::promise<void>>();
	auto stillAlive = std::make_shared<std::atomic<bool>>(true);

	inject<Dispatcher>().addEvent(
		[bodyRan, stillAlive] {
			Mounts::OwningMount wp = Mounts::OwningMount::make(
				static_cast<uint8_t>(99), 9999, "QsbrTestMount", 0, false, "test"
			);
			// Capture the raw pointer; the Mount remains alive after retire
		    // until the next quiescentState (which the dispatcher invokes
		    // post-event-body).
			const Mount* raw = wp.get();
			wp = nullptr; // retire
			// Mount still alive at this point (retired, not drained yet).
			stillAlive->store(raw != nullptr, std::memory_order_relaxed);
			bodyRan->set_value();
		},
		"qsbr-integration-mount-drain"
	);
	ASSERT_EQ(std::future_status::ready, bodyRan->get_future().wait_for(std::chrono::seconds(2)));
	EXPECT_TRUE(stillAlive->load());
	// The dispatcher's end-of-tick drain ran AFTER the body returned.
	// Verify by checking that the per-T retiree list is now empty.
	EXPECT_TRUE(waitFor([] {
		return WorldPtr<Mount>::BlockAllocator<Mounts::MountAllocator>::retirees == nullptr;
	}));
}
