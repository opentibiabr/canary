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
#include "utils/tools.hpp"

Protocol::Protocol(const Connection_ptr &initConnection) :
	connectionPtr(initConnection) { }

void Protocol::onSendMessage(const OutputMessage_ptr &msg) {
	if (!rawMessages) {
		const uint32_t sendMessageChecksum = msg->getLength() >= 128 && compression(*msg) ? (1U << 31) : 0;

		if (!encryptionEnabled) {
			msg->writeMessageLength();
			return;
		}

		msg->writePaddingAmount();

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

void Protocol::XTEA_transform(uint8_t* buffer, size_t messageLength, bool encrypt) const {
	constexpr uint32_t delta = 0x61C88647;
	size_t readPos = 0;
	const std::array<uint32_t, 4> newKey = key;

	std::array<std::array<uint32_t, 2>, 32> precachedControlSum;
	uint32_t sum = encrypt ? 0 : 0xC6EF3720;

	// Precompute control sums
	if (encrypt) {
		for (size_t i = 0; i < 32; ++i) {
			precachedControlSum[i][0] = sum + newKey[sum & 3];
			sum -= delta;
			precachedControlSum[i][1] = sum + newKey[(sum >> 11) & 3];
		}
	} else {
		for (size_t i = 0; i < 32; ++i) {
			precachedControlSum[i][0] = sum + newKey[(sum >> 11) & 3];
			sum += delta;
			precachedControlSum[i][1] = sum + newKey[sum & 3];
		}
	}

	while (readPos < messageLength) {
		std::array<uint8_t, 8> tempBuffer;
		std::ranges::copy_n(buffer + readPos, 8, tempBuffer.begin());

		// Convert bytes to uint32_t considering little-endian order
		std::array<uint8_t, 4> bytes0;
		std::array<uint8_t, 4> bytes1;
		std::copy_n(tempBuffer.begin(), 4, bytes0.begin());
		std::copy_n(tempBuffer.begin() + 4, 4, bytes1.begin());

		uint32_t vData0 = std::bit_cast<uint32_t>(bytes0);
		uint32_t vData1 = std::bit_cast<uint32_t>(bytes1);

		if (encrypt) {
			for (size_t i = 0; i < 32; ++i) {
				vData0 += ((vData1 << 4 ^ vData1 >> 5) + vData1) ^ precachedControlSum[i][0];
				vData1 += ((vData0 << 4 ^ vData0 >> 5) + vData0) ^ precachedControlSum[i][1];
			}
		} else {
			for (size_t i = 0; i < 32; ++i) {
				vData1 -= ((vData0 << 4 ^ vData0 >> 5) + vData0) ^ precachedControlSum[i][0];
				vData0 -= ((vData1 << 4 ^ vData1 >> 5) + vData1) ^ precachedControlSum[i][1];
			}
		}

		// Convert vData back to bytes
		bytes0 = std::bit_cast<std::array<uint8_t, 4>>(vData0);
		bytes1 = std::bit_cast<std::array<uint8_t, 4>>(vData1);

		// Copy transformed bytes back to buffer
		std::copy_n(bytes0.begin(), 4, buffer + readPos);
		std::copy_n(bytes1.begin(), 4, buffer + readPos + 4);

		readPos += 8;
	}
}

void Protocol::XTEA_encrypt(OutputMessage &outputMessage) const {
	// Ensure the message length is a multiple of 8
	size_t paddingBytes = outputMessage.getLength() % 8;
	if (paddingBytes != 0) {
		outputMessage.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = outputMessage.getOutputBuffer();
	size_t messageLength = outputMessage.getLength();

	XTEA_transform(buffer, messageLength, true);
}

bool Protocol::XTEA_decrypt(NetworkMessage &msg) const {
	uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength % 8) != 0) {
		return false;
	}

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	size_t messageLength = msgLength;

	XTEA_transform(buffer, messageLength, false);

	uint8_t paddingSize = msg.getByte();
	if (std::cmp_greater(paddingSize, msgLength - 1)) {
		return false;
	}

	msg.setLength(messageLength - paddingSize);
	return true;
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
