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

	struct ActivePlayerStats {
		uint32_t online = 0; // capped at 4 connections per IP, idle players excluded
		uint32_t uniqueIps = 0; // number of distinct IPs contributing to "online"
	};

	// Computes the otservlist-compliant active player counts: drops players idle
	// for more than 15 minutes, caps each IP at 4 connections, and reports the
	// number of unique IPs. Both XML and binary protocols read the same numbers
	// so the two reporters never disagree (otservlist may flag servers whose
	// reporters publish different totals).
	static ActivePlayerStats getActivePlayerStats();

	static const uint64_t start;

	static std::string SERVER_NAME;
	static std::string SERVER_VERSION;
	static std::string SERVER_DEVELOPERS;

private:
	static std::map<uint32_t, int64_t> ipConnectMap;
};
