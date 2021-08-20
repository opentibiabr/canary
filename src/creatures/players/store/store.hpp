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

#ifndef SRC_CREATURES_PLAYERS_STORE_STORE_HPP_
#define SRC_CREATURES_PLAYERS_STORE_STORE_HPP_

#include <boost/lexical_cast.hpp>

#include "declarations.hpp"

#include "creatures/players/player.h"
#include "utils/tools.h"

class Player;
class Item;
class Mounts;

class StoreOffers;
class StoreOffer;

enum OfferTypes_t : uint8_t {
	OFFER_TYPE_NONE = 0, // This will disable offer
	OFFER_TYPE_ITEM = 1,
	OFFER_TYPE_STACKABLE = 2,
	OFFER_TYPE_OUTFIT = 3,
	OFFER_TYPE_OUTFIT_ADDON = 4,
	OFFER_TYPE_MOUNT = 5,
	OFFER_TYPE_NAME_CHANGE = 6,
	OFFER_TYPE_SEX_CHANGE = 7,
	OFFER_TYPE_PROMOTION = 8,
	OFFER_TYPE_HOUSE = 9,
	OFFER_TYPE_EXP_BOOST = 10,
	OFFER_TYPE_PREY_SLOT = 11,
	OFFER_TYPE_PREY_BONUS = 12,
	OFFER_TYPE_TEMPLE = 13,
	OFFER_TYPE_BLESSINGS = 14,
	OFFER_TYPE_PREMIUM = 15,
	OFFER_TYPE_POUCH = 16,
	OFFER_TYPE_ALL_BLESSINGS = 17,
	OFFER_TYPE_INSTANT_REWARD_ACCESS = 18,
	OFFER_TYPE_TRAINING = 19,
	OFFER_TYPE_CHARM_EXPANSION = 20,
	OFFER_TYPE_CHARM_POINTS = 21,
	OFFER_TYPE_MULTI_ITEMS = 22,
	OFFER_TYPE_VIP = 24,
	OFFER_TYPE_FRAG_REMOVE = 25,
	OFFER_TYPE_SKULL_REMOVE = 26,
	OFFER_TYPE_RECOVERY_KEY = 27,
};

enum OfferBuyTypes_t : uint8_t {
	OFFER_BUY_TYPE_OTHERS = 0,
	OFFER_BUY_TYPE_NAMECHANGE = 1,
	OFFER_BUY_TYPE_TESTE = 3,
};

enum ClientOfferTypes_t {
	CLIENT_STORE_OFFER_OTHER = 0,
	CLIENT_STORE_OFFER_NAMECHANGE = 1
};

enum OfferStates_t {
	OFFER_STATE_NONE = 0,
	OFFER_STATE_NEW = 1,
	OFFER_STATE_SALE = 2,
	OFFER_STATE_TIMED = 3
};

enum StoreErrors_t {
	STORE_ERROR_PURCHASE = 0,
	STORE_ERROR_NETWORK = 1,
	STORE_ERROR_HISTORY = 2,
	STORE_ERROR_TRANSFER = 3,
	STORE_ERROR_INFORMATION = 4
};

enum StoreServiceTypes_t {
	STORE_SERVICE_STANDERD = 0,
	STORE_SERVICE_OUTFITS = 3,
	STORE_SERVICE_MOUNTS = 4,
	STORE_SERVICE_BLESSINGS = 5
};

enum StoreHistoryTypes_t {
	HISTORY_TYPE_NONE = 0,
	HISTORY_TYPE_GIFT = 1,
	HISTORY_TYPE_REFUND = 2
};

struct StoreCategory {
	StoreCategory(std::string name, std::vector<std::string> subcategory, std::string icon, bool rookgaard) :
		name(std::move(name)), subcategory(std::move(subcategory)), icon(std::move(icon)), rookgaard(rookgaard) {}

	std::string name;
	std::vector<std::string> subcategory;
	std::string icon;
	bool rookgaard;
};

struct StoreHome {
	std::vector<std::string> offers;
	std::vector<std::string> banners;
};

class Store {
	public:
		//bool loadStore(const FileName& identifier);
		bool loadFromXML(bool reloading = false);
		bool loadCategory(pugi::xml_node node, pugi::xml_attribute name);
		bool loadHome(pugi::xml_node node);
		bool loadOffer(pugi::xml_node node, pugi::xml_attribute storeAttribute, pugi::xml_attribute attributeName);
		bool reload();

		bool hasNewOffer() {
			return newoffer;
		}

		bool hasSaleOffer() {
			return saleoffer;
		}

		uint16_t getOfferCount() {
			return offercount;
		}

		bool isValidType(OfferTypes_t type);

		std::vector<StoreOffers*> getStoreOffers();
		std::vector<StoreCategory> getStoreCategories() {
			return categories;
		}
		StoreHome getStoreHome() {
			return home;
		}
		
