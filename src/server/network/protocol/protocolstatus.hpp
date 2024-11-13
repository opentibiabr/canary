/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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

	static const uint64_t start;

	static std::string SERVER_NAME;
	static std::string SERVER_VERSION;
	static std::string SERVER_DEVELOPERS;

private:
	static std::map<uint32_t, int64_t> ipConnectMap;
};
