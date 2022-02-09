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

#include "otpch.h"

#include "server/network/protocol/protocol.h"
#include "server/network/message/outputmessage.h"
#include "security/rsa.h"
#include "game/scheduling/tasks.h"

Protocol::~Protocol()
{
	if (compreesionEnabled) {
		deflateEnd(defStream.get());
	}
}

void Protocol::onSendMessage(const OutputMessage_ptr& msg)
{
	if (!rawMessages) {
		uint32_t _compression = 0;
		if (compreesionEnabled && msg->getLength() >= 128) {
			if (compression(*msg)) {
				_compression = (1U << 31);
			}
		}

		msg->writeMessageLength();

		if (encryptionEnabled) {
			XTEA_encrypt(*msg);
			if (checksumMethod == CHECKSUM_METHOD_NONE) {
				msg->addCryptoHeader(false, 0);
			} else if (checksumMethod == CHECKSUM_METHOD_ADLER32) {
				msg->addCryptoHeader(true, adlerChecksum(msg->getOutputBuffer(), msg->getLength()));
			} else if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
				msg->addCryptoHeader(true, _compression | (++serverSequenceNumber));
				if (serverSequenceNumber >= 0x7FFFFFFF) {
					serverSequenceNumber = 0;
				}
			}
		}
	}
}

