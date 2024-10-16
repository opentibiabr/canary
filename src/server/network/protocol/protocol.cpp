/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocol.hpp"

#include "config/configmanager.hpp"
#include "server/network/connection/connection.hpp"
#include "server/network/message/outputmessage.hpp"
#include "security/rsa.hpp"
#include "game/scheduling/dispatcher.hpp"

Protocol::Protocol(const Connection_ptr &initConnection) :
	connectionPtr(initConnection) { }

void Protocol::onSendMessage(const OutputMessage_ptr &msg) {
	if (!rawMessages) {
		const uint32_t sendMessageChecksum = msg->getLength() >= 128 && compression(*msg) ? (1U << 31) : 0;

		msg->writeMessageLength();

		if (!encryptionEnabled) {
			return;
		}

		XTEA_encrypt(*msg);
		if (checksumMethod == CHECKSUM_METHOD_NONE) {
			msg->addCryptoHeader(false, 0);
		} else if (checksumMethod == CHECKSUM_METHOD_ADLER32) {
			msg->addCryptoHeader(true, adlerChecksum(msg->getOutputBuffer(), msg->getLength()));
		} else if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			msg->addCryptoHeader(true, sendMessageChecksum | (++serverSequenceNumber));
			if (serverSequenceNumber >= 0x7FFFFFFF) {
				serverSequenceNumber = 0;
			}
		}
	}
}

bool Protocol::sendRecvMessageCallback(NetworkMessage &msg) {
	if (encryptionEnabled && !XTEA_decrypt(msg)) {
		g_logger().error("[Protocol::onRecvMessage] - XTEA_decrypt Failed");
		return false;
	}

	g_dispatcher().addEvent(
		[&msg, protocolWeak = std::weak_ptr<Protocol>(shared_from_this())]() {
			if (const auto &protocol = protocolWeak.lock()) {
				if (const auto &protocolConnection = protocol->getConnection()) {
					protocol->parsePacket(msg);
					protocolConnection->resumeWork();
				}
			}
		},
		__FUNCTION__
	);

	return true;
}

bool Protocol::onRecvMessage(NetworkMessage &msg) {
	if (checksumMethod != CHECKSUM_METHOD_NONE) {
		const auto recvChecksum = msg.get<uint32_t>();
		if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			if (recvChecksum == 0) {
				// checksum 0 indicate that the packet should be connection ping - 0x1C packet header
				// since we don't need that packet skip it
				return false;
			}

			const uint32_t checksum = ++clientSequenceNumber;
			if (clientSequenceNumber >= 0x7FFFFFFF) {
				clientSequenceNumber = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		} else {
			uint32_t checksum;
			if (const int32_t len = msg.getLength() - msg.getBufferPosition();
			    len > 0) {
				checksum = adlerChecksum(msg.getBuffer() + msg.getBufferPosition(), len);
			} else {
				checksum = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		}
	}

	return sendRecvMessageCallback(msg);
}

OutputMessage_ptr Protocol::getOutputBuffer(int32_t size) {
	// dispatcher thread
	if (!outputBuffer) {
		outputBuffer = OutputMessagePool::getOutputMessage();
	} else if ((outputBuffer->getLength() + size) > MAX_PROTOCOL_BODY_LENGTH) {
		send(outputBuffer);
		outputBuffer = OutputMessagePool::getOutputMessage();
	}
	return outputBuffer;
}

void Protocol::send(OutputMessage_ptr msg) const {
	if (auto connection = getConnection()) {
		connection->send(msg);
	}
}

void Protocol::disconnect() const {
	if (const auto connection = getConnection()) {
		connection->close();
	}
}

void Protocol::XTEA_encrypt(OutputMessage &outputMessage) const {
	const uint32_t delta = 0x61C88647;

	// The message must be a multiple of 8
	size_t paddingBytes = outputMessage.getLength() & 7;
	if (paddingBytes != 0) {
		outputMessage.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = outputMessage.getOutputBuffer();
	auto messageLength = static_cast<int32_t>(outputMessage.getLength());
	int32_t readPos = 0;
	const std::array<uint32_t, 4> newKey = { key[0], key[1], key[2], key[3] };
	// TODO: refactor this for not use c-style
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + newKey[sum & 3]);
		sum -= delta;
		precachedControlSum[i][1] = (sum + newKey[(sum >> 11) & 3]);
	}
	while (readPos < messageLength) {
		std::array<uint32_t, 2> vData = {};
		memcpy(vData.data(), buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[0] += ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][0];
			vData[1] += ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData.data(), 8);
		readPos += 8;
	}
}

