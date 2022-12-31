/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO_FILELOADER_H_
#define SRC_IO_FILELOADER_H_

class PropStream;

namespace OTB {
	using Identifier = std::array < char, 4 > ;

	struct Node {
		Node() = default;
		Node(Node&&) = default;
		Node& operator=(Node&&) = default;
		Node(const Node&) = delete;
		Node& operator=(const Node&) = delete;

		std::list<Node> children;
		mio::mmap_source::const_iterator propsBegin;
		mio::mmap_source::const_iterator propsEnd;
		uint8_t type;
		enum NodeChar: uint8_t {
			ESCAPE = 0xFD,
			START = 0xFE,
			END = 0xFF,
		};
	};

	struct LoadError: std::exception {
		const char * what() const noexcept override = 0;
	};

	struct InvalidOTBFormat final: LoadError {
		const char * what() const noexcept override {
			return "Invalid OTBM file format";
		}
	};

	class Loader {
		mio::mmap_source fileContents;
		Node root;
		std::vector < char > propBuffer;
		public:
			Loader(const std::string & fileName,
				const Identifier & acceptedIdentifier);
		bool getProps(const Node & node, PropStream & props);
		const Node & parseTree();
	};

} //namespace OTB

class PropStream
{
	public:
		void init(const char* a, size_t size) {
			reading_position = a;
			end = a + size;
		}

		size_t size() const {
			return end - reading_position;
		}

		template <typename T>
		bool read(T& ret) {
			if (size() < sizeof(T)) {
				return false;
			}

			memcpy(&ret, reading_position, sizeof(T));
			reading_position += sizeof(T);
			return true;
		}

		// Reads a value of type T from the stream.
		template <typename T>
		T get() {
			// T must be a trivially copyable type
			static_assert(std::is_trivially_copyable_v<T>);

			T value = 0;
			// Return the value if the stream is not large enough to hold a value of type T
			if (size() < sizeof(T)) {
				return value;
			}

			// Copy the bytes from the stream into the value
			std::memmove(&value, reading_position, sizeof(T));

			// Advance the cursor by the size of T
			reading_position += sizeof(T);

			return value;
		}

		bool readString(std::string& ret) {
			uint16_t strLen;
			if (!read<uint16_t>(strLen)) {
				return false;
			}

			if (size() < strLen) {
				return false;
			}

			char* str = new char[strLen + 1];
			memcpy(str, reading_position, strLen);
			str[strLen] = 0;
			ret.assign(str, strLen);
			delete[] str;
			reading_position += strLen;
			return true;
		}

		std::string getString() {
			uint16_t strLen;
			if (!read<uint16_t>(strLen)) {
				return "";
			}

			if (size() < strLen) {
				return "";
			}

			std::stringstream strStream;
			strStream.write(reading_position, strLen);
			std::string string = strStream.str();
			reading_position += strLen;
			return string;
		}

		bool skip(size_t n) {
			if (size() < n) {
				return false;
			}

			reading_position += n;
			return true;
		}

	private:
		const char* reading_position = nullptr;
		const char* end = nullptr;
};

class PropWriteStream
{
	public:
		PropWriteStream() = default;

		// non-copyable
		PropWriteStream(const PropWriteStream&) = delete;
		PropWriteStream& operator=(const PropWriteStream&) = delete;

		const char* getStream(size_t& size) const {
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

		void writeString(const std::string& str) {
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

#endif  // SRC_IO_FILELOADER_H_
