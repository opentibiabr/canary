/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/message/networkmessage.hpp"
#include "server/network/protocol/protocol.hpp"

class ProtocolStatus final : public Protocol {
public:
	// static protocol information
	enum { SERVER_SENDS_FIRST = false };
	enum { PROTOCOL_IDENTIFIER = 0xFF };
	enum { USE_CHECKSUM = false };
	static const char* protocol_name() {
		return "status protocol";
	}

	explicit ProtocolStatus(const Connection_ptr &conn) :
		Protocol(conn) { }

	void onRecvFirstMessage(NetworkMessage &msg) override;

	void sendStatusString();
	void sendInfo(uint16_t requestedInfo, const std::string &characterName) const;

	// Returns the player count filtered to at most 4 connections per IP. Both the XML
	// status protocol and the binary protocol use this so the two reporters do not
	// disagree (otservlist consumes the XML count and may flag servers if the binary
	// protocol reports a higher number).
	static uint32_t getIpFilteredPlayerCount();

	static const uint64_t start;

	static std::string SERVER_NAME;
	static std::string SERVER_VERSION;
	static std::string SERVER_DEVELOPERS;

private:
	static std::map<uint32_t, int64_t> ipConnectMap;
};
