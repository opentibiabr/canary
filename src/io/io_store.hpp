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
	std::string path;
	BannerType type;

	std::string categoryName;
	std::string collectionName;

	std::string offerName;
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

	static const std::map<std::string, OfferTypes_t, std::less<>> stringToOfferTypeMap;
	static const std::map<OfferTypes_t, uint16_t> offersDisableIndex;
	static const std::map<std::string, States_t, std::less<>> stringToOfferStateMap;
	static const std::map<std::string, BannerType, std::less<>> stringToBannerTypeMap;

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

	uint32_t dynamicId = std::numeric_limits<uint16_t>::max();

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
		"You already have charm expansion.",
		"You cannot make this purchase as long as your characters has a logout block."
	};
};

class Category { // We're gonna use the same class for Category and Subcategory
public:
	Category(const std::string &name, const std::string &icon, bool rookgaard, States_t state = States_t::NONE) :
		m_name(name), m_icon(icon), m_canRookgaardAccess(rookgaard), m_state(state) { }

	const std::string &getName() const {
		return m_name;
	}
	const std::string &getIcon() const {
		return m_icon;
	}
	States_t getState() const {
		return m_state;
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
	const std::vector<std::string> &getCollectionsVector() const;

private:
	friend class IOStore;

	std::string m_name;
	std::string m_icon;
	bool m_canRookgaardAccess;
	States_t m_state = States_t::NONE;
	bool m_specialCategory = false;

	// Used when Category class is a Category
	std::vector<Category> m_subCategories;

	// Used when Category class is a Subcategory or a "Special Category"
	std::vector<const Offer*> m_offers;
	std::vector<std::string> m_collections;

	void addSubCategory(const Category &newSubCategory);
	void addCollection(const std::string &newCollection);
	void addOffer(const Offer* newOffer);
	void setSpecialCategory(bool state) {
		m_specialCategory = state;
	}
};

class Offer {
public:
	Offer(uint32_t id, const std::string &name) :
		m_id(id), m_name(name) { }

	const std::string &getName() const {
		return m_name;
	}
	const std::string &getIcon() const {
		return m_icon;
	}
	uint32_t getID() const {
		return m_id;
	}
	uint32_t getPrice() const {
		return m_price;
	}
	uint32_t getItemId() const {
		return m_itemId;
	}
	OfferTypes_t getType() const {
		return m_type;
	}
	States_t getState() const {
		return m_state;
	}
	uint16_t getCount() const {
		return m_count;
	}
	uint16_t getValidUntil() const {
		return m_validUntil;
	}
	CoinType getCoinType() const {
		return m_coinType;
	}
	std::string getDescription() const {
		return m_description;
	}
	OutfitIds getOutfitIds() const {
		return m_outfitId;
	}
	std::string getCollection() const {
		return m_collectionName;
	}
	std::string getParentName() const {
		return m_parentName;
	}
	ConverType_t getConverType() const;
	bool getUseConfigure() const;
	bool isMovable() const {
		return m_movable;
	}

	const std::vector<Offer> &getRelatedOffersVector() const;
	void addRelatedOffer(const Offer &relatedOffer);

private:
	friend class IOStore;

	// Mandatory
	uint32_t m_id;
	std::string m_name;
	uint32_t m_price;
	OfferTypes_t m_type = OfferTypes_t::NONE;

	// Optional
	std::string m_icon;
	States_t m_state = States_t::NONE;
	uint32_t m_itemId;
	uint16_t m_count = 1; // Or charges
	uint16_t m_validUntil;
	CoinType m_coinType = CoinType::Normal;
	std::string m_description;
	OutfitIds m_outfitId;
	std::string m_collectionName;
	bool m_movable;

	// Internal
	std::string m_parentName;
	std::vector<Offer> m_relatedOffers;
};

constexpr auto g_ioStore = IOStore::getInstance;
