/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_ITEMS_DECAY_DECAY_H_
#define SRC_ITEMS_DECAY_DECAY_H_

#include "items/item.h"

class Decay {
	public:
		Decay(const Decay &) = delete;
		void operator=(const Decay &) = delete;

		static Decay &getInstance() {
			// Guaranteed to be destroyed
			static Decay instance;
			// Instantiated on first use
			return instance;
		}

		void startDecay(Item* item);
		void stopDecay(Item* item);

	private:
		Decay() = default;

		void checkDecay();
		void internalDecayItem(Item* item);

		uint32_t eventId { 0 };
		std::map<int64_t, std::vector<Item*>> decayMap;
};

constexpr auto g_decay = &Decay::getInstance;

#endif // SRC_ITEMS_DECAY_DECAY_H_
