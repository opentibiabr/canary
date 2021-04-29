/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
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

#include "utils/pugicast.h"

#include "map/house/house.h"
#include "io/iologindata.h"
#include "game/game.h"
#include "config/configmanager.h"
#include "items/bed.h"

extern ConfigManager g_config;
extern Game g_game;

House::House(uint32_t houseId) : id(houseId) {}

void House::addTile(HouseTile* tile)
{
	tile->setFlag(TILESTATE_PROTECTIONZONE);
	houseTiles.push_back(tile);
}

void House::setOwner(uint32_t guid, bool updateDatabase/* = true*/, Player* player/* = nullptr*/)
{
	if (updateDatabase && owner != guid) {
		Database& db = Database::getInstance();

		std::ostringstream query;
		query << "UPDATE `houses` SET `owner` = " << guid << ", `bid` = 0, `bid_end` = 0, `last_bid` = 0, `highest_bidder` = 0  WHERE `id` = " << id;
		db.executeQuery(query.str());
	}

	if (isLoaded && owner == guid) {
		return;
	}

	isLoaded = true;

	if (owner != 0) {
		//send items to depot
		if (player) {
			transferToDepot(player);
		} else {
			transferToDepot();
		}

		for (HouseTile* tile : houseTiles) {
			if (const CreatureVector* creatures = tile->getCreatures()) {
				for (int32_t i = creatures->size(); --i >= 0;) {
					kickPlayer(nullptr, (*creatures)[i]->getPlayer());
				}
			}
		}

		// Remove players from beds
		for (BedItem* bed : bedsList) {
			if (bed->getSleeper() != 0) {
				bed->wakeUp(nullptr);
			}
		}

		//clean access lists
		owner = 0;
		ownerAccountId = 0;
		setAccessList(SUBOWNER_LIST, "");
		setAccessList(GUEST_LIST, "");

		for (Door* door : doorList) {
			door->setAccessList("");
		}
	} else {
		std::string strRentPeriod = asLowerCaseString(g_config.getString(ConfigManager::HOUSE_RENT_PERIOD));
		time_t currentTime = time(nullptr);
		if (strRentPeriod == "yearly") {
		    currentTime += 24 * 60 * 60 * 365;
		} else if (strRentPeriod == "monthly") {
		    currentTime += 24 * 60 * 60 * 30;
		} else if (strRentPeriod == "weekly") {
		    currentTime += 24 * 60 * 60 * 7;
		} else if (strRentPeriod == "daily") {
		    currentTime += 24 * 60 * 60;
		} else {
		    currentTime = 0;
		}

		paidUntil = currentTime;
	}

	rentWarnings = 0;

	if (guid != 0) {

		Database& db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT `name`, `account_id` FROM `players` WHERE `id` = " << guid;
		DBResult_ptr result = db.storeQuery(query.str());
		if (!result) {
			return;
		}

		std::string name = result->getString("name");
		if (!name.empty()) {
			owner = guid;
			ownerName = name;
			ownerAccountId =  result->getNumber<uint32_t>("account_id");
		}
	}

	updateDoorDescription();
}

void House::updateDoorDescription() const
{
	std::ostringstream ss;
	if (owner != 0) {
		ss << "It belongs to house '" << houseName << "'. " << ownerName << " owns this house.";
	} else {
		ss << "It belongs to house '" << houseName << "'. Nobody owns this house.";

		const int32_t housePrice = g_config.getNumber(ConfigManager::HOUSE_PRICE);
		if (housePrice != -1) {
			ss << " It costs " << (houseTiles.size() * housePrice) << " gold coins.";
		}
	}

	for (const auto& it : doorList) {
		it->setSpecialDescription(ss.str());
	}
}

AccessHouseLevel_t House::getHouseAccessLevel(const Player* player)
{
	if (!player) {
		return HOUSE_OWNER;
	}

	if (g_config.getBoolean(ConfigManager::HOUSE_OWNED_BY_ACCOUNT)) {
		if (ownerAccountId == player->getAccount()) {
			return HOUSE_OWNER;
		}
	}

	if (player->hasFlag(PlayerFlag_CanEditHouses)) {
		return HOUSE_OWNER;
	}

	if (player->getGUID() == owner) {
		return HOUSE_OWNER;
	}

	if (subOwnerList.isInList(player)) {
		return HOUSE_SUBOWNER;
	}

	if (guestList.isInList(player)) {
		return HOUSE_GUEST;
	}

	return HOUSE_NOT_INVITED;
}

