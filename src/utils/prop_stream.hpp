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
		void init(const char* a, size_t size) {
			p = a;
			end = a + size;
		}

		size_t size() const {
			return end - p;
		}

		template <typename T>
		bool read(T& ret) {
			if (size() < sizeof(T)) {
				return false;
			}

			memcpy(&ret, p, sizeof(T));
			p += sizeof(T);
			return true;
		}

		bool readString(std::string& ret) {
			uint16_t strLen;
			if (!read<uint16_t>(strLen)) {
				return false;
			}

			if (size() < strLen) {
				return false;
			}

			auto str = new char[strLen + 1];
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
