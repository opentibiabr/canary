/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/message/outputmessage.hpp"

#include "lib/di/container.hpp"
#include "server/network/protocol/protocol.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "utils/lockfree.hpp"

constexpr std::chrono::milliseconds OUTPUTMESSAGE_AUTOSEND_DELAY { 10 };
static SharedOptimizedObjectPool<OutputMessage, 512, false, std::pmr::polymorphic_allocator<OutputMessage>, 8> g_outputPool;

OutputMessage::OutputMessage() = default;

OutputMessage::~OutputMessage() = default;

OutputMessagePool::OutputMessagePool() {
	g_outputPool.prewarm(64);
}

OutputMessagePool::~OutputMessagePool() {
	g_outputPool.flush_local_cache();
}

OutputMessagePool &OutputMessagePool::getInstance() {
	return inject<OutputMessagePool>();
}

void OutputMessage::reset() noexcept {
	info.position = INITIAL_BUFFER_POSITION;
	info.length = 0;
	outputBufferStart = INITIAL_BUFFER_POSITION;
}

bool OutputMessage::canAppend(const size_t size) const {
	return (getLength() + size) <= MAX_PROTOCOL_BODY_LENGTH;
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
	if (const auto it = std::ranges::find(bufferedProtocols, protocol); it != bufferedProtocols.end()) {
		*it = bufferedProtocols.back();
		bufferedProtocols.pop_back();
	}
}

OutputMessage_ptr OutputMessagePool::getOutputMessage() {
	auto result = g_outputPool.acquire();
	if (!result) {
		g_logger().error("[OutputMessagePool::getOutputMessage] Falha ao adquirir mensagem da pool");
		return nullptr;
	}
	return result.value();
}
