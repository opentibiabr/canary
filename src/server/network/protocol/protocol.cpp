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

Protocol::Protocol(Connection_ptr initConnection) :
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
			if (auto protocol = protocolWeak.lock()) {
				if (auto protocolConnection = protocol->getConnection()) {
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
		uint32_t recvChecksum = msg.get<uint32_t>();
		if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			if (recvChecksum == 0) {
				// checksum 0 indicate that the packet should be connection ping - 0x1C packet header
				// since we don't need that packet skip it
				return false;
			}

			uint32_t checksum;
			checksum = ++clientSequenceNumber;
			if (clientSequenceNumber >= 0x7FFFFFFF) {
				clientSequenceNumber = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		} else {
			uint32_t checksum;
			if (int32_t len = msg.getLength() - msg.getBufferPosition();
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
	if (auto connection = getConnection()) {
		connection->close();
	}
}

void Protocol::XTEA_encrypt(OutputMessage &outputMessage) const {
	size_t paddingBytes = outputMessage.getLength() & 7;
	if (paddingBytes != 0) {
		outputMessage.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = outputMessage.getOutputBuffer();
	int32_t messageLength;

	const bool hasAVX512 = g_cpuinfo().hasAVX512F();
	const bool hasAVX2 = g_cpuinfo().hasAVX2();
	const bool hasSSE2 = g_cpuinfo().hasSSE2();

	if (hasAVX512) {
		messageLength = static_cast<int32_t>(outputMessage.getLength()) - 256;
	} else if (hasAVX2) {
		messageLength = static_cast<int32_t>(outputMessage.getLength()) - 128;
	} else if (hasSSE2) {
		messageLength = static_cast<int32_t>(outputMessage.getLength()) - 64;
	} else {
		messageLength = static_cast<int32_t>(outputMessage.getLength());
	}

	int32_t readPos = 0;

	// Garantir que o cache de somas de controle está pronto para criptografia
	precacheControlSumsEncrypt();

	// Utilizando as somas de controle pré-calculadas de `cachedControlSumsEncrypt`
	_mm_prefetch(reinterpret_cast<const char*>(buffer), _MM_HINT_T0);
	_mm_prefetch(reinterpret_cast<const char*>(buffer + 64), _MM_HINT_T0);

	if (hasAVX512) {
		while (readPos <= messageLength) {
			const __m512i data0 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos)), _MM_PERM_DBCA);
			const __m512i data1 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 64)), _MM_PERM_DBCA);
			const __m512i data3 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 128)), _MM_PERM_DBCA);
			const __m512i data4 = _mm512_shuffle_epi32(_mm512_loadu_si512(reinterpret_cast<const void*>(buffer + readPos + 192)), _MM_PERM_DBCA);

			__m512i vdata0 = _mm512_unpacklo_epi64(data0, data1);
			__m512i vdata1 = _mm512_unpackhi_epi64(data0, data1);
			__m512i vdata3 = _mm512_unpacklo_epi64(data3, data4);
			__m512i vdata4 = _mm512_unpackhi_epi64(data3, data4);

			for (int i = 0; i < 32; ++i) {
				vdata0 = _mm512_add_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2])));
				vdata1 = _mm512_add_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
				vdata3 = _mm512_add_epi32(vdata3, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata4, 4), _mm512_srli_epi32(vdata4, 5)), vdata4), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2])));
				vdata4 = _mm512_add_epi32(vdata4, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata3, 4), _mm512_srli_epi32(vdata3, 5)), vdata3), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
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

			for (int i = 0; i < 32; ++i) {
				vdata0 = _mm512_add_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2])));
				vdata1 = _mm512_add_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
			}

			_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
			readPos += 64;
			_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
			readPos += 64;
		}
		messageLength += 64;
	}

	if (hasAVX2) {
		if (!hasAVX512) {
			while (readPos <= messageLength) {
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos), _MM_HINT_T1);
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos + 32), _MM_HINT_T1);

				const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data2 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 64)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data3 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 96)), _MM_SHUFFLE(3, 1, 2, 0));

				__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
				__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
				__m256i vdata2 = _mm256_unpacklo_epi64(data2, data3);
				__m256i vdata3 = _mm256_unpackhi_epi64(data2, data3);

				for (int i = 0; i < 32; ++i) {
					vdata0 = _mm256_add_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2])));
					vdata1 = _mm256_add_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
					vdata2 = _mm256_add_epi32(vdata2, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata3, 4), _mm256_srli_epi32(vdata3, 5)), vdata3), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2])));
					vdata3 = _mm256_add_epi32(vdata3, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata2, 4), _mm256_srli_epi32(vdata2, 5)), vdata2), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
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
		}

		if (readPos <= messageLength) {
			const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
			const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));

			__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
			__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);

			for (int i = 0; i < 32; ++i) {
				vdata0 = _mm256_add_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2])));
				vdata1 = _mm256_add_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
			}

			_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
			readPos += 32;
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
			readPos += 32;
		}
		messageLength += 32;
	}

	if (hasSSE2) {
		if (!hasAVX2) {
			while (readPos <= messageLength) {
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos), _MM_HINT_T1);
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos + 16), _MM_HINT_T1);

				const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data3 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data4 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 48)), _MM_SHUFFLE(3, 1, 2, 0));

				__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
				__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
				__m128i vdata3 = _mm_unpacklo_epi64(data3, data4);
				__m128i vdata4 = _mm_unpackhi_epi64(data3, data4);

				for (int i = 0; i < 32; ++i) {
					vdata0 = _mm_add_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2])));
					vdata1 = _mm_add_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
					vdata3 = _mm_add_epi32(vdata3, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata4, 4), _mm_srli_epi32(vdata4, 5)), vdata4), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2])));
					vdata4 = _mm_add_epi32(vdata4, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata3, 4), _mm_srli_epi32(vdata3, 5)), vdata3), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
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
		}

		if (readPos <= messageLength) {
			const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
			const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));

			__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
			__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);

			for (int i = 0; i < 32; ++i) {
				vdata0 = _mm_add_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2])));
				vdata1 = _mm_add_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(cachedControlSumsEncrypt[i * 2 + 1])));
			}

			_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
			readPos += 16;
			_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
			readPos += 16;
		}
		messageLength += 32;
	}

	while (readPos < messageLength) {
		auto* vData = reinterpret_cast<uint32_t*>(buffer + readPos);

		for (int i = 0; i < 32; ++i) {
			vData[0] += ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ cachedControlSumsEncrypt[i * 2];
			vData[1] += ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ cachedControlSumsEncrypt[i * 2 + 1];
		}
		readPos += 8;
	}
}