		std::map<std::string, std::vector<StoreOffer*>> getStoreOrganizedByName(StoreOffers* offer);
		std::map<std::string, std::vector<StoreOffer*>> getHomeOffersOrganized();
		std::vector<StoreOffer*> getStoreOffer(StoreOffers* offer);

		std::vector<StoreOffer*> getHomeOffers();
		const std::vector<std::string>& getHomeBanners() const {
			return home.banners;
		}

		uint8_t convertType(OfferTypes_t type);
		StoreOffers* getOfferByName(std::string name);
		StoreOffers* getOffersByOfferId(uint32_t id);
		StoreOffer* getStoreOfferByName(std::string name);
		StoreOffer* getOfferById(uint32_t id);
	protected:
		friend class StoreOffers;
		friend class StoreOffer;

		std::vector<StoreCategory> categories;
		std::map<std::string, StoreOffers> storeOffers;
		StoreHome home;

		bool loaded = false;
	private:
		// As mount uses uint16 as base, we can set the ids of the offers (which were not identified)
		// As the maximum value of uint16 + 1
		uint16_t beginid = std::numeric_limits<uint16_t>::max();
		uint32_t runningid = beginid;
		uint16_t offercount = 0;

		bool newoffer = false;
		bool saleoffer = false;

};

class StoreOffers {
	public:
		StoreOffers(std::string name) : 
				name(std::move(name)) {}

		std::string getName() {
			return name;
		}
		std::string getDescription() {
			return description;
		}
		std::string getIcon() {
			return icon;
		}
		std::string getParent() {
			return parent;
		}

		bool canUseRookgaard() {
			return rookgaard;
		}

		OfferStates_t getOfferState() {
			return state;
		}

		StoreOffer* getOfferByID(uint32_t id);
	protected:
		friend class Store;
		friend class StoreOffer;

		std::map<uint32_t, StoreOffer> offers;

	private:
		std::string name;
		std::string icon = "";
		std::string description = "";
		std::string parent;
		bool rookgaard = false;
		OfferStates_t state = OFFER_STATE_NONE;

};

class StoreOffer {
	public:
		StoreOffer(uint32_t _id, std::string _name) : 
				id(_id), name(std::move( _name)) {}

		std::string getDisabledReason(Player* player);

		std::string getName() {
			return name;
		}
		std::string getDescription(Player* player = nullptr);
		std::string getIcon() {
			return icon;
		}

		uint32_t getId() {
			return id;
		}
		uint32_t getPrice(Player* player = nullptr);
		uint32_t getBasePrice() {
			return basePrice;
		}
		uint32_t getValidUntil() {
			return validUntil;
		}
		uint16_t getCount(bool inBuy = false);

		uint16_t getBlessid() {
			return blessid;
		}
		uint16_t getItemType() {
			return itemId;
		}
		uint16_t getCharges() {
			return charges;
		}
		uint16_t getActionID() {
			return actionid;
		}
		uint8_t getAddon() {
			return addon;
		}
		uint16_t getOutfitMale() {
			return male;
		}
		uint16_t getOutfitFemale() {
			return female;
		}

		const std::map<uint16_t, uint16_t>& getItems() const {
			return itemList;
		}

		OfferStates_t getOfferState() {
			return state;
		}
		CoinType_t getCoinType() {
			return coinType;
		}
		OfferTypes_t getOfferType() {
			return type;
		}
		OfferBuyTypes_t getOfferBuyType() {
			return buyType;
		}

		Skulls_t getSkull() {
			return skull;
		}

		uint32_t getExpBoostPrice(int32_t value) {
			if(value == 1)
				return 30;
			else if (value == 2)
				return 45;
			else if (value == 3)
				return 90;
			else if (value == 4)
				return 180;
			else if (value == 5)
				return 360;
			else
				return 30;

		}

		bool haveOfferRookgaard() {
			return rookgaard;
		}

		Mount* getMount();

	protected:
		friend class Store;
		friend class StoreOffers;

	private:
		uint32_t id = 0;
		std::string name = "";

		std::map<uint16_t, uint16_t> itemList;
		std::string description = "";
		std::string icon = "";
		OfferStates_t state = OFFER_STATE_NONE;
		CoinType_t coinType = COIN_TYPE_DEFAULT;
		OfferBuyTypes_t buyType = OFFER_BUY_TYPE_OTHERS;
		uint16_t count = 150;
		uint32_t price = 0; // Default price (This preventing valueless offers from entering)
		uint32_t basePrice = 0; // Default price (This preventing valueless offers from entering)
		uint32_t validUntil = 0;
		uint16_t blessid = 0;
		uint16_t itemId = 0;
		uint16_t charges = 1;
		uint8_t addon = 0;
		uint16_t male;
		uint16_t female;
		uint16_t actionid = 0;
		Skulls_t skull = SKULL_NONE;

		bool disabled = false;
		bool rookgaard = true;
		OfferTypes_t type = OFFER_TYPE_NONE;
};

##endif // SRC_CREATURES_PLAYERS_STORE_STORE_HPP_
