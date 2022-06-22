/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_UTILS_PROP_STREAM_HPP_
#define SRC_UTILS_PROP_STREAM_HPP_

#include <limits>
#include <vector>

#include "declarations.hpp"

class PropStream
{
	public:
		void init(const char* initBuffer, size_t initSize) {
			buffer = initBuffer;
			end = buffer + initSize;
		}

		size_t size() const {
			return end - buffer;
		}

		template <typename T>
		bool read(T& byteType) {
			if (size() < sizeof(T)) {
				return false;
			}

			memcpy(&byteType, buffer, sizeof(T));
			buffer += sizeof(T);
			return true;
		}

		bool readString(std::string& byteString) {
			uint16_t byte;
			if (!read<uint16_t>(byte)) {
				return false;
			}

			if (size() < byte) {
				return false;
			}

			std::unique_ptr<char[]> string = std::make_unique<char[]>(byte + 1);
			memcpy(string.get(), buffer, byte);
			string[byte] = 0;
			byteString.assign(string.get(), byte);
			buffer += byte;
			return true;
		}

		bool skip(size_t skipByte) {
			if (size() < skipByte) {
				return false;
			}

			buffer += skipByte;
			return true;
		}

	private:
		const char* buffer = nullptr;
		const char* end = nullptr;
};

class PropWriteStream
{
	public:
		PropWriteStream() = default;

		NONCOPYABLE(PropWriteStream);

		const char* getStream(size_t& size) const {
			size = buffer.size();
			return buffer.data();
		}

		void clear() {
			buffer.clear();
		}

		template <typename T>
		void write(T add) {
			auto charPointer = std::bit_cast<char*>(&add);
			std::copy(charPointer, charPointer + sizeof(T), std::back_inserter(buffer));
		}

		void writeString(std::string string) {
			size_t strLength = string.size();
			if (strLength > std::numeric_limits<uint16_t>::max()) {
				write<uint16_t>(0);
				return;
			}

			write(static_cast<uint16_t>(strLength));
			std::ranges::copy(string.begin(), string.end(), std::back_inserter(buffer));
		}

	private:
		std::vector<char> buffer;
};

#endif  // SRC_UTILS_PROP_STREAM_HPP_