bool Protocol::onRecvMessage(NetworkMessage& msg)
{
	if (checksumMethod != CHECKSUM_METHOD_NONE) {
		uint32_t recvChecksum = msg.get<uint32_t>();
		if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			if (recvChecksum == 0) {
				// checksum 0 indicate that the packet should be connection ping - 0x1C packet header
				// since we don't need that packet skip it
				return false;
			}

			uint32_t checksum = ++clientSequenceNumber;
			if (clientSequenceNumber >= 0x7FFFFFFF) {
				clientSequenceNumber = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		} else {
			uint32_t checksum;
			int32_t len = msg.getLength() - msg.getBufferPosition();
			if (len > 0) {
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
	if (encryptionEnabled && !XTEA_decrypt(msg)) {
		return false;
	}

	using ProtocolWeak_ptr = std::weak_ptr<Protocol>;
	ProtocolWeak_ptr protocolWeak = std::weak_ptr<Protocol>(shared_from_this());

	std::function<void (void)> callback = [protocolWeak, &msg]() {
		if (auto protocol = protocolWeak.lock()) {
			if (auto connection = protocol->getConnection()) {
				protocol->parsePacket(msg);
				connection->resumeWork();
			}
		}
	};
	g_dispatcher.addTask(createTask(callback));
	return true;
}

OutputMessage_ptr Protocol::getOutputBuffer(int32_t size)
{
	//dispatcher thread
	if (!outputBuffer) {
		outputBuffer = OutputMessagePool::getOutputMessage();
	} else if ((outputBuffer->getLength() + size) > MAX_PROTOCOL_BODY_LENGTH) {
		send(outputBuffer);
		outputBuffer = OutputMessagePool::getOutputMessage();
	}
	return outputBuffer;
}

void Protocol::XTEA_encrypt(OutputMessage& msg) const
{
	const uint32_t delta = 0x61C88647;

	// The message must be a multiple of 8
	size_t paddingBytes = msg.getLength() & 7;
	if (paddingBytes != 0) {
		msg.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = msg.getOutputBuffer();
	#if defined(__AVX512F__)
	int32_t messageLength = static_cast<int32_t>(msg.getLength()) - 256;
	#elif defined(__AVX2__)
	int32_t messageLength = static_cast<int32_t>(msg.getLength()) - 128;
	#elif defined(__SSE2__)
	int32_t messageLength = static_cast<int32_t>(msg.getLength()) - 64;
	#else
	int32_t messageLength = static_cast<int32_t>(msg.getLength());
	#endif
	int32_t readPos = 0;
	const uint32_t k[] = {key[0], key[1], key[2], key[3]};
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + k[sum & 3]);
		sum -= delta;
		precachedControlSum[i][1] = (sum + k[(sum >> 11) & 3]);
	}
	#if defined(__AVX512F__)
	while (readPos <= messageLength) {
		const __m512i data0 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos)), _MM_PERM_DBCA);
		const __m512i data1 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 64)), _MM_PERM_DBCA);
		const __m512i data3 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 128)), _MM_PERM_DBCA);
		const __m512i data4 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 192)), _MM_PERM_DBCA);
		__m512i vdata0 = _mm512_unpacklo_epi64(data0, data1);
		__m512i vdata1 = _mm512_unpackhi_epi64(data0, data1);
		__m512i vdata3 = _mm512_unpacklo_epi64(data3, data4);
		__m512i vdata4 = _mm512_unpackhi_epi64(data3, data4);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm512_add_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm512_add_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(precachedControlSum[i][1])));
			vdata3 = _mm512_add_epi32(vdata3, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata4, 4), _mm512_srli_epi32(vdata4, 5)), vdata4), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata4 = _mm512_add_epi32(vdata4, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata3, 4), _mm512_srli_epi32(vdata3, 5)), vdata3), _mm512_set1_epi32(precachedControlSum[i][1])));
		}
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata3, vdata4));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata3, vdata4));
		readPos += 64;
	}
	messageLength += 128;
	if (readPos <= messageLength) {
		const __m512i data0 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos)), _MM_PERM_DBCA);
		const __m512i data1 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 64)), _MM_PERM_DBCA);
		__m512i vdata0 = _mm512_unpacklo_epi64(data0, data1);
		__m512i vdata1 = _mm512_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm512_add_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm512_add_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(precachedControlSum[i][1])));
		}
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
		readPos += 64;
	}
	messageLength += 64;
	#endif
	#if defined(__AVX2__)

	//AVX2 unroll - only if AVX512 disabled
	#if !defined(__AVX512F__)
	while (readPos <= messageLength) {
		const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data2 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 64)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data3 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 96)), _MM_SHUFFLE(3, 1, 2, 0));
		__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
		__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
		__m256i vdata2 = _mm256_unpacklo_epi64(data2, data3);
		__m256i vdata3 = _mm256_unpackhi_epi64(data2, data3);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm256_add_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm256_add_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(precachedControlSum[i][1])));
			vdata2 = _mm256_add_epi32(vdata2, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata3, 4), _mm256_srli_epi32(vdata3, 5)), vdata3), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata3 = _mm256_add_epi32(vdata3, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata2, 4), _mm256_srli_epi32(vdata2, 5)), vdata2), _mm256_set1_epi32(precachedControlSum[i][1])));
		}
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata2, vdata3));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata2, vdata3));
		readPos += 32;
	}
	messageLength += 64;
	#endif

	if (readPos <= messageLength) {
		const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
		__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm256_add_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm256_add_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(precachedControlSum[i][1])));
		}
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
		readPos += 32;
	}
	messageLength += 32;
	#endif
	#if defined(__SSE2__)

	//SSE2 unroll - only if AVX2 disabled
	#if !defined(__AVX2__)
	while (readPos <= messageLength) {
		const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data3 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data4 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 48)), _MM_SHUFFLE(3, 1, 2, 0));
		__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
		__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
		__m128i vdata3 = _mm_unpacklo_epi64(data3, data4);
		__m128i vdata4 = _mm_unpackhi_epi64(data3, data4);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm_add_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm_add_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(precachedControlSum[i][1])));
			vdata3 = _mm_add_epi32(vdata3, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata4, 4), _mm_srli_epi32(vdata4, 5)), vdata4), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata4 = _mm_add_epi32(vdata4, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata3, 4), _mm_srli_epi32(vdata3, 5)), vdata3), _mm_set1_epi32(precachedControlSum[i][1])));
		}
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata3, vdata4));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata3, vdata4));
		readPos += 16;
	}
	messageLength += 32;
	#endif

	if (readPos <= messageLength) {
		const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
		__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
		__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata0 = _mm_add_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata1 = _mm_add_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(precachedControlSum[i][1])));
		}
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
		readPos += 16;
	}
	messageLength += 32;
	#endif
	while (readPos < messageLength) {
		uint32_t vData[2];
		memcpy(vData, buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[0] += ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][0];
			vData[1] += ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData, 8);
		readPos += 8;
	}
}

