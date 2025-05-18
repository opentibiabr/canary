/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iomapserialize.hpp"

#include "config/configmanager.hpp"
#include "io/iologindata.hpp"
#include "game/game.hpp"
#include "items/bed.hpp"

void IOMapSerialize::loadHouseItems(Map* map) {
	Benchmark bm_context;

	DBResult_ptr result = Database::getInstance().storeQuery("SELECT `data` FROM `tile_store`");
	if (!result) {
		return;
	}

	do {
		unsigned long attrSize;
		const char* attr = result->getStream("data", attrSize);

		PropStream propStream;
		propStream.init(attr, attrSize);

		uint16_t x, y;
		uint8_t z;
		if (!propStream.read<uint16_t>(x) || !propStream.read<uint16_t>(y) || !propStream.read<uint8_t>(z)) {
			continue;
		}

		std::shared_ptr<Tile> tile = map->getTile(x, y, z);
		if (!tile) {
			continue;
		}

		uint32_t item_count;
		if (!propStream.read<uint32_t>(item_count)) {
			continue;
		}

		while (item_count--) {
			if (auto houseTile = std::dynamic_pointer_cast<HouseTile>(tile)) {
				const auto &house = houseTile->getHouse();
				auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
				if (!isTransferOnRestart && house->getOwner() == 0) {
					g_logger().trace("Skipping load item from house id: {}, position: {}, house does not have owner", house->getId(), house->getEntryPosition().toString());
					house->clearHouseInfo(false);
					continue;
				}
			}

			loadItem(propStream, tile, true);
		}
	} while (result->next());
	g_logger().info("Loaded house items in {} milliseconds", bm_context.duration());
}

bool IOMapSerialize::saveHouseItems() {
	bool success = DBTransaction::executeWithinTransaction([]() {
		return SaveHouseItemsGuard();
	});

	if (!success) {
		g_logger().error("[{}] Error occurred saving houses", __FUNCTION__);
	}

	return success;
}

bool IOMapSerialize::SaveHouseItemsGuard() {
	Database &db = Database::getInstance();
	std::ostringstream query;

	// clear old tile data
	if (!db.executeQuery("DELETE FROM `tile_store`")) {
		return false;
	}

	DBInsert stmt("INSERT INTO `tile_store` (`house_id`, `data`) VALUES ");

	PropWriteStream stream;
	for (const auto &[key, house] : g_game().map.houses.getHouses()) {
		// save house items
		for (const auto &tile : house->getTiles()) {
			saveTile(stream, tile);

			size_t attributesSize;
			const char* attributes = stream.getStream(attributesSize);
			if (attributesSize > 0) {
				query << house->getId() << ',' << db.escapeBlob(attributes, attributesSize);
				if (!stmt.addRow(query)) {
					return false;
				}
				stream.clear();
			}
		}
	}

	if (!stmt.execute()) {
		return false;
	}

	return true;
}

bool IOMapSerialize::loadContainer(PropStream &propStream, const std::shared_ptr<Container> &container) {
	while (container->serializationCount > 0) {
		if (!loadItem(propStream, container)) {
			g_logger().warn("Deserialization error for container item: {}", container->getID());
			return false;
		}
		container->serializationCount--;
	}

	uint8_t endAttr;
	if (!propStream.read<uint8_t>(endAttr) || endAttr != 0) {
		g_logger().warn("Deserialization error for container item: {}", container->getID());
		return false;
	}
	return true;
}

bool IOMapSerialize::loadItem(PropStream &propStream, const std::shared_ptr<Cylinder> &parent, bool isHouseItem /*= false*/) {
	uint16_t id;
	if (!propStream.read<uint16_t>(id)) {
		return false;
	}

	std::shared_ptr<Tile> tile = nullptr;
	if (parent->getParent() == nullptr) {
		tile = parent->getTile();
	}

	const ItemType &iType = Item::items[id];
	if (iType.isBed() || iType.movable || !tile || iType.isCarpet() || iType.isTrashHolder()) {
		// create a new item
		auto item = Item::CreateItem(id);
		if (item) {
			if (item->unserializeAttr(propStream)) {
				// Remove only not movable and not sleeper bed
				auto bed = item->getBed();
				if (isHouseItem && iType.isBed() && bed && bed->getSleeper() == 0 && !iType.movable) {
					return false;
				}
				std::shared_ptr<Container> container = item->getContainer();
				if (container && !loadContainer(propStream, container)) {
					return false;
				}

				parent->internalAddThing(item);
				item->startDecaying();
			} else {
				g_logger().warn("Deserialization error in {}", id);

				return false;
			}
		}
	} else {
		// Stationary items like doors/beds/blackboards/bookcases
		std::shared_ptr<Item> item = nullptr;
		if (const TileItemVector* items = tile->getItemList()) {
			for (auto &findItem : *items) {
				if (findItem->getID() == id) {
					item = findItem;
					break;
				} else if (iType.m_transformOnUse && findItem->getID() == iType.m_transformOnUse) {
					item = findItem;
					break;
				} else if (iType.isDoor() && findItem->getDoor()) {
					item = findItem;
					break;
				} else if (iType.isBed() && findItem->getBed()) {
					item = findItem;
					break;
				}
			}
		}

		if (item) {
			if (item->unserializeAttr(propStream)) {
				std::shared_ptr<Container> container = item->getContainer();
				if (container && !loadContainer(propStream, container)) {
					return false;
				}

				g_game().transformItem(item, id);
			} else {
				g_logger().warn("Deserialization error in {}", id);
			}
		} else {
			// The map changed since the last save, just read the attributes
			auto dummy = Item::CreateItem(id);
			if (dummy) {
				dummy->unserializeAttr(propStream);
				std::shared_ptr<Container> container = dummy->getContainer();
				if (container) {
					if (!loadContainer(propStream, container)) {
						return false;
					}
				} else if (std::shared_ptr<BedItem> bedItem = std::dynamic_pointer_cast<BedItem>(dummy)) {
					uint32_t sleeperGUID = bedItem->getSleeper();
					if (sleeperGUID != 0) {
						g_game().removeBedSleeper(sleeperGUID);
					}
				}
			}
		}
	}
	return true;
}

