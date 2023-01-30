/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_SERVER_NETWORK_MESSAGE_OUTPUTMESSAGE_H_
#define SRC_SERVER_NETWORK_MESSAGE_OUTPUTMESSAGE_H_

#include "server/network/message/networkmessage.h"
#include "server/network/connection/connection.h"
#include "utils/tools.h"

class Protocol;

class OutputMessage : public NetworkMessage
{
	public:
		OutputMessage() = default;

		// non-copyable
		OutputMessage(const OutputMessage&) = delete;
		OutputMessage& operator=(const OutputMessage&) = delete;

		uint8_t* getOutputBuffer() {
			return buffer + outputBufferStart;
		}

		void writeMessageLength() {
			add_header(info.length);
		}

		void addCryptoHeader(bool addChecksum, uint32_t checksum) {
			if (addChecksum) {
				add_header(checksum);
			}

			writeMessageLength();
		}

		void append(const NetworkMessage& msg) {
			auto msgLen = msg.getLength();
			memcpy(buffer + info.position, msg.getBuffer() + INITIAL_BUFFER_POSITION, msgLen);
			info.length += msgLen;
			info.position += msgLen;
		}

		void append(const OutputMessage_ptr& msg) {
			auto msgLen = msg->getLength();
			memcpy(buffer + info.position, msg->getBuffer() + INITIAL_BUFFER_POSITION, msgLen);
			info.length += msgLen;
			info.position += msgLen;
		}

	private:
		template <typename T>
		void add_header(T addHeader) {
			assert(outputBufferStart >= sizeof(T));
			outputBufferStart -= sizeof(T);
			memcpy(buffer + outputBufferStart, &addHeader, sizeof(T));
			//added header size to the message size
			info.length += sizeof(T);
		}

		MsgSize_t outputBufferStart = INITIAL_BUFFER_POSITION;
};

class OutputMessagePool
{
	public:
		// non-copyable
		OutputMessagePool(const OutputMessagePool&) = delete;
		OutputMessagePool& operator=(const OutputMessagePool&) = delete;

		static OutputMessagePool& getInstance() {
			static OutputMessagePool instance;
			return instance;
		}

		void sendAll();
		void scheduleSendAll();

		static OutputMessage_ptr getOutputMessage();

		void addProtocolToAutosend(Protocol_ptr protocol);
		void removeProtocolFromAutosend(const Protocol_ptr& protocol);
	private:
		OutputMessagePool() = default;
		//NOTE: A vector is used here because this container is mostly read
		//and relatively rarely modified (only when a client connects/disconnects)
		std::vector<Protocol_ptr> bufferedProtocols;
};


#endif  // SRC_SERVER_NETWORK_MESSAGE_OUTPUTMESSAGE_H_