bool Protocol::XTEA_decrypt(NetworkMessage& msg) const
{
	uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength & 7) != 0) {
		return false;
	}

	const uint32_t delta = 0x61C88647;

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	#if defined(__AVX512F__)
	int32_t messageLength = static_cast<int32_t>(msgLength) - 256;
	#elif defined(__AVX2__)
	int32_t messageLength = static_cast<int32_t>(msgLength) - 128;
	#elif defined(__SSE2__)
	int32_t messageLength = static_cast<int32_t>(msgLength) - 64;
	#else
	int32_t messageLength = static_cast<int32_t>(msgLength);
	#endif
	int32_t readPos = 0;
	const uint32_t k[] = {key[0], key[1], key[2], key[3]};
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0xC6EF3720;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + k[(sum >> 11) & 3]);
		sum += delta;
		precachedControlSum[i][1] = (sum + k[sum & 3]);
	}
	#if defined(__AVX512F__)
	while (readPos <= messageLength) {
		const __m512i data0 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos)), _MM_PERM_DBCA);
		const __m512i data1 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 64)), _MM_PERM_DBCA);
		const __m512i data2 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 128)), _MM_PERM_DBCA);
		const __m512i data3 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 192)), _MM_PERM_DBCA);
		__m512i vdata0 = _mm512_unpacklo_epi64(data0, data1);
		__m512i vdata1 = _mm512_unpackhi_epi64(data0, data1);
		__m512i vdata2 = _mm512_unpacklo_epi64(data2, data3);
		__m512i vdata3 = _mm512_unpackhi_epi64(data2, data3);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm512_sub_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm512_sub_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(precachedControlSum[i][1])));
			vdata3 = _mm512_sub_epi32(vdata3, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata2, 4), _mm512_srli_epi32(vdata2, 5)), vdata2), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata2 = _mm512_sub_epi32(vdata2, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata3, 4), _mm512_srli_epi32(vdata3, 5)), vdata3), _mm512_set1_epi32(precachedControlSum[i][1])));
		}
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata2, vdata3));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata2, vdata3));
		readPos += 64;
	}
	messageLength += 128;
	if (readPos <= messageLength) {
		const __m512i data0 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos)), _MM_PERM_DBCA);
		const __m512i data1 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 64)), _MM_PERM_DBCA);
		__m512i vdata0 = _mm512_unpacklo_epi64(data0, data1);
		__m512i vdata1 = _mm512_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm512_sub_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm512_sub_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(precachedControlSum[i][1])));
		}
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
		readPos += 64;
		_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
		readPos += 64;
	}
	messageLength += 64;
	#endif
	#if defined(__AVX2__)

	//AVX2 unroll - only if AVX512 disabled
	#if !defined(__AVX512F__)
	while (readPos <= messageLength) {
		const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data2 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 64)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data3 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 96)), _MM_SHUFFLE(3, 1, 2, 0));
		__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
		__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
		__m256i vdata2 = _mm256_unpacklo_epi64(data2, data3);
		__m256i vdata3 = _mm256_unpackhi_epi64(data2, data3);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm256_sub_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm256_sub_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(precachedControlSum[i][1])));
			vdata3 = _mm256_sub_epi32(vdata3, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata2, 4), _mm256_srli_epi32(vdata2, 5)), vdata2), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata2 = _mm256_sub_epi32(vdata2, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata3, 4), _mm256_srli_epi32(vdata3, 5)), vdata3), _mm256_set1_epi32(precachedControlSum[i][1])));
		}
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata2, vdata3));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata2, vdata3));
		readPos += 32;
	}
	messageLength += 64;
	#endif

	if (readPos <= messageLength) {
		const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
		__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm256_sub_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm256_sub_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(precachedControlSum[i][1])));
		}
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
		readPos += 32;
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
		readPos += 32;
	}
	messageLength += 32;
	#endif
	#if defined(__SSE2__)

	//SSE2 unroll - only if AVX2 disabled
	#if !defined(__AVX2__)
	while (readPos <= messageLength) {
		const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data2 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data3 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 48)), _MM_SHUFFLE(3, 1, 2, 0));
		__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
		__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
		__m128i vdata2 = _mm_unpacklo_epi64(data2, data3);
		__m128i vdata3 = _mm_unpackhi_epi64(data2, data3);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm_sub_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm_sub_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(precachedControlSum[i][1])));
			vdata3 = _mm_sub_epi32(vdata3, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata2, 4), _mm_srli_epi32(vdata2, 5)), vdata2), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata2 = _mm_sub_epi32(vdata2, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata3, 4), _mm_srli_epi32(vdata3, 5)), vdata3), _mm_set1_epi32(precachedControlSum[i][1])));
		}
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata2, vdata3));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata2, vdata3));
		readPos += 16;
	}
	messageLength += 32;
	#endif

	if (readPos <= messageLength) {
		const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
		const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
		__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
		__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
		for (int32_t i = 0; i < 32; ++i) {
			vdata1 = _mm_sub_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(precachedControlSum[i][0])));
			vdata0 = _mm_sub_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(precachedControlSum[i][1])));
		}
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
		readPos += 16;
		_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
		readPos += 16;
	}
	messageLength += 32;
	#endif
	while (readPos < messageLength) {
		uint32_t vData[2];
		memcpy(vData, buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[1] -= ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][0];
			vData[0] -= ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData, 8);
		readPos += 8;
	}

	uint16_t innerLength = msg.get<uint16_t>();
	if (innerLength > msgLength - 2) {
		return false;
	}

	msg.setLength(innerLength);
	return true;
}

