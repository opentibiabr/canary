/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/protocol/protocol.hpp"
#include "server/network/message/outputmessage.hpp"
#include "security/rsa.hpp"
#include "game/scheduling/dispatcher.hpp"

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

	g_dispatcher().addEvent([&msg, protocolWeak = std::weak_ptr<Protocol>(shared_from_this())]() {
		if (const auto protocol = protocolWeak.lock()) {
			if (const auto protocolConnection = protocol->getConnection()) {
				protocol->parsePacket(msg);
				protocolConnection->resumeWork();
			}
		} }, "Protocol::sendRecvMessageCallback");

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

void Protocol::XTEA_encrypt(OutputMessage &msg) const {
	const size_t paddingBytes = msg.getLength() & 7;
	if (paddingBytes != 0) {
		msg.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = msg.getOutputBuffer();
	const auto messageLength = static_cast<int32_t>(msg.getLength());

	precacheControlSumsEncrypt();

	// Alocar memória alinhada usando std::unique_ptr para garantir liberação
	const std::unique_ptr<uint8_t, AlignedFreeDeleter> alignedBuffer(
		aligned_alloc_memory(messageLength, 32), AlignedFreeDeleter()
	);

	if (!alignedBuffer) {
		g_logger().error("[] - Error alianhamento memory", __FUNCTION__);
	}

	// Copiar dados para buffer alinhado usando AVX2
	simd_memcpy_avx2(alignedBuffer.get(), buffer, messageLength);

	int32_t readPos = 0;
	while (readPos < messageLength) {
		// Usar prefetch otimizado com _MM_HINT_T1 para cache L2
		_mm_prefetch(reinterpret_cast<const char*>(alignedBuffer.get() + readPos + 256), _MM_HINT_T1);

		__m256i vData = is_aligned(alignedBuffer.get() + readPos, 32)
			? _mm256_load_si256(reinterpret_cast<const __m256i*>(alignedBuffer.get() + readPos))
			: _mm256_loadu_si256(reinterpret_cast<const __m256i*>(alignedBuffer.get() + readPos));

		auto* vDataArr = reinterpret_cast<uint32_t*>(&vData);

		for (int32_t i = 0; i < 32; i += 8) {
			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[i * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[i * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 1) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 1) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 2) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 2) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 3) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 3) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 4) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 4) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 5) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 5) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 6) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 6) * 2 + 1];

			vDataArr[0] += ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsEncrypt[(i + 7) * 2];
			vDataArr[1] += ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsEncrypt[(i + 7) * 2 + 1];
		}

		if (is_aligned(alignedBuffer.get() + readPos, 32)) {
			_mm256_store_si256(reinterpret_cast<__m256i*>(alignedBuffer.get() + readPos), vData);
		} else {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(alignedBuffer.get() + readPos), vData);
		}

		readPos += 8;
	}

	// Copiar de volta para o buffer original
	simd_memcpy_avx2(buffer, alignedBuffer.get(), messageLength);
}

bool Protocol::XTEA_decrypt(NetworkMessage &msg) const {
	const uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength & 7) != 0) {
		return false;
	}

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	const auto messageLength = static_cast<int32_t>(msgLength);

	precacheControlSumsDecrypt();

	// Alocar memória alinhada usando std::unique_ptr para garantir liberação
	const std::unique_ptr<uint8_t, AlignedFreeDeleter> alignedBuffer(
		aligned_alloc_memory(messageLength, 32), AlignedFreeDeleter()
	);

	if (!alignedBuffer) {
		g_logger().error("[] - Error alianhamento memory", __FUNCTION__);
	}

	simd_memcpy_avx2(alignedBuffer.get(), buffer, messageLength);

	int32_t readPos = 0;
	while (readPos < messageLength) {
		_mm_prefetch(reinterpret_cast<const char*>(alignedBuffer.get() + readPos + 256), _MM_HINT_T1);

		__m256i vData = is_aligned(alignedBuffer.get() + readPos, 32)
			? _mm256_load_si256(reinterpret_cast<const __m256i*>(alignedBuffer.get() + readPos))
			: _mm256_loadu_si256(reinterpret_cast<const __m256i*>(alignedBuffer.get() + readPos));

		auto* vDataArr = reinterpret_cast<uint32_t*>(&vData);

		for (int32_t i = 0; i < 32; i += 8) {
			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[i * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[i * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 1) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 1) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 2) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 2) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 3) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 3) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 4) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 4) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 5) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 5) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 6) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 6) * 2 + 1];

			vDataArr[1] -= ((vDataArr[0] << 4) ^ (vDataArr[0] >> 5)) + vDataArr[0] ^ cachedControlSumsDecrypt[(i + 7) * 2];
			vDataArr[0] -= ((vDataArr[1] << 4) ^ (vDataArr[1] >> 5)) + vDataArr[1] ^ cachedControlSumsDecrypt[(i + 7) * 2 + 1];
		}

		if (is_aligned(alignedBuffer.get() + readPos, 32)) {
			_mm256_store_si256(reinterpret_cast<__m256i*>(alignedBuffer.get() + readPos), vData);
		} else {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(alignedBuffer.get() + readPos), vData);
		}

		readPos += 8;
	}

	simd_memcpy_avx2(buffer, alignedBuffer.get(), messageLength);

	const auto innerLength = msg.get<uint16_t>();
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
		return; // Cache já está pronto para descriptografia
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

uint32_t Protocol::getIP() const {
	if (const auto protocolConnection = getConnection()) {
		return protocolConnection->getIP();
	}

	return 0;
}

bool Protocol::compression(OutputMessage &msg) const {
	if (checksumMethod != CHECKSUM_METHOD_SEQUENCE) {
		return false;
	}

	static thread_local auto compress_ptr = std::make_unique<ZStream>();
	static const auto &compress = compress_ptr;

	if (!compress->stream) {
		return false;
	}

	const auto outputMessageSize = msg.getLength();
	if (outputMessageSize > NETWORKMESSAGE_MAXSIZE) {
		g_logger().error("[NetworkMessage::compression] - Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, outputMessageSize);
		return false;
	}

	compress->stream->next_in = msg.getOutputBuffer();
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

	msg.reset();
	msg.addBytes(compress->buffer.data(), totalSize);

	return true;
}
