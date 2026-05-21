/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <array>
#include <bit>
#include <cstring>
#include <span>

class FileStream {
public:
	FileStream(const char* begin, const char* end) :
		m_data(reinterpret_cast<const uint8_t*>(begin), static_cast<size_t>(end - begin)) {
	}

	explicit FileStream(const mio::mmap_source &source) :
		FileStream(source.begin(), source.end()) {
	}

	void back(uint32_t pos = 1);
	void seek(uint32_t pos);
	void skip(uint32_t len);
	uint32_t size() const;
	uint32_t tell() const;

	bool startNode(uint8_t type = 0);
	bool endNode();
	bool isProp(uint8_t prop, bool toNext = true);

	uint8_t getU8() {
		if (m_pos + 1 > m_data.size()) {
			g_logger().error("Failed to getU8");
			return {};
		}

		if (m_nodes > 0 && m_data[m_pos] == OTB::Node::ESCAPE) {
			++m_pos;
		}

		return m_data[m_pos++];
	}

	uint16_t getU16() {
		uint16_t v = 0;
		read(v, m_nodes > 0);
		return v;
	}

	uint32_t getU32() {
		uint32_t v = 0;
		read(v, m_nodes > 0);
		return v;
	}

	uint64_t getU64() {
		uint64_t v = 0;
		read(v, m_nodes > 0);
		return v;
	}

	std::string getString();

private:
	template <typename T>
	bool read(T &ret, bool escape = false) {
		static_assert(std::is_trivially_copyable_v<T>, "Type T must be trivially copyable");

		constexpr auto size = sizeof(T);

		if (m_pos + size > m_data.size()) {
			g_logger().error("Read failed");
			return false;
		}

		if (escape) {
			std::array<uint8_t, size> array {};
			for (uint_fast8_t i = 0; i < size; ++i) {
				if (m_data[m_pos] == OTB::Node::ESCAPE) {
					++m_pos;
				}
				array[i] = m_data[m_pos++];
			}
			ret = std::bit_cast<T>(array);
			return true;
		}

		std::memcpy(&ret, m_data.data() + m_pos, size);
		m_pos += size;
		return true;
	}

	uint32_t m_nodes { 0 };
	uint32_t m_pos { 0 };

	std::span<const uint8_t> m_data;
};
