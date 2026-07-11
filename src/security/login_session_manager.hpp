/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/protocol/protocol_profile.hpp"

#include <mbedtls/ctr_drbg.h>
#include <mbedtls/entropy.h>

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <chrono>
	#include <cstdint>
	#include <mutex>
	#include <optional>
	#include <string>
	#include <unordered_set>
	#include <vector>
#endif

/**
 * @brief Parameters binding a freshly issued login session token to the
 * account and character set that were actually authenticated on the login
 * connection.
 *
 * The character isn't known yet at issuance time (the client picks it after
 * seeing the character list), so the token is bound to the full set of
 * character names the account is allowed to select from; consumeToken()
 * requires an exact match against that set.
 */
struct LoginSessionIssueParams {
	uint32_t accountId = 0;
	std::vector<std::string> allowedCharacterNames;
	ProtocolProfileId protocolProfile = ProtocolProfileId::Current;
};

struct LoginSessionConsumeResult {
	bool ok = false;
	uint32_t accountId = 0;
};

/**
 * @brief Issues and redeems short-lived, single-use login session tokens.
 *
 * A token is a 256-bit value generated with an mbedTLS CTR-DRBG CSPRNG.
 * Only its SHA-256 hash is ever kept in memory - the raw value is returned
 * once, at issuance, for the caller to hand to the client. Redemption is
 * single-use: the matching entry is removed before its fields are even
 * inspected, so two concurrent redemption attempts for the same token can
 * never both succeed, and a wrong character name still burns the token
 * (an attacker who intercepts a token in flight only ever gets one guess).
 *
 * This class intentionally does not depend on any global/singleton state
 * beyond its own members, so tests (and callers) can construct isolated
 * instances; getInstance() is provided only as the production-wiring
 * convenience accessor used by the rest of the server.
 */
class LoginSessionManager {
public:
	static constexpr std::chrono::seconds DefaultTtl { 60 };
	static constexpr std::size_t DefaultMaxActiveTokens = 4096;

	explicit LoginSessionManager(std::chrono::seconds ttl = DefaultTtl, std::size_t maxActiveTokens = DefaultMaxActiveTokens);
	~LoginSessionManager();

	LoginSessionManager(const LoginSessionManager &) = delete;
	LoginSessionManager &operator=(const LoginSessionManager &) = delete;

	static LoginSessionManager &getInstance();

	/**
	 * @brief Generates and stores a new token bound to the given account,
	 * character set and protocol profile.
	 * @return The raw token (hex-encoded, wire-safe) to send to the client,
	 * or std::nullopt if the parameters are invalid or randomness generation
	 * failed.
	 */
	[[nodiscard]] std::optional<std::string> issueToken(const LoginSessionIssueParams &params);

	/**
	 * @brief Redeems a token exactly once. Regardless of outcome, a token
	 * matched by hash is removed from the store before this call returns.
	 */
	[[nodiscard]] LoginSessionConsumeResult consumeToken(const std::string &token, const std::string &characterName, ProtocolProfileId protocolProfile);

	[[nodiscard]] std::size_t activeTokenCount() const;

private:
	struct Entry {
		std::array<std::byte, 32> tokenHash {};
		uint32_t accountId = 0;
		std::unordered_set<std::string> allowedCharacterNames;
		ProtocolProfileId protocolProfile = ProtocolProfileId::Current;
		std::chrono::steady_clock::time_point expiresAt {};
	};

	void cleanupExpiredLocked(std::chrono::steady_clock::time_point now) const;
	[[nodiscard]] std::array<std::byte, 32> hashToken(const std::string &token) const;
	[[nodiscard]] bool randomBytes(unsigned char* buffer, std::size_t length);

	const std::chrono::seconds ttl;
	const std::size_t maxActiveTokens;

	mutable std::mutex mutex;
	mutable std::vector<Entry> entries;
	mbedtls_entropy_context entropy {};
	mbedtls_ctr_drbg_context ctrDrbg {};
};
