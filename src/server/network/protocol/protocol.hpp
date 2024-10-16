/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
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
	virtual void onConnect() { }

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
		ZStream() noexcept;

		~ZStream() {
			deflateEnd(stream.get());
		}

		std::unique_ptr<z_stream> stream;
		std::array<char, NETWORKMESSAGE_MAXSIZE> buffer {};
	};

	struct AlignedFreeDeleter {
		void operator()(uint8_t* ptr) const {
			if (ptr) {
#ifdef _WIN32
				_aligned_free(ptr);
#else
				std::free(ptr);
#endif
			}
		}
	};

	inline uint8_t* aligned_alloc_memory(size_t size, size_t alignment) const {
#ifdef _WIN32
		return static_cast<uint8_t*>(_aligned_malloc(size, alignment));
#else
		uint8_t* originalMemory = nullptr;

		if (posix_memalign(reinterpret_cast<void**>(&originalMemory), alignment, size) != 0) {
			return nullptr;
		}

		if (!is_aligned(originalMemory, alignment)) {
			uintptr_t address = reinterpret_cast<uintptr_t>(originalMemory);
			uintptr_t alignedAddress = (address + alignment - 1) & ~(alignment - 1);
			return reinterpret_cast<uint8_t*>(alignedAddress);
		}

		return originalMemory;
#endif
	}

	inline bool is_aligned(const void* ptr, size_t alignment) const {
		return _mm_testz_si128(_mm_set1_epi64x(reinterpret_cast<uintptr_t>(ptr)), _mm_set1_epi64x(alignment - 1));
	}

	inline void simd_memcpy_avx2(uint8_t* __restrict dest, const uint8_t* __restrict src, size_t len) const {
		size_t i = 0;

		const bool src_aligned = is_aligned(src, 32);
		const bool dest_aligned = is_aligned(dest, 32);

		if (src_aligned && dest_aligned) {
			for (; i + 32 <= len; i += 32) {
				const __m256i data = _mm256_load_si256(reinterpret_cast<const __m256i*>(src + i));
				_mm256_store_si256(reinterpret_cast<__m256i*>(dest + i), data);
			}
		} else {
			for (; i + 32 <= len; i += 32) {
				const __m256i data = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src + i));
				_mm256_storeu_si256(reinterpret_cast<__m256i*>(dest + i), data);
			}
		}
		for (; i < len; ++i) {
			dest[i] = src[i];
		}
	}

	void precacheControlSumsEncrypt() const;
	void precacheControlSumsDecrypt() const;

	mutable std::array<uint32_t, 32 * 2> cachedControlSumsEncrypt {};
	mutable std::array<uint32_t, 32 * 2> cachedControlSumsDecrypt {};
	mutable bool cacheEncryptInitialized = false;
	mutable bool cacheDecryptInitialized = false;
	mutable std::array<uint32_t, 4> key {};

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

	friend class Connection;
};
