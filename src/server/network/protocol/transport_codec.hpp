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
	void encodeOutbound(Protocol &protocol, OutputMessage &msg) const;
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
