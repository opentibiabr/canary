/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "server/network/protocol/market_payload.hpp"

#include "server/network/message/networkmessage.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <cstddef>
	#include <limits>
#endif

MarketPayload::LockerWriter::LockerWriter(NetworkMessage &message) :
	msg(message) {
	if (!msg.canAdd(sizeof(uint16_t))) {
		return;
	}

	countPosition = msg.getBufferPosition();
	msg.skipBytes(sizeof(uint16_t));
	initialized = true;
}

MarketPayload::AddLockerResult MarketPayload::LockerWriter::add(const LockerEntry &entry) {
	if (finished || !initialized) {
		return AddLockerResult::Finished;
	}
	if (recordCount == std::numeric_limits<uint16_t>::max()) {
		return AddLockerResult::CountLimit;
	}

	const size_t recordSize = sizeof(uint16_t) + sizeof(uint16_t) + (entry.hasTier ? sizeof(uint8_t) : 0);
	if (!msg.canAdd(recordSize)) {
		return AddLockerResult::MessageFull;
	}

	msg.add<uint16_t>(entry.itemId);
	if (entry.hasTier) {
		msg.addByte(entry.tier);
	}
	writeLockerAmount(msg, entry.amount);
	++recordCount;
	return AddLockerResult::Added;
}

void MarketPayload::LockerWriter::finish() {
	if (!initialized || finished) {
		return;
	}

	const auto endPosition = msg.getBufferPosition();
	msg.setBufferPosition(countPosition);
	msg.add<uint16_t>(recordCount);
	msg.setBufferPosition(endPosition);
	finished = true;
}

bool MarketPayload::LockerWriter::valid() const {
	return initialized;
}

uint16_t MarketPayload::LockerWriter::count() const {
	return recordCount;
}

void MarketPayload::writeLockerAmount(NetworkMessage &msg, uint32_t amount) {
	msg.add<uint16_t>(static_cast<uint16_t>(std::min<uint32_t>(amount, std::numeric_limits<uint16_t>::max())));
}
