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
	#include <cstdint>
	#include <optional>
#endif

class NetworkMessage;
class OutputMessage;
class Protocol;

class TransportCodec {
public:
	explicit constexpr TransportCodec(const TransportProfile &initProfile) :
		profile(initProfile) { }

	[[nodiscard]] const TransportProfile &getProfile() const {
		return profile;
	}

	[[nodiscard]] std::optional<uint16_t> decodeBodySize(uint16_t rawLengthHeader) const;
	/**
	 * @brief Encodes an outbound message using the active transport framing.
	 *
	 * @details Outer length and encrypted payload layout come from the bound
	 * TransportProfile, but checksum/compression behavior is still finalized from
	 * the current Protocol state. This preserves the shipped login/game byte
	 * contracts while multiprotocol transport ownership is phased in.
	 */
	void encodeOutbound(Protocol &protocol, OutputMessage &msg) const;
	/**
	 * @brief Validates and unwraps an inbound message using the active transport framing.
	 *
	 * @details Inbound checksum handling still mirrors the current Protocol state
	 * instead of relying exclusively on TransportProfile metadata. The profile
	 * describes the intended contract, but Protocol remains part of the runtime
	 * authority for checksum/compression-sensitive paths.
	 */
	[[nodiscard]] bool prepareInbound(Protocol &protocol, NetworkMessage &msg) const;

private:
	[[nodiscard]] bool decryptXtea(Protocol &protocol, NetworkMessage &msg) const;
	void encryptXtea(Protocol &protocol, OutputMessage &msg) const;

	const TransportProfile &profile;
};

class TransportCodecs {
public:
	[[nodiscard]] static const TransportCodec &get(TransportProfileId id);
	[[nodiscard]] static const TransportCodec &rawClientFirst();
	[[nodiscard]] static const TransportCodec &currentModern();
	[[nodiscard]] static const TransportCodec &legacyRawWithLoginHeader();
	[[nodiscard]] static const TransportCodec &legacyClassic();
};
