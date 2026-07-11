/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "security/login_session_manager.hpp"

#include "utils/tools.hpp"

#include <mbedtls/sha256.h>

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <array>
	#include <cstddef>
#endif

namespace {
	constexpr std::array<unsigned char, 18> LoginSessionPersonalization = { 'c', 'a', 'n', 'a', 'r', 'y', '-', 'l', 'o', 'g', 'i', 'n', '-', 's', 'e', 's', 's', 'n' };
	constexpr std::size_t TokenBytes = 32;

	[[nodiscard]] std::string bytesToHex(const std::array<std::byte, TokenBytes> &bytes) {
		static constexpr char digits[] = "0123456789abcdef";
		std::string hex;
		hex.reserve(bytes.size() * 2);
		for (const auto byte : bytes) {
			const auto value = std::to_integer<uint8_t>(byte);
			hex.push_back(digits[value >> 4]);
			hex.push_back(digits[value & 0x0F]);
		}
		return hex;
	}

	// Deliberately branchless/constant-time: every byte is compared regardless
	// of earlier mismatches, so redemption timing can't leak how many leading
	// bytes of a guessed token happened to match the stored hash.
	[[nodiscard]] bool constantTimeEquals(const std::array<std::byte, TokenBytes> &a, const std::array<std::byte, TokenBytes> &b) {
		unsigned char diff = 0;
		for (std::size_t i = 0; i < a.size(); ++i) {
			diff = static_cast<unsigned char>(diff | (std::to_integer<uint8_t>(a[i]) ^ std::to_integer<uint8_t>(b[i])));
		}
		return diff == 0;
	}
}

LoginSessionManager::LoginSessionManager(std::chrono::seconds initTtl, std::size_t initMaxActiveTokens) :
	ttl(initTtl), maxActiveTokens(initMaxActiveTokens) {
	mbedtls_entropy_init(&entropy);
	mbedtls_ctr_drbg_init(&ctrDrbg);
	if (mbedtls_ctr_drbg_seed(&ctrDrbg, mbedtls_entropy_func, &entropy, LoginSessionPersonalization.data(), LoginSessionPersonalization.size()) != 0) {
		g_logger().error("[LoginSessionManager] failed to seed CSPRNG; token issuance will fail closed");
	}
}

LoginSessionManager::~LoginSessionManager() {
	mbedtls_ctr_drbg_free(&ctrDrbg);
	mbedtls_entropy_free(&entropy);
}

LoginSessionManager &LoginSessionManager::getInstance() {
	static LoginSessionManager manager;
	return manager;
}

bool LoginSessionManager::randomBytes(unsigned char* buffer, std::size_t length) {
	std::scoped_lock lock(mutex);
	return mbedtls_ctr_drbg_random(&ctrDrbg, buffer, length) == 0;
}

std::array<std::byte, 32> LoginSessionManager::hashToken(const std::string &token) const {
	std::array<std::byte, TokenBytes> hash {};
	mbedtls_sha256(reinterpret_cast<const unsigned char*>(token.data()), token.size(), reinterpret_cast<unsigned char*>(hash.data()), 0);
	return hash;
}

std::optional<std::string> LoginSessionManager::issueToken(const LoginSessionIssueParams &params) {
	if (params.accountId == 0 || params.allowedCharacterNames.empty()) {
		return std::nullopt;
	}

	std::array<std::byte, TokenBytes> rawTokenBytes {};
	if (!randomBytes(reinterpret_cast<unsigned char*>(rawTokenBytes.data()), rawTokenBytes.size())) {
		g_logger().error("[LoginSessionManager::issueToken] CSPRNG failure while issuing token for account [{}]", params.accountId);
		return std::nullopt;
	}

	const auto token = bytesToHex(rawTokenBytes);

	Entry entry;
	entry.tokenHash = hashToken(token);
	entry.accountId = params.accountId;
	entry.protocolProfile = params.protocolProfile;
	for (const auto &characterName : params.allowedCharacterNames) {
		entry.allowedCharacterNames.insert(asLowerCaseString(characterName));
	}

	const auto now = std::chrono::steady_clock::now();
	entry.expiresAt = now + ttl;

	std::scoped_lock lock(mutex);
	cleanupExpiredLocked(now);
	while (entries.size() >= maxActiveTokens) {
		entries.erase(entries.begin());
	}
	entries.emplace_back(std::move(entry));
	return token;
}

LoginSessionConsumeResult LoginSessionManager::consumeToken(const std::string &token, const std::string &characterName, ProtocolProfileId protocolProfile) {
	const auto presentedHash = hashToken(token);
	const auto normalizedCharacterName = asLowerCaseString(characterName);
	const auto now = std::chrono::steady_clock::now();

	std::scoped_lock lock(mutex);
	cleanupExpiredLocked(now);

	const auto it = std::ranges::find_if(entries, [&presentedHash](const Entry &entry) {
		return constantTimeEquals(entry.tokenHash, presentedHash);
	});
	if (it == entries.end()) {
		return {};
	}

	// Single-use, unconditionally: the entry is gone the instant it's matched,
	// before we even look at whether the character/profile check below passes.
	const Entry matched = std::move(*it);
	entries.erase(it);

	if (matched.protocolProfile != protocolProfile) {
		return {};
	}
	if (!matched.allowedCharacterNames.contains(normalizedCharacterName)) {
		return {};
	}

	return { .ok = true, .accountId = matched.accountId };
}

std::size_t LoginSessionManager::activeTokenCount() const {
	std::scoped_lock lock(mutex);
	cleanupExpiredLocked(std::chrono::steady_clock::now());
	return entries.size();
}

void LoginSessionManager::cleanupExpiredLocked(std::chrono::steady_clock::time_point now) const {
	std::erase_if(entries, [now](const Entry &entry) {
		return entry.expiresAt <= now;
	});
}
