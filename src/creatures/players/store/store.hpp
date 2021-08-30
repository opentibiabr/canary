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
    StoreCategory(std::string m_name, std::vector<std::string> subcategory,
        std::string m_icon, bool m_rookgaard)
        : m_name(std::move(m_name))
        , subcategory(std::move(subcategory))
        , m_icon(std::move(m_icon))
        , m_rookgaard(m_rookgaard)
    {
    }

    std::string m_name;
    std::vector<std::string> subcategory;
    std::string m_icon;
    bool m_rookgaard;
};

struct StoreHome {
    std::vector<std::string> offers;
    std::vector<std::string> banners;
};

class Store
{
public:
    // bool loadStore(const FileName& identifier);
    bool loadFromXML(bool reloading = false);
    bool loadCategory(pugi::xml_node node, pugi::xml_attribute m_name);
    bool loadHome(pugi::xml_node node);
    bool loadOffer(pugi::xml_node node, pugi::xml_attribute storeAttribute,
        pugi::xml_attribute attributeName);
    bool reload();

    bool hasNewOffer()
    {
        return newoffer;
    }

    bool hasSaleOffer()
    {
        return saleoffer;
    }

    uint16_t getOfferCount()
    {
        return offercount;
    }

    bool isValidType(OfferTypes_t type);

    std::vector<StoreOffers*> getStoreOffers();
    std::vector<StoreCategory> getStoreCategories()
    {
        return categories;
    }
    StoreHome getStoreHome()
    {
        return home;
    }

    std::map<std::string, std::vector<StoreOffer*>> getStoreOrganizedByName(
        StoreOffers* offer);
    std::map<std::string, std::vector<StoreOffer*>> getHomeOffersOrganized();
    std::vector<StoreOffer*> getStoreOffer(StoreOffers* offer);

    std::vector<StoreOffer*> getHomeOffers();
    const std::vector<std::string>& getHomeBanners() const
    {
        return home.banners;
    }

    uint8_t convertType(OfferTypes_t type);
    StoreOffers* getOfferByName(std::string m_name);
    StoreOffers* getOffersByOfferId(uint32_t m_id);
    StoreOffer* getStoreOfferByName(std::string m_name);
    StoreOffer* getOfferById(uint32_t m_id);

protected:
    friend class StoreOffers;
    friend class StoreOffer;

    std::vector<StoreCategory> categories;
    std::map<std::string, StoreOffers> storeOffers;
    StoreHome home;

    bool loaded = false;

private:
    // As mount uses uint16 as base, we can set the ids of the offers (which
    // were not identified) As the maximum value of uint16 + 1
    uint16_t begin_id = std::numeric_limits<uint16_t>::max();
    uint32_t running_id = begin_id;
    uint16_t offercount = 0;

    bool newoffer = false;
    bool saleoffer = false;
};

class StoreOffers
{
public:
    explicit StoreOffers(std::string m_name)
        : m_name(std::move(m_name))
    {
    }

    std::string getName()
    {
        return m_name;
    }
    std::string getDescription()
    {
        return m_description;
    }
    std::string getIcon()
    {
        return m_icon;
    }
    std::string getParent()
    {
        return parent;
    }

    bool canUseRookgaard()
    {
        return m_rookgaard;
    }

    OfferStates_t getOfferState()
    {
        return m_state;
    }

    StoreOffer* getOfferByID(uint32_t m_id);

protected:
    friend class Store;
    friend class StoreOffer;

    std::map<uint32_t, StoreOffer> offers;

private:
    std::string m_name;
    std::string m_icon = "";
    std::string m_description = "";
    std::string parent;
    bool m_rookgaard = false;
    OfferStates_t m_state = OFFER_STATE_NONE;
};

class StoreOffer
{
public:
    StoreOffer(uint32_t _id, std::string _name)
        : m_id(_id)
        , m_name(std::move(_name))
    {
    }

    std::string getDisabledReason(Player* player);

    std::string getName()
    {
        return m_name;
    }
    std::string getDescription(Player* player = nullptr);
    std::string getIcon()
    {
        return m_icon;
    }

    uint32_t getId()
    {
        return m_id;
    }
    uint32_t getPrice(Player* player = nullptr);
    uint32_t getBasePrice()
    {
        return m_basePrice;
    }
    uint32_t getValidUntil()
    {
        return m_validUntil;
    }
    uint16_t getCount(bool inBuy = false);

    uint16_t getBlessid()
    {
        return m_blessId;
    }
    uint16_t getItemType()
    {
        return m_itemId;
    }
    uint16_t getCharges()
    {
        return m_charges;
    }
    uint16_t getActionID()
    {
        return m_actionId;
    }
    uint8_t getAddon()
    {
        return m_addon;
    }
    uint16_t getOutfitMale()
    {
        return m_male;
    }
    uint16_t getOutfitFemale()
    {
        return m_female;
    }

    const std::map<uint16_t, uint16_t>& getItems() const
    {
        return m_itemList;
    }

    OfferStates_t getOfferState()
    {
        return m_state;
    }
    CoinType_t getCoinType()
    {
        return m_coinType;
    }
    OfferTypes_t getOfferType()
    {
        return m_type;
    }
    OfferBuyTypes_t getOfferBuyType()
    {
        return m_buyType;
    }

    Skulls_t getSkull()
    {
        return m_skull;
    }

    bool haveOfferRookgaard()
    {
        return m_rookgaard;
    }

    Mount* getMount();

protected:
    friend class Store;
    friend class StoreOffers;

private:
    uint32_t m_id = 0;
    std::string m_name = "";

    std::map<uint16_t, uint16_t> m_itemList;
    std::string m_description;
    std::string m_icon = "";
    OfferStates_t m_state = OFFER_STATE_NONE;
    CoinType_t m_coinType = COIN_TYPE_DEFAULT;
    OfferBuyTypes_t m_buyType = OFFER_BUY_TYPE_OTHERS;
    uint16_t m_count = 1;
    uint32_t m_price =
        150; // Default m_price (This preventing valueless offers from entering)
    uint32_t m_basePrice =
        0; // Default m_price (This preventing valueless offers from entering)
    uint32_t m_validUntil = 0;
    uint16_t m_blessId = 0;
    uint16_t m_itemId = 0;
    uint16_t m_charges = 1;
    uint8_t m_addon = 0;
    uint16_t m_male;
    uint16_t m_female;
    uint16_t m_actionId = 0;
    Skulls_t m_skull = SKULL_NONE;

    bool m_disabled = false;
    bool m_rookgaard = true;
    OfferTypes_t m_type = OFFER_TYPE_NONE;
};

#endif // SRC_CREATURES_PLAYERS_STORE_STORE_HPP_
