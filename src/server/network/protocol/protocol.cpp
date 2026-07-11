/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/protocol.hpp"

#include "config/configmanager.hpp"
#include "server/network/connection/connection.hpp"
#include "server/network/message/outputmessage.hpp"
#include "server/network/protocol/transport_codec.hpp"
#include "security/rsa.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "utils/tools.hpp"

Protocol::Protocol(const Connection_ptr &initConnection) :
	connectionPtr(initConnection) {
	if (initConnection) {
		initConnection->setTransportCodec(TransportCodecs::currentGamePlain());
	}
}

void Protocol::setChecksumMethod(ChecksumMethods_t method) {
	const auto connection = getConnection();
	if (!connection) {
		return;
	}

	const auto &activeProfile = connection->getTransportCodec().getProfile();
	TransportProfileId targetProfile = activeProfile.id;
	if (activeProfile.outerLength == OuterLengthEncoding::ModernBlockCount) {
		switch (method) {
			case CHECKSUM_METHOD_ADLER32:
				targetProfile = TransportProfileId::CurrentLogin;
				break;
			case CHECKSUM_METHOD_SEQUENCE:
				targetProfile = TransportProfileId::CurrentGameSequence;
				break;
			case CHECKSUM_METHOD_NONE:
				targetProfile = TransportProfileId::CurrentGamePlain;
				break;
		}
	} else if (method != activeProfile.inboundChecksum || method != activeProfile.outboundChecksum) {
		g_logger().error("[Protocol::setChecksumMethod] checksum contract is not available for transport profile {}", static_cast<uint8_t>(activeProfile.id));
		return;
	}

	connection->setTransportCodec(TransportCodecs::get(targetProfile), connection->getInitialTransportState());
}

void Protocol::onSendMessage(const OutputMessage_ptr &msg) {
	if (!rawMessages) {
		if (const auto &connection = getConnection()) {
			connection->getTransportCodec().encodeOutbound(*this, *msg);
		}
	}
}

bool Protocol::sendRecvMessageCallback(NetworkMessage &msg) {
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
	const auto &connection = getConnection();
	if (!connection || !connection->getTransportCodec().prepareInbound(*this, msg)) {
		return false;
	}

	return sendRecvMessageCallback(msg);
}

void Protocol::onConnectionAccepted() {
	sendLoginChallenge();
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
		if (std::memcpy(tempBuffer.data(), buffer + readPos, tempBuffer.size()) == nullptr) {
			g_logger().error("[{}] memcpy failed while preparing XTEA block", __FUNCTION__);
			return;
		}

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

bool Protocol::compression(OutputMessage &outputMessage, CompressionLayout layout) const {
	if (layout == CompressionLayout::None) {
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
