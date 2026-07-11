/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/server_definitions.hpp"

class OutputMessage;
using OutputMessage_ptr = std::shared_ptr<OutputMessage>;
class Connection;
using Connection_ptr = std::shared_ptr<Connection>;
using ConnectionWeak_ptr = std::weak_ptr<Connection>;

class NetworkMessage;
enum class CompressionLayout : uint8_t;

class Protocol : public std::enable_shared_from_this<Protocol> {
public:
	explicit Protocol(const Connection_ptr &initConnection);

	virtual ~Protocol() = default;

	// non-copyable
	Protocol(const Protocol &) = delete;
	Protocol &operator=(const Protocol &) = delete;

	virtual void parsePacket(NetworkMessage &) { }

	virtual void onSendMessage(const OutputMessage_ptr &msg);
	bool onRecvMessage(NetworkMessage &msg);
	bool sendRecvMessageCallback(NetworkMessage &msg);
	virtual void onRecvFirstMessage(NetworkMessage &msg) = 0;
	virtual void onConnectionAccepted();
	virtual void sendLoginChallenge() { }

	bool isConnectionExpired() const;

	Connection_ptr getConnection() const;

	uint32_t getIP() const;

	// Use this function for autosend messages only
	OutputMessage_ptr getOutputBuffer(int32_t size);

	OutputMessage_ptr &getCurrentBuffer() {
		return outputBuffer;
	}

	void send(OutputMessage_ptr msg) const;

protected:
	void disconnect() const;

	void enableXTEAEncryption() {
		encryptionEnabled = true;
	}
	void setXTEAKey(const uint32_t* newKey) {
		if (std::memcpy(key.data(), newKey, sizeof(uint32_t) * key.size()) == nullptr) {
			g_logger().error("[{}] memcpy failed while setting XTEA key", __FUNCTION__);
			return;
		}
	}

	/** Selects a complete transport profile matching the negotiated checksum contract. */
	void setChecksumMethod(ChecksumMethods_t method);

	// Exposed to Protocol subclasses (in addition to the TransportCodec friend
	// declaration below) so test doubles can construct known-ciphertext fixtures
	// for transport framing regression tests.
	void XTEA_transform(uint8_t* buffer, size_t messageLength, bool encrypt) const;

	static bool RSA_decrypt(NetworkMessage &msg);

	void setRawMessages(bool value) {
		rawMessages = value;
	}

	virtual void release() { }

private:
	struct ZStream {
		ZStream() noexcept;

		~ZStream() {
			deflateEnd(stream.get());
		}

		std::unique_ptr<z_stream> stream;
		std::array<char, NETWORKMESSAGE_MAXSIZE> buffer {};
	};

	bool compression(OutputMessage &msg, CompressionLayout layout) const;

	OutputMessage_ptr outputBuffer;

	const ConnectionWeak_ptr connectionPtr;
	std::array<uint32_t, 4> key = {};
	uint32_t serverSequenceNumber = 0;
	uint32_t clientSequenceNumber = 0;
	bool encryptionEnabled = false;
	bool rawMessages = false;

	friend class Connection;
	friend class TransportCodec;
};
