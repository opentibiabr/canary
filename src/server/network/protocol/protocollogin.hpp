/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/protocol/protocol.hpp"

class NetworkMessage;
class OutputMessage;

class ProtocolLogin : public Protocol {
public:
	// static protocol information
	enum { SERVER_SENDS_FIRST = false };
	enum { PROTOCOL_IDENTIFIER = 0x01 };
	enum { USE_CHECKSUM = true };
	static const char* protocol_name() {
		return "login protocol";
	}

	explicit ProtocolLogin(Connection_ptr loginConnection) :
		Protocol(loginConnection) { }

	void onRecvFirstMessage(NetworkMessage &msg);

private:
	void disconnectClient(const std::string &message);

	void getCharacterList(const std::string &accountDescriptor, const std::string &password);

	bool oldProtocol = false;
};
