/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

// This test validates the *contract* documented in
// docs/multichannel/ARCHITECTURE.md §8 and THREAT_MODEL.md T3/T4: a
// transaction_uuid primary key on `economic_ledger` (and
// `mail_delivery_audit`) means a retried operation re-inserts the same UUID
// and gets a duplicate-key error instead of a second effect.
//
// Deliberately not shipped as production code: the real enforcement is the
// SQL PRIMARY KEY itself (a single authoritative source of truth, per spec
// §2.5's "one authoritative representation" principle generalized to
// economy tables) - an in-memory idempotency cache would just be a second,
// non-durable, per-process source of truth competing with the DB, which is
// exactly the anti-pattern the spec warns against elsewhere. This model
// exists purely to pin down and test the *semantics* the DB constraint is
// expected to provide, independent of having a live database in this
// sandbox to prove it against directly.

#include <gtest/gtest.h>
#include <algorithm>
#include <atomic>
#include <mutex>
#include <string>
#include <thread>
#include <unordered_map>
#include <vector>

namespace {
	enum class LedgerOutcome {
		Applied, // first time this transaction_uuid was seen - effect happens once
		Replayed, // same transaction_uuid, same operation - effect must NOT happen again
		Conflict, // same transaction_uuid reused for a *different* operation - must never
		          // happen in practice, but if it does, this must be surfaced loudly,
		          // never silently accepted as a replay of the wrong thing.
	};

	// Minimal model of `INSERT INTO economic_ledger (transaction_uuid, ...)`
	// relying on transaction_uuid being a PRIMARY KEY: the first writer wins,
	// everyone else observes the existing row instead of re-applying effects.
	class LedgerModel {
	public:
		LedgerOutcome record(const std::string &transactionUuid, const std::string &operationType) {
			std::lock_guard lock(mutex);
			const auto it = entries.find(transactionUuid);
			if (it == entries.end()) {
				entries.emplace(transactionUuid, operationType);
				return LedgerOutcome::Applied;
			}
			if (it->second == operationType) {
				return LedgerOutcome::Replayed;
			}
			return LedgerOutcome::Conflict;
		}

		[[nodiscard]] std::size_t appliedCount() const {
			std::lock_guard lock(mutex);
			return entries.size();
		}

	private:
		mutable std::mutex mutex;
		std::unordered_map<std::string, std::string> entries;
	};
} // namespace

TEST(IdempotencyContractTest, FirstApplicationIsApplied) {
	LedgerModel ledger;
	EXPECT_EQ(LedgerOutcome::Applied, ledger.record("txn-1", "market.buy"));
}

TEST(IdempotencyContractTest, RetryWithSameUuidIsReplayedNotReapplied) {
	LedgerModel ledger;
	ASSERT_EQ(LedgerOutcome::Applied, ledger.record("txn-1", "market.buy"));
	EXPECT_EQ(LedgerOutcome::Replayed, ledger.record("txn-1", "market.buy"));
	EXPECT_EQ(LedgerOutcome::Replayed, ledger.record("txn-1", "market.buy"));
	EXPECT_EQ(1u, ledger.appliedCount());
}

TEST(IdempotencyContractTest, DifferentUuidsApplyIndependently) {
	LedgerModel ledger;
	EXPECT_EQ(LedgerOutcome::Applied, ledger.record("txn-1", "market.buy"));
	EXPECT_EQ(LedgerOutcome::Applied, ledger.record("txn-2", "market.buy"));
	EXPECT_EQ(2u, ledger.appliedCount());
}

TEST(IdempotencyContractTest, ReusingUuidForDifferentOperationIsAConflictNotASilentReplay) {
	LedgerModel ledger;
	ASSERT_EQ(LedgerOutcome::Applied, ledger.record("txn-1", "market.buy"));
	EXPECT_EQ(LedgerOutcome::Conflict, ledger.record("txn-1", "mail.deliver"));
}

TEST(IdempotencyContractTest, ConcurrentReplayOfSameUuidAppliesExactlyOnce) {
	LedgerModel ledger;
	constexpr int attempts = 32;
	std::vector<std::thread> threads;
	std::vector<LedgerOutcome> results(attempts);
	std::atomic<int> readyCount { 0 };
	std::atomic<bool> go { false };

	for (int i = 0; i < attempts; ++i) {
		threads.emplace_back([&, i] {
			readyCount.fetch_add(1);
			while (!go.load()) {
				std::this_thread::yield();
			}
			results[static_cast<std::size_t>(i)] = ledger.record("txn-shared", "mail.deliver");
		});
	}
	while (readyCount.load() < attempts) {
		std::this_thread::yield();
	}
	go.store(true);
	for (auto &thread : threads) {
		thread.join();
	}

	const auto appliedCount = std::ranges::count(results, LedgerOutcome::Applied);
	const auto replayedCount = std::ranges::count(results, LedgerOutcome::Replayed);

	EXPECT_EQ(1, appliedCount);
	EXPECT_EQ(attempts - 1, replayedCount);
	EXPECT_EQ(1u, ledger.appliedCount());
}
