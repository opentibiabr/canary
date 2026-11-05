/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <cstdint>
#endif

class NetworkMessage;

namespace MarketPayload {
	struct LockerEntry {
		uint16_t itemId = 0;
		uint8_t tier = 0;
		uint32_t amount = 0;
		bool hasTier = false;
	};

	enum class AddLockerResult : uint8_t {
		Added,
		MessageFull,
		CountLimit,
		Finished,
	};

	class LockerWriter final {
	public:
		explicit LockerWriter(NetworkMessage &message);

		LockerWriter(const LockerWriter &) = delete;
		LockerWriter &operator=(const LockerWriter &) = delete;

		[[nodiscard]] AddLockerResult add(const LockerEntry &entry);
		void finish();

		[[nodiscard]] bool valid() const;
		[[nodiscard]] uint16_t count() const;

	private:
		NetworkMessage &msg;
		uint16_t countPosition = 0;
		uint16_t recordCount = 0;
		bool initialized = false;
		bool finished = false;
	};

	void writeLockerAmount(NetworkMessage &msg, uint32_t amount);
}
