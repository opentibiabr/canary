/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/protocol/protocol.hpp"

class ProtocolStatus final : public Protocol {
public:
	// static protocol information
	static constexpr bool SERVER_SENDS_FIRST = false;
	static constexpr uint8_t PROTOCOL_IDENTIFIER = 0xFF;
	static constexpr bool USE_CHECKSUM = false;
	static constexpr const char* protocol_name() noexcept {
		return "status protocol";
	}

	explicit ProtocolStatus(const Connection_ptr &conn) noexcept :
		Protocol(conn) { }

	void onRecvFirstMessage(NetworkMessage &msg) noexcept override;

	void sendStatusString();
	void sendStatusStringJson();
	void sendInfo(uint16_t requestedInfo, const std::string &characterName) const;

	static inline const auto start = std::chrono::steady_clock::now();
	static inline const std::string SERVER_NAME = "Canary";
	static inline const std::string SERVER_VERSION = "3.0";
	static inline const std::string SERVER_DEVELOPERS = "OpenTibiaBR Organization";

private:
	static inline phmap::flat_hash_map<uint32_t, std::chrono::steady_clock::time_point> ipConnectMap {};
};
