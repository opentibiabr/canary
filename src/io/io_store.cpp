/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "io/io_store.hpp"

#include "config/configmanager.hpp"
#include "database/databasetasks.hpp"
#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "utils/tools.hpp"

const std::map<std::string, OfferTypes_t, std::less<>> IOStore::stringToOfferTypeMap = {
	{ "none", OfferTypes_t::NONE },
	{ "item", OfferTypes_t::ITEM },
	{ "stackable", OfferTypes_t::STACKABLE },
	{ "charges", OfferTypes_t::CHARGES },
	{ "looktype", OfferTypes_t::LOOKTYPE },
	{ "outfit", OfferTypes_t::OUTFIT },
	{ "mount", OfferTypes_t::MOUNT },
	{ "nameChange", OfferTypes_t::NAMECHANGE },
	{ "sexChange", OfferTypes_t::SEXCHANGE },
	{ "house", OfferTypes_t::HOUSE },
	{ "expBoost", OfferTypes_t::EXPBOOST },
	{ "preySlot", OfferTypes_t::PREYSLOT },
	{ "preyBonus", OfferTypes_t::PREYBONUS },
	{ "temple", OfferTypes_t::TEMPLE },
	{ "blessings", OfferTypes_t::BLESSINGS },
	{ "allblessings", OfferTypes_t::ALLBLESSINGS },
	{ "premium", OfferTypes_t::PREMIUM },
	{ "pouch", OfferTypes_t::POUCH },
	{ "instantReward", OfferTypes_t::INSTANT_REWARD_ACCESS },
	{ "charmExpansion", OfferTypes_t::CHARM_EXPANSION },
	{ "huntingSlot", OfferTypes_t::HUNTINGSLOT },
	{ "hireling", OfferTypes_t::HIRELING },
	{ "hirelingNameChange", OfferTypes_t::HIRELING_NAMECHANGE },
	{ "hirelingSexChange", OfferTypes_t::HIRELING_SEXCHANGE },
	{ "hirelingSkill", OfferTypes_t::HIRELING_SKILL },
	{ "hirelingOutfit", OfferTypes_t::HIRELING_OUTFIT }
};

const std::map<OfferTypes_t, uint16_t> IOStore::offersDisableIndex = {
	{ OfferTypes_t::OUTFIT, 0 },
	{ OfferTypes_t::MOUNT, 1 },
	{ OfferTypes_t::EXPBOOST, 2 },
	{ OfferTypes_t::PREYSLOT, 3 },
	{ OfferTypes_t::HUNTINGSLOT, 3 },
	{ OfferTypes_t::PREYBONUS, 4 },
	{ OfferTypes_t::BLESSINGS, 5 },
	{ OfferTypes_t::ALLBLESSINGS, 6 },
	{ OfferTypes_t::POUCH, 7 },
	{ OfferTypes_t::INSTANT_REWARD_ACCESS, 8 },
	{ OfferTypes_t::CHARM_EXPANSION, 9 },
	{ OfferTypes_t::TEMPLE, 10 }
};

const std::map<std::string, States_t, std::less<>> IOStore::stringToOfferStateMap = {
	{ "none", States_t::NONE }, { "new", States_t::NEW }, { "sale", States_t::SALE }, { "timed", States_t::TIMED }
};

const std::map<std::string, BannerType, std::less<>> IOStore::stringToBannerTypeMap = {
	{ "collection", BannerType::COLLECTION },
	{ "offer", BannerType::OFFER }
};

bool IOStore::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY) + "/XML/store/store.xml";
	pugi::xml_parse_result result = doc.load_file(folder.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, folder, result);
		return false;
	}

	auto storeNode = doc.child("store");

	pugi::xml_node homeNode = storeNode.child("home");
	if (!loadStoreHome(homeNode)) {
		return false;
	}

	for (pugi::xml_node category : storeNode.children("category")) {
		auto newCategory = loadCategoryFromXml(category);

		pugi::xml_node child = category.first_child();
		if (child && std::string(child.name()) == "subcategory") {
			for (pugi::xml_node subcategory : category.children("subcategory")) {
				auto newSubCategory = loadCategoryFromXml(subcategory, true);

				for (pugi::xml_node offer : subcategory.children("offer")) {
					if (!loadOfferFromXml(&newSubCategory, offer)) {
						return false;
					}
				}
				m_subCategoryVector.push_back(newSubCategory);
				newCategory.addSubCategory(newSubCategory);
			}
		} else if (child && std::string(child.name()) == "offer") {
			newCategory.setSpecialCategory(true);
			for (pugi::xml_node offer : category.children("offer")) {
				if (!loadOfferFromXml(&newCategory, offer)) {
					return false;
				}
			}
		}
		addCategory(newCategory);
	}

	return true;
}

