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

class House;
class BedItem;
class Player;

class AccessList {
public:
	void parseList(const std::string &list);
	void addPlayer(const std::string &name);
	void addGuild(const std::string &name);
	void addGuildRank(const std::string &name, const std::string &rankName);

	bool isInList(std::shared_ptr<Player> player) const;

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

	bool canUse(std::shared_ptr<Player> player) const;

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
	static std::shared_ptr<HouseTransferItem> createHouseTransferItem(std::shared_ptr<House> house);

	explicit HouseTransferItem(std::shared_ptr<House> newHouse) :
		Item(0), house(newHouse) { }

	void onTradeEvent(TradeEvents_t event, std::shared_ptr<Player> owner) override;
	bool canTransform() const override {
		return false;
	}

private:
	std::shared_ptr<House> house;
};

class House : public SharedObject {
public:
	explicit House(uint32_t houseId);

	void addTile(std::shared_ptr<HouseTile> tile);
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

	AccessHouseLevel_t getHouseAccessLevel(std::shared_ptr<Player> player) const;
	bool kickPlayer(std::shared_ptr<Player> player, std::shared_ptr<Player> target);

	void setEntryPos(Position pos) {
		posEntry = pos;
	}
	const Position &getEntryPosition() const {
		return posEntry;
	}

	void setName(std::string newHouseName) {
		this->houseName = newHouseName;
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
	bool tryTransferOwnership(std::shared_ptr<Player> player, bool serverStartup);
	void setOwner(uint32_t guid, bool updateDatabase = true, std::shared_ptr<Player> player = nullptr);
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

	void addDoor(std::shared_ptr<Door> door);
	void removeDoor(std::shared_ptr<Door> door);
	std::shared_ptr<Door> getDoorByNumber(uint32_t doorId) const;
	std::shared_ptr<Door> getDoorByPosition(const Position &pos);

	std::shared_ptr<HouseTransferItem> getTransferItem();
	void resetTransferItem();
	bool executeTransfer(std::shared_ptr<HouseTransferItem> item, std::shared_ptr<Player> player);

	const HouseTileList &getTiles() const {
		return houseTiles;
	}

	const std::list<std::shared_ptr<Door>> &getDoors() const {
		return doorList;
	}

	void addBed(std::shared_ptr<BedItem> bed);
	void removeBed(std::shared_ptr<BedItem> bed);
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

	bool transferToDepot(std::shared_ptr<Player> player) const;
	bool transferToDepot(std::shared_ptr<Player> player, std::shared_ptr<HouseTile> tile) const;

	bool hasItemOnTile() const;
	bool hasNewOwnership() const;
	void setNewOwnership();

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

	Position posEntry = {};

	bool isLoaded = false;

	void handleContainer(ItemList &moveItemList, std::shared_ptr<Item> item) const;
	void handleWrapableItem(ItemList &moveItemList, std::shared_ptr<Item> item, std::shared_ptr<Player> player, std::shared_ptr<HouseTile> houseTile) const;
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
		if (auto it = houseMap.find(id); it != houseMap.end()) {
			return it->second;
		}

		return houseMap[id] = std::make_shared<House>(id);
	}

	std::shared_ptr<House> getHouse(uint32_t houseId) {
		auto it = houseMap.find(houseId);
		if (it == houseMap.end()) {
			return nullptr;
		}
		return it->second;
	}

	std::shared_ptr<House> getHouseByPlayerId(uint32_t playerId);

	bool loadHousesXML(const std::string &filename);

	void payHouses(RentPeriod_t rentPeriod) const;

	const HouseMap &getHouses() const {
		return houseMap;
	}

private:
	HouseMap houseMap;
};
