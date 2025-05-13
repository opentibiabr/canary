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
	// 1 byte for padding message size
	static constexpr MsgSize_t INITIAL_BUFFER_POSITION = 7;

	int32_t decodeHeader();

	void reset() {
		info = {};
	}

	// simply read functions for incoming message
	uint8_t getByte(bool suppresLog = false, const std::source_location &location = std::source_location::current());

	uint8_t getPreviousByte();

	template <typename T>
	T get() {
		static_assert(!std::is_same_v<T, double>, "Error: get<double>() is not allowed. Use getDouble() instead.");
		static_assert(std::is_trivially_copyable_v<T>, "Type T must be trivially copyable");
		if (!canRead(sizeof(T))) {
			return T();
		}

		// Create a temporary byte array to store the value read from the buffer.
		std::array<unsigned char, sizeof(T)> tempBuffer;
		// Copy data from the buffer to the temporary array
		std::span<const unsigned char> sourceSpan(buffer.data() + info.position, sizeof(T));
		std::ranges::copy(sourceSpan, tempBuffer.begin());
		// Update the read position in the buffer
		info.position += sizeof(T);
		// Convert the byte array to type T using std::bit_cast and return the result
		return std::bit_cast<T>(tempBuffer);
	}

	std::string getString(uint16_t stringLen = 0, const std::source_location &location = std::source_location::current());
	Position getPosition();

	// skips count unknown/unused bytes in an incoming message
	void skipBytes(int16_t count);

	// simply write functions for outgoing message
	void addByte(uint8_t value, std::source_location location = std::source_location::current());

	template <typename T>
	void add(T value, std::source_location location = std::source_location::current()) {
		static_assert(!std::is_same_v<T, double>, "Error: get<double>() is not allowed. Use addDouble() instead.");
		static_assert(std::is_trivially_copyable_v<T>, "Type T must be trivially copyable");

		if (!canAdd(sizeof(T))) {
			g_logger().error("Cannot add value of size '{}', buffer size: '{}' overflow. Called at line '{}:{}' in '{}'", sizeof(T), buffer.size(), location.line(), location.column(), location.function_name());
			return;
		}

		if (info.position + sizeof(T) > buffer.size()) {
			g_logger().error("Buffer overflow detected, current position: '{}', value size: '{}', buffer size: '{}'. Called at line '{}:{}' in '{}'", info.position, sizeof(T), buffer.size(), location.line(), location.column(), location.function_name());
			return;
		}

		// Convert the value to an array of unsigned char using std::bit_cast
		auto byteArray = std::bit_cast<std::array<unsigned char, sizeof(T)>>(value);

		// Create a span from the byte array
		std::span<const unsigned char> byteSpan(byteArray);

		// Check if the size of byteSpan can fit into the buffer
		if (byteSpan.size() > (buffer.size() - info.position)) {
			g_logger().error("Buffer overflow during span copy. Source span size: {}, buffer available space: {}", byteSpan.size(), buffer.size() - info.position);
			return;
		}

		g_logger().trace("[{}] called at line '{}:{}' in '{}'", __FUNCTION__, location.line(), location.column(), location.function_name());

		std::ranges::copy(byteSpan, buffer.begin() + info.position);

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

	void addDouble(double value, uint8_t precision = 4);
	double getDouble();

	// write functions for complex types
	void addPosition(const Position &pos);

	MsgSize_t getLength() const;

	void setLength(MsgSize_t newLength);

	MsgSize_t getBufferPosition() const;

	void setBufferPosition(MsgSize_t newPosition);

	uint16_t getLengthHeader() const;

	bool isOverrun() const;

	uint8_t* getBuffer();

	const uint8_t* getBuffer() const;

	uint8_t* getBodyBuffer();

	bool canAdd(size_t size) const;

	bool canRead(int32_t size) const;

	void append(const NetworkMessage &other);

protected:
	struct NetworkMessageInfo {
		MsgSize_t length = 0;
		MsgSize_t position = INITIAL_BUFFER_POSITION;
		bool overrun = false;
	};

	NetworkMessageInfo info;
	std::array<uint8_t, NETWORKMESSAGE_MAXSIZE> buffer = {};
};
