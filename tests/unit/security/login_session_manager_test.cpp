/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/login_session_manager.hpp"

#include <gtest/gtest.h>

#ifndef USE_PRECOMPILED_HEADERS
	#include <atomic>
	#include <thread>
	#include <unordered_set>
	#include <vector>
#endif

namespace {
	LoginSessionIssueParams makeParams(uint32_t accountId = 1, std::vector<std::string> characters = { "Knight" }, ProtocolProfileId profile = ProtocolProfileId::Current) {
		LoginSessionIssueParams params;
		params.accountId = accountId;
		params.allowedCharacterNames = std::move(characters);
		params.protocolProfile = profile;
		return params;
	}
}

TEST(LoginSessionManagerTest, ValidTokenIsConsumedSuccessfully) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams());
	ASSERT_TRUE(token.has_value());

	const auto result = manager.consumeToken(*token, "Knight", ProtocolProfileId::Current);
	EXPECT_TRUE(result.ok);
	EXPECT_EQ(1u, result.accountId);
}

TEST(LoginSessionManagerTest, SecondUseOfSameTokenFails) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams());
	ASSERT_TRUE(token.has_value());

	ASSERT_TRUE(manager.consumeToken(*token, "Knight", ProtocolProfileId::Current).ok);
	const auto replay = manager.consumeToken(*token, "Knight", ProtocolProfileId::Current);
	EXPECT_FALSE(replay.ok);
	EXPECT_EQ(0u, replay.accountId);
}

TEST(LoginSessionManagerTest, ExpiredTokenIsRejected) {
	LoginSessionManager manager(std::chrono::seconds(0));
	const auto token = manager.issueToken(makeParams());
	ASSERT_TRUE(token.has_value());

	std::this_thread::sleep_for(std::chrono::milliseconds(5));

	const auto result = manager.consumeToken(*token, "Knight", ProtocolProfileId::Current);
	EXPECT_FALSE(result.ok);
}

TEST(LoginSessionManagerTest, InvalidAccountIsRejectedAtIssuance) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams(/*accountId=*/0));
	EXPECT_FALSE(token.has_value());
}

TEST(LoginSessionManagerTest, InvalidCharacterNameIsRejectedAndStillBurnsToken) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams(1, { "Knight", "Druid" }));
	ASSERT_TRUE(token.has_value());

	const auto wrongCharacter = manager.consumeToken(*token, "Sorcerer", ProtocolProfileId::Current);
	EXPECT_FALSE(wrongCharacter.ok);

	// A wrong character name must burn the token just like a successful redeem -
	// otherwise an attacker who stole the token in flight could keep guessing names.
	const auto retryWithCorrectName = manager.consumeToken(*token, "Knight", ProtocolProfileId::Current);
	EXPECT_FALSE(retryWithCorrectName.ok);
}

TEST(LoginSessionManagerTest, InvalidProtocolProfileIsRejected) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams(1, { "Knight" }, ProtocolProfileId::Current));
	ASSERT_TRUE(token.has_value());

	const auto result = manager.consumeToken(*token, "Knight", ProtocolProfileId::Tibia1100);
	EXPECT_FALSE(result.ok);
}

TEST(LoginSessionManagerTest, OldestEntriesAreEvictedOnceLimitIsExceeded) {
	constexpr std::size_t limit = 4;
	LoginSessionManager manager(LoginSessionManager::DefaultTtl, limit);

	std::vector<std::string> tokens;
	for (std::size_t i = 0; i < limit + 2; ++i) {
		auto token = manager.issueToken(makeParams(static_cast<uint32_t>(i + 1)));
		ASSERT_TRUE(token.has_value());
		tokens.push_back(*token);
	}

	EXPECT_EQ(limit, manager.activeTokenCount());

	// The two oldest tokens must have been evicted to make room.
	EXPECT_FALSE(manager.consumeToken(tokens[0], "Knight", ProtocolProfileId::Current).ok);
	EXPECT_FALSE(manager.consumeToken(tokens[1], "Knight", ProtocolProfileId::Current).ok);

	// The newest token issued must still be redeemable.
	const auto newest = manager.consumeToken(tokens.back(), "Knight", ProtocolProfileId::Current);
	EXPECT_TRUE(newest.ok);
}

TEST(LoginSessionManagerTest, IssuedTokensAreUniqueNoCollisionOrDuplication) {
	LoginSessionManager manager(LoginSessionManager::DefaultTtl, 1024);

	std::unordered_set<std::string> seen;
	for (int i = 0; i < 256; ++i) {
		auto token = manager.issueToken(makeParams(static_cast<uint32_t>(i + 1)));
		ASSERT_TRUE(token.has_value());
		EXPECT_TRUE(seen.insert(*token).second) << "duplicate token generated";
	}
}

TEST(LoginSessionManagerTest, ConcurrentRedemptionOfSameTokenSucceedsExactlyOnce) {
	LoginSessionManager manager;
	const auto token = manager.issueToken(makeParams());
	ASSERT_TRUE(token.has_value());

	constexpr int attempts = 16;
	std::atomic<int> successCount { 0 };
	std::vector<std::thread> threads;
	threads.reserve(attempts);
	for (int i = 0; i < attempts; ++i) {
		threads.emplace_back([&manager, &token, &successCount] {
			if (manager.consumeToken(*token, "Knight", ProtocolProfileId::Current).ok) {
				++successCount;
			}
		});
	}
	for (auto &thread : threads) {
		thread.join();
	}

	EXPECT_EQ(1, successCount.load());
}
