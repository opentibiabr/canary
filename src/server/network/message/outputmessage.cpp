/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "outputmessage.hpp"

#include "lib/di/container.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"

const std::chrono::milliseconds OUTPUTMESSAGE_AUTOSEND_DELAY { 10 };

OutputMessagePool &OutputMessagePool::getInstance() {
	return inject<OutputMessagePool>();
}

void OutputMessagePool::scheduleSendAll() {
	g_dispatcher().scheduleEvent(
		OUTPUTMESSAGE_AUTOSEND_DELAY.count(), [this] { sendAll(); }, "OutputMessagePool::sendAll"
	);
}

void OutputMessagePool::sendAll() {
	std::vector<std::pair<Protocol_ptr, OutputMessage_ptr>> buffer;
	buffer.reserve(bufferedProtocols.size());

	// dispatcher thread
	for (auto &protocol : bufferedProtocols) {
		if (auto &msg = protocol->getCurrentBuffer()) {
			buffer.emplace_back(std::make_pair(protocol, std::move(msg)));
		}
	}

	if (!buffer.empty()) {
		threadPool.detach_task([buffer = std::move(buffer)] {
			for (auto &protocol : buffer) {
				protocol.first->send(std::move(protocol.second));
			}
		});
	}

	if (!bufferedProtocols.empty()) {
		scheduleSendAll();
	}
}

void OutputMessagePool::addProtocolToAutosend(Protocol_ptr protocol) {
	// dispatcher thread
	if (bufferedProtocols.empty()) {
		scheduleSendAll();
	}
	bufferedProtocols.emplace_back(protocol);
}

void OutputMessagePool::removeProtocolFromAutosend(const Protocol_ptr &protocol) {
	// dispatcher thread
	auto it = std::ranges::find(bufferedProtocols.begin(), bufferedProtocols.end(), protocol);
	if (it != bufferedProtocols.end()) {
		*it = bufferedProtocols.back();
		bufferedProtocols.pop_back();
	}
}

OutputMessage_ptr OutputMessagePool::getOutputMessage() {
	return std::make_shared<OutputMessage>();
}
