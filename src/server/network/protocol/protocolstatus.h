/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLSTATUS_H_
#define SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLSTATUS_H_

#include "server/network/message/networkmessage.h"
#include "server/network/protocol/protocol.h"

class ProtocolStatus final : public Protocol
{
	public:
		// static protocol information
		enum {SERVER_SENDS_FIRST = false};
		enum {PROTOCOL_IDENTIFIER = 0xFF};
		enum {USE_CHECKSUM = false};
		static const char* protocol_name() {
			return "status protocol";
		}

		explicit ProtocolStatus(Connection_ptr conn) : Protocol(conn) {}

		void onRecvFirstMessage(NetworkMessage& msg) override;

		void sendStatusString();
		void sendInfo(uint16_t requestedInfo, const std::string& characterName);

		static const uint64_t start;

	private:
		static std::map<uint32_t, int64_t> ipConnectMap;
};

#endif  // SRC_SERVER_NETWORK_PROTOCOL_PROTOCOLSTATUS_H_
