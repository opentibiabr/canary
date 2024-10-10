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

struct IntervalInfo;
struct Outfit_t;

#ifndef PRECOMPILED_HEADERS
	#include <array>
	#include <list>
	#include <string>
	#include <vector>
	#include <mio/mmap.hpp>
#endif

namespace OTB {
	using Identifier = std::array<char, 4>;

	struct Node {
		Node() = default;
		Node(Node &&) = default;
		Node &operator=(Node &&) = default;
		Node(const Node &) = delete;
		Node &operator=(const Node &) = delete;

		std::list<Node> children;
		mio::mmap_source::const_iterator propsBegin;
		mio::mmap_source::const_iterator propsEnd;
		uint8_t type;
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
	PropStream() = default;
	explicit PropStream(const std::vector<uint8_t> &attributes);

	void init(const std::vector<uint8_t> &attributes);

	size_t size() const;

	bool readU8(uint8_t &value);
	bool readU16(uint16_t &value);
	bool readU32(uint32_t &value);
	bool readU64(uint64_t &value);
	bool readI8(int8_t &value);
	bool readI16(int16_t &value);
	bool readI32(int32_t &value);
	bool readI64(int64_t &value);
	bool readDouble(double &value);
	bool readFloat(float &value);
	bool readBool(bool &value);
	bool readIntervalInfo(IntervalInfo &info);
	bool readOutfit(Outfit_t &outfit);

	bool readString(std::string &ret);

	bool skip(size_t n);

private:
	std::vector<uint8_t> buffer;
	size_t pos = 0;
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

	std::pair<const char*, size_t> getStream() const {
		return { buffer.data(), buffer.size() };
	}

	void clear() {
		buffer.clear();
	}

	template <typename T>
	void write(T add) {
		char* addr = reinterpret_cast<char*>(&add);
		std::copy(addr, addr + sizeof(T), std::back_inserter(buffer));
	}

	void writeString(const std::string &str) {
		size_t strLength = str.size();
		if (strLength > std::numeric_limits<uint16_t>::max()) {
			write<uint16_t>(0);
			return;
		}

		write(static_cast<uint16_t>(strLength));
		std::copy(str.begin(), str.end(), std::back_inserter(buffer));
	}

private:
	std::vector<char> buffer;
};
