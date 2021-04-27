/**
 * @file gamestore.h
 * 
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019 Mark Samman <mark.samman@gmail.com>
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

#ifndef OT_SRC_GAMESTORE_H_
#define OT_SRC_GAMESTORE_H_

#include "movement/position.h"

enum Offer_t {
	DISABLED=0,
	ITEM=1,
	STACKABLE_ITEM=2,
	OUTFIT=3,
	OUTFIT_ADDON=4,
	MOUNT=5,
	NAMECHANGE=6,
	SEXCHANGE=7,
	PROMOTION=8,
	PREMIUM_TIME,
	TELEPORT,
	BLESSING,
	BOOST_XP, //not using yet
	BOOST_STAMINA, //not using yet
	WRAP_ITEM
};

enum ClientOffer_t{
	SIMPLE=0,
	ADDITIONALINFO=1
};

enum StoreState_t {
	NORMAL=0,
	NEW,
	SALE,
	LIMITED_TIME
};

enum GameStoreError_t{
	STORE_ERROR_PURCHASE=0,
	STORE_ERROR_NETWORK,
	STORE_ERROR_HISTORY,
	STORE_ERROR_TRANSFER,
	STORE_ERROR_INFORMATION
};

enum StoreService_t {
	SERVICE_STANDARD = 0,
	SERVICE_OUTFIT = 3,
	SERVICE_MOUNT = 4
};

struct BaseOffer{
	uint32_t id;
	std::string name;
	std::string description;
	uint32_t price;
	Offer_t type;
	StoreState_t state;
	std::vector<std::string> icons;
};

struct ItemOffer : BaseOffer{
	uint16_t productId;
	uint16_t count;
};

struct MountOffer: BaseOffer{
	uint8_t mountId;
};

struct OutfitOffer : BaseOffer {
	uint16_t maleLookType;
	uint16_t femaleLookType;
	uint8_t addonNumber;
};

struct TeleportOffer : BaseOffer{
	Position position;
};

struct PremiumTimeOffer : BaseOffer{
	uint16_t days;
};

struct BlessingOffer : BaseOffer{
	std::vector<uint8_t> blessings;
};

struct StoreCategory{
	std::string name;
	std::string description;
	StoreState_t state;
	std::vector<std::string> icons;
	std::vector<BaseOffer*> offers;
};

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


struct HistoryStoreOffer {
	uint32_t time;
	uint8_t mode;
	uint32_t amount;
	std::string description;
};

using HistoryStoreOfferList = std::vector<HistoryStoreOffer>;

class IOGameStore {
	public:
		static HistoryStoreOfferList getHistoryEntries(uint32_t account_id, uint32_t page);
};

#endif //OTX_GAMESTORE_H
