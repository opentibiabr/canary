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

#ifndef SRC_MAP_HOUSE_HOUSE_H_
#define SRC_MAP_HOUSE_HOUSE_H_

#include "items/containers/container.h"
#include "declarations.hpp"
#include "map/house/housetile.h"
#include "game/movement/position.h"

class House;
class BedItem;
class Player;

class AccessList
{
	public:
		void parseList(const std::string& list);
		void addPlayer(const std::string& name);
		void addGuild(const std::string& name);
		void addGuildRank(const std::string& name, const std::string& rankName);

		bool isInList(const Player* player);

		void getList(std::string& list) const;

	private:
		std::string list;
		phmap::flat_hash_set<uint32_t> playerList;
		phmap::flat_hash_set<uint32_t> guildRankList;
		bool allowEveryone = false;
};

class Door final : public Item
{
	public:
		explicit Door(uint16_t type);

		// non-copyable
		Door(const Door&) = delete;
		Door& operator=(const Door&) = delete;

		Door* getDoor() override {
			return this;
		}
		const Door* getDoor() const override {
			return this;
		}

		House* getHouse() {
			return house;
		}

		//serialization
		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream& propStream) override;
		void serializeAttr(PropWriteStream&) const override {}

		void setDoorId(uint32_t doorId) {
			setIntAttr(ITEM_ATTRIBUTE_DOORID, doorId);
		}
		uint32_t getDoorId() const {
			return getIntAttr(ITEM_ATTRIBUTE_DOORID);
		}

		bool canUse(const Player* player);

		void setAccessList(const std::string& textlist);
		bool getAccessList(std::string& list) const;

		void onRemoved() override;

	private:
		void setHouse(House* house);

		House* house = nullptr;
		std::unique_ptr<AccessList> accessList;
		friend class House;
};

using HouseTileList = std::list<HouseTile*>;
using HouseBedItemList = std::list<BedItem*>;

class HouseTransferItem final : public Item
{
	public:
		static HouseTransferItem* createHouseTransferItem(House* house);

		explicit HouseTransferItem(House* newHouse) : Item(0), house(newHouse) {}

		void onTradeEvent(TradeEvents_t event, Player* owner) override;
		bool canTransform() const override {
			return false;
		}

	private:
		House* house;
};

class House
{
	public:
		explicit House(uint32_t houseId);

		void addTile(HouseTile* tile);
		void updateDoorDescription() const;

		bool canEditAccessList(uint32_t listId, const Player* player);
		// listId special = values:
		// GUEST_LIST = guest list
		// SUBOWNER_LIST = subowner list
		void setAccessList(uint32_t listId, const std::string& textlist);
		bool getAccessList(uint32_t listId, std::string& list) const;

		bool isInvited(const Player* player);

		AccessHouseLevel_t getHouseAccessLevel(const Player* player);
		bool kickPlayer(Player* player, Player* target);

		void setEntryPos(Position pos) {
			posEntry = pos;
		}
		const Position& getEntryPosition() const {
			return posEntry;
		}

		void setName(std::string newHouseName) {
			this->houseName = newHouseName;
		}
		const std::string& getName() const {
			return houseName;
		}

		void setOwner(uint32_t guid, bool updateDatabase = true, Player* player = nullptr);
		uint32_t getOwner() const {
			return owner;
		}

		void setPaidUntil(time_t paid) {
			paidUntil = paid;
		}
		time_t getPaidUntil() const {
			return paidUntil;
		}

		void setRent(uint32_t newRent) {
			this->rent = newRent;
		}
		uint32_t getRent() const {
			return rent;
		}

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

		void addDoor(Door* door);
		void removeDoor(Door* door);
		Door* getDoorByNumber(uint32_t doorId) const;
		Door* getDoorByPosition(const Position& pos);

		HouseTransferItem* getTransferItem();
		void resetTransferItem();
		bool executeTransfer(HouseTransferItem* item, Player* player);

		const HouseTileList& getTiles() const {
			return houseTiles;
		}

		const std::list<Door*>& getDoors() const {
			return doorList;
		}

		void addBed(BedItem* bed);
		const HouseBedItemList& getBeds() const {
			return bedsList;
		}
		uint32_t getBedCount() {
			return static_cast<uint32_t>(std::ceil(bedsList.size() / 2.)); //each bed takes 2 sqms of space, ceil is just for bad maps
		}

	private:
		bool transferToDepot() const;
		bool transferToDepot(Player* player) const;

		AccessList guestList;
		AccessList subOwnerList;

		Container transfer_container{ITEM_LOCKER};

		HouseTileList houseTiles;
		std::list<Door*> doorList;
		HouseBedItemList bedsList;

		std::string houseName;
		std::string ownerName;

		HouseTransferItem* transferItem = nullptr;

		time_t paidUntil = 0;

		uint32_t id;
		uint32_t owner = 0;
		uint32_t ownerAccountId = 0;
		uint32_t rentWarnings = 0;
		uint32_t rent = 0;
		uint32_t townId = 0;

		Position posEntry = {};

		bool isLoaded = false;
};

using HouseMap = std::map<uint32_t, House*>;

class Houses
{
	public:
		Houses() = default;
		~Houses() {
			for (const auto& it : houseMap) {
				delete it.second;
			}
		}

		// non-copyable
		Houses(const Houses&) = delete;
		Houses& operator=(const Houses&) = delete;

		House* addHouse(uint32_t id) {
			auto it = houseMap.find(id);
			if (it != houseMap.end()) {
				return it->second;
			}

			House* house = new House(id);
			houseMap[id] = house;
			return house;
		}

		House* getHouse(uint32_t houseId) {
			auto it = houseMap.find(houseId);
			if (it == houseMap.end()) {
				return nullptr;
			}
			return it->second;
		}

		House* getHouseByPlayerId(uint32_t playerId);

		bool loadHousesXML(const std::string& filename);

		void payHouses(RentPeriod_t rentPeriod) const;

		const HouseMap& getHouses() const {
			return houseMap;
		}

	private:
		HouseMap houseMap;
};

#endif  // SRC_MAP_HOUSE_HOUSE_H_