Category IOStore::loadCategoryFromXml(pugi::xml_node category, bool isSubCategory /* = false*/) {
	auto categoryName = std::string(category.attribute("name").as_string());
	auto categoryIcon = std::string(category.attribute("icon").as_string());
	auto categoryRookString = std::string(category.attribute("rookgaard").as_string());

	bool categoryRook = categoryRookString == "yes";

	if (isSubCategory) {
		auto subCategoryStateString = std::string(category.attribute("state").as_string());
		States_t subCategoryState = States_t::NONE;
		if (auto it = stringToOfferStateMap.find(subCategoryStateString);
		    it != stringToOfferStateMap.end()) {
			subCategoryState = it->second;
		}

		Category newSubCategory(categoryName, categoryIcon, categoryRook, subCategoryState);
		return newSubCategory;
	}

	Category newCategory(categoryName, categoryIcon, categoryRook);
	return newCategory;
}

bool IOStore::loadOfferFromXml(Category* category, pugi::xml_node offer) {
	auto name = std::string(offer.attribute("name").as_string());
	if (name.empty()) {
		g_logger().warn("Offer name empty.");
		return false;
	}

	uint32_t id = 0;
	auto offerId = offer.attribute("id");
	if (offerId) {
		id = static_cast<uint32_t>(offerId.as_uint());
	} else {
		id = dynamicId;
		dynamicId++;
	}

	Offer newOffer(id, name);

	auto price = static_cast<uint32_t>(offer.attribute("price").as_uint());
	if (price == 0) {
		g_logger().warn("Offer {} price is 0.", name);
		return false;
	}
	newOffer.m_price = price;

	uint16_t count = 1;
	if (offer.attribute("count")) {
		count = static_cast<uint16_t>(offer.attribute("count").as_uint());
	} else if (offer.attribute("charges")) {
		count = static_cast<uint16_t>(offer.attribute("charges").as_uint());
	}
	newOffer.m_count = count;

	std::string icon = "";
	if (offer.attribute("icon")) {
		icon = std::string(offer.attribute("icon").as_string());
	}
	newOffer.m_icon = std::move(icon);

	auto typeString = std::string(offer.attribute("type").as_string());
	OfferTypes_t type = OfferTypes_t::NONE;
	if (auto it = stringToOfferTypeMap.find(typeString);
	    it != stringToOfferTypeMap.end()) {
		type = it->second;
	} else {
		g_logger().warn("Offer {} type is none.", name);
		return false;
	}
	newOffer.m_type = type;

	OutfitIds outfitId;
	if (type == OfferTypes_t::OUTFIT || type == OfferTypes_t::HIRELING) {
		outfitId.femaleId = static_cast<uint16_t>(offer.attribute("female").as_uint());
		outfitId.maleId = static_cast<uint16_t>(offer.attribute("male").as_uint());
	}
	newOffer.m_outfitId = outfitId;

	uint32_t itemId = 0;
	if (type == OfferTypes_t::ITEM || type == OfferTypes_t::STACKABLE || type == OfferTypes_t::HOUSE || type == OfferTypes_t::CHARGES || type == OfferTypes_t::POUCH) {
		itemId = static_cast<uint16_t>(offer.attribute("item").as_uint());
	}
	newOffer.m_itemId = itemId;

	auto stateString = std::string(offer.attribute("state").as_string());
	States_t state = States_t::NONE;
	if (auto it = stringToOfferStateMap.find(stateString);
	    it != stringToOfferStateMap.end()) {
		state = it->second;
	}
	newOffer.m_state = state;

	uint16_t validUntil = 0;
	if (offer.attribute("validUntil")) {
		validUntil = static_cast<uint16_t>(offer.attribute("validUntil").as_uint());
	}
	newOffer.m_validUntil = validUntil;

	CoinType coinType = CoinType::Normal;
	if (offer.attribute("coinType")) {
		auto coinTypeString = std::string(offer.attribute("coinType").as_string());
		coinType = coinTypeString == "normal" ? CoinType::Normal : CoinType::Transferable;
	}
	newOffer.m_coinType = coinType;

	std::string collection = "";
	if (offer.attribute("collection")) {
		collection = std::string(offer.attribute("collection").as_string());
	}
	newOffer.m_collectionName = collection;

	std::string desc = "";
	if (offer.attribute("description")) {
		desc = std::string(offer.attribute("description").as_string());
	}
	newOffer.m_description = std::move(desc);

	bool isMovable = false;
	if (offer.attribute("movable")) {
		isMovable = bool(offer.attribute("movable").as_bool());
	}
	newOffer.m_movable = isMovable;

	newOffer.m_parentName = category->getName();
	auto baseOffer = getOfferByName(name);
	if (baseOffer) {
		baseOffer->addRelatedOffer(newOffer);
		addOffer(id, newOffer);
		return true;
	}
	newOffer.m_relatedOffers.push_back(newOffer);
	addOffer(id, newOffer);

	const Offer* foundOffer = getOfferById(id);
	if (!foundOffer) {
		g_logger().warn("Offer {} not found.", name);
		return false;
	}
	category->addOffer(foundOffer);
	if (!collection.empty()) {
		category->addCollection(collection);
	}

	return true;
}

