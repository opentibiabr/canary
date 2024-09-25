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

	NetworkMessage() : buffer(NETWORKMESSAGE_MAXSIZE, 0) {}

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
		if (info.position == 0) {
			g_logger().error("Attempted to get previous byte at position 0");
			return 0;
		}
		return buffer[--info.position];
	}

	template <typename T>
	T get() {
		if (!canRead(sizeof(T))) {
			return T();
		}

		T v;
		memcpy(&v, buffer.data() + info.position, sizeof(T));
		info.position += sizeof(T);
		return v;
	}

	std::string getString(uint16_t stringLen = 0, const std::source_location &location = std::source_location::current());
	Position getPosition();

	// skips count unknown/unused bytes in an incoming message
	void skipBytes(int16_t count) {
		info.position += count;
	}

	// simply write functions for outgoing message
	void addByte(uint8_t value) {
		if (!canAdd(1)) {
			g_logger().error("Cannot add byte, buffer overflow");
			return;
		}

		buffer[info.position++] = value;
		info.length++;
	}

	template <typename T>
	void add(T value) {
		if (!canAdd(sizeof(T))) {
			g_logger().error("Cannot add value of size {}, buffer overflow", sizeof(T));
			return;
		}

		memcpy(buffer.data() + info.position, &value, sizeof(T));
		info.position += sizeof(T);
		info.length += sizeof(T);
	}

	void addBytes(const char* bytes, size_t size);
	void addPaddingBytes(size_t n);

	/**
	 * Adds a string to the network message buffer.
	 *
	 * @param value The string value to be added to the message buffer.
	 *
	 * @param location An optional parameter that captures the location from which `addString` is invoked.
	 * This enhances logging by including the file name, line number, and function name
	 * in debug and error log messages. It helps in debugging by indicating the context when issues occur,
	 * such as attempting to add an empty string or when there are message size errors.
	 *
	 * Using `std::source_location` automatically captures the caller context, making it easier
	 * to diagnose issues related to network message construction, especially in complex systems
	 * where the same method might be called from multiple places.
	 *
	 * @param function An optional string parameter provided from Lua that specifies the name of the Lua
	 * function or context from which `addString` is called. When this parameter is not empty,
	 * it overrides the information captured by `std::source_location` in log messages.
	 * This allows for more precise and meaningful logging in scenarios where `addString` is invoked
	 * directly from Lua scripts, enabling developers to trace the origin of network messages
	 * back to specific Lua functions or contexts.
	 *
	 * This dual-parameter approach ensures flexibility:
	 * - When called from C++ without specifying `function`, `std::source_location` provides the necessary
	 *   context for logging.
	 * - When called from Lua with a `function` name, the provided string offers clearer insight into
	 *   the Lua-side invocation, enhancing the ability to debug and maintain Lua-C++ integrations.
	 *
	 * @note It is recommended to use the `function` parameter when invoking `addString` from Lua to ensure
	 * that log messages accurately reflect the Lua context. When invoking from C++, omitting the `function`
	 * parameter allows `std::source_location` to automatically capture the C++ context.
	 */
	void addString(const std::string &value, const std::source_location &location = std::source_location::current(), const std::string &function = "");

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
		return buffer.data();
	}

	const uint8_t* getBuffer() const {
		return buffer.data();
	}

	uint8_t* getBodyBuffer() {
		info.position = 2;
		return buffer.data() + HEADER_LENGTH;
	}

protected:
	bool canAdd(size_t size) const {
		return (size + info.position) < MAX_BODY_LENGTH;
	}

	bool canRead(int32_t size) {
		return size <= (info.length - (info.position - INITIAL_BUFFER_POSITION));
	}

	struct NetworkMessageInfo {
		MsgSize_t length = 0;
		MsgSize_t position = INITIAL_BUFFER_POSITION;
		bool overrun = false;
	};

	NetworkMessageInfo info;
	std::vector<uint8_t> buffer;
};
