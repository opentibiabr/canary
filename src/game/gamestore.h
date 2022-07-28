/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
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

		std::vector<std::string> getIconsVector(const std::string& rawString) const;
		std::vector<uint8_t> getIntVector(const std::string& rawString) const;

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
