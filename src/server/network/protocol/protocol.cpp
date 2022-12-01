/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "pch.hpp"

#include "server/network/protocol/protocol.h"
#include "server/network/message/outputmessage.h"
#include "security/rsa.h"
#include "game/scheduling/tasks.h"

Protocol::~Protocol() = default;

void Protocol::onSendMessage(const OutputMessage_ptr& msg)
{
	if (!rawMessages) {
		uint32_t sendMessageChecksum = 0;
		if (compreesionEnabled && msg->getLength() >= 128 && compression(*msg)) {
			sendMessageChecksum = (1U << 31);
		}

		msg->writeMessageLength();

		if (!encryptionEnabled) {
			return;
		}

		XTEA_encrypt(*msg);
		if (checksumMethod == CHECKSUM_METHOD_NONE) {
			msg->addCryptoHeader(false, 0);
		} else if (checksumMethod == CHECKSUM_METHOD_ADLER32) {
			msg->addCryptoHeader(true, adlerChecksum(msg->getOutputBuffer(), msg->getLength()));
		} else if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			msg->addCryptoHeader(true, sendMessageChecksum | (++serverSequenceNumber));
			if (serverSequenceNumber >= 0x7FFFFFFF) {
				serverSequenceNumber = 0;
			}
		}
	}
}

bool Protocol::sendRecvMessageCallback(NetworkMessage& msg)
{
	if (encryptionEnabled && !XTEA_decrypt(msg)) {
		SPDLOG_ERROR("[Protocol::onRecvMessage] - XTEA_decrypt Failed");
		return false;
	}

	auto protocolWeak = std::weak_ptr<Protocol>(shared_from_this());
	std::function<void (void)> callback = [protocolWeak, &msg]() {
		if (auto protocol = protocolWeak.lock()) {
			if (auto protocolConnection = protocol->getConnection()) {
				protocol->parsePacket(msg);
				protocolConnection->resumeWork();
			}
		}
	};
	g_dispatcher().addTask(createTask(callback));
	return true;
}

bool Protocol::onRecvMessage(NetworkMessage& msg)
{
	if (checksumMethod != CHECKSUM_METHOD_NONE) {
		uint32_t recvChecksum = msg.get<uint32_t>();
		if (checksumMethod == CHECKSUM_METHOD_SEQUENCE) {
			if (recvChecksum == 0) {
				// checksum 0 indicate that the packet should be connection ping - 0x1C packet header
				// since we don't need that packet skip it
				return false;
			}

			uint32_t checksum;
			checksum = ++clientSequenceNumber;
			if (clientSequenceNumber >= 0x7FFFFFFF) {
				clientSequenceNumber = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		} else {
			uint32_t checksum;
			if (int32_t len = msg.getLength() - msg.getBufferPosition();
			len > 0)
			{
				checksum = adlerChecksum(msg.getBuffer() + msg.getBufferPosition(), len);
			} else {
				checksum = 0;
			}

			if (recvChecksum != checksum) {
				// incorrect packet - skip it
				return false;
			}
		}
	}

	return sendRecvMessageCallback(msg);
}

OutputMessage_ptr Protocol::getOutputBuffer(int32_t size)
{
	//dispatcher thread
	if (!outputBuffer) {
		outputBuffer = OutputMessagePool::getOutputMessage();
	} else if ((outputBuffer->getLength() + size) > MAX_PROTOCOL_BODY_LENGTH) {
		send(outputBuffer);
		outputBuffer = OutputMessagePool::getOutputMessage();
	}
	return outputBuffer;
}

void Protocol::XTEA_encrypt(OutputMessage& msg) const
{
	const uint32_t delta = 0x61C88647;

	// The message must be a multiple of 8
	size_t paddingBytes = msg.getLength() & 7;
	if (paddingBytes != 0) {
		msg.addPaddingBytes(8 - paddingBytes);
	}

	uint8_t* buffer = msg.getOutputBuffer();
	auto messageLength = static_cast<int32_t>(msg.getLength());
	int32_t readPos = 0;
	const std::array<uint32_t, 4> newKey = {key[0], key[1], key[2], key[3]};
	// TODO: refactor this for not use c-style
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + newKey[sum & 3]);
		sum -= delta;
		precachedControlSum[i][1] = (sum + newKey[(sum >> 11) & 3]);
	}
	while (readPos < messageLength) {
		std::array<uint32_t, 2> vData = {};
		memcpy(vData.data(), buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[0] += ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][0];
			vData[1] += ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData.data(), 8);
		readPos += 8;
	}
}