bool Protocol::RSA_decrypt(NetworkMessage& msg)
{
	if ((msg.getLength() - msg.getBufferPosition()) < 128) {
		return false;
	}

	g_rsa().decrypt(reinterpret_cast<char*>(msg.getBuffer()) + msg.getBufferPosition()); //does not break strict aliasing
	return (msg.getByte() == 0);
}

uint32_t Protocol::getIP() const
{
	if (auto connection = getConnection()) {
		return connection->getIP();
	}

	return 0;
}

void Protocol::enableCompression()
{
	if (!compreesionEnabled) {
		int32_t compressionLevel = g_configManager().getNumber(COMPRESSION_LEVEL);
		if (compressionLevel != 0) {
			defStream.reset(new z_stream);
			defStream->zalloc = Z_NULL;
			defStream->zfree = Z_NULL;
			defStream->opaque = Z_NULL;
			if (deflateInit2(defStream.get(), compressionLevel, Z_DEFLATED, -15, 9, Z_DEFAULT_STRATEGY) != Z_OK) {
				defStream.reset();
				SPDLOG_ERROR("[Protocol::enableCompression()] - Zlib deflateInit2 error: {}", (defStream->msg ? defStream->msg : " unknown error"));
			} else {
				compreesionEnabled = true;
			}
		}
	}
}

bool Protocol::compression(OutputMessage& msg)
{
	static thread_local uint8_t defBuffer[NETWORKMESSAGE_MAXSIZE];
	defStream->next_in = msg.getOutputBuffer();
	defStream->avail_in = msg.getLength();
	defStream->next_out = defBuffer;
	defStream->avail_out = NETWORKMESSAGE_MAXSIZE;

	int32_t ret = deflate(defStream.get(), Z_FINISH);
	if (ret != Z_OK && ret != Z_STREAM_END) {
		return false;
	}
	uint32_t totalSize = static_cast<uint32_t>(defStream->total_out);
	deflateReset(defStream.get());
	if (totalSize == 0) {
		return false;
	}

	msg.reset();
	msg.addBytes(reinterpret_cast<const char*>(defBuffer), static_cast<size_t>(totalSize));
	return true;
}
