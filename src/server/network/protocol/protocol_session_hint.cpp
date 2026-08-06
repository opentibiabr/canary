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
	constexpr auto reusableHintTtl = std::chrono::hours(24);
	constexpr size_t maxHints = 512;

	[[nodiscard]] bool shouldReuseHintAfterMatch(const ProtocolProfile &profile) {
		return !profile.initialBehavior.hasSameWireBehavior(ProtocolProfileRegistry::defaultModernInitialBehavior());
	}

	[[nodiscard]] std::chrono::steady_clock::time_point getHintExpiration(const ProtocolProfile &profile, std::chrono::steady_clock::time_point now) {
		return now + (shouldReuseHintAfterMatch(profile) ? reusableHintTtl : hintTtl);
	}
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
		[[maybe_unused]] auto nextHint = hints.erase(hints.begin());
	}

	Hint hint;
	hint.id = nextHintId++;
	hint.remoteIp = remoteIp;
	hint.profileId = profileId;
	hint.behavior = profile->initialBehavior;
	hint.accountSessionHash = hashSession(accountSession);
	hint.expiresAt = getHintExpiration(*profile, now);
	hint.reusable = shouldReuseHintAfterMatch(*profile);
	for (const auto &characterName : characterNames) {
		[[maybe_unused]] auto [_, inserted] = hint.allowedCharacterNames.insert(asLowerCaseString(characterName));
	}

	[[maybe_unused]] const auto erasedHints = std::erase_if(hints, [&hint](const Hint &existingHint) {
		if (existingHint.remoteIp != hint.remoteIp) {
			return false;
		}

		return std::ranges::any_of(hint.allowedCharacterNames, [&existingHint](const auto &characterName) {
			return existingHint.allowedCharacterNames.contains(characterName);
		});
	});

	[[maybe_unused]] auto &storedHint = hints.emplace_back(std::move(hint));
}

std::optional<ProtocolSessionHintLease> ProtocolSessionHintStore::claimByIp(uint32_t remoteIp, std::optional<InitialConnectionBehavior> requiredBehavior) {
	const auto now = std::chrono::steady_clock::now();
	std::scoped_lock lock(mutex);
	cleanupExpired(now);

	std::optional<InitialConnectionBehavior> behavior;
	std::vector<ProtocolSessionHintId> candidates;
	for (const auto &hint : hints) {
		if (hint.remoteIp != remoteIp) {
			continue;
		}
		if (requiredBehavior && !requiredBehavior->hasSameWireBehavior(hint.behavior)) {
			continue;
		}

		if (!behavior) {
			behavior = hint.behavior;
		} else if (!behavior->hasSameWireBehavior(hint.behavior)) {
			return std::nullopt;
		}

		candidates.push_back(hint.id);
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
	return consumeAndResolveProfile(lease, accountSession, characterName, clientVersion).has_value();
}

std::optional<ProtocolProfileId> ProtocolSessionHintStore::consumeAndResolveProfile(
	const ProtocolSessionHintLease &lease,
	const std::string &accountSession,
	const std::string &characterName,
	uint16_t clientVersion
) {
	if (!lease) {
		return std::nullopt;
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

		const auto profileId = it->profileId;
		if (it->reusable) {
			it->expiresAt = getHintExpiration(*profile, now);
		} else {
			[[maybe_unused]] auto nextHint = hints.erase(it);
		}
		return profileId;
	}

	return std::nullopt;
}

void ProtocolSessionHintStore::clearReusableHintsByIp(uint32_t remoteIp, std::optional<InitialConnectionBehavior> requiredBehavior) {
	const auto now = std::chrono::steady_clock::now();
	std::scoped_lock lock(mutex);
	cleanupExpired(now);

	[[maybe_unused]] const auto erasedHints = std::erase_if(hints, [remoteIp, &requiredBehavior](const Hint &hint) {
		if (hint.remoteIp != remoteIp || !hint.reusable) {
			return false;
		}

		return !requiredBehavior || requiredBehavior->hasSameWireBehavior(hint.behavior);
	});
}

void ProtocolSessionHintStore::cleanupExpired(std::chrono::steady_clock::time_point now) {
	[[maybe_unused]] const auto erasedHints = std::erase_if(hints, [now](const Hint &hint) {
		return hint.expiresAt <= now;
	});
}

std::string ProtocolSessionHintStore::hashSession(const std::string &accountSession) {
	return transformToSHA256(accountSession);
}
