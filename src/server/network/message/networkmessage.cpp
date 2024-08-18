/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "server/network/message/networkmessage.hpp"
#include "items/containers/container.hpp"

int32_t NetworkMessage::decodeHeader() {
	int32_t newSize = buffer[0] | buffer[1] << 8;
	info.length = newSize;
	return info.length;
}

std::string NetworkMessage::getString(uint16_t stringLen /* = 0*/) {
	if (stringLen == 0) {
		stringLen = get<uint16_t>();
	}

	if (!canRead(stringLen)) {
		return std::string();
	}

	char* v = reinterpret_cast<char*>(buffer) + info.position; // does not break strict aliasing
	info.position += stringLen;
	return std::string(v, stringLen);
}

Position NetworkMessage::getPosition() {
	Position pos;
	pos.x = get<uint16_t>();
	pos.y = get<uint16_t>();
	pos.z = getByte();
	return pos;
}

void NetworkMessage::addString(const std::string &value, const std::string &function /* = ""*/) {
	size_t stringLen = value.length();
	if (value.empty() && !function.empty()) {
		g_logger().debug("[NetworkMessage::addString] - Value string is empty, function '{}'", function);
	}
	if (!canAdd(stringLen + 2)) {
		g_logger().error("[NetworkMessage::addString] - NetworkMessage size is wrong: {}, function '{}'", stringLen, function);
		return;
	}
	if (stringLen > NETWORKMESSAGE_MAXSIZE) {
		g_logger().error("[NetworkMessage::addString] - Exceeded NetworkMessage max size: {}, actual size: {}, function '{}'", NETWORKMESSAGE_MAXSIZE, stringLen, function);
		return;
	}

	add<uint16_t>(stringLen);

	unsigned char* dst = buffer + info.position;
	const auto* src = reinterpret_cast<const unsigned char*>(value.c_str());
	size_t remaining = stringLen;

#if defined(__AVX2__)
	// Use AVX2 to copy 32 bytes at a time
	while (remaining >= 32) {
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
		src += 32;
		dst += 32;
		remaining -= 32;
	}
#endif

#if defined(__SSE2__)
	// Use SSE2 to copy remaining bytes
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

	info.position += stringLen;
	info.length += stringLen;
}

void NetworkMessage::addDouble(double value, uint8_t precision /* = 2*/) {
	addByte(precision);
	add<uint32_t>((value * std::pow(static_cast<float>(10), precision)) + std::numeric_limits<int32_t>::max());
}

void NetworkMessage::addBytes(const char* bytes, size_t size) {
	if (bytes == nullptr) {
		g_logger().error("[NetworkMessage::addBytes] - Bytes is nullptr");
		return;
	}
	if (!canAdd(size)) {
		g_logger().error("[NetworkMessage::addBytes] - NetworkMessage size is wrong: {}", size);
		return;
	}
	if (size > NETWORKMESSAGE_MAXSIZE) {
		g_logger().error("[NetworkMessage::addBytes] - Exceeded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, size);
		return;
	}

	unsigned char* dst = buffer + info.position;
	const auto* src = reinterpret_cast<const unsigned char*>(bytes);
	size_t remaining = size;

#if defined(__AVX2__)
	// Use AVX2 to copy 32 bytes at a time
	while (remaining >= 32) {
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), _mm256_loadu_si256(reinterpret_cast<const __m256i*>(src)));
		src += 32;
		dst += 32;
		remaining -= 32;
	}
#endif

#if defined(__SSE2__)
	// Use SSE2 to copy remaining bytes
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

	info.position += size;
	info.length += size;
}

void NetworkMessage::addPaddingBytes(size_t n) {
#define canAdd(size) ((size + info.position) < NETWORKMESSAGE_MAXSIZE)
	if (!canAdd(n)) {
		return;
	}
#undef canAdd

	unsigned char* dst = buffer + info.position;
	size_t remaining = n;

#if defined(__AVX2__)
	const __m256i padding_avx2 = _mm256_set1_epi8(0x33); // AVX2: 32 bytes de valor de preenchimento

	// Use AVX2 para preencher 32 bytes de cada vez
	while (remaining >= 32) {
		_mm256_storeu_si256(reinterpret_cast<__m256i*>(dst), padding_avx2);
		dst += 32;
		remaining -= 32;
	}
#endif

#if defined(__SSE2__)
	const __m128i padding_sse2 = _mm_set1_epi8(0x33); // SSE2: 16 bytes de valor de preenchimento

	// Use SSE2 para preencher os bytes restantes
	while (remaining >= 16) {
		_mm_storeu_si128(reinterpret_cast<__m128i*>(dst), padding_sse2);
		dst += 16;
		remaining -= 16;
	}
	while (remaining >= 8) {
		_mm_storel_epi64(reinterpret_cast<__m128i*>(dst), _mm_loadl_epi64(reinterpret_cast<const __m128i*>(&padding_sse2)));
		dst += 8;
		remaining -= 8;
	}
	while (remaining >= 4) {
		*reinterpret_cast<uint32_t*>(dst) = 0x33333333; // Preencher 4 bytes com 0x33
		dst += 4;
		remaining -= 4;
	}
	while (remaining >= 2) {
		*reinterpret_cast<uint16_t*>(dst) = 0x3333; // Preencher 2 bytes com 0x33
		dst += 2;
		remaining -= 2;
	}
	while (remaining == 1) {
		*dst = 0x33; // Preencher 1 byte com 0x33
		remaining -= 1;
	}
#else
	memset(dst, 0x33, remaining);
#endif

	info.length += n;
}

void NetworkMessage::addPosition(const Position &pos) {
	add<uint16_t>(pos.x);
	add<uint16_t>(pos.y);
	addByte(pos.z);
}