bool House::kickPlayer(Player* player, Player* target)
{
	if (!target) {
		return false;
	}

	HouseTile* houseTile = dynamic_cast<HouseTile*>(target->getTile());
	if (!houseTile || houseTile->getHouse() != this) {
		return false;
	}

	if (getHouseAccessLevel(player) < getHouseAccessLevel(target) || target->hasFlag(PlayerFlag_CanEditHouses)) {
		return false;
	}

	Position oldPosition = target->getPosition();
	if (g_game.internalTeleport(target, getEntryPosition()) == RETURNVALUE_NOERROR) {
		g_game.addMagicEffect(oldPosition, CONST_ME_POFF);
		g_game.addMagicEffect(getEntryPosition(), CONST_ME_TELEPORT);
	}
	return true;
}

void House::setAccessList(uint32_t listId, const std::string& textlist)
{
	if (listId == GUEST_LIST) {
		guestList.parseList(textlist);
	} else if (listId == SUBOWNER_LIST) {
		subOwnerList.parseList(textlist);
	} else {
		Door* door = getDoorByNumber(listId);
		if (door) {
			door->setAccessList(textlist);
		}

		// We dont have kick anyone
		return;
	}

	//kick uninvited players
	for (HouseTile* tile : houseTiles) {
		if (CreatureVector* creatures = tile->getCreatures()) {
			for (int32_t i = creatures->size(); --i >= 0;) {
				Player* player = (*creatures)[i]->getPlayer();
				if (player && !isInvited(player)) {
					kickPlayer(nullptr, player);
				}
			}
		}
	}
}

bool House::transferToDepot() const
{
	if (townId == 0 || owner == 0) {
		return false;
	}

	Player* player = g_game.getPlayerByGUID(owner);
	if (player) {
		transferToDepot(player);
	} else {
		Player tmpPlayer(nullptr);
		if (!IOLoginData::loadPlayerById(&tmpPlayer, owner)) {
			return false;
		}

		transferToDepot(&tmpPlayer);
		IOLoginData::savePlayer(&tmpPlayer);
	}
	return true;
}

bool House::transferToDepot(Player* player) const
{
	if (townId == 0 || owner == 0) {
		return false;
	}
int constructionKits[58][2] = {
{3901, 1666}, {3902, 1670}, {3903, 1652}, {3904, 1674},
{3905, 1658}, {3906, 3813}, {3907, 3817}, {3908, 1619}, {3909, 12799}, {3910, 2105},
{3911, 1614}, {3912, 3806}, {3913, 3807}, {3914, 3809}, {3915, 1716}, {3916, 1724},
{3917, 1732}, {3918, 1775}, {3919, 1774}, {3920, 1750}, {3921, 3832}, {3922, 2095},
{3923, 2098}, {3924, 2064}, {3925, 2582}, {3926, 2117}, {3927, 1728}, {3928, 1442},
{3929, 1446}, {3930, 1447}, {3931, 2034}, {3932, 2604}, {3933, 2080}, {3934, 2084},
{3935, 3821}, {3936, 3811}, {3937, 2101}, {3938, 3812}, {5086, 5046}, {5087, 5055},
{5088, 5056}, {6114, 6111}, {6115, 6109}, {6372, 6356}, {6373, 6371}, {8692, 8688},
{9974, 9975}, {11124, 11125}, {11126, 11127}, {11133, 11129}, {11205, 11203}, {14328, 1616},
{14329, 1615}, {16075, 16020}, {16099, 16098}, {20254, 20295}, {20255, 20297}, {20257, 20299},
	};
	ItemList moveItemList;
	for (HouseTile* tile : houseTiles) {
		if (const TileItemVector* items = tile->getItemList()) {
			for (Item* item : *items) {
				if (item->isWrapable()) {
					Container* container = item->getContainer();
					if (container) {
						for (Item* containerItem : container->getItemList()) {
							moveItemList.push_back(containerItem);
						}
					}
					std::string itemName = item->getName();
					uint16_t itemID = item->getID();
					Item* newItem = g_game.transformItem(item, 26054);
					ItemAttributes::CustomAttribute val;
					val.set<int64_t>(itemID);
					std::string key = "unWrapId";
					newItem->setCustomAttribute(key, val);
					std::ostringstream ss;
					ss << "Unwrap it in your own house to create a <" << itemName << ">.";
					newItem->setStrAttr(ITEM_ATTRIBUTE_DESCRIPTION, ss.str());
					moveItemList.push_back(newItem);
				}
				else if (item->isPickupable()) {
					moveItemList.push_back(item);
				}
				else {
					Container* container = item->getContainer();
					if (container) {
						for (Item* containerItem : container->getItemList()) {
							moveItemList.push_back(containerItem);
						}
					}
					for (int i = 0; i < 58; i++) {
						if (constructionKits[i][1] == item->getID()) {
							Item* newItem = g_game.transformItem(item, constructionKits[i][0]);
							moveItemList.push_back(newItem);
							break;
						}
						if (item->isRotatable()) {
							uint16_t newRotation = item->getID();
							for (int x = 0; x < 5; x++) {
								if (!Item::items[newRotation].rotatable) break;
								newRotation = Item::items[newRotation].rotateTo;
								if (newRotation == item->getID()) break;
								if (newRotation == constructionKits[i][1]) {
									Item* newItem = g_game.transformItem(item, constructionKits[i][0]);
									moveItemList.push_back(newItem);
									break;
								}
							}
						}
					}
				}
			}
		}
	}

	for (Item* item : moveItemList) {
		g_game.internalMoveItem(item->getParent(), player->getInbox(), INDEX_WHEREEVER, item, item->getItemCount(), nullptr, FLAG_NOLIMIT);
	}
	return true;
}