bool IOStore::loadStoreHome(pugi::xml_node homeNode) {
	auto bannersNode = homeNode.child("banners");
	auto bannerDelay = static_cast<uint8_t>(bannersNode.attribute("delay").as_uint());
	setBannerDelay(bannerDelay);

	pugi::xml_node bannersChild = bannersNode.first_child();
	if (bannersChild && std::string(bannersChild.name()) == "banner") {
		for (pugi::xml_node banner : bannersNode.children("banner")) {
			BannerInfo tempBanner;

			std::string bannerPath = std::string(banner.attribute("path").as_string());
			if (bannerPath.empty()) {
				return false;
			}
			tempBanner.path = bannerPath;

			std::string bannerTypeString = std::string(banner.attribute("type").as_string());
			auto it = stringToBannerTypeMap.find(bannerTypeString);
			if (it == stringToBannerTypeMap.end()) {
				return false;
			}
			BannerType bannerType = it->second;

			if (bannerType == BannerType::COLLECTION) {
				std::string categoryName = std::string(banner.attribute("category").as_string());
				std::string collectionName = std::string(banner.attribute("collection").as_string());
				if (categoryName.empty() || collectionName.empty()) {
					return false;
				}
				tempBanner.categoryName = categoryName;
				tempBanner.collectionName = collectionName;
			} else if (bannerType == BannerType::OFFER) {
				std::string offerName = std::string(banner.attribute("offer").as_string());
				if (offerName.empty()) {
					return false;
				}
				tempBanner.offerName = offerName;
			} else {
				return false;
			}
			tempBanner.type = bannerType;

			m_banners.push_back(tempBanner);
		}
	} else {
		return false;
	}

	auto homeOffersNode = homeNode.child("offers");
	pugi::xml_node homeOffersChild = homeOffersNode.first_child();
	if (homeOffersChild && std::string(homeOffersChild.name()) == "offer") {
		for (pugi::xml_node offer : homeOffersNode.children("offer")) {
			auto homeOfferId = static_cast<uint32_t>(offer.attribute("id").as_uint());
			m_homeOffers.push_back(homeOfferId);
		}
	}

	return true;
}

const std::vector<Category> &IOStore::getCategoryVector() const {
	return m_categoryVector;
}
void IOStore::addCategory(const Category &newCategory) {
	for (const auto &category : m_categoryVector) {
		if (newCategory.getName() == category.getName()) {
			return;
		}
	}
	m_categoryVector.push_back(newCategory);
}

const Category* IOStore::getCategoryByName(std::string_view categoryName) const {
	for (const auto &category : m_categoryVector) {
		if (categoryName == category.getName()) {
			return &category;
		}
	}
	return nullptr;
}

const Category* IOStore::getSubCategoryByName(std::string_view subCategoryName) const {
	for (const auto &subCategory : m_subCategoryVector) {
		if (subCategoryName == subCategory.getName()) {
			return &subCategory;
		}
	}
	return nullptr;
}

void IOStore::addOffer(uint32_t offerId, Offer offer) {
	auto it = m_offersMap.find(offerId);
	if (it != m_offersMap.end()) {
		return;
	}

	m_offersMap.try_emplace(offerId, std::move(offer));
}

const Offer* IOStore::getOfferById(uint32_t offerId) const {
	if (auto it = m_offersMap.find(offerId);
	    it != m_offersMap.end()) {
		return &it->second;
	}

	return nullptr;
}

std::vector<Offer> IOStore::getOffersContainingSubstring(const std::string &searchString) {
	std::vector<Offer> offersVector;
	auto lowerSearchString = asLowerCaseString(searchString);

	for (const auto &[id, offer] : m_offersMap) {
		const auto &currentOfferName = offer.getName();
		auto lowerCurrentOfferName = asLowerCaseString(currentOfferName);

		if (lowerCurrentOfferName.find(lowerSearchString) != std::string::npos) {
			offersVector.push_back(offer);
		}
	}

	return offersVector;
}

Offer* IOStore::getOfferByName(const std::string &searchString) {
	auto lowerSearchString = asLowerCaseString(searchString);

	for (auto &[id, offer] : m_offersMap) {
		auto currentOfferName = offer.getName();
		auto lowerCurrentOfferName = asLowerCaseString(currentOfferName);

		if (lowerSearchString == lowerCurrentOfferName) {
			return &offer;
		}
	}

	return nullptr;
}

