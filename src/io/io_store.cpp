/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
 */

#include "pch.hpp"

#include "io/io_store.hpp"

#include "creatures/monsters/monsters.hpp"
#include "creatures/players/player.hpp"
#include "utils/tools.hpp"

bool IOStore::loadFromXml() {
	pugi::xml_document doc;
	auto folder = g_configManager().getString(CORE_DIRECTORY, __FUNCTION__) + "/XML/store/store.xml";
	if (!doc.load_file(folder.c_str())) {
		printXMLError(__FUNCTION__, folder, doc.load_file(folder.c_str()));
		consoleHandlerExit();
		return false;
	}

	auto storeNode = doc.child("store");

	pugi::xml_node homeNode = storeNode.child("home");
	if (!loadStoreHome(homeNode)) {
		return false;
	}

	for (pugi::xml_node category : storeNode.children("category")) {
		auto categoryName = std::string(category.attribute("name").as_string());
		auto categoryIcon = std::string(category.attribute("icon").as_string());
		auto categoryRookString = std::string(category.attribute("rookgaard").as_string());
		bool categoryRook;
		if (categoryRookString == "yes") {
			categoryRook = true;
		} else {
			categoryRook = false;
		}

		Category newCategory(categoryName, categoryIcon, categoryRook);

		pugi::xml_node child = category.first_child();
		if (child && std::string(child.name()) == "subcategory") {
			for (pugi::xml_node subcategory : category.children("subcategory")) {
				auto subCategoryName = std::string(subcategory.attribute("name").as_string());
				auto subCategoryIcon = std::string(subcategory.attribute("icon").as_string());

				auto subCategoryRookString = std::string(category.attribute("rookgaard").as_string());
				bool subCategoryRook;
				if (subCategoryRookString == "yes") {
					subCategoryRook = true;
				} else {
					subCategoryRook = false;
				}

				auto subCategoryStateString = std::string(subcategory.attribute("state").as_string());
				States_t subCategoryState;
				if (auto it = stringToOfferStateMap.find(subCategoryStateString);
				    it != stringToOfferStateMap.end()) {
					subCategoryState = it->second;
				} else {
					subCategoryState = States_t::NONE;
				}

				Category newSubCategory(subCategoryName, subCategoryIcon, subCategoryRook, subCategoryState);
				for (pugi::xml_node offer : subcategory.children("offer")) {
					auto thisOffer = loadOfferFromXml(&newSubCategory, offer);
					if (!thisOffer) {
						return false;
					}
				}
				subCategoryVector.push_back(newSubCategory);
				newCategory.addSubCategory(newSubCategory);
			}
		} else if (child && std::string(child.name()) == "offer") {
			newCategory.setSpecialCategory(true);
			for (pugi::xml_node offer : category.children("offer")) {
				auto thisOffer = loadOfferFromXml(&newCategory, offer);
				if (!thisOffer) {
					return false;
				}
			}
		}
		addCategory(newCategory);
	}

	return true;
}

bool IOStore::loadOfferFromXml(Category* category, pugi::xml_node offer) {
	auto name = std::string(offer.attribute("name").as_string());
	if (name.empty()) {
		g_logger().warn("Offer name empty.");
		return false;
	}

	std::string icon = "";
	if (offer.attribute("icon")) {
		icon = std::string(offer.attribute("icon").as_string());
	}

	auto id = static_cast<uint32_t>(offer.attribute("offerId").as_uint());
	if (id == 0) {
		g_logger().warn("Offer {} id is 0.", name);
		return false;
	}

	auto price = static_cast<uint32_t>(offer.attribute("price").as_uint());
	if (price == 0) {
		g_logger().warn("Offer {} price is 0.", name);
		return false;
	}

	auto typeString = std::string(offer.attribute("type").as_string());
	OfferTypes_t type;
	if (auto it = stringToOfferTypeMap.find(typeString);
	    it != stringToOfferTypeMap.end()) {
		type = it->second;
	} else {
		g_logger().warn("Offer {} type is none.", name);
		return false;
	}

	OutfitIds outfitId;
	if (type == OfferTypes_t::OUTFIT || type == OfferTypes_t::HIRELING) {
		auto femaleId = static_cast<uint16_t>(offer.attribute("female").as_uint());
		auto maleId = static_cast<uint16_t>(offer.attribute("male").as_uint());
		outfitId.femaleId = femaleId;
		outfitId.maleId = maleId;
	}

	auto stateString = std::string(offer.attribute("state").as_string());
	States_t state = States_t::NONE;
	if (auto it = stringToOfferStateMap.find(stateString);
	    it != stringToOfferStateMap.end()) {
		state = it->second;
	}

	uint16_t count = 1;
	if (offer.attribute("count")) {
		count = static_cast<uint16_t>(offer.attribute("count").as_uint());
	}

	uint16_t validUntil = 0;
	if (offer.attribute("validUntil")) {
		validUntil = static_cast<uint16_t>(offer.attribute("validUntil").as_uint());
	}

	CoinType_t coinType = CoinType_t::COIN;
	if (offer.attribute("coinType")) {
		coinType = CoinType_t::COIN;
	}

	std::string desc = "";
	if (offer.attribute("description")) {
		desc = std::string(offer.attribute("description").as_string());
	}

	bool isMovable = false;
	if (offer.attribute("movable")) {
		isMovable = bool(offer.attribute("movable").as_bool());
	}

	auto parentName = category->getCategoryName();
	Offer newOffer(parentName, name, icon, id, price, type, state, count, validUntil, coinType, desc, outfitId, isMovable);

	addOffer(id, newOffer);
	category->addOffer(newOffer);

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
			tempBanner.bannerName = std::string(banner.attribute("path").as_string());
			if (tempBanner.bannerName.empty()) {
				return false;
			}

			tempBanner.offerId = static_cast<uint32_t>(banner.attribute("bannerOfferId").as_uint());
			if (tempBanner.offerId == 0) {
				return false;
			}

			banners.push_back(tempBanner);
		}
	} else {
		return false;
	}

	auto homeOffersNode = homeNode.child("offers");
	pugi::xml_node homeOffersChild = homeOffersNode.first_child();
	if (homeOffersChild && std::string(homeOffersChild.name()) == "offer") {
		for (pugi::xml_node offer : homeOffersNode.children("offer")) {
			auto homeOfferId = static_cast<uint32_t>(offer.attribute("id").as_uint());

			homeOffers.push_back(homeOfferId);
		}
	}

	return true;
}