bool Protocol::XTEA_decrypt(NetworkMessage &msg) const {
	uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength & 7) != 0) {
		return false;
	}

	const uint32_t delta = 0x61C88647;

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	auto messageLength = static_cast<int32_t>(msgLength);
	int32_t readPos = 0;
	const std::array<uint32_t, 4> newKey = { key[0], key[1], key[2], key[3] };
	// TODO: refactor this for not use c-style
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0xC6EF3720;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + newKey[(sum >> 11) & 3]);
		sum += delta;
		precachedControlSum[i][1] = (sum + newKey[sum & 3]);
	}
	while (readPos < messageLength) {
		std::array<uint32_t, 2> vData = {};
		memcpy(vData.data(), buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[1] -= ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][0];
			vData[0] -= ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData.data(), 8);
		readPos += 8;
	}

	uint16_t innerLength = msg.get<uint16_t>();
	if (std::cmp_greater(innerLength, msgLength - 2)) {
		return false;
	}

	msg.setLength(innerLength);
	return true;
}

inline void Protocol::precacheControlSumsEncrypt() const {
	if (cacheEncryptInitialized) {
		return; // Cache já está pronto para criptografia
	}

	constexpr uint32_t delta = 0x61C88647;
	uint32_t sum = 0;

	for (int32_t i = 0; i < 32; ++i) {
		cachedControlSumsEncrypt[i * 2] = sum + key[sum & 3];
		sum -= delta;
		cachedControlSumsEncrypt[i * 2 + 1] = sum + key[(sum >> 11) & 3];
	}

	cacheEncryptInitialized = true;
}

inline void Protocol::precacheControlSumsDecrypt() const {
	if (cacheDecryptInitialized) {
		return;
	}

	constexpr uint32_t delta = 0x61C88647;
	uint32_t sum = 0xC6EF3720;

	for (int32_t i = 0; i < 32; ++i) {
		cachedControlSumsDecrypt[i * 2] = sum + key[(sum >> 11) & 3];
		sum += delta;
		cachedControlSumsDecrypt[i * 2 + 1] = sum + key[sum & 3];
	}

	cacheDecryptInitialized = true;
}

bool Protocol::RSA_decrypt(NetworkMessage &msg) {
	if ((msg.getLength() - msg.getBufferPosition()) < 128) {
		return false;
	}

	const auto charData = static_cast<char*>(static_cast<void*>(msg.getBuffer()));
	// Does not break strict aliasing
	g_RSA().decrypt(charData + msg.getBufferPosition());
	return (msg.getByte() == 0);
}

bool Protocol::isConnectionExpired() const {
	return connectionPtr.expired();
}

Connection_ptr Protocol::getConnection() const {
	return connectionPtr.lock();
}

uint32_t Protocol::getIP() const {
	if (const auto protocolConnection = getConnection()) {
		return protocolConnection->getIP();
	}

	return 0;
}

bool Protocol::compression(OutputMessage &outputMessage) const {
	if (checksumMethod != CHECKSUM_METHOD_SEQUENCE) {
		return false;
	}

	static thread_local auto compress_ptr = std::make_unique<ZStream>();
	static const auto &compress = compress_ptr;

	if (!compress->stream) {
		return false;
	}

	const auto outputMessageSize = outputMessage.getLength();
	if (outputMessageSize > NETWORKMESSAGE_MAXSIZE) {
		g_logger().error("[NetworkMessage::compression] - Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, outputMessageSize);
		return false;
	}

	compress->stream->next_in = outputMessage.getOutputBuffer();
	compress->stream->avail_in = outputMessageSize;
	compress->stream->next_out = reinterpret_cast<Bytef*>(compress->buffer.data());
	compress->stream->avail_out = NETWORKMESSAGE_MAXSIZE;

	const int32_t ret = deflate(compress->stream.get(), Z_FINISH);
	if (ret != Z_OK && ret != Z_STREAM_END) {
		return false;
	}

	const auto totalSize = compress->stream->total_out;
	deflateReset(compress->stream.get());

	if (totalSize == 0) {
		return false;
	}

	outputMessage.reset();
	outputMessage.addBytes(compress->buffer.data(), totalSize);

	return true;
}

Protocol::ZStream::ZStream() noexcept {
	const int32_t compressionLevel = g_configManager().getNumber(COMPRESSION_LEVEL);
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
