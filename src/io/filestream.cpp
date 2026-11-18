/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/filestream.hpp"

#include "io/fileloader.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <vector>
#endif

[[nodiscard]] uint32_t FileStream::tell() const {
	return m_pos;
}

void FileStream::seek(uint32_t pos) {
	if (pos > m_data.size()) {
		g_logger().error("Seek failed");
		return;
	}
	m_pos = pos;
}

void FileStream::skip(uint32_t len) {
	seek(tell() + len);
}

[[nodiscard]] uint32_t FileStream::size() const {
	std::size_t size = m_data.size();
	if (size > std::numeric_limits<uint32_t>::max()) {
		g_logger().error("File size exceeds uint32_t range");
		return {};
	}

	return static_cast<uint32_t>(size);
}

std::string FileStream::getString() {
	std::string str;
	if (const uint16_t len = getU16(); len > 0 && len < 8192) {
		if (m_pos + len > m_data.size()) {
			g_logger().error("[FileStream::getString] - Read failed");
			return {};
		}

		str.assign(reinterpret_cast<const char*>(m_data.data() + m_pos), len);
		m_pos += len;
	} else if (len != 0) {
		g_logger().error("[FileStream::getString] - Read failed because string is too big");
	}
	return str;
}

void FileStream::back(uint32_t pos) {
	m_pos -= pos;
}

bool FileStream::readNodeProperties(const std::function<bool(std::span<const uint8_t>, size_t &)> &decode) {
	size_t end = m_pos;
	bool escaped = false;
	while (end < m_data.size() && m_data[end] != OTB::Node::START && m_data[end] != OTB::Node::END) {
		if (m_data[end++] == OTB::Node::ESCAPE) {
			if (end == m_data.size()) {
				return false;
			}
			escaped = true;
			++end;
		}
	}
	if (end == m_data.size()) {
		return false;
	}
	auto bytes = m_data.subspan(m_pos, end - m_pos);
	std::vector<uint8_t> unescaped;
	if (escaped) {
		unescaped.reserve(bytes.size());
		for (size_t i = 0; i < bytes.size(); ++i) {
			if (bytes[i] == OTB::Node::ESCAPE) {
				++i;
			}
			unescaped.push_back(bytes[i]);
		}
		bytes = unescaped;
	}
	size_t consumed = 0;
	if (!decode(bytes, consumed) || consumed > bytes.size()) {
		return false;
	}
	if (!escaped) {
		m_pos += static_cast<uint32_t>(consumed);
	} else {
		for (size_t i = 0; i < consumed; ++i) {
			m_pos += m_data[m_pos] == OTB::Node::ESCAPE ? 2 : 1;
		}
	}
	return true;
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