std::vector<Category> IOStore::getCategoryVector() const {
	return categoryVector;
}
void IOStore::addCategory(Category newCategory) {
	for (const auto &category : categoryVector) {
		if (newCategory.getCategoryName() == category.getCategoryName()) {
			return;
		}
	}
	categoryVector.push_back(newCategory);
}

const Category* IOStore::getCategoryByName(std::string categoryName) const {
	for (const auto &category : categoryVector) {
		if (categoryName == category.getCategoryName()) {
			return &category;
		}
	}
	return nullptr;
}

const Category* IOStore::getSubCategoryByName(std::string subCategoryName) const {
	for (const auto &subCategory : subCategoryVector) {
		if (subCategoryName == subCategory.getCategoryName()) {
			return &subCategory;
		}
	}
	return nullptr;
}

void IOStore::addOffer(uint32_t offerId, Offer offer) {
	if (auto it = offersMap.find(offerId);
	    it != offersMap.end()) {
		return;
	}

	offersMap.try_emplace(offerId, offer);
	auto newOffer = std::pair<uint32_t, Offer>(offerId, offer);
	offersMap.insert(newOffer);
}

const Offer* IOStore::getOfferById(uint32_t offerId) const {
	if (auto it = offersMap.find(offerId);
	    it != offersMap.end()) {
		return &it->second;
	}
	return nullptr;
}

std::vector<Offer> IOStore::getOffersContainingSubstring(const std::string &searchString) {
	std::vector<Offer> offersVector;
	auto lowerSearchString = asLowerCaseString(searchString);

	for (const auto &offer : offersMap) {
		auto currentOfferName = offer.second.getOfferName();
		auto lowerCurrentOfferName = asLowerCaseString(currentOfferName);

		if (lowerCurrentOfferName.find(lowerSearchString) != std::string::npos) {
			offersVector.push_back(offer.second);
		}
	}

	return offersVector;
}

std::vector<BannerInfo> IOStore::getBannersVector() const {
	return banners;
}
std::vector<uint32_t> IOStore::getHomeOffersVector() const {
	return homeOffers;
}
uint32_t IOStore::getBannerDelay() const {
	return bannerDelay;
}
void IOStore::setBannerDelay(uint8_t delay) {
	bannerDelay = delay;
}

const Category* IOStore::findCategory(std::string categoryName) {
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

const std::vector<std::string> IOStore::getOffersDisableReasonVector() {
	return offersDisableReason;
}

// Category Class functions
const Category* Category::getFirstSubCategory() const {
	return &subCategories.at(0);
}
std::vector<Category> Category::getSubCategoriesVector() const {
	return subCategories;
}
void Category::addSubCategory(Category newSubCategory) {
	for (const auto &subCategory : subCategories) {
		if (newSubCategory.getCategoryName() == subCategory.getCategoryName()) {
			return;
		}
	}
	subCategories.push_back(newSubCategory);
}

std::vector<Offer> Category::getOffersVector() const {
	return offers;
}
void Category::addOffer(Offer newOffer) {
	for (const auto &offer : offers) {
		if (newOffer.getOfferId() == offer.getOfferId()
		    && newOffer.getOfferName() == offer.getOfferName()
		    && newOffer.getOfferCount() == offer.getOfferCount()) {
			return;
		}
	}
	offers.push_back(newOffer);
}

// Offer Functions
ConverType_t Offer::getConverType() const {
	if (offerType == OfferTypes_t::MOUNT) {
		return ConverType_t::MOUNT;
	} else if (offerType == OfferTypes_t::OUTFIT) {
		return ConverType_t::OUTFIT;
	} else if (offerType == OfferTypes_t::ITEM || offerType == OfferTypes_t::STACKABLE || offerType == OfferTypes_t::HOUSE || offerType == OfferTypes_t::CHARGES || offerType == OfferTypes_t::POUCH) {
		return ConverType_t::ITEM;
	} else if (offerType == OfferTypes_t::HIRELING) {
		return ConverType_t::HIRELING;
	}

	return ConverType_t::NONE;
}

bool Offer::getUseConfigure() const {
	if (offerType == OfferTypes_t::NAMECHANGE || offerType == OfferTypes_t::HIRELING || offerType == OfferTypes_t::HIRELING_NAMECHANGE) {
		return true;
	}

	return false;
}
