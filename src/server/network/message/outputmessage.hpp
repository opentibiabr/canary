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
#include "server/network/connection/connection.hpp"
#include <spdlog/spdlog.h>

class Protocol;

class OutputMessage : public NetworkMessage {
public:
	OutputMessage() = default;

	// non-copyable
	OutputMessage(const OutputMessage &) = delete;
	OutputMessage &operator=(const OutputMessage &) = delete;

	uint8_t* getOutputBuffer() {
		return buffer + outputBufferStart;
	}

	void writeMessageLength() {
		add_header(info.length);
	}

	void addCryptoHeader(bool addChecksum, uint32_t checksum) {
		if (addChecksum) {
			add_header(checksum);
		}

		writeMessageLength();
	}

	void append(const NetworkMessage &msg) {
		const auto msgLen = msg.getLength();
		const unsigned char* src = msg.getBuffer() + INITIAL_BUFFER_POSITION;
		unsigned char* dst = buffer + info.position;

		size_t remaining = msgLen;

#if defined(__AVX2__)
		// Use AVX2 to copy 32 bytes at a time
		while (remaining >= 32) {
			copy_block<32>(src, dst);
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 to copy remaining bytes
		while (remaining >= 16) {
			copy_block<16>(src, dst);
			remaining -= 16;
		}
		while (remaining >= 8) {
			copy_block<8>(src, dst);
			remaining -= 8;
		}
		while (remaining >= 4) {
			copy_block<4>(src, dst);
			remaining -= 4;
		}
		while (remaining >= 2) {
			copy_block<2>(src, dst);
			remaining -= 2;
		}
		while (remaining == 1) {
			copy_block<1>(src, dst);
			remaining -= 1;
		}
#else
		// Fallback to original method using memcpy if neither AVX2 nor SSE2 are available
		memcpy(dst, src, remaining);
#endif

		info.length += msgLen;
		info.position += msgLen;
	}

	void append(const OutputMessage_ptr &msg) {
		const auto msgLen = msg->getLength();
		const unsigned char* src = msg->getBuffer() + INITIAL_BUFFER_POSITION;
		unsigned char* dst = buffer + info.position;

		size_t remaining = msgLen;

#if defined(__AVX2__)
		// Use AVX2 to copy 32 bytes at a time
		while (remaining >= 32) {
			copy_block<32>(src, dst);
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 to copy remaining bytes
		while (remaining >= 16) {
			copy_block<16>(src, dst);
			remaining -= 16;
		}
		while (remaining >= 8) {
			copy_block<8>(src, dst);
			remaining -= 8;
		}
		while (remaining >= 4) {
			copy_block<4>(src, dst);
			remaining -= 4;
		}
		while (remaining >= 2) {
			copy_block<2>(src, dst);
			remaining -= 2;
		}
		while (remaining == 1) {
			copy_block<1>(src, dst);
			remaining -= 1;
		}
#else
		// Fallback to original method using memcpy if neither AVX2 nor SSE2 are available
		memcpy(dst, src, remaining);
#endif

		info.length += msgLen;
		info.position += msgLen;
	}

private:
	template <typename T>
	void add_header(T addHeader) {
		if (outputBufferStart < sizeof(T)) {
			g_logger().error("[{}]: Insufficient buffer space for header!", __FUNCTION__);
			return;
		}

		assert(outputBufferStart >= sizeof(T));
		outputBufferStart -= sizeof(T);

#if defined(__SSE2__)
		if constexpr (sizeof(T) >= 16) {
			// Use SSE2 to copy 16 bytes at a time
			_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + outputBufferStart), _mm_loadu_si128(reinterpret_cast<const __m128i*>(&addHeader)));
		} else if constexpr (sizeof(T) >= 8) {
			// Use SSE2 to copy 8 bytes
			_mm_storel_epi64(reinterpret_cast<__m128i*>(buffer + outputBufferStart), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(&addHeader)));
		} else if constexpr (sizeof(T) >= 4) {
			// Use SSE2 to copy 4 bytes
			*reinterpret_cast<uint32_t*>(buffer + outputBufferStart) = *reinterpret_cast<const uint32_t*>(&addHeader);
		} else if constexpr (sizeof(T) >= 2) {
			// Use SSE2 to copy 2 bytes
			*reinterpret_cast<uint16_t*>(buffer + outputBufferStart) = *reinterpret_cast<const uint16_t*>(&addHeader);
		} else {
			// Copy 1 byte
			*reinterpret_cast<uint8_t*>(buffer + outputBufferStart) = *reinterpret_cast<const uint8_t*>(&addHeader);
		}
#else
		// Fallback to original method using memcpy if SSE2 is not available
		memcpy(buffer + outputBufferStart, &addHeader, sizeof(T));
#endif

		// added header size to the message size
		info.length += sizeof(T);
	}

	MsgSize_t outputBufferStart = INITIAL_BUFFER_POSITION;

	template <size_t N>
	static void copy_block(const unsigned char*&src, unsigned char*&dst) {
		if constexpr (N == 32) {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
		} else if constexpr (N == 16) {
			_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), _mm_loadu_si128(reinterpret_cast<const __m128i*>(src)));
		} else if constexpr (N == 8) {
			_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(src)));
		} else if constexpr (N == 4) {
			*reinterpret_cast<uint32_t*>(dst) = *reinterpret_cast<const uint32_t*>(src);
		} else if constexpr (N == 2) {
			*reinterpret_cast<uint16_t*>(dst) = *reinterpret_cast<const uint16_t*>(src);
		} else if constexpr (N == 1) {
			*dst = *src;
		}

		src += N;
		dst += N;
	}
};

class OutputMessagePool {
public:
	OutputMessagePool() = default;

	// non-copyable
	OutputMessagePool(const OutputMessagePool &) = delete;
	OutputMessagePool &operator=(const OutputMessagePool &) = delete;

	static OutputMessagePool &getInstance() {
		return inject<OutputMessagePool>();
	}

	void sendAll();
	void scheduleSendAll();

	static OutputMessage_ptr getOutputMessage();

	void addProtocolToAutosend(Protocol_ptr protocol);
	void removeProtocolFromAutosend(const Protocol_ptr &protocol);

private:
	// NOTE: A vector is used here because this container is mostly read
	// and relatively rarely modified (only when a client connects/disconnects)
	std::vector<Protocol_ptr> bufferedProtocols;
};
