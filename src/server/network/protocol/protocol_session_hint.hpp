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

#ifndef USE_PRECOMPILED_HEADERS
	#include <chrono>
	#include <cstdint>
	#include <mutex>
	#include <optional>
	#include <string>
	#include <unordered_set>
	#include <vector>
#endif

using ProtocolSessionHintId = uint64_t;

struct ProtocolSessionHintLease {
	uint64_t leaseId = 0;
	uint32_t remoteIp = 0;
	InitialConnectionBehavior behavior {};
	std::vector<ProtocolSessionHintId> candidateIds;
	std::chrono::steady_clock::time_point expiresAt {};

	[[nodiscard]] explicit operator bool() const {
		return leaseId != 0 && !candidateIds.empty();
	}
};

class ProtocolSessionHintStore {
public:
	static ProtocolSessionHintStore &getInstance();

	void registerHint(
		uint32_t remoteIp,
		ProtocolProfileId profileId,
		const std::string &accountSession,
		const std::vector<std::string> &characterNames
	);

	[[nodiscard]] std::optional<ProtocolSessionHintLease> claimByIp(uint32_t remoteIp, std::optional<InitialConnectionBehavior> requiredBehavior = std::nullopt);
	[[nodiscard]] bool consumeIfMatches(
		const ProtocolSessionHintLease &lease,
		const std::string &accountSession,
		const std::string &characterName,
		uint16_t clientVersion
	);
	[[nodiscard]] std::optional<ProtocolProfileId> consumeAndResolveProfile(
		const ProtocolSessionHintLease &lease,
		const std::string &accountSession,
		const std::string &characterName,
		uint16_t clientVersion
	);
	void clearReusableHintsByIp(uint32_t remoteIp, std::optional<InitialConnectionBehavior> requiredBehavior = std::nullopt);

private:
	struct Hint {
		ProtocolSessionHintId id = 0;
		uint32_t remoteIp = 0;
		ProtocolProfileId profileId = ProtocolProfileId::Current;
		InitialConnectionBehavior behavior {};
		std::string accountSessionHash;
		std::unordered_set<std::string> allowedCharacterNames;
		std::chrono::steady_clock::time_point expiresAt {};
		bool reusable = false;
	};

	void cleanupExpired(std::chrono::steady_clock::time_point now);
	[[nodiscard]] static std::string hashSession(const std::string &accountSession);

	std::mutex mutex;
	std::vector<Hint> hints;
	ProtocolSessionHintId nextHintId = 1;
	uint64_t nextLeaseId = 1;
};