bool House::getAccessList(uint32_t listId, std::string& list) const
{
	if (listId == GUEST_LIST) {
		guestList.getList(list);
		return true;
	} else if (listId == SUBOWNER_LIST) {
		subOwnerList.getList(list);
		return true;
	}

	Door* door = getDoorByNumber(listId);
	if (!door) {
		return false;
	}

	return door->getAccessList(list);
}

bool House::isInvited(const Player* player)
{
	return getHouseAccessLevel(player) != HOUSE_NOT_INVITED;
}

void House::addDoor(Door* door)
{
	door->incrementReferenceCounter();
	doorList.push_back(door);
	door->setHouse(this);
	updateDoorDescription();
}

void House::removeDoor(Door* door)
{
	auto it = std::find(doorList.begin(), doorList.end(), door);
	if (it != doorList.end()) {
		door->decrementReferenceCounter();
		doorList.erase(it);
	}
}

void House::addBed(BedItem* bed)
{
	bedsList.push_back(bed);
	bed->setHouse(this);
}

Door* House::getDoorByNumber(uint32_t doorId) const
{
	for (Door* door : doorList) {
		if (door->getDoorId() == doorId) {
			return door;
		}
	}
	return nullptr;
}

Door* House::getDoorByPosition(const Position& pos)
{
	for (Door* door : doorList) {
		if (door->getPosition() == pos) {
			return door;
		}
	}
	return nullptr;
}

bool House::canEditAccessList(uint32_t listId, const Player* player)
{
	switch (getHouseAccessLevel(player)) {
		case HOUSE_OWNER:
			return true;

		case HOUSE_SUBOWNER:
			return listId == GUEST_LIST;

		default:
			return false;
	}
}

HouseTransferItem* House::getTransferItem()
{
	if (transferItem != nullptr) {
		return nullptr;
	}

	transfer_container.setParent(nullptr);
	transferItem = HouseTransferItem::createHouseTransferItem(this);
	transfer_container.addThing(transferItem);
	return transferItem;
}

void House::resetTransferItem()
{
	if (transferItem) {
		Item* tmpItem = transferItem;
		transferItem = nullptr;
		transfer_container.setParent(nullptr);

		transfer_container.removeThing(tmpItem, tmpItem->getItemCount());
		g_game.ReleaseItem(tmpItem);
	}
}

HouseTransferItem* HouseTransferItem::createHouseTransferItem(House* house)
{
	HouseTransferItem* transferItem = new HouseTransferItem(house);
	transferItem->incrementReferenceCounter();
	transferItem->setID(ITEM_DOCUMENT_RO);
	transferItem->setSubType(1);
	std::ostringstream ss;
	ss << "It is a house transfer document for '" << house->getName() << "'.";
	transferItem->setSpecialDescription(ss.str());
	return transferItem;
}

void HouseTransferItem::onTradeEvent(TradeEvents_t event, Player* owner)
{
	if (event == ON_TRADE_TRANSFER) {
		if (house) {
			house->executeTransfer(this, owner);
		}

		g_game.internalRemoveItem(this, 1);
	} else if (event == ON_TRADE_CANCEL) {
		if (house) {
			house->resetTransferItem();
		}
	}
}

