/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "outputmessage.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"

constexpr auto OUTPUTMESSAGE_AUTOSEND_DELAY = 10;

void OutputMessagePool::try_flush() {
	const auto time = OTSYS_TIME(true);
	if (time > timeLastFlush) {
		flush();
		timeLastFlush = time + OUTPUTMESSAGE_AUTOSEND_DELAY;
	}
}

void OutputMessagePool::flush() const {
	for (auto &protocol : bufferedProtocols) {
		if (auto &msg = protocol->getCurrentBuffer()) {
			protocol->send(std::move(msg));
		}
	}
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