const std::vector<BannerInfo> &IOStore::getBannersVector() const {
	return m_banners;
}
const std::vector<uint32_t> &IOStore::getHomeOffersVector() const {
	return m_homeOffers;
}
uint32_t IOStore::getBannerDelay() const {
	return m_bannerDelay;
}
void IOStore::setBannerDelay(uint8_t delay) {
	m_bannerDelay = delay;
}

const Category* IOStore::findCategory(const std::string &categoryName) {
	auto currentCategory = getCategoryByName(categoryName);
	if (!currentCategory) {
		currentCategory = getSubCategoryByName(categoryName);
		return currentCategory;
	}

	if (currentCategory->isSpecialCategory()) {
		return currentCategory;
	}

	auto subCat = currentCategory->getFirstSubCategory();
	return subCat;
}

const std::vector<std::string> &IOStore::getOffersDisableReasonVector() const {
	return m_offersDisableReason;
}

StoreHistoryDetail IOStore::getStoreHistoryDetail(const std::string &playerName, uint32_t createdAt, bool hasDetail) {
	std::string query = fmt::format(
		"SELECT * FROM `store_history` WHERE `player_name` = {} AND `created_at` = {} AND `show_detail` = {}",
		g_database().escapeString(playerName), createdAt, static_cast<uint8_t>(hasDetail)
	);

	DBResult_ptr result = Database::getInstance().storeQuery(query);
	if (!result) {
		g_logger().error("Failed to get store history details.");
		return {};
	}

	StoreHistoryDetail storeDetail;
	storeDetail.type = result->getNumber<StoreDetailType>("type");
	storeDetail.createdAt = createdAt;
	storeDetail.coinAmount = result->getNumber<int32_t>("coin_amount");
	storeDetail.description = result->getString("description");
	storeDetail.playerName = result->getString("player_name");
	storeDetail.totalPrice = result->getNumber<int64_t>("total_price");

	g_logger().debug("Store details for creation data: {}, description '{}', player '{}', coin amount '{}', total price '{}'", storeDetail.createdAt, storeDetail.description, storeDetail.playerName, storeDetail.coinAmount, storeDetail.totalPrice);
	return storeDetail;
}

// Category Class functions
const Category* Category::getFirstSubCategory() const {
	return &m_subCategories.at(0);
}
const std::vector<Category> &Category::getSubCategoriesVector() const {
	return m_subCategories;
}
void Category::addSubCategory(const Category &newSubCategory) {
	for (const auto &subCategory : m_subCategories) {
		if (newSubCategory.getName() == subCategory.getName()) {
			return;
		}
	}
	m_subCategories.push_back(newSubCategory);
}

const std::vector<const Offer*> &Category::getOffersVector() const {
	return m_offers;
}
void Category::addOffer(const Offer* newOffer) {
	for (const auto &offer : m_offers) {
		if (newOffer->getID() == offer->getID()
		    && newOffer->getName() == offer->getName()
		    && newOffer->getCount() == offer->getCount()) {
			return;
		}
	}
	m_offers.push_back(newOffer);
}

const std::vector<std::string> &Category::getCollectionsVector() const {
	return m_collections;
}
void Category::addCollection(const std::string &newCollection) {
	for (const auto &collection : m_collections) {
		if (newCollection == collection) {
			return;
		}
	}
	m_collections.push_back(newCollection);
}

// Offer Functions
const std::vector<Offer> &Offer::getRelatedOffersVector() const {
	return m_relatedOffers;
}
void Offer::addRelatedOffer(const Offer &relatedOffer) {
	for (const auto &offer : m_relatedOffers) {
		if (relatedOffer.getCount() == offer.getCount()
		    && relatedOffer.getPrice() == offer.getPrice()) {
			return;
		}
	}

	m_relatedOffers.push_back(relatedOffer);
}

ConverType_t Offer::getConverType() const {
	using enum OfferTypes_t;

	switch (m_type) {
		case MOUNT:
			return ConverType_t::MOUNT;
		case LOOKTYPE:
			return ConverType_t::LOOKTYPE;
		case ITEM:
		case STACKABLE:
		case HOUSE:
		case CHARGES:
		case POUCH:
			return ConverType_t::ITEM;
		case OUTFIT:
		case HIRELING:
			return ConverType_t::OUTFIT;

		default:
			return ConverType_t::NONE;
	}
}

bool Offer::getUseConfigure() const {
	using enum OfferTypes_t;
	if (m_type == NAMECHANGE || m_type == HIRELING || m_type == HIRELING_NAMECHANGE) {
		return true;
	}

	return false;
}
