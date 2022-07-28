/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO_IOMARKET_H_
#define SRC_IO_IOMARKET_H_

#include "database/database.h"
#include "declarations.hpp"

class IOMarket
{
	public:
		static IOMarket& getInstance() {
			static IOMarket instance;
			return instance;
		}

		static MarketOfferList getActiveOffers(MarketAction_t action, uint16_t itemId);
		static MarketOfferList getOwnOffers(MarketAction_t action, uint32_t playerId);
		static HistoryMarketOfferList getOwnHistory(MarketAction_t action, uint32_t playerId);

		static void processExpiredOffers(DBResult_ptr result, bool);
		static void checkExpiredOffers();

		static uint32_t getPlayerOfferCount(uint32_t playerId);
		static MarketOfferEx getOfferByCounter(uint32_t timestamp, uint16_t counter);

		static void createOffer(uint32_t playerId, MarketAction_t action, uint32_t itemId, uint16_t amount, uint32_t price, bool anonymous);
		static void acceptOffer(uint32_t offerId, uint16_t amount);
		static void deleteOffer(uint32_t offerId);

		static void appendHistory(uint32_t playerId, MarketAction_t type, uint16_t itemId, uint16_t amount, uint32_t price, time_t timestamp, MarketOfferState_t state);
		static bool moveOfferToHistory(uint32_t offerId, MarketOfferState_t state);

		void updateStatistics();

		MarketStatistics* getPurchaseStatistics(uint16_t itemId);
		MarketStatistics* getSaleStatistics(uint16_t itemId);

	private:
		IOMarket() = default;

		std::map<uint16_t, MarketStatistics> purchaseStatistics;
		std::map<uint16_t, MarketStatistics> saleStatistics;
};

#endif  // SRC_IO_IOMARKET_H_
