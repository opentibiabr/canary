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

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <charconv>
	#include <cstddef>
	#include <string_view>
	#include <system_error>
#endif

namespace protocol_port_utils {
	[[nodiscard]] inline uint32_t legacyIpStringToNumber(std::string_view ip) {
		std::array<uint32_t, 4> octets {};
		size_t offset = 0;
		for (size_t index = 0; index < octets.size(); ++index) {
			const size_t end = index + 1 == octets.size() ? ip.size() : ip.find('.', offset);
			if (end == std::string_view::npos || end == offset) {
				return 0;
			}

			const auto part = ip.substr(offset, end - offset);
			const auto [ptr, ec] = std::from_chars(part.data(), part.data() + part.size(), octets[index]);
			if (ec != std::errc {} || ptr != part.data() + part.size() || octets[index] > 255) {
				return 0;
			}

			offset = end + 1;
		}

		return octets[0] | (octets[1] << 8) | (octets[2] << 16) | (octets[3] << 24);
	}

	[[nodiscard]] inline uint16_t getModernGamePort() {
		return static_cast<uint16_t>(g_configManager().getNumber(GAME_PORT));
	}

	[[nodiscard]] inline uint16_t getWebSocketGamePort() {
		return static_cast<uint16_t>(g_configManager().getNumber(WEBSOCKET_PORT));
	}

	[[nodiscard]] inline uint16_t getNextAvailableLegacyGamePort(
		uint32_t preferredPort,
		uint16_t reservedLegacyPort = 0
	) {
		const auto modernGamePort = getModernGamePort();
		const auto webSocketGamePort = getWebSocketGamePort();
		const auto loginPort = static_cast<uint16_t>(g_configManager().getNumber(LOGIN_PORT));
		const auto statusPort = static_cast<uint16_t>(g_configManager().getNumber(STATUS_PORT));

		for (uint32_t port = preferredPort; port <= 65535; ++port) {
			const auto candidate = static_cast<uint16_t>(port);
			if (candidate != modernGamePort && candidate != webSocketGamePort && candidate != loginPort
			    && candidate != statusPort && candidate != reservedLegacyPort) {
				return candidate;
			}
		}

		return static_cast<uint16_t>(preferredPort <= 65535 ? preferredPort : 65535);
	}

	[[nodiscard]] inline uint16_t getLegacy1100GamePort() {
		const auto configuredPort = g_configManager().getNumber(LEGACY_1100_GAME_PORT);
		if (configuredPort > 0) {
			return static_cast<uint16_t>(configuredPort);
		}

		return getNextAvailableLegacyGamePort(static_cast<uint32_t>(getModernGamePort()) + 1);
	}

	[[nodiscard]] inline uint16_t getLegacy860GamePort() {
		const auto configuredPort = g_configManager().getNumber(LEGACY_860_GAME_PORT);
		if (configuredPort > 0) {
			return static_cast<uint16_t>(configuredPort);
		}

		return getNextAvailableLegacyGamePort(
			static_cast<uint32_t>(getModernGamePort()) + 2,
			getLegacy1100GamePort()
		);
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
