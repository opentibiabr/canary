/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

class FileStream {
public:
	FileStream(const char* begin, const char* end) {
		m_data.insert(m_data.end(), begin, end);
	}

	explicit FileStream(mio::mmap_source source) {
		m_data.insert(m_data.end(), source.begin(), source.end());
	}

	void back(uint32_t pos = 1);
	void seek(uint32_t pos);
	void skip(uint32_t len);
	uint32_t size() const;
	uint32_t tell() const;

	bool startNode(uint8_t type = 0);
	bool endNode();
	bool isProp(uint8_t prop, bool toNext = true);

	uint8_t getU8();
	uint16_t getU16();
	uint32_t getU32();
	uint64_t getU64();
	std::string getString();

private:
	template <typename T>
	bool read(T &ret, bool escape = false);
	uint32_t m_nodes { 0 };
	uint32_t m_pos { 0 };

	std::vector<uint8_t> m_data;
};
