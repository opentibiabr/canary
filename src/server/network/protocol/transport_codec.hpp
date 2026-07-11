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
	 * @brief Encodes an outbound message using the complete active transport contract.
	 *
	 * @details Framing, encrypted payload layout, checksum, sequence and compression
	 * are all selected by the bound TransportProfile. Protocol only owns per-session
	 * crypto keys and sequence counters.
	 */
	void encodeOutbound(Protocol &protocol, OutputMessage &msg) const;
	/**
	 * @brief Validates and unwraps an inbound message using the complete active transport contract.
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
	[[nodiscard]] static const TransportCodec &currentLogin();
	[[nodiscard]] static const TransportCodec &currentGameSequence();
	[[nodiscard]] static const TransportCodec &currentGamePlain();
	[[nodiscard]] static const TransportCodec &legacyRawWithLoginHeader();
	[[nodiscard]] static const TransportCodec &legacyClassic();
};
