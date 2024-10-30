/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/containers/container.hpp"
#include "declarations.hpp"
#include "map/house/housetile.hpp"
#include "game/movement/position.hpp"
#include "enums/player_cyclopedia.hpp"

class House;
class BedItem;
class Player;

using days = std::chrono::duration<int64_t, std::ratio<86400>>;

class AccessList {
public:
	void parseList(const std::string &list);
	void addPlayer(const std::string &name);
	void addGuild(const std::string &name);
	void addGuildRank(const std::string &name, const std::string &rankName);

	bool isInList(const std::shared_ptr<Player> &player) const;

	void getList(std::string &list) const;

private:
	std::string list;
	phmap::flat_hash_set<uint32_t> playerList;
	phmap::flat_hash_set<uint32_t> guildRankList;
	bool allowEveryone = false;
};

class Door final : public Item {
public:
	explicit Door(uint16_t type);

	// non-copyable
	Door(const Door &) = delete;
	Door &operator=(const Door &) = delete;

	std::shared_ptr<Door> getDoor() override {
		return static_self_cast<Door>();
	}

	std::shared_ptr<House> getHouse() {
		return house;
	}

	// serialization
	Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream) override;
	void serializeAttr(PropWriteStream &) const override { }

	void setDoorId(uint32_t doorId) {
		setAttribute(ItemAttribute_t::DOORID, doorId);
	}
	uint32_t getDoorId() const {
		return getAttribute<uint32_t>(ItemAttribute_t::DOORID);
	}

	bool canUse(const std::shared_ptr<Player> &player) const;

	void setAccessList(const std::string &textlist);
	bool getAccessList(std::string &list) const;

	void onRemoved() override;

private:
	void setHouse(std::shared_ptr<House> house);

	std::shared_ptr<House> house = nullptr;
	std::unique_ptr<AccessList> accessList;
	friend class House;
};

using HouseTileList = std::list<std::shared_ptr<HouseTile>>;
using HouseBedItemList = std::list<std::shared_ptr<BedItem>>;

class HouseTransferItem final : public Item {
public:
	static std::shared_ptr<HouseTransferItem> createHouseTransferItem(const std::shared_ptr<House> &house);

	explicit HouseTransferItem(std::shared_ptr<House> newHouse) :
		Item(0), house(std::move(newHouse)) { }

	void onTradeEvent(TradeEvents_t event, const std::shared_ptr<Player> &owner) override;
	bool canTransform() const override {
		return false;
	}

private:
	std::shared_ptr<House> house;
};

class House final : public SharedObject {
public:
	explicit House(uint32_t houseId);

	void addTile(const std::shared_ptr<HouseTile> &tile);
	void updateDoorDescription() const;

	bool canEditAccessList(uint32_t listId, const std::shared_ptr<Player> &player) const;
	// listId special = values:
	// GUEST_LIST = guest list
	// SUBOWNER_LIST = subowner list
	void setAccessList(uint32_t listId, const std::string &textlist);
	bool getAccessList(uint32_t listId, std::string &list) const;

	bool isInvited(const std::shared_ptr<Player> &player) const {
		return getHouseAccessLevel(player) != HOUSE_NOT_INVITED;
	}

	AccessHouseLevel_t getHouseAccessLevel(const std::shared_ptr<Player> &player) const;
	bool kickPlayer(const std::shared_ptr<Player> &player, const std::shared_ptr<Player> &target);

	void setEntryPos(Position pos) {
		posEntry = pos;
	}
	const Position &getEntryPosition() const {
		return posEntry;
	}

	void setName(std::string newHouseName) {
		this->houseName = std::move(newHouseName);
	}
	const std::string &getName() const {
		return houseName;
	}