bool House::executeTransfer(HouseTransferItem* item, Player* newOwner)
{
	if (transferItem != item) {
		return false;
	}

	setOwner(newOwner->getGUID());
	transferItem = nullptr;
	return true;
}

void AccessList::parseList(const std::string& list)
{
	playerList.clear();
	guildRankList.clear();
	allowEveryone = false;
	this->list = list;
	if (list.empty()) {
		return;
	}

	auto lines = explodeString(list, "\n", 100);
	for (auto& line : lines) {
		trimString(line);
		trim_left(line, '\t');
		trim_right(line, '\t');
		trimString(line);

		if (line.empty() || line.front() == '#' || line.length() > 100) {
			continue;
		}

		toLowerCaseString(line);

		std::string::size_type at_pos = line.find("@");
		if (at_pos != std::string::npos) {
			if (at_pos == 0) {
				addGuild(line.substr(1));
			} else {
				addGuildRank(line.substr(0, at_pos - 1), line.substr(at_pos + 1));
			}
		} else if (line == "*") {
			allowEveryone = true;
		} else if (line.find_first_of("!*?") != std::string::npos) {
			// Remove regular expressions since they don't make much sense in houses
			continue;
		} else if (line.length() <= NETWORKMESSAGE_PLAYERNAME_MAXLENGTH) {
			addPlayer(line);
		}
	}
}

void AccessList::addPlayer(const std::string& name)
{
	Player* player = g_game.getPlayerByName(name);
	if (player) {
		playerList.insert(player->getGUID());
	} else {
		uint32_t guid = IOLoginData::getGuidByName(name);
		if (guid != 0) {
			playerList.insert(guid);
		}
	}
}

namespace {

const Guild* getGuildByName(const std::string& name)
{
	uint32_t guildId = IOGuild::getGuildIdByName(name);
	if (guildId == 0) {
		return nullptr;
	}

	const Guild* guild = g_game.getGuild(guildId);
	if (guild) {
		return guild;
	}

	return IOGuild::loadGuild(guildId);
}

}

void AccessList::addGuild(const std::string& name)
{
	const Guild* guild = getGuildByName(name);
	if (guild) {
		for (const auto& rank : guild->getRanks()) {
			guildRankList.insert(rank->id);
		}
	}
}

void AccessList::addGuildRank(const std::string& name, const std::string& guildName)
{
	const Guild* guild = getGuildByName(guildName);
	if (guild) {
		const GuildRank_ptr rank = guild->getRankByName(name);
		if (rank) {
			guildRankList.insert(rank->id);
		}
	}
}

bool AccessList::isInList(const Player* player)
{
	if (allowEveryone) {
		return true;
	}

	auto playerIt = playerList.find(player->getGUID());
	if (playerIt != playerList.end()) {
		return true;
	}

	GuildRank_ptr rank = player->getGuildRank();
	return rank && guildRankList.find(rank->id) != guildRankList.end();
}

void AccessList::getList(std::string& retList) const
{
	retList = this->list;
}

Door::Door(uint16_t type) :	Item(type) {}

Attr_ReadValue Door::readAttr(AttrTypes_t attr, PropStream& propStream)
{
	if (attr == ATTR_HOUSEDOORID) {
		uint8_t doorId;
		if (!propStream.read<uint8_t>(doorId)) {
			return ATTR_READ_ERROR;
		}

		setDoorId(doorId);
		return ATTR_READ_CONTINUE;
	}
	return Item::readAttr(attr, propStream);
}

void Door::setHouse(House* newHouse)
{
	if (this->house != nullptr) {
		return;
	}

	this->house = newHouse;

	if (!accessList) {
		accessList.reset(new AccessList());
	}
}

bool Door::canUse(const Player* player)
{
	if (!house) {
		return true;
	}

	if (house->getHouseAccessLevel(player) >= HOUSE_SUBOWNER) {
		return true;
	}

	return accessList->isInList(player);
}

void Door::setAccessList(const std::string& textlist)
{
	if (!accessList) {
		accessList.reset(new AccessList());
	}

	accessList->parseList(textlist);
}

bool Door::getAccessList(std::string& list) const
{
	if (!house) {
		return false;
	}

	accessList->getList(list);
	return true;
}

void Door::onRemoved()
{
	Item::onRemoved();

	if (house) {
		house->removeDoor(this);
	}
}

