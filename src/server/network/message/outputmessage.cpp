/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/message/outputmessage.hpp"

#include "game/scheduling/dispatcher.hpp"
#include "lib/di/container.hpp"
#include "server/network/protocol/protocol.hpp"
#include "utils/lockfree.hpp"

constexpr uint16_t OUTPUTMESSAGE_FREE_LIST_CAPACITY = 2048;
constexpr std::chrono::milliseconds OUTPUTMESSAGE_AUTOSEND_DELAY { 10 };

OutputMessagePool &OutputMessagePool::getInstance() {
	return inject<OutputMessagePool>();
}

void OutputMessagePool::scheduleSendAll() {
	g_dispatcher().scheduleEvent(
		OUTPUTMESSAGE_AUTOSEND_DELAY.count(), [this] { sendAll(); }, "OutputMessagePool::sendAll"
	);
}

void OutputMessagePool::sendAll() {
	// dispatcher thread
	for (const auto &protocol : bufferedProtocols) {
		auto &msg = protocol->getCurrentBuffer();
		if (msg) {
			protocol->send(std::move(msg));
		}
	}

	if (!bufferedProtocols.empty()) {
		scheduleSendAll();
	}
}

void OutputMessagePool::addProtocolToAutosend(const Protocol_ptr &protocol) {
	// dispatcher thread
	if (bufferedProtocols.empty()) {
		scheduleSendAll();
	}
	bufferedProtocols.emplace_back(protocol);
}

void OutputMessagePool::removeProtocolFromAutosend(const Protocol_ptr &protocol) {
	// dispatcher thread
	const auto it = std::ranges::find(bufferedProtocols, protocol);
	if (it != bufferedProtocols.end()) {
		*it = bufferedProtocols.back();
		bufferedProtocols.pop_back();
	}
}

OutputMessage_ptr OutputMessagePool::getOutputMessage() {
	return std::allocate_shared<OutputMessage>(LockfreePoolingAllocator<OutputMessage, OUTPUTMESSAGE_FREE_LIST_CAPACITY>());
}

uint8_t* OutputMessage::getOutputBuffer() {
	return buffer.data() + outputBufferStart;
}

void OutputMessage::writeMessageLength() {
	add_header(info.length);
}

void OutputMessage::addCryptoHeader(bool addChecksum, uint32_t checksum) {
	if (addChecksum) {
		add_header(checksum);
	}

	writeMessageLength();
}

void OutputMessage::append(const NetworkMessage &msg) {
	auto msgLen = msg.getLength();
	std::span<const unsigned char> sourceSpan(msg.getBuffer() + INITIAL_BUFFER_POSITION, msgLen);
	std::span<unsigned char> destSpan(buffer.data() + info.position, msgLen);
	std::ranges::copy(sourceSpan, destSpan.begin());
	info.length += msgLen;
	info.position += msgLen;
}

void OutputMessage::append(const OutputMessage_ptr &msg) {
	auto msgLen = msg->getLength();
	std::span<const unsigned char> sourceSpan(msg->getBuffer() + INITIAL_BUFFER_POSITION, msgLen);
	std::span<unsigned char> destSpan(buffer.data() + info.position, msgLen);
	std::ranges::copy(sourceSpan, destSpan.begin());
	info.length += msgLen;
	info.position += msgLen;
}
