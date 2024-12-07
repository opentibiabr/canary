/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/house/house.hpp"

#include "config/configmanager.hpp"
#include "game/game.hpp"
#include "game/scheduling/save_manager.hpp"
#include "io/ioguild.hpp"
#include "io/iologindata.hpp"
#include "items/bed.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "lib/metrics/metrics.hpp"
#include "utils/pugicast.hpp"
#include "creatures/players/player.hpp"

House::House(uint32_t houseId) :
	id(houseId) { }

void House::addTile(const std::shared_ptr<HouseTile> &tile) {
	tile->setFlag(TILESTATE_PROTECTIONZONE);
	houseTiles.push_back(tile);
	updateDoorDescription();
}

void House::setNewOwnerGuid(int32_t newOwnerGuid, bool serverStartup) {
	auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
	if (!isTransferOnRestart) {
		setOwner(newOwnerGuid, true);
		return;
	}

	std::ostringstream query;
	query << "UPDATE `houses` SET `new_owner` = " << newOwnerGuid << " WHERE `id` = " << id;

	Database &db = Database::getInstance();
	db.executeQuery(query.str());
	if (!serverStartup) {
		setNewOwnership();
	}
}

void House::clearHouseInfo(bool preventOwnerDeletion) {
	// Remove players from beds
	for (const auto &bed : bedsList) {
		if (bed->getSleeper() != 0) {
			bed->wakeUp(nullptr);
		}
	}

	// Clean access lists
	if (!preventOwnerDeletion) {
		owner = 0;
		ownerAccountId = 0;
	}
	// Clean access lists
	setAccessList(SUBOWNER_LIST, "");
	setAccessList(GUEST_LIST, "");

	for (const auto &door : doorList) {
		door->setAccessList("");
	}
}

bool House::tryTransferOwnership(const std::shared_ptr<Player> &player, bool serverStartup) {
	bool transferSuccess = false;
	if (player) {
		transferSuccess = transferToDepot(player);
	} else {
		transferSuccess = transferToDepot();
	}

	for (const auto &tile : houseTiles) {
		if (const CreatureVector* creatures = tile->getCreatures()) {
			for (int32_t i = creatures->size(); --i >= 0;) {
				const auto &creature = (*creatures)[i];
				kickPlayer(nullptr, creature->getPlayer());
			}
		}
	}

	clearHouseInfo(serverStartup);

	return transferSuccess;
}

void House::setOwner(uint32_t guid, bool updateDatabase /* = true*/, const std::shared_ptr<Player> &player /* = nullptr*/) {
	if (updateDatabase && owner != guid) {
		Database &db = Database::getInstance();

		std::ostringstream query;
		query << "UPDATE `houses` SET `owner` = " << guid << ", `new_owner` = -1, `bid` = 0, `bid_end` = 0, `last_bid` = 0, `highest_bidder` = 0  WHERE `id` = " << id;
		db.executeQuery(query.str());
	}

	if (isLoaded && owner == guid) {
		return;
	}

	isLoaded = true;

	if (owner != 0) {
		tryTransferOwnership(player, false);
	} else {
		std::string strRentPeriod = asLowerCaseString(g_configManager().getString(HOUSE_RENT_PERIOD));
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
		Database &db = Database::getInstance();
		std::ostringstream query;
		query << "SELECT `name`, `account_id` FROM `players` WHERE `id` = " << guid;
		const DBResult_ptr result = db.storeQuery(query.str());
		if (!result) {
			return;
		}

		const std::string name = result->getString("name");
		if (!name.empty()) {
			owner = guid;
			ownerName = name;
			ownerAccountId = result->getNumber<uint32_t>("account_id");
		}
	}

	updateDoorDescription();
}

void House::updateDoorDescription() const {
	std::ostringstream ss;
	if (owner != 0) {
		ss << "It belongs to house '" << houseName << "'. " << ownerName << " owns this house.";
	} else {
		ss << "It belongs to house '" << houseName << "'. Nobody owns this house.";
	}

	ss << " It is " << getSize() << " square meters.";
	const int32_t housePrice = getPrice();
	if (housePrice != -1) {
		if (g_configManager().getBoolean(HOUSE_PURSHASED_SHOW_PRICE) || owner == 0) {
			ss << " It costs " << formatNumber(getPrice()) << " gold coins.";
		}
		std::string strRentPeriod = asLowerCaseString(g_configManager().getString(HOUSE_RENT_PERIOD));
		if (strRentPeriod != "never") {
			ss << " The rent cost is " << formatNumber(getRent()) << " gold coins and it is billed " << strRentPeriod << ".";
		}
	}

	for (const auto &it : doorList) {
		it->setAttribute(ItemAttribute_t::DESCRIPTION, ss.str());
	}
}

