/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class PropStream;

namespace OTB {
	using Identifier = std::array<char, 4>;

	struct Node {
		Node() = default;
		Node(Node &&) = default;
		Node &operator=(Node &&) = default;
		Node(const Node &) = delete;
		Node &operator=(const Node &) = delete;

		std::list<Node> children;
		mio::mmap_source::const_iterator propsBegin {};
		mio::mmap_source::const_iterator propsEnd {};
		uint8_t type {};
		enum NodeChar : uint8_t {
			ESCAPE = 0xFD,
			START = 0xFE,
			END = 0xFF,
		};
	};

	struct LoadError : std::exception {
		const char* what() const noexcept override = 0;
	};

	struct InvalidOTBFormat final : LoadError {
		const char* what() const noexcept override {
			return "Invalid OTBM file format";
		}
	};

	class Loader {
		mio::mmap_source fileContents;
		Node root;
		std::vector<char> propBuffer;

	public:
		Loader(const std::string &fileName, const Identifier &acceptedIdentifier);
		bool getProps(const Node &node, PropStream &props);
		const Node &parseTree();
	};
} // namespace OTB

class PropStream {
public:
	void init(const char* a, size_t size) {
		p = a;
		end = a + size;
	}

	size_t size() const {
		return end - p;
	}

	template <typename T>
	bool read(T &ret) {
		if (size() < sizeof(T)) {
			return false;
		}

		const char* src = p;
		char* dst = reinterpret_cast<char*>(&ret);
		size_t remaining = sizeof(T);

#if defined(__AVX2__)
		// Use AVX2 para copiar 32 bytes de cada vez
		while (remaining >= 32) {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
			src += 32;
			dst += 32;
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 para copiar os bytes restantes
		while (remaining >= 16) {
			_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), _mm_loadu_si128(reinterpret_cast<const __m128i*>(src)));
			src += 16;
			dst += 16;
			remaining -= 16;
		}
		while (remaining >= 8) {
			_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(src)));
			src += 8;
			dst += 8;
			remaining -= 8;
		}
		while (remaining >= 4) {
			*reinterpret_cast<uint32_t*>(dst) = *reinterpret_cast<const uint32_t*>(src);
			src += 4;
			dst += 4;
			remaining -= 4;
		}
		while (remaining >= 2) {
			*reinterpret_cast<uint16_t*>(dst) = *reinterpret_cast<const uint16_t*>(src);
			src += 2;
			dst += 2;
			remaining -= 2;
		}
		while (remaining == 1) {
			*dst = *src;
			remaining -= 1;
		}
#else
		memcpy(dst, src, remaining);
#endif

		p += sizeof(T);
		return true;
	}

	bool readString(std::string &ret) {
		uint16_t strLen;
		if (!read<uint16_t>(strLen)) {
			return false;
		}

		if (size() < strLen) {
			return false;
		}

		char* str = new char[strLen + 1];
		const char* src = p;
		char* dst = str;
		size_t remaining = strLen;

#if defined(__AVX2__)
		// Use AVX2 para copiar 32 bytes de cada vez
		while (remaining >= 32) {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
			src += 32;
			dst += 32;
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 para copiar os bytes restantes
		while (remaining >= 16) {
			_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), _mm_loadu_si128(reinterpret_cast<const __m128i*>(src)));
			src += 16;
			dst += 16;
			remaining -= 16;
		}
		while (remaining >= 8) {
			_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(src)));
			src += 8;
			dst += 8;
			remaining -= 8;
		}
		while (remaining >= 4) {
			*reinterpret_cast<uint32_t*>(dst) = *reinterpret_cast<const uint32_t*>(src);
			src += 4;
			dst += 4;
			remaining -= 4;
		}
		while (remaining >= 2) {
			*reinterpret_cast<uint16_t*>(dst) = *reinterpret_cast<const uint16_t*>(src);
			src += 2;
			dst += 2;
			remaining -= 2;
		}
		while (remaining == 1) {
			*dst = *src;
			remaining -= 1;
		}
