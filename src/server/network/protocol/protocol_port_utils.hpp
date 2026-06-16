/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "config/configmanager.hpp"
#include "server/network/protocol/protocol_profile.hpp"

namespace protocol_port_utils {
	[[nodiscard]] inline uint16_t getModernGamePort() {
		return static_cast<uint16_t>(g_configManager().getNumber(GAME_PORT));
	}

	[[nodiscard]] inline uint16_t getLegacy1100GamePort() {
		const auto configuredPort = g_configManager().getNumber(LEGACY_1100_GAME_PORT);
		return static_cast<uint16_t>(configuredPort > 0 ? configuredPort : getModernGamePort() + 1);
	}

	[[nodiscard]] inline uint16_t getLegacy860GamePort() {
		const auto configuredPort = g_configManager().getNumber(LEGACY_860_GAME_PORT);
		return static_cast<uint16_t>(configuredPort > 0 ? configuredPort : getModernGamePort() + 2);
	}

	[[nodiscard]] inline uint16_t getGamePortForProfile(const ProtocolProfile &profile) {
		switch (profile.id) {
			case ProtocolProfileId::Tibia1100:
				return getLegacy1100GamePort();
			case ProtocolProfileId::Cipsoft860Vanilla:
			case ProtocolProfileId::Cipsoft860ExtendedAssets:
			case ProtocolProfileId::Cipsoft860CanaryExtended:
			case ProtocolProfileId::OTCv8Extended860:
				return getLegacy860GamePort();
			case ProtocolProfileId::Current:
			default:
				return getModernGamePort();
		}
	}
}