void IOMapSerialize::saveItem(PropWriteStream &stream, const std::shared_ptr<Item> &item) {
	const auto &container = item->getContainer();

	// Write ID & props
	stream.write<uint16_t>(item->getID());
	item->serializeAttr(stream);

	if (container) {
		// Hack our way into the attributes
		stream.write<uint8_t>(ATTR_CONTAINER_ITEMS);
		stream.write<uint32_t>(container->size());
		for (auto it = container->getReversedItems(), end = container->getReversedEnd(); it != end; ++it) {
			saveItem(stream, *it);
		}
	}

	stream.write<uint8_t>(0x00); // attr end
}

void IOMapSerialize::saveTile(PropWriteStream &stream, const std::shared_ptr<Tile> &tile) {
	const TileItemVector* tileItems = tile->getItemList();
	if (!tileItems) {
		return;
	}

	std::list<std::shared_ptr<Item>> items;
	uint16_t count = 0;
	for (auto &item : *tileItems) {
		if (item->getID() == ITEM_BATHTUB_FILLED_NOTMOVABLE) {
			std::shared_ptr<Item> tub = Item::CreateItem(ITEM_BATHTUB_FILLED);
			items.push_front(tub);
			++count;
			continue;
		} else if (!item->isSavedToHouses()) {
			continue;
		}

		items.push_front(item);
		++count;
	}

	if (!items.empty()) {
		const Position &tilePosition = tile->getPosition();
		stream.write<uint16_t>(tilePosition.x);
		stream.write<uint16_t>(tilePosition.y);
		stream.write<uint8_t>(tilePosition.z);

		stream.write<uint32_t>(count);
		for (const std::shared_ptr<Item> &item : items) {
			saveItem(stream, item);
		}
	}
}

bool IOMapSerialize::loadHouseInfo() {
	Database &db = Database::getInstance();

	DBResult_ptr result = db.storeQuery("SELECT `id`, `owner`, `new_owner`, `bidder`, `bidder_name`, `highest_bid`, `internal_bid`, `bid_end_date`, `state`, `transfer_status` FROM `houses`");
	if (!result) {
		return false;
	}

	do {
		auto houseId = result->getNumber<uint32_t>("id");
		const auto house = g_game().map.houses.getHouse(houseId);
		if (!house) {
			continue;
		}

		auto owner = result->getNumber<uint32_t>("owner");
		auto newOwner = result->getNumber<int32_t>("new_owner");
		uint32_t bidder = result->getNumber<uint32_t>("bidder");
		std::string bidderName = result->getString("bidder_name");
		uint32_t highestBid = result->getNumber<uint32_t>("highest_bid");
		uint32_t internalBid = result->getNumber<uint32_t>("internal_bid");
		uint32_t bidEndDate = result->getNumber<uint32_t>("bid_end_date");
		auto state = static_cast<CyclopediaHouseState>(result->getNumber<uint16_t>("state"));
		auto transferStatus = result->getNumber<bool>("transfer_status");
		const auto timeNow = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();

		// Transfer house owner
		auto isTransferOnRestart = g_configManager().getBoolean(TOGGLE_HOUSE_TRANSFER_ON_SERVER_RESTART);
		if (isTransferOnRestart && newOwner >= 0) {
			g_game().setTransferPlayerHouseItems(houseId, owner);
			if (newOwner == 0) {
				g_logger().debug("Removing house id '{}' owner", houseId);
				house->setOwner(0);
			} else {
				g_logger().debug("Setting house id '{}' owner to player GUID '{}'", houseId, newOwner);
				house->setOwner(newOwner);
			}
		} else if (state == CyclopediaHouseState::Available && timeNow > bidEndDate && bidder > 0) {
			g_logger().debug("[BID] - Setting house id '{}' owner to player GUID '{}'", houseId, bidder);
			if (highestBid < internalBid) {
				uint32_t diff = internalBid - highestBid;
				IOLoginData::increaseBankBalance(bidder, diff);
			}
			house->setOwner(bidder);
			bidder = 0;
			bidderName = "";
			highestBid = 0;
			internalBid = 0;
			bidEndDate = 0;
		} else if (state == CyclopediaHouseState::Transfer && timeNow > bidEndDate && bidder > 0) {
			g_logger().debug("[TRANSFER] - Removing house id '{}' from owner GUID '{}' and transfering to new owner GUID '{}'", houseId, owner, bidder);
			if (transferStatus) {
				g_game().setTransferPlayerHouseItems(houseId, owner);
				house->setOwner(bidder);
				IOLoginData::increaseBankBalance(owner, internalBid);
			} else {
				house->setOwner(owner);
			}
			bidder = 0;
			bidderName = "";
			internalBid = 0;
			bidEndDate = 0;
			transferStatus = false;
		} else if (state == CyclopediaHouseState::MoveOut && timeNow > bidEndDate) {
			g_logger().debug("[MOVE OUT] - Removing house id '{}' owner", houseId);
			g_game().setTransferPlayerHouseItems(houseId, owner);
			house->setOwner(0);
			bidEndDate = 0;
		} else {
			house->setOwner(owner, false);
			house->setState(state);
		}
		house->setBidder(bidder);
		house->setBidderName(bidderName);
		house->setHighestBid(highestBid);
		house->setInternalBid(internalBid);
		house->setBidHolderLimit(internalBid);
		house->setBidEndDate(bidEndDate);
		house->setTransferStatus(transferStatus);
	} while (result->next());

	result = db.storeQuery("SELECT `house_id`, `listid`, `list` FROM `house_lists`");
	if (result) {
		do {
			const auto &house = g_game().map.houses.getHouse(result->getNumber<uint32_t>("house_id"));
			if (house) {
				auto listId = result->getNumber<uint32_t>("listid");
				auto list = result->getString("list");
				house->setAccessList(listId, list);
			}
		} while (result->next());
	}
	return true;
}