#else
		memcpy(dst, src, remaining);
#endif

		str[strLen] = 0; // Null-terminate the string
		ret.assign(str, strLen);
		delete[] str;
		p += strLen;
		return true;
	}

	bool skip(size_t n) {
		if (size() < n) {
			return false;
		}

		p += n;
		return true;
	}

private:
	const char* p = nullptr;
	const char* end = nullptr;
};

class PropWriteStream {
public:
	PropWriteStream() = default;

	// non-copyable
	PropWriteStream(const PropWriteStream &) = delete;
	PropWriteStream &operator=(const PropWriteStream &) = delete;

	const char* getStream(size_t &size) const {
		size = buffer.size();
		return buffer.data();
	}

	void clear() {
		buffer.clear();
	}

	template <typename T>
	void write(T add) {
		char* addr = reinterpret_cast<char*>(&add);
		size_t remaining = sizeof(T);
		size_t pos = buffer.size();
		buffer.resize(pos + remaining);

		char* dst = buffer.data() + pos;

#if defined(__AVX2__)
		// Use AVX2 para copiar 32 bytes de cada vez
		while (remaining >= 32) {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(addr)));
			addr += 32;
			dst += 32;
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 para copiar os bytes restantes
		while (remaining >= 16) {
			_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), _mm_loadu_si128(reinterpret_cast<const __m128i*>(addr)));
			addr += 16;
			dst += 16;
			remaining -= 16;
		}
		while (remaining >= 8) {
			_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(addr)));
			addr += 8;
			dst += 8;
			remaining -= 8;
		}
		while (remaining >= 4) {
			*reinterpret_cast<uint32_t*>(dst) = *reinterpret_cast<const uint32_t*>(addr);
			addr += 4;
			dst += 4;
			remaining -= 4;
		}
		while (remaining >= 2) {
			*reinterpret_cast<uint16_t*>(dst) = *reinterpret_cast<const uint16_t*>(addr);
			addr += 2;
			dst += 2;
			remaining -= 2;
		}
		if (remaining == 1) {
			*dst = *addr;
		}
#else
		std::copy(addr, addr + remaining, std::back_inserter(buffer));
#endif
	}

	void writeString(const std::string &str) {
		size_t strLength = str.size();
		if (strLength > std::numeric_limits<uint16_t>::max()) {
			write<uint16_t>(0);
			return;
		}

		write(static_cast<uint16_t>(strLength));

		const char* src = str.data();
		size_t remaining = strLength;
		size_t pos = buffer.size();
		buffer.resize(pos + remaining);

		char* dst = buffer.data() + pos;

#if defined(__AVX2__)
		// Use AVX2 para copiar 32 bytes de cada vez
		while (remaining >= 32) {
			_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
			src += 32;
			dst += 32;
			remaining -= 32;
		}
#endif

#if defined(__SSE2__)
		// Use SSE2 para copiar os bytes restantes
		while (remaining >= 16) {
			_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), _mm_loadu_si128(reinterpret_cast<const __m128i*>(src)));
			src += 16;
			dst += 16;
			remaining -= 16;
		}
		while (remaining >= 8) {
			_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(src)));
			src += 8;
			dst += 8;
			remaining -= 8;
		}
		while (remaining >= 4) {
			*reinterpret_cast<uint32_t*>(dst) = *reinterpret_cast<const uint32_t*>(src);
			src += 4;
			dst += 4;
			remaining -= 4;
		}
		while (remaining >= 2) {
			*reinterpret_cast<uint16_t*>(dst) = *reinterpret_cast<const uint16_t*>(src);
			src += 2;
			dst += 2;
			remaining -= 2;
		}
		if (remaining == 1) {
			*dst = *src;
		}
#else
		// Fallback para std::copy se nem AVX2 nem SSE2 estiverem disponíveis
		std::copy(src, src + remaining, std::back_inserter(buffer));
#endif
	}

private:
	std::vector<char> buffer;
};
