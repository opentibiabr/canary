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
#include "utils/lockfree.hpp"

constexpr uint16_t OUTPUTMESSAGE_FREE_LIST_CAPACITY = 2048;
constexpr std::chrono::milliseconds OUTPUTMESSAGE_AUTOSEND_DELAY { 10 };

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
	auto it = std::ranges::find(bufferedProtocols.begin(), bufferedProtocols.end(), protocol);
	if (it != bufferedProtocols.end()) {
		*it = bufferedProtocols.back();
		bufferedProtocols.pop_back();
	}
}

OutputMessage_ptr OutputMessagePool::getOutputMessage() {
	LockfreePoolingAllocator<OutputMessage, OUTPUTMESSAGE_FREE_LIST_CAPACITY> allocator;
	OutputMessage* rawPtr = allocator.allocate(1);

	try {
		new (rawPtr) OutputMessage();
	} catch (...) {
		allocator.deallocate(rawPtr, 1);
		throw;
	}

	return { rawPtr, [&allocator](OutputMessage*&ptr) mutable {
				if (ptr) {
					ptr->~OutputMessage();
					allocator.deallocate(ptr, 1);
				}
			} };
}