bool IOMapSerialize::saveHouseInfo() {
	bool success = DBTransaction::executeWithinTransaction([]() {
		return SaveHouseInfoGuard();
	});

	if (!success) {
		g_logger().error("[{}] Error occurred saving houses info", __FUNCTION__);
	}

	return success;
}

bool IOMapSerialize::SaveHouseInfoGuard() {
	Database &db = Database::getInstance();

	std::ostringstream query;
	DBInsert houseUpdate("INSERT INTO `houses` (`id`, `owner`, `paid`, `warnings`, `name`, `town_id`, `rent`, `size`, `beds`, `bidder`, `bidder_name`, `highest_bid`, `internal_bid`, `bid_end_date`, `state`, `transfer_status`) VALUES ");
	houseUpdate.upsert({ "owner", "paid", "warnings", "name", "town_id", "rent", "size", "beds", "bidder", "bidder_name", "highest_bid", "internal_bid", "bid_end_date", "state", "transfer_status" });

	for (const auto &[key, house] : g_game().map.houses.getHouses()) {
		auto stateValue = magic_enum::enum_integer(house->getState());
		std::string values = fmt::format("{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}", house->getId(), house->getOwner(), house->getPaidUntil(), house->getPayRentWarnings(), db.escapeString(house->getName()), house->getTownId(), house->getRent(), house->getSize(), house->getBedCount(), house->getBidder(), db.escapeString(house->getBidderName()), house->getHighestBid(), house->getInternalBid(), house->getBidEndDate(), std::to_string(stateValue), (house->getTransferStatus() ? 1 : 0));

		if (!houseUpdate.addRow(values)) {
			return false;
		}
	}

	if (!houseUpdate.execute()) {
		return false;
	}

	DBInsert listUpdate("INSERT INTO `house_lists` (`house_id` , `listid` , `list`, `version`) VALUES ");
	listUpdate.upsert({ "list", "version" });
	auto version = getTimeUsNow();

	for (const auto &[key, house] : g_game().map.houses.getHouses()) {
		std::string listText;
		if (house->getAccessList(GUEST_LIST, listText) && !listText.empty()) {
			query << house->getId() << ',' << GUEST_LIST << ',' << db.escapeString(listText) << ',' << version;
			if (!listUpdate.addRow(query)) {
				return false;
			}

			listText.clear();
		}

		if (house->getAccessList(SUBOWNER_LIST, listText) && !listText.empty()) {
			query << house->getId() << ',' << SUBOWNER_LIST << ',' << db.escapeString(listText) << ',' << version;
			if (!listUpdate.addRow(query)) {
				return false;
			}

			listText.clear();
		}

		for (const std::shared_ptr<Door> &door : house->getDoors()) {
			if (door->getAccessList(listText) && !listText.empty()) {
				query << house->getId() << ',' << door->getDoorId() << ',' << db.escapeString(listText) << ',' << version;
				if (!listUpdate.addRow(query)) {
					return false;
				}

				listText.clear();
			}
		}
	}

	if (!listUpdate.execute()) {
		return false;
	}

	if (!db.executeQuery(fmt::format("DELETE FROM `house_lists` WHERE `version` < {}", version))) {
		return false;
	}

	return true;
}