AccessHouseLevel_t House::getHouseAccessLevel(const std::shared_ptr<Player> &player) const {
	if (!player) {
		return HOUSE_OWNER;
	}

	if (g_configManager().getBoolean(HOUSE_OWNED_BY_ACCOUNT)) {
		if (ownerAccountId == player->getAccountId()) {
			return HOUSE_OWNER;
		}
	}

	if (player->hasFlag(PlayerFlags_t::CanEditHouses)) {
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

bool House::kickPlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target) {
	if (!target) {
		return false;
	}

	const auto &houseTile = std::dynamic_pointer_cast<HouseTile>(target->getTile());
	if (!houseTile || houseTile->getHouse() != static_self_cast<House>()) {
		return false;
	}

	if (getHouseAccessLevel(player) < getHouseAccessLevel(target) || target->hasFlag(PlayerFlags_t::CanEditHouses)) {
		return false;
	}

	const Position oldPosition = target->getPosition();
	if (g_game().internalTeleport(target, getEntryPosition()) == RETURNVALUE_NOERROR) {
		g_game().addMagicEffect(oldPosition, CONST_ME_POFF);
		g_game().addMagicEffect(getEntryPosition(), CONST_ME_TELEPORT);
	}
	return true;
}

void House::setAccessList(uint32_t listId, const std::string &textlist) {
	if (listId == GUEST_LIST) {
		guestList.parseList(textlist);
	} else if (listId == SUBOWNER_LIST) {
		subOwnerList.parseList(textlist);
	} else {
		const auto &door = getDoorByNumber(listId);
		if (door) {
			door->setAccessList(textlist);
		}

		// We dont have kick anyone
		return;
	}

	// kick uninvited players
	for (const std::shared_ptr<HouseTile> &tile : houseTiles) {
		if (const CreatureVector* creatures = tile->getCreatures()) {
			for (int32_t i = creatures->size(); --i >= 0;) {
				const auto &player = (*creatures)[i]->getPlayer();
				if (player && !isInvited(player)) {
					kickPlayer(nullptr, player);
				}
			}
		}
	}
}

bool House::transferToDepot() const {
	if (townId == 0) {
		return false;
	}

	const auto &player = g_game().getPlayerByGUID(owner);
	if (player) {
		transferToDepot(player);
	} else {
		const auto tmpPlayer = std::make_shared<Player>(nullptr);
		if (!IOLoginData::loadPlayerById(tmpPlayer, owner)) {
			return false;
		}

		transferToDepot(tmpPlayer);
	}
	return true;
}

bool House::transferToDepot(const std::shared_ptr<Player> &player) const {
	if (townId == 0 || !player) {
		return false;
	}
	for (const auto &tile : houseTiles) {
		if (!transferToDepot(player, tile)) {
			return false;
		}
	}
	return true;
}

bool House::transferToDepot(const std::shared_ptr<Player> &player, const std::shared_ptr<HouseTile> &tile) const {
	if (townId == 0 || !player) {
		return false;
	}
	if (tile->getHouse().get() != this) {
		g_logger().debug("[{}] tile house is not this house", __FUNCTION__);
		return false;
	}

	ItemList moveItemList;
	if (const TileItemVector* items = tile->getItemList()) {
		for (const auto &item : *items) {
			if (item->isWrapable()) {
				handleWrapableItem(moveItemList, item, player, tile);
			} else if (item->isPickupable()) {
				moveItemList.push_back(item);
			} else {
				handleContainer(moveItemList, item);
			}
		}
	}

	std::unordered_set<std::shared_ptr<Player>> playersToSave = { player };

	for (const auto &item : moveItemList) {
		g_logger().debug("[{}] moving item '{}' to depot", __FUNCTION__, item->getName());
		auto targetPlayer = player;
		if (item->hasOwner() && !item->isOwner(targetPlayer)) {
			targetPlayer = g_game().getPlayerByGUID(item->getOwnerId());
			if (!targetPlayer) {
				g_game().internalRemoveItem(item, item->getItemCount());
				continue;
			}
			playersToSave.insert(targetPlayer);
		}
		g_game().internalMoveItem(item->getParent(), targetPlayer->getInbox(), INDEX_WHEREEVER, item, item->getItemCount(), nullptr, FLAG_NOLIMIT);
	}
	for (const auto &playerToSave : playersToSave) {
		g_saveManager().savePlayer(playerToSave);
	}
	return true;
}

bool House::hasItemOnTile() const {
	bool foundItem = false;
	for (const auto &tile : houseTiles) {
		if (const auto &items = tile->getItemList()) {
			for (const auto &item : *items) {
				if (!item) {
					continue;
				}

				if (item->isWrapable()) {
					foundItem = true;
					g_logger().error("It is not possible to purchase a house with wrap item inside: id '{}', name '{}'", item->getID(), item->getName());
					break;
				} else if (item->isPickupable()) {
					foundItem = true;
					g_logger().error("It is not possible to purchase a house with pickupable item inside: id '{}', name '{}'", item->getID(), item->getName());
					break;
				} else {
					if (item->getContainer() && (item->isPickupable() || item->isWrapable())) {
						foundItem = true;
						g_logger().error("It is not possible to purchase a house with container item inside: id '{}', name '{}'", item->getID(), item->getName());
						break;
					}
				}
			}
		}
	}

	return foundItem;
}

bool House::hasNewOwnership() const {
	return hasNewOwnerOnStartup;
}

void House::setNewOwnership() {
	hasNewOwnerOnStartup = true;
}

void House::handleWrapableItem(ItemList &moveItemList, const std::shared_ptr<Item> &item, const std::shared_ptr<Player> &player, const std::shared_ptr<HouseTile> &houseTile) const {
	if (item->isWrapContainer()) {
		g_logger().debug("[{}] found wrapable item '{}'", __FUNCTION__, item->getName());
		handleContainer(moveItemList, item);
	}

	const auto &newItem = g_game().wrapItem(item, houseTile->getHouse());
	if (newItem->isRemoved() && !newItem->getParent()) {
		g_logger().warn("[{}] item removed during wrapping - check ground type - player name: {} item id: {} position: {}", __FUNCTION__, player->getName(), item->getID(), houseTile->getPosition().toString());
		return;
	}

	moveItemList.push_back(newItem);
}

void House::handleContainer(ItemList &moveItemList, const std::shared_ptr<Item> &item) const {
	if (const auto &container = item->getContainer()) {
		for (const auto &containerItem : container->getItemList()) {
			moveItemList.push_back(containerItem);
		}
	}
}

bool House::getAccessList(uint32_t listId, std::string &list) const {
	if (listId == GUEST_LIST) {
		guestList.getList(list);
		return true;
	} else if (listId == SUBOWNER_LIST) {
		subOwnerList.getList(list);
		return true;
	}

	const auto &door = getDoorByNumber(listId);
	if (!door) {
		return false;
	}

	return door->getAccessList(list);
}

void House::addDoor(const std::shared_ptr<Door> &door) {
	doorList.push_back(door);
	door->setHouse(static_self_cast<House>());
	updateDoorDescription();
}

void House::removeDoor(const std::shared_ptr<Door> &door) {
	auto it = std::ranges::find(doorList, door);
	if (it != doorList.end()) {
		doorList.erase(it);
	}
}

void House::addBed(const std::shared_ptr<BedItem> &bed) {
	bedsList.push_back(bed);
	bed->setHouse(static_self_cast<House>());
}

void House::removeBed(const std::shared_ptr<BedItem> &bed) {
	bed->setHouse(nullptr);
	bedsList.remove(bed);
}

std::shared_ptr<Door> House::getDoorByNumber(uint32_t doorId) const {
	for (std::shared_ptr<Door> door : doorList) {
		if (door->getDoorId() == doorId) {
			return door;
		}
	}
	return nullptr;
}

std::shared_ptr<Door> House::getDoorByPosition(const Position &pos) const {
	for (const auto &door : doorList) {
		if (door->getPosition() == pos) {
			return door;
		}
	}
	return nullptr;
}

bool House::canEditAccessList(uint32_t listId, const std::shared_ptr<Player> &player) const {
	switch (getHouseAccessLevel(player)) {
		case HOUSE_OWNER:
			return true;

		case HOUSE_SUBOWNER:
			return listId == GUEST_LIST;

		default:
			return false;
	}
}

std::shared_ptr<HouseTransferItem> House::getTransferItem() {
	if (transferItem != nullptr) {
		return nullptr;
	}

	transfer_container->resetParent();
	transferItem = HouseTransferItem::createHouseTransferItem(static_self_cast<House>());
	transfer_container->addThing(transferItem);
	return transferItem;
}

void House::resetTransferItem() {
	if (transferItem) {
		auto tmpItem = transferItem;
		transferItem = nullptr;
		transfer_container->resetParent();
		transfer_container->removeThing(tmpItem, tmpItem->getItemCount());
	}
}

std::shared_ptr<HouseTransferItem> HouseTransferItem::createHouseTransferItem(const std::shared_ptr<House> &house) {
	auto transferItem = std::make_shared<HouseTransferItem>(house);
	transferItem->setID(ITEM_DOCUMENT_RO);
	transferItem->setSubType(1);
	std::ostringstream ss;
	ss << "It is a house transfer document for '" << house->getName() << "'.";
	transferItem->setAttribute(ItemAttribute_t::DESCRIPTION, ss.str());
	return transferItem;
}

void HouseTransferItem::onTradeEvent(TradeEvents_t event, const std::shared_ptr<Player> &owner) {
	if (event == ON_TRADE_TRANSFER) {
		if (house) {
			auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
			auto ownershipTransferMessage = " The ownership will be transferred upon server restart.";
			const auto boughtMessage = fmt::format("You have successfully bought the house.{}", isTransferOnRestart ? ownershipTransferMessage : "");
			const auto soldMessage = fmt::format("You have successfully sold your house.{}", isTransferOnRestart ? ownershipTransferMessage : "");

			owner->sendTextMessage(MESSAGE_EVENT_ADVANCE, boughtMessage);

			const auto oldOwner = g_game().getPlayerByGUID(house->getOwner());
			if (oldOwner) {
				oldOwner->sendTextMessage(MESSAGE_EVENT_ADVANCE, soldMessage);
			}
			house->executeTransfer(static_self_cast<HouseTransferItem>(), owner);
		}

		g_game().internalRemoveItem(static_self_cast<HouseTransferItem>(), 1);
	} else if (event == ON_TRADE_CANCEL) {
		if (house) {
			house->resetTransferItem();
		}
	}
}

bool House::executeTransfer(const std::shared_ptr<HouseTransferItem> &item, const std::shared_ptr<Player> &newOwner) {
	if (transferItem != item) {
		return false;
	}

	auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
	if (isTransferOnRestart) {
		if (hasNewOwnerOnStartup) {
			return false;
		}

		setNewOwnerGuid(newOwner->getGUID(), false);
	} else {
		setOwner(newOwner->getGUID());
	}
	transferItem = nullptr;
	return true;
}

void AccessList::parseList(const std::string &list) {
	const std::regex regexValidChars("[^a-zA-Z' \n*!@#]+");
	std::string validList = std::regex_replace(list, regexValidChars, "");

	// Remove empty lines
	std::istringstream iss(validList);
	std::ostringstream oss;
	std::string line;
	while (std::getline(iss, line)) {
		if (!line.empty()) {
			oss << line << '\n';
		}
	}
	validList = oss.str();

	playerList.clear();
	guildRankList.clear();
	allowEveryone = false;
	this->list = validList;
	if (list.empty()) {
		return;
	}

	auto lines = explodeString(validList, "\n", 100);
	for (auto &m_line : lines) {
		trimString(m_line);
		trim_left(m_line, '\t');
		trim_right(m_line, '\t');
		trimString(m_line);

		if (m_line.empty() || m_line.front() == '#' || m_line.length() > 100) {
			continue;
		}

		toLowerCaseString(m_line);

		const std::string::size_type at_pos = m_line.find('@');
		if (at_pos != std::string::npos) {
			if (at_pos == 0) {
				addGuild(m_line.substr(1));
			} else {
				addGuildRank(m_line.substr(0, at_pos - 1), m_line.substr(at_pos + 1));
			}
		} else if (m_line == "*") {
			allowEveryone = true;
		} else if (m_line.find_first_of("!*?") != std::string::npos) {
			// Remove regular expressions since they don't make much sense in houses
			continue;
		} else if (m_line.length() <= NETWORKMESSAGE_PLAYERNAME_MAXLENGTH) {
			addPlayer(m_line);
		}
	}
}

void AccessList::addPlayer(const std::string &name) {
	const auto &player = g_game().getPlayerByName(name);
	if (player) {
		playerList.insert(player->getGUID());
	} else {
		const uint32_t guid = IOLoginData::getGuidByName(name);
		if (guid != 0) {
			playerList.insert(guid);
		}
	}
}

namespace {
	std::shared_ptr<Guild> getGuildByName(const std::string &name) {
		const uint32_t guildId = IOGuild::getGuildIdByName(name);
		if (guildId == 0) {
			return nullptr;
		}

		const auto &guild = g_game().getGuild(guildId);
		if (guild) {
			return guild;
		}

		return IOGuild::loadGuild(guildId);
	}
}

void AccessList::addGuild(const std::string &name) {
	const auto &guild = getGuildByName(name);
	if (guild) {
		for (const auto &rank : guild->getRanks()) {
			guildRankList.insert(rank->id);
		}
	}
}

void AccessList::addGuildRank(const std::string &name, const std::string &guildName) {
	const auto &guild = getGuildByName(guildName);
	if (guild) {
		const GuildRank_ptr &rank = guild->getRankByName(name);
		if (rank) {
			guildRankList.insert(rank->id);
		}
	}
}

bool AccessList::isInList(const std::shared_ptr<Player> &player) const {
	if (allowEveryone) {
		return true;
	}

	if (playerList.contains(player->getGUID())) {
		return true;
	}

	const auto &rank = player->getGuildRank();
	return rank && guildRankList.contains(rank->id);
}

void AccessList::getList(std::string &retList) const {
	retList = this->list;
}

Door::Door(uint16_t type) :
	Item(type) { }

Attr_ReadValue Door::readAttr(AttrTypes_t attr, PropStream &propStream) {
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

void Door::setHouse(std::shared_ptr<House> newHouse) {
	if (this->house != nullptr) {
		return;
	}

	this->house = std::move(newHouse);

	if (!accessList) {
		accessList = std::make_unique<AccessList>();
	}
}

bool Door::canUse(const std::shared_ptr<Player> &player) const {
	if (!house) {
		return true;
	}

	if (house->getHouseAccessLevel(player) >= HOUSE_SUBOWNER) {
		return true;
	}

	return accessList->isInList(player);
}

void Door::setAccessList(const std::string &textlist) {
	if (!accessList) {
		accessList = std::make_unique<AccessList>();
	}

	accessList->parseList(textlist);
}

bool Door::getAccessList(std::string &list) const {
	if (!house) {
		return false;
	}

	accessList->getList(list);
	return true;
}

void Door::onRemoved() {
	Item::onRemoved();

	if (house) {
		house->removeDoor(static_self_cast<Door>());
	}
}

std::shared_ptr<House> Houses::getHouseByPlayerId(uint32_t playerId) const {
	for (const auto &it : houseMap) {
		if (it.second->getOwner() == playerId) {
			return it.second;
		}
	}
	return nullptr;
}

bool Houses::loadHousesXML(const std::string &filename) {
	pugi::xml_document doc;
	const pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError(__FUNCTION__, filename, result);
		return false;
	}

	for (const auto &houseNode : doc.child("houses").children()) {
		pugi::xml_attribute houseIdAttribute = houseNode.attribute("houseid");
		if (!houseIdAttribute) {
			return false;
		}

		auto houseId = pugi::cast<int32_t>(houseIdAttribute.value());

		const auto &house = getHouse(houseId);
		if (!house) {
			g_logger().error("[Houses::loadHousesXML] - Unknown house, id: {}", houseId);
			return false;
		}

		house->setName(houseNode.attribute("name").as_string());

		const Position entryPos(
			pugi::cast<uint16_t>(houseNode.attribute("entryx").value()),
			pugi::cast<uint16_t>(houseNode.attribute("entryy").value()),
			pugi::cast<uint16_t>(houseNode.attribute("entryz").value())
		);
		if (entryPos.x == 0 && entryPos.y == 0 && entryPos.z == 0) {
			g_logger().warn("[Houses::loadHousesXML] - Entry not set for house "
			                "name: {} with id: {}",
			                house->getName(), houseId);
		}
		house->setEntryPos(entryPos);

		house->setRent(pugi::cast<uint32_t>(houseNode.attribute("rent").value()));
		house->setSize(pugi::cast<uint32_t>(houseNode.attribute("size").value()));
		house->setTownId(pugi::cast<uint32_t>(houseNode.attribute("townid").value()));
		auto maxBedsAttr = houseNode.attribute("beds");
		int32_t maxBeds = -1;
		if (!maxBedsAttr.empty()) {
			maxBeds = pugi::cast<int32_t>(maxBedsAttr.value());
		}
		house->setMaxBeds(maxBeds);

		house->setOwner(0, false);
	}
	return true;
}

void Houses::payHouses(RentPeriod_t rentPeriod) const {
	if (rentPeriod == RENTPERIOD_NEVER) {
		return;
	}

	const time_t currentTime = time(nullptr);
	for (const auto &it : houseMap) {
		const auto &house = it.second;
		if (house->getOwner() == 0) {
			continue;
		}

		const uint32_t ownerId = house->getOwner();
		const auto &town = g_game().map.towns.getTown(house->getTownId());
		if (!town) {
			continue;
		}

		const auto &player = g_game().getPlayerByGUID(ownerId, true);
		if (!player) {
			// Player doesn't exist, reset house owner
			house->tryTransferOwnership(nullptr, true);
			continue;
		}

		// Player hasn't logged in for a while, reset house owner
		auto daysToReset = g_configManager().getNumber(HOUSE_LOSE_AFTER_INACTIVITY);
		if (daysToReset > 0) {
			auto daysSinceLastLogin = (currentTime - player->getLastLoginSaved()) / (60 * 60 * 24);
			bool vipKeep = g_configManager().getBoolean(VIP_KEEP_HOUSE) && player->isVip();
			bool activityKeep = daysSinceLastLogin < daysToReset;
			if (vipKeep && !activityKeep) {
				g_logger().info("Player {} has not logged in for {} days, but is a VIP, so the house will not be reset.", player->getName(), daysToReset);
			} else if (!vipKeep && !activityKeep) {
				g_logger().info("Player {} has not logged in for {} days, so the house will be reset.", player->getName(), daysToReset);
				house->setOwner(0, true, player);
				g_saveManager().savePlayer(player);
				continue;
			}
		}

		const uint32_t rent = house->getRent();
		if (rent == 0 || house->getPaidUntil() > currentTime) {
			continue;
		}

		if (player->getBankBalance() >= rent) {
			g_game().removeMoney(player, rent, 0, true);
			g_metrics().addCounter("balance_decrease", rent, { { "player", player->getName() }, { "context", "house_rent" } });

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
				const int32_t daysLeft = 7 - house->getPayRentWarnings();

				const std::shared_ptr<Item> &letter = Item::CreateItem(ITEM_LETTER_STAMPED);
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
				letter->setAttribute(ItemAttribute_t::TEXT, ss.str());
				const auto &playerInbox = player->getInbox();
				g_game().internalAddItem(playerInbox, letter, INDEX_WHEREEVER, FLAG_NOLIMIT);
				house->setPayRentWarnings(house->getPayRentWarnings() + 1);
			} else {
				house->setOwner(0, true, player);
			}
		}

		g_saveManager().savePlayer(player);
	}
}

uint32_t House::getRent() const {
	return static_cast<uint32_t>(g_configManager().getFloat(HOUSE_RENT_RATE) * static_cast<float>(rent));
}

uint32_t House::getPrice() const {
	auto sqmPrice = static_cast<uint32_t>(g_configManager().getNumber(HOUSE_PRICE_PER_SQM)) * getSize();
	auto rentPrice = static_cast<uint32_t>(static_cast<float>(getRent()) * g_configManager().getFloat(HOUSE_PRICE_RENT_MULTIPLIER));
	return sqmPrice + rentPrice;
}
