/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#pragma once

#include "enums/account_coins.hpp"
#include "enums/player_store_enums.hpp"

// Structs
struct OutfitIds {
	uint16_t maleId {};
	uint16_t femaleId {};
};

struct BannerInfo {
	std::string bannerName;
	uint32_t offerId {};
};

struct StoreHistoryDetail {
	StoreDetailType type {};
	uint32_t createdAt {};
	int32_t coinAmount {};
	int64_t totalPrice {};
	std::string description {};
	std::string playerName {};
};

struct RelatedOffer {
	uint32_t id {};
	uint32_t price {};
	uint16_t count {};
};

struct StoreHistory {
	time_t createdAt {};

	int32_t coinAmount {};
	CoinType coinType {};
	StoreDetailType type {};
	int64_t totalPrice {};

	std::string description {};
	std::string playerName {};
	bool fromMarket = false;
};

class Category;
class Offer;

class IOStore {
public:
	IOStore(const IOStore &) = delete;
	IOStore &operator=(const IOStore &) = delete;
	IOStore(IOStore &&) = delete;
	IOStore &operator=(IOStore &&) = delete;

	static IOStore &getInstance() {
		static IOStore instance;
		return instance;
	}

	bool loadFromXml();

	static const std::map<std::string, OfferTypes_t> stringToOfferTypeMap;
	static const std::map<OfferTypes_t, uint16_t> offersDisableIndex;
	static const std::map<std::string, States_t> stringToOfferStateMap;

	const std::vector<Category> &getCategoryVector() const;
	const Category* getCategoryByName(std::string_view categoryName) const;
	const Category* getSubCategoryByName(std::string_view subCategoryName) const;
	const Offer* getOfferById(uint32_t offerId) const;

	const std::vector<BannerInfo> &getBannersVector() const;
	const std::vector<uint32_t> &getHomeOffersVector() const;
	uint32_t getBannerDelay() const;
	void setBannerDelay(uint8_t delay);

	const Category* findCategory(const std::string &categoryName);

	const std::vector<std::string> &getOffersDisableReasonVector() const;

	std::vector<Offer> getOffersContainingSubstring(const std::string &searchString);
	Offer* getOfferByName(const std::string &searchString);

	static StoreHistoryDetail getStoreHistoryDetail(const std::string &playerName, uint32_t createdAt, bool hasDetail);

private:
	IOStore() = default;
	~IOStore() = default;

	// Home
	std::vector<BannerInfo> m_banners;
	uint8_t m_bannerDelay = 5;
	std::vector<uint32_t> m_homeOffers;

	std::vector<Category> m_categoryVector;
	std::vector<Category> m_subCategoryVector;
	std::map<uint32_t, Offer> m_offersMap;

	Category loadCategoryFromXml(pugi::xml_node offer, bool isSubCategory = false);
	bool loadOfferFromXml(Category* category, pugi::xml_node offer);
	bool loadStoreHome(pugi::xml_node homeNode);

	void addCategory(const Category &newCategory);
	void addOffer(uint32_t offerId, Offer offer);

	std::vector<std::string> m_offersDisableReason = {
		"You already own this outfit.",
		"You already own this mount.",
		"You can't buy XP Boost for today.",
		"You already have 3 slots released.",
		"You already have maximum of prey wildcards.",
		"You reached the maximum amount for this blessing.",
		"You reached the maximum amount for some blessing.",
		"You already have a pouch.",
		"You already have maximum of reward tokens.",
		"You already have charm expansion."
	};
};

class Category { // We're gonna use the same class for Category and Subcategory
public:
	Category(const std::string &name, const std::string &icon, bool rookgaard, States_t state = States_t::NONE) :
		m_categoryName(name), m_categoryIcon(icon), m_canRookgaardAccess(rookgaard), m_categoryState(state) { }

	const std::string &getCategoryName() const {
		return m_categoryName;
	}
	const std::string &getCategoryIcon() const {
		return m_categoryIcon;
	}
	States_t getCategoryState() const {
		return m_categoryState;
	}
	bool canRookgaardAccess() const {
		return m_canRookgaardAccess;
	}
	bool isSpecialCategory() const {
		return m_specialCategory;
	}

	const Category* getFirstSubCategory() const;
	const std::vector<Category> &getSubCategoriesVector() const;
	const std::vector<const Offer*> &getOffersVector() const;

private:
	friend class IOStore;

	std::string m_categoryName;
	std::string m_categoryIcon;
	bool m_canRookgaardAccess;
	States_t m_categoryState = States_t::NONE;
	bool m_specialCategory = false;

	// Used when Category class is a Category
	std::vector<Category> m_subCategories;

	// Used when Category class is a Subcategory or a "Special Category"
	std::vector<const Offer*> m_offers;

	void addSubCategory(const Category &newSubCategory);
	void addOffer(const Offer* newOffer);
	void setSpecialCategory(bool state) {
		m_specialCategory = state;
	}
};

class Offer {
public:
	Offer(const std::string &name, uint32_t id, uint32_t price, OfferTypes_t type, const std::string &icon, States_t state, uint16_t count, uint16_t duration, CoinType coin, const std::string &description, OutfitIds outfitIds, bool movable, const std::string &parentName, std::vector<RelatedOffer> relatedOffers) :
		m_offerName(name), m_offerId(id), m_offerPrice(price), m_offerType(type), m_offerIcon(icon), m_offerState(state), m_offerCount(count), m_validUntil(duration), m_coinType(coin), m_offerDescription(description), m_outfitId(outfitIds), m_movable(movable), m_parentName(parentName), m_relatedOffers(relatedOffers) { }

	const std::string &getOfferName() const {
		return m_offerName;
	}
	const std::string &getOfferIcon() const {
		return m_offerIcon;
	}
	uint32_t getOfferId() const {
		return m_offerId;
	}
	uint32_t getOfferPrice() const {
		return m_offerPrice;
	}
	OfferTypes_t getOfferType() const {
		return m_offerType;
	}
	States_t getOfferState() const {
		return m_offerState;
	}
	uint16_t getOfferCount() const {
		return m_offerCount;
	}
	uint16_t getValidUntil() const {
		return m_validUntil;
	}
	CoinType getCoinType() const {
		return m_coinType;
	}
	std::string getOfferDescription() const {
		return m_offerDescription;
	}
	OutfitIds getOutfitIds() const {
		return m_outfitId;
	}
	std::string getParentName() const {
		return m_parentName;
	}
	ConverType_t getConverType() const;
	bool getUseConfigure() const;
	bool isMovable() const {
		return m_movable;
	}

	const std::vector<RelatedOffer> &getRelatedOffersVector() const;
	void addRelatedOffer(const RelatedOffer &relatedOffer);

private:
	// Mandatory
	std::string m_offerName;
	uint32_t m_offerId; // Any identifier (itemId, mountId, ...)
	uint32_t m_offerPrice;
	OfferTypes_t m_offerType = OfferTypes_t::NONE;

	// Optional
	std::string m_offerIcon;
	States_t m_offerState = States_t::NONE;
	uint16_t m_offerCount = 0; // Or charges
	uint16_t m_validUntil;
	CoinType m_coinType = CoinType::Normal;
	std::string m_offerDescription;
	OutfitIds m_outfitId;
	bool m_movable;

	// Internal
	std::string m_parentName;
	std::vector<RelatedOffer> m_relatedOffers;
};

constexpr auto g_ioStore = IOStore::getInstance;
