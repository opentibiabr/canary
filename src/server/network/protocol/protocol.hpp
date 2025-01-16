/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/connection/connection.hpp"
#include "config/configmanager.hpp"

class Protocol : public std::enable_shared_from_this<Protocol> {
public:
	explicit Protocol(Connection_ptr initConnection) :
		connectionPtr(initConnection) { }

	virtual ~Protocol() = default;

	// non-copyable
	Protocol(const Protocol &) = delete;
	Protocol &operator=(const Protocol &) = delete;

	virtual void parsePacket(NetworkMessage &) { }

	virtual void onSendMessage(const OutputMessage_ptr &msg);
	bool onRecvMessage(NetworkMessage &msg);
	bool sendRecvMessageCallback(NetworkMessage &msg);
	virtual void onRecvFirstMessage(NetworkMessage &msg) = 0;
	virtual void onConnect() { }

	bool isConnectionExpired() const {
		return connectionPtr.expired();
	}

	Connection_ptr getConnection() const {
		return connectionPtr.lock();
	}

	uint32_t getIP() const;

	// Use this function for autosend messages only
	OutputMessage_ptr getOutputBuffer(int32_t size);

	OutputMessage_ptr &getCurrentBuffer() {
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
		if (auto connection = getConnection()) {
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

	static bool RSA_decrypt(NetworkMessage &msg);

	void setRawMessages(bool value) {
		rawMessages = value;
	}

	virtual void release() { }

private:
	struct ZStream {
		ZStream() noexcept {
			const int32_t compressionLevel = g_configManager().getNumber(COMPRESSION_LEVEL, __FUNCTION__);
			if (compressionLevel <= 0) {
				return;
			}

			stream = std::make_unique<z_stream>();
			stream->zalloc = nullptr;
			stream->zfree = nullptr;
			stream->opaque = nullptr;

			if (deflateInit2(stream.get(), compressionLevel, Z_DEFLATED, -15, 9, Z_DEFAULT_STRATEGY) != Z_OK) {
				stream.reset();
				g_logger().error("[Protocol::enableCompression()] - Zlib deflateInit2 error: {}", (stream->msg ? stream->msg : " unknown error"));
			}
		}

		~ZStream() {
			deflateEnd(stream.get());
		}

		std::unique_ptr<z_stream> stream;
		std::array<char, NETWORKMESSAGE_MAXSIZE> buffer {};
	};

	void XTEA_encrypt(OutputMessage &msg) const;
	bool XTEA_decrypt(NetworkMessage &msg) const;
	bool compression(OutputMessage &msg) const;

	OutputMessage_ptr outputBuffer;

	const ConnectionWeak_ptr connectionPtr;
	std::array<uint32_t, 4> key = {};
	uint32_t serverSequenceNumber = 0;
	uint32_t clientSequenceNumber = 0;
	std::underlying_type_t<ChecksumMethods_t> checksumMethod = CHECKSUM_METHOD_NONE;
	bool encryptionEnabled = false;
	bool rawMessages = false;

	friend class Connection;
};
