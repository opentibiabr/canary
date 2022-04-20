/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
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

#ifndef SRC_ITEMS_DECAY_DECAY_H_
#define SRC_ITEMS_DECAY_DECAY_H_

#include "items/item.h"

class Decay
{
	public:
		Decay(Decay const&) = delete;
		void operator=(Decay const&) = delete;

		static Decay& getInstance() {
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

		uint32_t eventId {0};
		std::map<int64_t, std::vector<Item*>> decayMap;
};

constexpr auto g_decay = &Decay::getInstance;

#endif // SRC_ITEMS_DECAY_DECAY_H_