bool Protocol::XTEA_decrypt(NetworkMessage &msg) const {
	uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength & 7) != 0) {
		return false;
	}

	precacheControlSumsDecrypt();

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	int32_t messageLength;

	const bool hasAVX512 = g_cpuinfo().hasAVX512F();
	const bool hasAVX2 = g_cpuinfo().hasAVX2();
	const bool hasSSE2 = g_cpuinfo().hasSSE2();

	if (hasAVX512) {
		messageLength = static_cast<int32_t>(msgLength) - 256;
	} else if (hasAVX2) {
		messageLength = static_cast<int32_t>(msgLength) - 128;
	} else if (hasSSE2) {
		messageLength = static_cast<int32_t>(msgLength) - 64;
	} else {
		messageLength = static_cast<int32_t>(msgLength);
	}

	int32_t readPos = 0;

	_mm_prefetch(reinterpret_cast<const char*>(buffer), _MM_HINT_T0);
	_mm_prefetch(reinterpret_cast<const char*>(buffer + 64), _MM_HINT_T0);

	if (hasAVX512) {
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
				vdata1 = _mm512_sub_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2])));
				vdata0 = _mm512_sub_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
				vdata3 = _mm512_sub_epi32(vdata3, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata2, 4), _mm512_srli_epi32(vdata2, 5)), vdata2), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2])));
				vdata2 = _mm512_sub_epi32(vdata2, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata3, 4), _mm512_srli_epi32(vdata3, 5)), vdata3), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
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
				vdata1 = _mm512_sub_epi32(vdata1, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata0, 4), _mm512_srli_epi32(vdata0, 5)), vdata0), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2])));
				vdata0 = _mm512_sub_epi32(vdata0, _mm512_xor_si512(_mm512_add_epi32(_mm512_xor_si512(_mm512_slli_epi32(vdata1, 4), _mm512_srli_epi32(vdata1, 5)), vdata1), _mm512_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
			}

			_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpacklo_epi32(vdata0, vdata1));
			readPos += 64;
			_mm512_storeu_si512(reinterpret_cast<void*>(buffer + readPos), _mm512_unpackhi_epi32(vdata0, vdata1));
			readPos += 64;
		}
		messageLength += 64;
	}

	if (hasAVX2) {
		if (!hasAVX512) {
			while (readPos <= messageLength) {
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos), _MM_HINT_T1);
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos + 32), _MM_HINT_T1);

				const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data2 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 64)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m256i data3 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 96)), _MM_SHUFFLE(3, 1, 2, 0));

				__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
				__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);
				__m256i vdata2 = _mm256_unpacklo_epi64(data2, data3);
				__m256i vdata3 = _mm256_unpackhi_epi64(data2, data3);

				for (int32_t i = 0; i < 32; ++i) {
					vdata1 = _mm256_sub_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2])));
					vdata0 = _mm256_sub_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
					vdata3 = _mm256_sub_epi32(vdata3, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata2, 4), _mm256_srli_epi32(vdata2, 5)), vdata2), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2])));
					vdata2 = _mm256_sub_epi32(vdata2, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata3, 4), _mm256_srli_epi32(vdata3, 5)), vdata3), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
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
		}

		if (readPos <= messageLength) {
			const __m256i data0 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
			const __m256i data1 = _mm256_shuffle_epi32(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));

			__m256i vdata0 = _mm256_unpacklo_epi64(data0, data1);
			__m256i vdata1 = _mm256_unpackhi_epi64(data0, data1);

			for (int32_t i = 0; i < 32; ++i) {
				vdata1 = _mm256_sub_epi32(vdata1, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata0, 4), _mm256_srli_epi32(vdata0, 5)), vdata0), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2])));
				vdata0 = _mm256_sub_epi32(vdata0, _mm256_xor_si256(_mm256_add_epi32(_mm256_xor_si256(_mm256_slli_epi32(vdata1, 4), _mm256_srli_epi32(vdata1, 5)), vdata1), _mm256_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
			}

			_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpacklo_epi32(vdata0, vdata1));
			readPos += 32;
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(buffer + readPos), _mm256_unpackhi_epi32(vdata0, vdata1));
			readPos += 32;
		}
		messageLength += 32;
	}

	if (hasSSE2) {
		if (!hasAVX2) {
			while (readPos <= messageLength) {
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos), _MM_HINT_T1);
				_mm_prefetch(reinterpret_cast<const char*>(buffer + readPos + 16), _MM_HINT_T1);

				const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data2 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 32)), _MM_SHUFFLE(3, 1, 2, 0));
				const __m128i data3 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 48)), _MM_SHUFFLE(3, 1, 2, 0));

				__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
				__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);
				__m128i vdata2 = _mm_unpacklo_epi64(data2, data3);
				__m128i vdata3 = _mm_unpackhi_epi64(data2, data3);

				for (int32_t i = 0; i < 32; ++i) {
					vdata1 = _mm_sub_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2])));
					vdata0 = _mm_sub_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
					vdata3 = _mm_sub_epi32(vdata3, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata2, 4), _mm_srli_epi32(vdata2, 5)), vdata2), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2])));
					vdata2 = _mm_sub_epi32(vdata2, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata3, 4), _mm_srli_epi32(vdata3, 5)), vdata3), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
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
		}

		if (readPos <= messageLength) {
			const __m128i data0 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos)), _MM_SHUFFLE(3, 1, 2, 0));
			const __m128i data1 = _mm_shuffle_epi32(_mm_loadu_si128(reinterpret_cast<const __m128i*>(buffer + readPos + 16)), _MM_SHUFFLE(3, 1, 2, 0));

			__m128i vdata0 = _mm_unpacklo_epi64(data0, data1);
			__m128i vdata1 = _mm_unpackhi_epi64(data0, data1);

			for (int32_t i = 0; i < 32; ++i) {
				vdata1 = _mm_sub_epi32(vdata1, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata0, 4), _mm_srli_epi32(vdata0, 5)), vdata0), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2])));
				vdata0 = _mm_sub_epi32(vdata0, _mm_xor_si128(_mm_add_epi32(_mm_xor_si128(_mm_slli_epi32(vdata1, 4), _mm_srli_epi32(vdata1, 5)), vdata1), _mm_set1_epi32(cachedControlSumsDecrypt[i * 2 + 1])));
			}

			_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpacklo_epi32(vdata0, vdata1));
			readPos += 16;
			_mm_storeu_si128(reinterpret_cast<__m128i*>(buffer + readPos), _mm_unpackhi_epi32(vdata0, vdata1));
			readPos += 16;
		}
		messageLength += 32;
	}

	// Fallback para CPUs sem AVX/SSE2
	while (readPos < messageLength) {
		auto* vData = reinterpret_cast<uint32_t*>(buffer + readPos);

		for (int32_t i = 0; i < 32; ++i) {
			vData[1] -= ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ cachedControlSumsDecrypt[i * 2];
			vData[0] -= ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ cachedControlSumsDecrypt[i * 2 + 1];
		}

		readPos += 8;
	}

	auto innerLength = msg.get<uint16_t>();
	if (innerLength > msgLength - 2) {
		return false;
	}

	msg.setLength(innerLength);
	return true;
}

inline void Protocol::precacheControlSumsEncrypt() const {
	if (cacheEncryptInitialized) {
		return;
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

	auto charData = static_cast<char*>(static_cast<void*>(msg.getBuffer()));
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
	if (auto protocolConnection = getConnection()) {
		return protocolConnection->getIP();
	}

	return 0;
}

bool Protocol::compression(OutputMessage &outputMessage) const {
	if (checksumMethod != CHECKSUM_METHOD_SEQUENCE) {
		return false;
	}

	static const thread_local auto &compress = std::make_unique<ZStream>();
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
