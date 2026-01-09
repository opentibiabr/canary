/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "server/network/message/networkmessage.hpp"
#include "server/network/connection/connection.hpp"

class Protocol;

class OutputMessage : public NetworkMessage {
public:
	OutputMessage() = default;
	virtual ~OutputMessage() = default;

	// non-copyable
	OutputMessage(const OutputMessage &) = delete;
	OutputMessage &operator=(const OutputMessage &) = delete;

	uint8_t* getOutputBuffer() {
		return buffer.data() + outputBufferStart;
	}

	void writePaddingAmount() {
		uint8_t paddingAmount = 8 - (info.length % 8) - 1;
		addPaddingBytes(paddingAmount);
		add_header(paddingAmount);
	}

	void writeMessageLength() {
		add_header(static_cast<uint16_t>((info.length - 4) / 8));
	}

	void addCryptoHeader(bool addChecksum, uint32_t checksum) {
		if (addChecksum) {
			add_header(checksum);
		}

		writeMessageLength();
	}

	void append(const NetworkMessage &msg) {
		auto msgLen = msg.getLength();
		if (std::memcpy(buffer.data() + info.position, msg.getBuffer() + INITIAL_BUFFER_POSITION, msgLen) == nullptr) {
			g_logger().error("[{}] memcpy failed while appending message", __FUNCTION__);
			return;
		}
		info.length += msgLen;
		info.position += msgLen;
	}

	void append(const OutputMessage_ptr &msg) {
		auto msgLen = msg->getLength();
		if (std::memcpy(buffer.data() + info.position, msg->getBuffer() + INITIAL_BUFFER_POSITION, msgLen) == nullptr) {
			g_logger().error("[{}] memcpy failed while appending output message", __FUNCTION__);
			return;
		}
		info.length += msgLen;
		info.position += msgLen;
	}

private:
	template <typename T>
	void add_header(T addHeader) {
		if (outputBufferStart < sizeof(T)) {
			g_logger().error("[{}]: Insufficient buffer space for header!", __FUNCTION__);
			return;
		}

		// Ensure at runtime that outputBufferStart >= sizeof(T)
		assert(outputBufferStart >= sizeof(T));
		// Move the buffer position back to make space for the header
		outputBufferStart -= sizeof(T);

		static_assert(std::is_trivially_copyable_v<T>, "Type T must be trivially copyable");

		// Convert the header to an array of unsigned char using std::bit_cast
		auto byteArray = std::bit_cast<std::array<unsigned char, sizeof(T)>>(addHeader);

		// Copy the bytes into the buffer
		if (std::memcpy(buffer.data() + outputBufferStart, byteArray.data(), byteArray.size()) == nullptr) {
			g_logger().error("[{}] memcpy failed while adding header", __FUNCTION__);
			return;
		}
		// Update the message size
		info.length += sizeof(T);
	}

	MsgSize_t outputBufferStart = INITIAL_BUFFER_POSITION;
};

class OutputMessagePool {
public:
	OutputMessagePool() = default;

	// non-copyable
	OutputMessagePool(const OutputMessagePool &) = delete;
	OutputMessagePool &operator=(const OutputMessagePool &) = delete;

	static OutputMessagePool &getInstance();

	void sendAll();
	void scheduleSendAll();

	static OutputMessage_ptr getOutputMessage();

	void addProtocolToAutosend(const Protocol_ptr &protocol);
	void removeProtocolFromAutosend(const Protocol_ptr &protocol);

private:
	// NOTE: A vector is used here because this container is mostly read
	// and relatively rarely modified (only when a client connects/disconnects)
	std::vector<Protocol_ptr> bufferedProtocols;
};
