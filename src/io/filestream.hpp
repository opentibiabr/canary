/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <bit>
	#include <cstring>
	#include <span>
#endif

class FileStream {
public:
	// Non-owning view; callers must keep the source byte range alive.
	FileStream(const char* begin, const char* end) :
		m_data(reinterpret_cast<const uint8_t*>(begin), static_cast<size_t>(end - begin)) {
	}

	// The mapped file must outlive this stream because m_data does not own it.
	explicit FileStream(const mio::mmap_source &source) :
		FileStream(source.begin(), source.end()) {
	}

	void back(uint32_t pos = 1);
	void seek(uint32_t pos);
	void skip(uint32_t len);
	[[nodiscard]] uint32_t size() const;
	[[nodiscard]] uint32_t tell() const;

	bool startNode(uint8_t type = 0);
	bool endNode();
	bool isProp(uint8_t prop, bool toNext = true);

	uint8_t getU8() {
		if (m_nodes > 0) {
			uint8_t value = 0;
			if (!readEscapedByte(value, "Failed to getU8")) {
				return {};
			}

			return value;
		}

		if (m_pos >= m_data.size()) {
			g_logger().error("Failed to getU8");
			return {};
		}

		return m_data[m_pos++];
	}

	uint16_t getU16() {
		uint16_t v = 0;
		if (!read(v, m_nodes > 0)) {
			return {};
		}
		return v;
	}

	uint32_t getU32() {
		uint32_t v = 0;
		if (!read(v, m_nodes > 0)) {
			return {};
		}
		return v;
	}

	uint64_t getU64() {
		uint64_t v = 0;
		if (!read(v, m_nodes > 0)) {
			return {};
		}
		return v;
	}

	std::string getString();

private:
	bool readEscapedByte(uint8_t &value, const char* errorMessage) {
		if (m_pos >= m_data.size()) {
			g_logger().error(errorMessage);
			return false;
		}

		if (m_data[m_pos] == kOtbNodeEscapeByte) {
			++m_pos;
			if (m_pos >= m_data.size()) {
				g_logger().error(errorMessage);
				return false;
			}
		}

		value = m_data[m_pos++];
		return true;
	}

	template <typename T>
	bool read(T &ret, bool escape = false) {
		static_assert(std::is_trivially_copyable_v<T>, "Type T must be trivially copyable");

		constexpr auto size = sizeof(T);

		if (escape) {
			std::array<uint8_t, size> array {};
			for (uint_fast8_t i = 0; i < size; ++i) {
				if (!readEscapedByte(array[i], "Read failed")) {
					return false;
				}
			}
			ret = std::bit_cast<T>(array);
			return true;
		}

		if (m_pos + size > m_data.size()) {
			g_logger().error("Read failed");
			return false;
		}

		if (std::memcpy(&ret, m_data.data() + m_pos, size) != &ret) {
			return false;
		}
		m_pos += size;
		return true;
	}

	static constexpr uint8_t kOtbNodeEscapeByte = 0xFD;

	uint32_t m_nodes { 0 };
	uint32_t m_pos { 0 };

	std::span<const uint8_t> m_data;
};
