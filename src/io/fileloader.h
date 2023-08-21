/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_IO_FILELOADER_H_
#define SRC_IO_FILELOADER_H_

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

			memcpy(&ret, p, sizeof(T));
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
			memcpy(str, p, strLen);
			str[strLen] = 0;
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

class FileStream {
	public:
		FileStream(const char* begin, const char* end) {
			m_data.insert(m_data.end(), begin, end);
		}

		FileStream(mio::mmap_source source) {
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

#endif // SRC_IO_FILELOADER_H_
