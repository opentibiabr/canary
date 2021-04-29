/**
 * @file gamestore.cpp
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

#include "otpch.h"

#include "game/gamestore.h"

#include "utils/pugicast.h"
#include "utils/tools.h"
#include "database/database.h"

#include <boost/algorithm/string.hpp>

uint16_t GameStore::HISTORY_ENTRIES_PER_PAGE=16;

std::vector<std::string> getIconsVector(std::string rawString)
{
	std::vector<std::string> icons;
	boost::split(icons, rawString, boost::is_any_of("|")); //converting the |-separated string to a vector of tokens
	icons.shrink_to_fit();
	return icons;
}

std::vector<uint8_t> getIntVector(std::string rawString)
{
	std::vector<uint8_t> ints;
	std::vector<std::string> rawInts;
	boost::split(rawInts, rawString, boost::is_any_of("|"));

	for(std::string numStr : rawInts) {
		uint8_t i = (uint8_t)std::stoi(numStr) ;
		ints.push_back(i);
	}
	ints.shrink_to_fit();
	return ints;
}

bool GameStore::reload()
{
	for (auto category:storeCategoryOffers) {
		for (auto offer:category->offers) {
			offer->icons.clear();
			if (offer->type == BLESSING) {
				((BlessingOffer *) offer)->blessings.clear();
			}
			free(offer); //offer is a pointer, so it needs to be released manually
		}
		category->offers.clear();
		category->icons.clear();
		free(category); //category is also a pointer
	}
	storeCategoryOffers.clear();
	loaded = false;
	return loadFromXml();
}

bool GameStore::loadFromXml()
{
	if (isLoaded()) {
		return true;
	} else {
		offerCount = 0;
		pugi::xml_document doc;
		pugi::xml_parse_result result = doc.load_file("data/XML/gamestore.xml");
		if (!result) {
			printXMLError("Error - GameStore::loadFromXml", "data/XML/gamestore.xml", result);
			return false;
		}

		for (auto categoryNode : doc.child("gamestore").children()) { //category iterator
			StoreCategory *cat = new StoreCategory();
			cat->name = categoryNode.attribute("name").as_string();
			cat->description = categoryNode.attribute("description").as_string("");
			if (!cat->name.length()) {
				printXMLError("Error parsing XML category name  - GameStore::loadFromXml", "data/XML/gamestore.xml", result);
				return false;
			}

			std::string state = categoryNode.attribute("state").as_string("normal");
			if (boost::iequals(state, "normal")) { //reading state (defaults to normal)
				cat->state = StoreState_t::NORMAL;
			} else if (boost::iequals(state, "new")) {
				cat->state = StoreState_t::NEW;
			} else if (boost::iequals(state, "sale")) {
				cat->state = StoreState_t::SALE;
			} else if (boost::iequals(state, "limitedtime")) {
				cat->state = StoreState_t::LIMITED_TIME;
			}
			cat->icons = getIconsVector(categoryNode.attribute("icons").as_string("default.png"));

			for (auto offerNode : categoryNode.children()) {
				std::string type = offerNode.attribute("type").as_string();
				BaseOffer *offer = nullptr;
				if (boost::iequals(type, "namechange")) {
					offer = new BaseOffer();
					offer->type = NAMECHANGE;
				} else if (boost::iequals(type, "sexchange")) {
					offer = new BaseOffer();
					offer->type = SEXCHANGE;
				} else if (boost::iequals(type, "promotion")) {
					offer = new BaseOffer();
					offer->type = PROMOTION;
				} else if (boost::iequals(type, "outfit")) {
					OutfitOffer *tmp = new OutfitOffer();
					tmp->type = OUTFIT;
					tmp->maleLookType = (uint16_t) offerNode.attribute("malelooktype").as_uint();
					tmp->femaleLookType = (uint16_t) offerNode.attribute("femalelooktype").as_uint();
					tmp->addonNumber = (uint8_t) offerNode.attribute("addon").as_uint(0);
					if (!tmp->femaleLookType || !tmp->maleLookType || tmp->addonNumber > 3) {
						printXMLError("Error parsing XML outfit offer  - GameStore::loadFromXml",
									  "data/XML/gamestore.xml",
									  result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "addon")) {
					OutfitOffer *tmp = new OutfitOffer();
					tmp->type = OUTFIT_ADDON;
					tmp->maleLookType = (uint16_t) offerNode.attribute("malelooktype").as_uint();
					tmp->femaleLookType = (uint16_t) offerNode.attribute("femalelooktype").as_uint();
					tmp->addonNumber = (uint8_t) offerNode.attribute("addon").as_uint(0);
					if (!tmp->femaleLookType || !tmp->maleLookType || !tmp->addonNumber || tmp->addonNumber > 3) {
						printXMLError("Error parsing XML addon offer - GameStore::loadFromXml", "data/XML/gamestore.xml", result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "mount")) {
					MountOffer *tmp = new MountOffer();
					tmp->type = MOUNT;
					tmp->mountId = (uint8_t) offerNode.attribute("mountid").as_uint();
					if (!tmp->mountId) {
						printXMLError(
								"Error parsing XML mountID number not specified for an mount offer - GameStore::loadFromXml",
								"data/XML/gamestore.xml", result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "item")) {
					ItemOffer *tmp = new ItemOffer();
					tmp->type = ITEM;
					tmp->productId = (uint16_t) offerNode.attribute("productid").as_uint();
					tmp->count = (uint16_t) offerNode.attribute("count").as_uint();

					if (!tmp->productId || !tmp->count) {
						printXMLError("Error parsing XML Item Offer - GameStore::loadFromXml",
									  "data/XML/gamestore.xml", result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "stackableitem")) {
					ItemOffer *tmp = new ItemOffer();
					tmp->type = STACKABLE_ITEM;
					tmp->productId = (uint16_t) offerNode.attribute("productid").as_uint();
					tmp->count = (uint16_t) offerNode.attribute("count").as_uint();

					if (!tmp->productId || !tmp->count) {
						printXMLError("Error parsing XML Stackable Item Offer - GameStore::loadFromXml",
									  "data/XML/gamestore.xml", result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "wrapitem")) {
					ItemOffer *tmp = new ItemOffer();
					tmp->type = WRAP_ITEM;
					tmp->productId = (uint16_t) offerNode.attribute("productid").as_uint();
					tmp->count = (uint16_t) offerNode.attribute("count").as_uint();
					if (!tmp->productId || !tmp->count) {
						printXMLError("Error parsing XML Wrappable Item Offer - GameStore::loadFromXml",
									  "data/XML/gamestore.xml", result);
						return false;
					} else {
						offer = tmp;
					}
				} else if (boost::iequals(type, "bless")) {
					BlessingOffer* tmp = new BlessingOffer();
					tmp->blessings = getIntVector(offerNode.attribute("blessnumber").as_string());
					tmp->type = BLESSING;
					if (!tmp->blessings.size()) {
						//no number was found
						printXMLError("Error Parsing XML bless offer - no blessnumber specified  - GameStore::loadFromXml",
										"data/XML/gamestore.xml", result);
						return false;
					}

					offer = tmp;
				} else if (boost::iequals(type, "teleport")) {
					TeleportOffer* tmp = new TeleportOffer();
					tmp->type = TELEPORT;

					uint16_t posX, posY;
					uint8_t posZ;
					posX = (uint16_t)offerNode.attribute("x").as_uint();
					posY = (uint16_t)offerNode.attribute("y").as_uint();
					posZ = (uint8_t)offerNode.attribute("z").as_uint();

					tmp->position = Position(posX,posY,posZ);

					offer = tmp;
				} else if (boost::iequals(type, "premiumtime")) {
					PremiumTimeOffer* tmp = new PremiumTimeOffer();
					tmp->type = PREMIUM_TIME;

					tmp->days = (uint16_t)offerNode.attribute("days").as_uint();
					if (tmp->days == 0) {
						printXMLError("Error parsing XML premiumtime offer type - required 'days' attribute not found - GameStore::loadFromXml",
									  "data/XML/gamestore.xml",
									  result);
						return false;
					}

					offer = tmp;
				}

				if (!offer) {
					printXMLError("Error parsing XML invalid offer type - GameStore::loadFromXml", "data/XML/gamestore.xml", result);
					return false;
				} else {
					offer->name = offerNode.attribute("name").as_string();
					offer->price = offerNode.attribute("price").as_uint();
					offer->description = offerNode.attribute("description").as_string("");
					offer->icons = getIconsVector(offerNode.attribute("icons").as_string("default.png"));

					std::string offerstate = categoryNode.attribute("state").as_string("normal");

					if (boost::iequals(offerstate, "normal")) { //reading state (defaults to normal)
						offer->state = StoreState_t::NORMAL;
					} else if (boost::iequals(offerstate, "new")) {
						offer->state = StoreState_t::NEW;
					} else if (boost::iequals(offerstate, "sale")) {
						//offer->state = StoreState_t::SALE;
					 // TODO: Solve the client crash with sale offers. Probably we need to add the previous price to show the strikethrough text indicating a sale.
						offer->state = StoreState_t::NORMAL;
					} else if (boost::iequals(offerstate, "limitedtime")) {
						offer->state = StoreState_t::LIMITED_TIME;
					}

					if (!offer->name.length() || !offer->price) {
						printXMLError(
								"Error parsing XML - One or more required offer params are missing - GameStore::loadFromXml",
								"data/XML/gamestore.xml", result);
						return false;
					}
					offerCount++;
					offer->id = offerCount;
					cat->offers.push_back(offer);
				}
			}
			cat->offers.shrink_to_fit();
			storeCategoryOffers.push_back(cat);
		}
		storeCategoryOffers.shrink_to_fit();
		loaded = true;
		return true;
	}
}

int8_t GameStore::getCategoryIndexByName(std::string categoryName)
{
	for (uint16_t i = 0; i < storeCategoryOffers.size(); i++) {
		if (boost::iequals(storeCategoryOffers.at(i)->name, categoryName)) {
			return i;
		}
	}

	return -1;
}

bool GameStore::haveCategoryByState(StoreState_t state)
{
	for (auto category : storeCategoryOffers) {
		if (category->state == state) {
			return true;
		}
	}

	return false;
}

uint16_t GameStore::getOffersCount()
{
	uint16_t count = 0;
	for(auto category:storeCategoryOffers) {
		count+= category->offers.size();
	}

	return count;
}

const BaseOffer *GameStore::getOfferByOfferId(uint32_t offerId)
{
	for(StoreCategory* category : storeCategoryOffers) {
		for (BaseOffer *offer : category->offers) {
			if (offer->id == offerId) {
				return offer;
			}
		}
	}

	return nullptr;
}

HistoryStoreOfferList IOGameStore::getHistoryEntries(uint32_t account_id, uint32_t page)
{
	HistoryStoreOfferList historyStoreOfferList;

	std::ostringstream query;

	query << "SELECT `description`,`mode`,`coin_amount`,`time` FROM `store_history` WHERE `account_id` = " <<account_id << " ORDER BY `time` DESC LIMIT "
		  << (std::max<int>((page-1),0)*GameStore::HISTORY_ENTRIES_PER_PAGE)
		  << "," << GameStore::HISTORY_ENTRIES_PER_PAGE <<";";
	DBResult_ptr result = Database::getInstance().storeQuery(query.str());

	if (result) {
		do {
			HistoryStoreOffer entry;

			entry.description = result->getString("description");
			entry.mode = result->getNumber<uint8_t>("mode");
			entry.amount = result->getNumber<uint32_t>("coin_amount");
			entry.time = result->getNumber<uint32_t>("time");

			historyStoreOfferList.push_back(entry);
		} while (result->next());
	}

	return historyStoreOfferList;
}