	/**
	 * @brief Set the new owner's GUID for the house.
	 *
	 * This function updates the new owner's GUID in the database.
	 * It also sets the `hasNewOwnerOnStartup` flag if the given guid is positive.
	 *
	 * @param guid The new owner's GUID. Default value is 0.
	 * @param serverStartup If set to false, further changes to ownership will be blocked.
	 *
	 * @note The guid "0" is used when the player uses the "leavehouse" command,
	 * indicating that the house is not being transferred to anyone.
	 * @note The guid "-1" represents the default value and will not execute any actions.
	 * @note The actual transfer of ownership will occur upon server restart if `serverStartup` is set to false.
	 */
	void setNewOwnerGuid(int32_t newOwnerGuid, bool serverStartup);
	void clearHouseInfo(bool preventOwnerDeletion);
	bool tryTransferOwnership(const std::shared_ptr<Player> &player, bool serverStartup);
	void setOwner(uint32_t guid, bool updateDatabase = true, const std::shared_ptr<Player> &player = nullptr);
	uint32_t getOwner() const {
		return owner;
	}

	void setPaidUntil(time_t paid) {
		paidUntil = paid;
	}
	time_t getPaidUntil() const {
		return paidUntil;
	}

	void setSize(uint32_t newSize) {
		this->size = newSize;
	}
	uint32_t getSize() const {
		return size;
	}
	uint32_t getPrice() const;

	void setRent(uint32_t newRent) {
		this->rent = newRent;
	}
	uint32_t getRent() const;

	void setPayRentWarnings(uint32_t warnings) {
		rentWarnings = warnings;
	}
	uint32_t getPayRentWarnings() const {
		return rentWarnings;
	}

	void setTownId(uint32_t newTownId) {
		this->townId = newTownId;
	}
	uint32_t getTownId() const {
		return townId;
	}

	uint32_t getId() const {
		return id;
	}

	void addDoor(const std::shared_ptr<Door> &door);
	void removeDoor(const std::shared_ptr<Door> &door);
	std::shared_ptr<Door> getDoorByNumber(uint32_t doorId) const;
	std::shared_ptr<Door> getDoorByPosition(const Position &pos) const;

	std::shared_ptr<HouseTransferItem> getTransferItem();
	void resetTransferItem();
	bool executeTransfer(const std::shared_ptr<HouseTransferItem> &item, const std::shared_ptr<Player> &player);

	const HouseTileList &getTiles() const {
		return houseTiles;
	}

	const std::list<std::shared_ptr<Door>> &getDoors() const {
		return doorList;
	}

	void addBed(const std::shared_ptr<BedItem> &bed);
	void removeBed(const std::shared_ptr<BedItem> &bed);
	const HouseBedItemList &getBeds() const {
		return bedsList;
	}
	uint32_t getBedCount() const {
		return static_cast<uint32_t>(std::floor(static_cast<double>(bedsList.size()) / 2.));
	}

	void setMaxBeds(int32_t count) {
		maxBeds = count;
	}

	int32_t getMaxBeds() const {
		return maxBeds;
	}

	bool transferToDepot(const std::shared_ptr<Player> &player) const;
	bool transferToDepot(const std::shared_ptr<Player> &player, const std::shared_ptr<HouseTile> &tile) const;

	bool hasItemOnTile() const;
	bool hasNewOwnership() const;
	void setNewOwnership();

	void setClientId(uint32_t newClientId) {
		this->m_clientId = newClientId;
	}
	uint32_t getClientId() const {
		return m_clientId;
	}

	void setBidder(int32_t bidder) {
		this->m_bidder = bidder;
	}
	int32_t getBidder() const {
		return m_bidder;
	}

	void setBidderName(const std::string &bidderName) {
		this->m_bidderName = bidderName;
	}
	std::string getBidderName() const {
		return m_bidderName;
	}

	void setHighestBid(uint64_t bidValue) {
		this->m_highestBid = bidValue;
	}
	uint64_t getHighestBid() const {
		return m_highestBid;
	}

	void setInternalBid(uint64_t bidValue) {
		this->m_internalBid = bidValue;
	}
	uint64_t getInternalBid() const {
		return m_internalBid;
	}

	void setBidHolderLimit(uint64_t bidValue) {
		this->m_bidHolderLimit = bidValue;
	}
	uint64_t getBidHolderLimit() const {
		return m_bidHolderLimit;
	}

	void calculateBidEndDate(uint8_t daysToEnd);
	void setBidEndDate(uint32_t bidEndDate) {
		this->m_bidEndDate = bidEndDate;
	};
	uint32_t getBidEndDate() const {
		return m_bidEndDate;
	}

