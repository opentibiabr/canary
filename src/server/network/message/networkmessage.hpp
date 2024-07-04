/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "utils/const.hpp"
#include "declarations.hpp"

class Item;
class Creature;
class Player;
struct Position;
class RSA;

class NetworkMessage {
public:
	using MsgSize_t = uint16_t;
	// Headers:
	// 2 bytes for unencrypted message size
	// 4 bytes for checksum
	// 2 bytes for encrypted message size
	static constexpr MsgSize_t INITIAL_BUFFER_POSITION = 8;

	NetworkMessage() = default;

	void reset() {
		info = {};
	}

	// simply read functions for incoming message
	uint8_t getByte() {
		if (!canRead(1)) {
			return 0;
		}

		return buffer[info.position++];
	}

	uint8_t getPreviousByte() {
		return buffer[--info.position];
	}

	template <typename T>
	T get() {
		if (!canRead(sizeof(T))) {
			return 0;
		}

		T v;
		memcpy(&v, buffer + info.position, sizeof(T));
		info.position += sizeof(T);
		return v;
	}

	std::string getString(uint16_t stringLen = 0);
	Position getPosition();

	// skips count unknown/unused bytes in an incoming message
	void skipBytes(int16_t count) {
		info.position += count;
	}

	// simply write functions for outgoing message
	void addByte(uint8_t value) {
		if (!canAdd(1)) {
			return;
		}

		buffer[info.position++] = value;
		info.length++;
	}

	template <typename T>
	void add(T value) {
		if (!canAdd(sizeof(T))) {
			return;
		}

		memcpy(buffer + info.position, &value, sizeof(T));
		info.position += sizeof(T);
		info.length += sizeof(T);
	}

	void addBytes(const char* bytes, size_t size);
	void addPaddingBytes(size_t n);

	/**
	 * Adds a string to the network message buffer.
	 *
	 * @param value The string value to be added to the message buffer.
	 * @param function * @param function An optional parameter that specifies the function name from which `addString` is invoked.
	 * Including this enhances logging by adding the function name to the debug and error log messages.
	 * This helps in debugging by indicating the context when issues occur, such as attempting to add an
	 * empty string or when there are message size errors.
	 *
	 * When the function parameter is used, it aids in identifying the context in log messages,
	 * making it easier to diagnose issues related to network message construction,
	 * especially in complex systems where the same method might be called from multiple places.
	 */
	void addString(const std::string &value, const std::string &function = "");

	void addDouble(double value, uint8_t precision = 2);

	// write functions for complex types
	void addPosition(const Position &pos);

	MsgSize_t getLength() const {
		return info.length;
	}

	void setLength(MsgSize_t newLength) {
		info.length = newLength;
	}

	MsgSize_t getBufferPosition() const {
		return info.position;
	}

	void setBufferPosition(MsgSize_t newPosition) {
		info.position = newPosition;
	}

	uint16_t getLengthHeader() const {
		return static_cast<uint16_t>(buffer[0] | buffer[1] << 8);
	}

	int32_t decodeHeader();

	bool isOverrun() const {
		return info.overrun;
	}

	uint8_t* getBuffer() {
		return buffer;
	}

	const uint8_t* getBuffer() const {
		return buffer;
	}

	uint8_t* getBodyBuffer() {
		info.position = 2;
		return buffer + HEADER_LENGTH;
	}

protected:
	bool canAdd(size_t size) const {
		return (size + info.position) < MAX_BODY_LENGTH;
	}

	bool canRead(int32_t size) {
		if ((info.position + size) > (info.length + 8) || size >= (NETWORKMESSAGE_MAXSIZE - info.position)) {
			info.overrun = true;
			return false;
		}
		return true;
	}

	struct NetworkMessageInfo {
		MsgSize_t length = 0;
		MsgSize_t position = INITIAL_BUFFER_POSITION;
		bool overrun = false;
	};

	NetworkMessageInfo info;
	uint8_t buffer[NETWORKMESSAGE_MAXSIZE];
};
