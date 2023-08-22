/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/filestream.hpp"

#include "io/fileloader.hpp"

uint32_t FileStream::tell() const {
	return m_pos;
}

void FileStream::seek(uint32_t pos) {
	if (pos > m_data.size()) {
		throw std::ios_base::failure("Seek failed");
	}
	m_pos = pos;
}

void FileStream::skip(uint32_t len) {
	seek(tell() + len);
}

uint32_t FileStream::size() const {
	std::size_t size = m_data.size();
	if (size > std::numeric_limits<uint32_t>::max()) {
		throw std::overflow_error("File size exceeds uint32_t range");
	}

	return static_cast<uint32_t>(size);
}

template <typename T>
bool FileStream::read(T &ret, bool escape) {
	const auto size = sizeof(T);

	if (m_pos + size > m_data.size()) {
		throw std::ios_base::failure("Read failed");
	}

	std::array<uint8_t, sizeof(T)> array;
	if (escape) {
		for (int_fast8_t i = -1; ++i < size;) {
			if (m_data[m_pos] == OTB::Node::ESCAPE) {
				++m_pos;
			}
			array[i] = m_data[m_pos];
			++m_pos;
		}
		memcpy(&ret, array.data(), size);
	} else {
		memcpy(&ret, &m_data[m_pos], size);
		m_pos += size;
	}

	return true;
}

uint8_t FileStream::getU8() {
	uint8_t v = 0;

	if (m_pos + 1 > m_data.size()) {
		throw std::ios_base::failure("Failed to getU8");
	}

	// Fast Escape Val
	if (m_nodes > 0 && m_data[m_pos] == OTB::Node::ESCAPE) {
		++m_pos;
	}

	v = m_data[m_pos];
	++m_pos;

	return v;
}

uint16_t FileStream::getU16() {
	uint16_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

uint32_t FileStream::getU32() {
	uint32_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

uint64_t FileStream::getU64() {
	uint64_t v = 0;
	read(v, m_nodes > 0);
	return v;
}

std::string FileStream::getString() {
	std::string str;
	if (const uint16_t len = getU16(); len > 0 && len < 8192) {
		if (m_pos + len > m_data.size()) {
			throw std::ios_base::failure("[FileStream::getString] - Read failed");
		}

		str = { (char*)&m_data[m_pos], len };
		m_pos += len;
	} else if (len != 0) {
		throw std::ios_base::failure("[FileStream::getString] - Read failed because string is too big");
	}
	return str;
}

void FileStream::back(uint32_t pos) {
	m_pos -= pos;
}

bool FileStream::isProp(uint8_t prop, bool toNext) {
	if (getU8() == prop) {
		if (!toNext) {
			back();
		}
		return true;
	}

	back();
	return false;
}

bool FileStream::startNode(uint8_t type) {
	if (getU8() == OTB::Node::START) {
		if (type == 0 || getU8() == type) {
			++m_nodes;
			return true;
		}

		back();
	}

	back();
	return false;
}

bool FileStream::endNode() {
	if (getU8() == OTB::Node::END) {
		--m_nodes;
		return true;
	}

	back();
	return false;
}
