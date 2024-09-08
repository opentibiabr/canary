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
	explicit Protocol(const Connection_ptr &initConnection) :
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
		if (const auto connection = getConnection()) {
			connection->close();
		}
	}

	void enableXTEAEncryption() {
		encryptionEnabled = true;
	}
	void setXTEAKey(const uint32_t* newKey) {
		uint32_t* dst = this->key.data();

#if defined(__AVX2__)
		const __m128i avx_key = _mm_loadu_si128(reinterpret_cast<const __m128i*>(newKey));
		_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), avx_key);
#elif defined(__SSE2__)
		__m128i sse_key = _mm_loadu_si128(reinterpret_cast<const __m128i*>(newKey));
		_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), sse_key);
#else
		memcpy(dst, newKey, sizeof(uint32_t) * 4);
#endif
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

	inline void simd_memcpy_avx2(uint8_t* dest, const uint8_t* src, size_t len) const {
		size_t i = 0;

		// Copiar blocos de 32 bytes por vez (256 bits) com AVX2
		for (; i + 32 <= len; i += 32) {
			const __m256i data = _mm256_load_si256(reinterpret_cast<const __m256i*>(src + i));
			_mm256_store_si256(reinterpret_cast<__m256i*>(dest + i), data);
		}

		// Copiar os bytes restantes que não formam um bloco completo de 32 bytes
		for (; i < len; ++i) {
			dest[i] = src[i];
		}
	}

	void XTEA_encrypt(OutputMessage &msg) const;
	bool XTEA_decrypt(NetworkMessage &msg) const;
	bool compression(OutputMessage &msg) const;

	OutputMessage_ptr outputBuffer;

	const ConnectionWeak_ptr connectionPtr;
	uint32_t serverSequenceNumber = 0;
	uint32_t clientSequenceNumber = 0;
	std::underlying_type_t<ChecksumMethods_t> checksumMethod = CHECKSUM_METHOD_NONE;
	bool encryptionEnabled = false;
	bool rawMessages = false;

	mutable std::array<uint32_t, 32 * 2> cachedControlSumsEncrypt; // Cache para criptografia
	mutable std::array<uint32_t, 32 * 2> cachedControlSumsDecrypt; // Cache para descriptografia
	mutable bool cacheEncryptInitialized = false;
	mutable bool cacheDecryptInitialized = false;
	mutable std::array<uint32_t, 4> key;

	void precacheControlSumsEncrypt() const;
	void precacheControlSumsDecrypt() const;

	friend class Connection;
};
