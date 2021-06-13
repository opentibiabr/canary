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

#ifndef SRC_GAME_GAMESTORE_H_
#define SRC_GAME_GAMESTORE_H_

#include "declarations.hpp"

class GameStore {
	public:
		static uint16_t HISTORY_ENTRIES_PER_PAGE;
		static void startup() {
			HISTORY_ENTRIES_PER_PAGE=16;
		}

		bool isLoaded() {
			return loaded;
		}

		bool reload();
		bool loadFromXml();
		uint16_t getOffersCount();

		uint16_t getCategoryCount() {
			return (uint16_t) storeCategoryOffers.size();
		}

		std::vector<StoreCategory*> getCategoryOffers() {
			return storeCategoryOffers;
		};

		int8_t getCategoryIndexByName(std::string categoryName);
		bool haveCategoryByState(StoreState_t state);
		const BaseOffer* getOfferByOfferId(uint32_t offerId);

	private:
		uint32_t offerCount=0;
		bool loaded=false;
		std::vector<StoreCategory*> storeCategoryOffers;
};

class IOGameStore {
	public:
		static HistoryStoreOfferList getHistoryEntries(uint32_t account_id, uint32_t page);
};

#endif  // SRC_GAME_GAMESTORE_H_