	void setState(CyclopediaHouseState state) {
		this->m_state = state;
	}
	CyclopediaHouseState getState() const {
		return m_state;
	}

	void setTransferStatus(bool transferStatus) {
		this->m_transferStatus = transferStatus;
	}
	bool getTransferStatus() const {
		return m_transferStatus;
	}

	void setOwnerAccountId(uint32_t accountId) {
		this->ownerAccountId = accountId;
	}
	uint32_t getOwnerAccountId() const {
		return ownerAccountId;
	}

	void setGuildhall(bool isGuildHall) {
		this->guildHall = isGuildHall;
	}
	bool isGuildhall() const {
		return guildHall;
	}

private:
	bool transferToDepot() const;

	AccessList guestList;
	AccessList subOwnerList;

	std::shared_ptr<Container> transfer_container = std::make_shared<Container>(ITEM_LOCKER);

	HouseTileList houseTiles;
	std::list<std::shared_ptr<Door>> doorList;
	HouseBedItemList bedsList;

	std::string houseName;
	std::string ownerName;

	bool hasNewOwnerOnStartup = false;

	std::shared_ptr<HouseTransferItem> transferItem = nullptr;

	time_t paidUntil = 0;

	uint32_t id;
	uint32_t owner = 0;
	uint32_t ownerAccountId = 0;
	uint32_t rentWarnings = 0;
	uint32_t rent = 0;
	uint32_t size = 0;
	uint32_t townId = 0;
	uint32_t maxBeds = 4;
	int32_t bedsCount = -1;
	bool guildHall = false;

	Position posEntry = {};

	// House Auction
	uint32_t m_clientId;
	int32_t m_bidder = 0;
	std::string m_bidderName = "";
	uint64_t m_highestBid = 0;
	uint64_t m_internalBid = 0;
	uint64_t m_bidHolderLimit = 0;
	uint32_t m_bidEndDate = 0;
	CyclopediaHouseState m_state = CyclopediaHouseState::Available;
	bool m_transferStatus = false;

	bool isLoaded = false;

	void handleContainer(ItemList &moveItemList, const std::shared_ptr<Item> &item) const;
	void handleWrapableItem(ItemList &moveItemList, const std::shared_ptr<Item> &item, const std::shared_ptr<Player> &player, const std::shared_ptr<HouseTile> &houseTile) const;
};

using HouseMap = std::map<uint32_t, std::shared_ptr<House>>;

class Houses {
public:
	Houses() = default;
	~Houses() = default;

	// non-copyable
	Houses(const Houses &) = delete;
	Houses &operator=(const Houses &) = delete;

	std::shared_ptr<House> addHouse(uint32_t id) {
		if (const auto it = houseMap.find(id); it != houseMap.end()) {
			return it->second;
		}

		return houseMap[id] = std::make_shared<House>(id);
	}

	std::shared_ptr<House> getHouse(uint32_t houseId) {
		const auto it = houseMap.find(houseId);
		if (it == houseMap.end()) {
			return nullptr;
		}
		return it->second;
	}

	void addHouseClientId(uint32_t clientId, std::shared_ptr<House> house) {
		if (auto it = houseMapClientId.find(clientId); it != houseMapClientId.end()) {
			return;
		}

		houseMapClientId.emplace(clientId, house);
	}

	std::shared_ptr<House> getHouseByClientId(uint32_t clientId) {
		auto it = houseMapClientId.find(clientId);
		if (it == houseMapClientId.end()) {
			return nullptr;
		}
		return it->second;
	}

	std::shared_ptr<House> getHouseByPlayerId(uint32_t playerId) const;
	std::vector<std::shared_ptr<House>> getAllHousesByPlayerId(uint32_t playerId);
	std::shared_ptr<House> getHouseByBidderName(const std::string &bidderName);
	uint16_t getHouseCountByAccount(uint32_t accountId);

	bool loadHousesXML(const std::string &filename);

	void payHouses(RentPeriod_t rentPeriod) const;

	const HouseMap &getHouses() const {
		return houseMap;
	}

private:
	HouseMap houseMap;
	HouseMap houseMapClientId;
};
