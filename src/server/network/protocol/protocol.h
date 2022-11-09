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

#ifndef SRC_SERVER_NETWORK_PROTOCOL_PROTOCOL_H_
#define SRC_SERVER_NETWORK_PROTOCOL_PROTOCOL_H_

#include "server/network/connection/connection.h"
#include "config/configmanager.h"

class Protocol : public std::enable_shared_from_this<Protocol>
{
	public:
		explicit Protocol(Connection_ptr initConnection) : connectionPtr(initConnection) {}
		virtual ~Protocol();

		// non-copyable
		Protocol(const Protocol&) = delete;
		Protocol& operator=(const Protocol&) = delete;

		virtual void parsePacket(NetworkMessage&) {}

		virtual void onSendMessage(const OutputMessage_ptr& msg);
		bool onRecvMessage(NetworkMessage& msg);
		bool sendRecvMessageCallback(NetworkMessage& msg);
		virtual void onRecvFirstMessage(NetworkMessage& msg) = 0;
		virtual void onConnect() {}

		bool isConnectionExpired() const {
			return connectionPtr.expired();
		}

		Connection_ptr getConnection() const {
			return connectionPtr.lock();
		}

		uint32_t getIP() const;

		//Use this function for autosend messages only
		OutputMessage_ptr getOutputBuffer(int32_t size);

		OutputMessage_ptr& getCurrentBuffer() {
			return outputBuffer;
		}

		void send(OutputMessage_ptr msg) const {
			if (auto connection = getConnection();
			connection != nullptr) {
				connection->send(msg);
			}
		}

	protected:
		void disconnect() const {
			if (auto connection = getConnection();
			connection != nullptr) {
				connection->close();
			}
		}
		void enableXTEAEncryption() {
			encryptionEnabled = true;
		}
		void setXTEAKey(const uint32_t* newKey) {
			memcpy(this->key.data(), newKey, sizeof(*newKey) * 4);
		}
		void setChecksumMethod(ChecksumMethods_t method) {
			checksumMethod = method;
		}
		void enableCompression();

		static bool RSA_decrypt(NetworkMessage& msg);

		void setRawMessages(bool value) {
			rawMessages = value;
		}

		virtual void release() {}

	private:
		void XTEA_encrypt(OutputMessage& msg) const;
		bool XTEA_decrypt(NetworkMessage& msg) const;
		bool compression(OutputMessage& msg) const;


		OutputMessage_ptr outputBuffer;
		std::unique_ptr<z_stream> defStream;

		const ConnectionWeak_ptr connectionPtr;
		std::array<uint32_t, 4> key = {};
		uint32_t serverSequenceNumber = 0;
		uint32_t clientSequenceNumber = 0;
		std::underlying_type_t<ChecksumMethods_t> checksumMethod = CHECKSUM_METHOD_NONE;
		bool encryptionEnabled = false;
		bool rawMessages = false;
		bool compreesionEnabled = false;

		friend class Connection;
};

#endif  // SRC_SERVER_NETWORK_PROTOCOL_PROTOCOL_H_