House* Houses::getHouseByPlayerId(uint32_t playerId)
{
	for (const auto& it : houseMap) {
		if (it.second->getOwner() == playerId) {
			return it.second;
		}
	}
	return nullptr;
}

bool Houses::loadHousesXML(const std::string& filename)
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError("Error - Houses::loadHousesXML", filename, result);
		return false;
	}

	for (auto houseNode : doc.child("houses").children()) {
		pugi::xml_attribute houseIdAttribute = houseNode.attribute("houseid");
		if (!houseIdAttribute) {
			return false;
		}

		int32_t houseId = pugi::cast<int32_t>(houseIdAttribute.value());

		House* house = getHouse(houseId);
		if (!house) {
			SPDLOG_ERROR("[Houses::loadHousesXML] - Unknown house, id: {}",
                         houseId);
			return false;
		}

		house->setName(houseNode.attribute("name").as_string());

		Position entryPos(
			pugi::cast<uint16_t>(houseNode.attribute("entryx").value()),
			pugi::cast<uint16_t>(houseNode.attribute("entryy").value()),
			pugi::cast<uint16_t>(houseNode.attribute("entryz").value())
		);
		if (entryPos.x == 0 && entryPos.y == 0 && entryPos.z == 0) {
			SPDLOG_WARN("[Houses::loadHousesXML] - Entry not set for house "
                        "name: {} with id: {}", house->getName(), houseId);
		}
		house->setEntryPos(entryPos);

		house->setRent(pugi::cast<uint32_t>(houseNode.attribute("rent").value()));
		house->setTownId(pugi::cast<uint32_t>(houseNode.attribute("townid").value()));

		house->setOwner(0, false);
	}
	return true;
}

void Houses::payHouses(RentPeriod_t rentPeriod) const
{
	if (rentPeriod == RENTPERIOD_NEVER) {
		return;
	}

	time_t currentTime = time(nullptr);
	for (const auto& it : houseMap) {
		House* house = it.second;
		if (house->getOwner() == 0) {
			continue;
		}

		const uint32_t rent = house->getRent();
		if (rent == 0 || house->getPaidUntil() > currentTime) {
			continue;
		}

		const uint32_t ownerId = house->getOwner();
		Town* town = g_game.map.towns.getTown(house->getTownId());
		if (!town) {
			continue;
		}

		Player player(nullptr);
		if (!IOLoginData::loadPlayerById(&player, ownerId)) {
			// Player doesn't exist, reset house owner
			house->setOwner(0);
			continue;
		}

		if (player.getBankBalance() >= rent) {
			player.setBankBalance(player.getBankBalance() - rent);

			time_t paidUntil = currentTime;
			switch (rentPeriod) {
				case RENTPERIOD_DAILY:
					paidUntil += 24 * 60 * 60;
					break;
				case RENTPERIOD_WEEKLY:
					paidUntil += 24 * 60 * 60 * 7;
					break;
				case RENTPERIOD_MONTHLY:
					paidUntil += 24 * 60 * 60 * 30;
					break;
				case RENTPERIOD_YEARLY:
					paidUntil += 24 * 60 * 60 * 365;
					break;
				default:
					break;
			}

			house->setPaidUntil(paidUntil);
		} else {
			if (house->getPayRentWarnings() < 7) {
				int32_t daysLeft = 7 - house->getPayRentWarnings();

				Item* letter = Item::CreateItem(ITEM_LETTER_STAMPED);
				std::string period;

				switch (rentPeriod) {
					case RENTPERIOD_DAILY:
						period = "daily";
						break;

					case RENTPERIOD_WEEKLY:
						period = "weekly";
						break;

					case RENTPERIOD_MONTHLY:
						period = "monthly";
						break;

					case RENTPERIOD_YEARLY:
						period = "annual";
						break;

					default:
						break;
				}

				std::ostringstream ss;
				ss << "Warning! \nThe " << period << " rent of " << house->getRent() << " gold for your house \"" << house->getName() << "\" is payable. Have it within " << daysLeft << " days or you will lose this house.";
				letter->setText(ss.str());
				g_game.internalAddItem(player.getInbox(), letter, INDEX_WHEREEVER, FLAG_NOLIMIT);
				house->setPayRentWarnings(house->getPayRentWarnings() + 1);
			} else {
				house->setOwner(0, true, &player);
			}
		}

		IOLoginData::savePlayer(&player);
	}
}