bool Protocol::XTEA_decrypt(NetworkMessage& msg) const
{
	uint16_t msgLength = msg.getLength() - (checksumMethod == CHECKSUM_METHOD_NONE ? 2 : 6);
	if ((msgLength & 7) != 0) {
		return false;
	}

	const uint32_t delta = 0x61C88647;

	uint8_t* buffer = msg.getBuffer() + msg.getBufferPosition();
	auto messageLength = static_cast<int32_t>(msgLength);
	int32_t readPos = 0;
	const std::array<uint32_t, 4> newKey = {key[0], key[1], key[2], key[3]};
	// TODO: refactor this for not use c-style
	uint32_t precachedControlSum[32][2];
	uint32_t sum = 0xC6EF3720;
	for (int32_t i = 0; i < 32; ++i) {
		precachedControlSum[i][0] = (sum + newKey[(sum >> 11) & 3]);
		sum += delta;
		precachedControlSum[i][1] = (sum + newKey[sum & 3]);
	}
	while (readPos < messageLength) {
		std::array<uint32_t, 2> vData = {};
		memcpy(vData.data(), buffer + readPos, 8);
		for (int32_t i = 0; i < 32; ++i) {
			vData[1] -= ((vData[0] << 4 ^ vData[0] >> 5) + vData[0]) ^ precachedControlSum[i][0];
			vData[0] -= ((vData[1] << 4 ^ vData[1] >> 5) + vData[1]) ^ precachedControlSum[i][1];
		}
		memcpy(buffer + readPos, vData.data(), 8);
		readPos += 8;
	}

	uint16_t innerLength = msg.get<uint16_t>();
	if (innerLength > msgLength - 2) {
		return false;
	}

	msg.setLength(innerLength);
	return true;
}

bool Protocol::RSA_decrypt(NetworkMessage& msg)
{
	if ((msg.getLength() - msg.getBufferPosition()) < 128) {
		return false;
	}

	auto charData = static_cast<char*>(static_cast<void*>(msg.getBuffer()));
	// Does not break strict aliasing
	g_RSA().decrypt(charData + msg.getBufferPosition());
	return (msg.getByte() == 0);
}

uint32_t Protocol::getIP() const
{
	if (auto protocolConnection = getConnection()) {
		return protocolConnection->getIP();
	}

	return 0;
}

void Protocol::enableCompression()
{
	if (!compreesionEnabled) {
		int32_t compressionLevel = g_configManager().getNumber(COMPRESSION_LEVEL);
		if (compressionLevel != 0) {
			defStream.reset(new z_stream);
			defStream->zalloc = Z_NULL;
			defStream->zfree = Z_NULL;
			defStream->opaque = Z_NULL;
			if (deflateInit2(defStream.get(), compressionLevel, Z_DEFLATED, -15, 9, Z_DEFAULT_STRATEGY) != Z_OK) {
				defStream.reset();
				SPDLOG_ERROR("[Protocol::enableCompression()] - Zlib deflateInit2 error: {}", (defStream->msg ? defStream->msg : " unknown error"));
			} else {
				compreesionEnabled = true;
			}
		}
	}
}

bool Protocol::compression(OutputMessage& msg) const
{
	auto outputMessageSize = msg.getLength();
	if (outputMessageSize > NETWORKMESSAGE_MAXSIZE) {
		SPDLOG_ERROR("[NetworkMessage::compression] - Exceded NetworkMessage max size: {}, actually size: {}", NETWORKMESSAGE_MAXSIZE, outputMessageSize);
		return false;
	}

	static thread_local std::array<char, NETWORKMESSAGE_MAXSIZE> defBuffer;
	defStream->next_in = msg.getOutputBuffer();
	defStream->avail_in = outputMessageSize;
	defStream->next_out = (Bytef*)defBuffer.data();
	defStream->avail_out = NETWORKMESSAGE_MAXSIZE;

	if (int32_t ret = deflate(defStream.get(), Z_FINISH);
	ret != Z_OK && ret != Z_STREAM_END)
	{
		return false;
	}
	auto totalSize = static_cast<uint32_t>(defStream->total_out);
	deflateReset(defStream.get());
	if (totalSize == 0) {
		return false;
	}

	msg.reset();
	auto charData = static_cast<char*>(static_cast<void*>(defBuffer.data()));
	msg.addBytes(charData, static_cast<size_t>(totalSize));
	return true;
}
