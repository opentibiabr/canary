/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "outputmessage.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"

const std::chrono::milliseconds OUTPUTMESSAGE_AUTOSEND_DELAY { 10 };

void OutputMessagePool::scheduleSendAll() {
	auto function = std::bind_front(&OutputMessagePool::sendAll, this);
	g_dispatcher().scheduleEvent(OUTPUTMESSAGE_AUTOSEND_DELAY.count(), function, "OutputMessagePool::sendAll");
}

void OutputMessagePool::sendAll() {
	// dispatcher thread
	for (auto &protocol : bufferedProtocols) {
		auto &msg = protocol->getCurrentBuffer();
		if (msg) {
			protocol->send(std::move(msg));
		}
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
