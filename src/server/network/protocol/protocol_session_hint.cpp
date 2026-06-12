/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocol_session_hint.hpp"

#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

namespace {
	constexpr auto hintTtl = std::chrono::seconds(30);
	constexpr size_t maxHints = 512;
}

ProtocolSessionHintStore &ProtocolSessionHintStore::getInstance() {
	static ProtocolSessionHintStore store;
	return store;
}

void ProtocolSessionHintStore::registerHint(
	uint32_t remoteIp,
	ProtocolProfileId profileId,
	const std::string &accountSession,
	const std::vector<std::string> &characterNames
) {
	const auto* profile = ProtocolProfileRegistry::getProfile(profileId);
	if (!profile || !ProtocolProfileRegistry::isProfileAllowed(profileId)) {
		return;
	}

	const auto now = std::chrono::steady_clock::now();
	std::scoped_lock lock(mutex);
	cleanupExpired(now);

	if (hints.size() >= maxHints) {
		hints.erase(hints.begin());
	}

	Hint hint;
	hint.id = nextHintId++;
	hint.remoteIp = remoteIp;
	hint.profileId = profileId;
	hint.behavior = profile->initialBehavior;
	hint.accountSessionHash = hashSession(accountSession);
	hint.expiresAt = now + hintTtl;
	for (const auto &characterName : characterNames) {
		hint.allowedCharacterNames.insert(asLowerCaseString(characterName));
	}

	std::erase_if(hints, [&hint](const Hint &existingHint) {
		if (existingHint.remoteIp != hint.remoteIp) {
			return false;
		}

		for (const auto &characterName : hint.allowedCharacterNames) {
			if (existingHint.allowedCharacterNames.contains(characterName)) {
				return true;
			}
		}

		return false;
	});

	hints.emplace_back(std::move(hint));
}

std::optional<ProtocolSessionHintLease> ProtocolSessionHintStore::claimByIp(uint32_t remoteIp) {
	const auto now = std::chrono::steady_clock::now();
	std::scoped_lock lock(mutex);
	cleanupExpired(now);

	std::optional<InitialConnectionBehavior> behavior;
	std::vector<ProtocolSessionHintId> candidates;
	for (const auto &hint : hints) {
		if (hint.remoteIp != remoteIp) {
			continue;
		}

		if (!behavior) {
			behavior = hint.behavior;
		} else if (!behavior->hasSameWireBehavior(hint.behavior)) {
			return std::nullopt;
		}

		candidates.emplace_back(hint.id);
	}

	if (!behavior || candidates.empty()) {
		return std::nullopt;
	}

	ProtocolSessionHintLease lease;
	lease.leaseId = nextLeaseId++;
	lease.remoteIp = remoteIp;
	lease.behavior = *behavior;
	lease.candidateIds = std::move(candidates);
	lease.expiresAt = now + hintTtl;
	return lease;
}

bool ProtocolSessionHintStore::consumeIfMatches(
	const ProtocolSessionHintLease &lease,
	const std::string &accountSession,
	const std::string &characterName,
	uint16_t clientVersion
) {
	if (!lease) {
		return false;
	}

	const auto now = std::chrono::steady_clock::now();
	std::scoped_lock lock(mutex);
	cleanupExpired(now);

	const auto accountSessionHash = hashSession(accountSession);
	const auto normalizedCharacterName = asLowerCaseString(characterName);
	for (const auto hintId : lease.candidateIds) {
		const auto it = std::ranges::find_if(hints, [hintId](const Hint &hint) {
			return hint.id == hintId;
		});
		if (it == hints.end()) {
			continue;
		}

		const auto* profile = ProtocolProfileRegistry::getProfile(it->profileId);
		if (!profile || profile->clientVersion != clientVersion) {
			continue;
		}

		if (it->accountSessionHash != accountSessionHash) {
			continue;
		}

		if (!it->allowedCharacterNames.contains(normalizedCharacterName)) {
			continue;
		}

		hints.erase(it);
		return true;
	}

	return false;
}

void ProtocolSessionHintStore::cleanupExpired(std::chrono::steady_clock::time_point now) {
	std::erase_if(hints, [now](const Hint &hint) {
		return hint.expiresAt <= now;
	});
}

std::string ProtocolSessionHintStore::hashSession(const std::string &accountSession) {
	return transformToSHA256(accountSession);
}
