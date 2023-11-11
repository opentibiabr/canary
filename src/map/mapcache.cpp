/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "mapcache.hpp"

#include "game/movement/teleport.hpp"
#include "items/bed.hpp"
#include "io/iologindata.hpp"
#include "items/item.hpp"
#include "game/game.hpp"
#include "game/zones/zone.hpp"
#include "map/map.hpp"
#include "utils/hash.hpp"
#include "io/filestream.hpp"

#include "io/iomap.hpp"

static phmap::flat_hash_map<size_t, std::shared_ptr<BasicItem>> items;
static phmap::flat_hash_map<size_t, std::shared_ptr<BasicTile>> tiles;

std::shared_ptr<BasicItem> static_tryGetItemFromCache(const std::shared_ptr<BasicItem> &ref) {
	return ref ? items.try_emplace(ref->hash(), ref).first->second : nullptr;
}

std::shared_ptr<BasicTile> static_tryGetTileFromCache(const std::shared_ptr<BasicTile> &ref) {
	return ref ? tiles.try_emplace(ref->hash(), ref).first->second : nullptr;
}

void MapCache::flush() {
	items.clear();
	tiles.clear();
}

void MapCache::parseItemAttr(const std::shared_ptr<BasicItem> &BasicItem, std::shared_ptr<Item> item) {
	if (BasicItem->charges > 0) {
		item->setSubType(BasicItem->charges);
	}

	if (BasicItem->actionId > 0) {
		item->setAttribute(ItemAttribute_t::ACTIONID, BasicItem->actionId);
	}

	if (BasicItem->uniqueId > 0) {
		item->addUniqueId(BasicItem->uniqueId);
	}

	if (item->getTeleport() && (BasicItem->destX != 0 || BasicItem->destY != 0 || BasicItem->destZ != 0)) {
		auto dest = Position(BasicItem->destX, BasicItem->destY, BasicItem->destZ);
		item->getTeleport()->setDestPos(dest);
	}

	if (item->getDoor() && BasicItem->doorOrDepotId != 0) {
		item->getDoor()->setDoorId(BasicItem->doorOrDepotId);
	}

	if (item->getContainer() && item->getContainer()->getDepotLocker() && BasicItem->doorOrDepotId != 0) {
		item->getContainer()->getDepotLocker()->setDepotId(BasicItem->doorOrDepotId);
	}

	if (!BasicItem->text.empty()) {
		item->setAttribute(ItemAttribute_t::TEXT, BasicItem->text);
	}

	/* if (BasicItem.description != 0)
		item->setAttribute(ItemAttribute_t::DESCRIPTION, STRING_CACHE[BasicItem.description]);*/
}

std::shared_ptr<Item> MapCache::createItem(const std::shared_ptr<BasicItem> &BasicItem, Position position) {
	auto item = Item::CreateItem(BasicItem->id, position);
	if (!item) {
		return nullptr;
	}

	parseItemAttr(BasicItem, item);

	if (item->getContainer() && !BasicItem->items.empty()) {
		for (const auto &BasicItemInside : BasicItem->items) {
			if (auto itemInsede = createItem(BasicItemInside, position)) {
				item->getContainer()->addItem(itemInsede);
				item->getContainer()->updateItemWeight(itemInsede->getWeight());
			}
		}
	}

	if (item->getItemCount() == 0) {
		item->setItemCount(1);
	}

	item->startDecaying();
	item->loadedFromMap = true;
	item->decayDisabled = Item::items[item->getID()].decayTo != -1;

	return item;
}

std::shared_ptr<Tile> MapCache::getOrCreateTileFromCache(const std::unique_ptr<Floor> &floor, uint16_t x, uint16_t y) {
	const auto cachedTile = floor->getTileCache(x, y);
	if (!cachedTile) {
		return floor->getTile(x, y);
	}

	std::unique_lock l(floor->getMutex());

	const uint8_t z = floor->getZ();

	auto map = static_cast<Map*>(this);

	std::shared_ptr<Tile> tile = nullptr;
	if (cachedTile->isHouse()) {
		const auto house = map->houses.getHouse(cachedTile->houseId);
		tile = std::make_shared<HouseTile>(x, y, z, house);
		house->addTile(std::static_pointer_cast<HouseTile>(tile));
	} else if (cachedTile->isStatic) {
		tile = std::make_shared<StaticTile>(x, y, z);
	} else {
		tile = std::make_shared<DynamicTile>(x, y, z);
	}

	auto pos = Position(x, y, z);

	if (cachedTile->ground != nullptr) {
		tile->internalAddThing(createItem(cachedTile->ground, pos));
	}

	for (const auto &BasicItemd : cachedTile->items) {
		tile->internalAddThing(createItem(BasicItemd, pos));
	}

	tile->setFlag(static_cast<TileFlags_t>(cachedTile->flags));
	for (const auto &zone : Zone::getZones(pos)) {
		tile->addZone(zone);
	}

	floor->setTile(x, y, tile);

	// Remove Tile from cache
	floor->setTileCache(x, y, nullptr);

	return tile;
}

void MapCache::setBasicTile(uint16_t x, uint16_t y, uint8_t z, const std::shared_ptr<BasicTile> &newTile) {
	if (z >= MAP_MAX_LAYERS) {
		g_logger().error("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	const auto tile = static_tryGetTileFromCache(newTile);
	if (const auto leaf = QTreeNode::getLeafStatic<QTreeLeafNode*, QTreeNode*>(&root, x, y)) {
		leaf->createFloor(z)->setTileCache(x, y, tile);
	} else {
		root.getBestLeaf(x, y, 15)->createFloor(z)->setTileCache(x, y, tile);
	}
}

std::shared_ptr<BasicItem> MapCache::tryReplaceItemFromCache(const std::shared_ptr<BasicItem> &ref) {
	return static_tryGetItemFromCache(ref);
}

void BasicTile::hash(size_t &h) const {
	std::array<uint32_t, 4> arr = { flags, houseId, type, isStatic };
	for (const auto v : arr) {
		if (v > 0) {
			stdext::hash_combine(h, v);
		}
	}

	if (ground != nullptr) {
		ground->hash(h);
	}

	if (!items.empty()) {
		stdext::hash_combine(h, items.size());
		for (const auto &item : items) {
			item->hash(h);
		}
	}
}

void BasicItem::hash(size_t &h) const {
	const std::array<uint32_t, 8> arr = { id, charges, actionId, uniqueId, destX, destY, destZ, doorOrDepotId };
	for (const auto v : arr) {
		if (v > 0) {
			stdext::hash_combine(h, v);
		}
	}

	if (!text.empty()) {
		stdext::hash_combine(h, text);
	}

	if (!items.empty()) {
		stdext::hash_combine(h, items.size());
		for (const auto &item : items) {
			item->hash(h);
		}
	}
}

bool BasicItem::unserializeItemNode(FileStream &stream, uint16_t x, uint16_t y, uint8_t z) {
	if (stream.isProp(OTB::Node::END)) {
		stream.back();
		return true;
	}

	readAttr(stream);

	while (stream.startNode()) {
		if (stream.getU8() != OTBM_ITEM) {
			throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not read item node.", x, y, z));
		}

		const uint16_t streamId = stream.getU16();

		const auto item = std::make_shared<BasicItem>();
		item->id = streamId;

		if (!item->unserializeItemNode(stream, x, y, z)) {
			throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to load item.", x, y, z));
		}

		items.emplace_back(static_tryGetItemFromCache(item));

		if (!stream.endNode()) {
			throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not end node.", x, y, z));
		}
	}

	return true;
}

void BasicItem::readAttr(FileStream &stream) {
	bool end = false;
	while (!end) {
		const uint8_t attr = stream.getU8();
		switch (attr) {
			case ATTR_DEPOT_ID: {
				doorOrDepotId = stream.getU16();
			} break;

			case ATTR_HOUSEDOORID: {
				doorOrDepotId = stream.getU8();
			} break;

			case ATTR_TELE_DEST: {
				destX = stream.getU16();
				destY = stream.getU16();
				destZ = stream.getU8();
			} break;

			case ATTR_COUNT: {
				charges = stream.getU8();
			} break;

			case ATTR_CHARGES: {
				charges = stream.getU16();
			} break;

			case ATTR_ACTION_ID: {
				actionId = stream.getU16();
			} break;

			case ATTR_UNIQUE_ID: {
				uniqueId = stream.getU16();
			} break;

			case ATTR_TEXT: {
				const auto str = stream.getString();
				if (!str.empty()) {
					text = str;
				}
			} break;

			case ATTR_DESC: {
				const auto str = stream.getString();
				// if (!str.empty())
				//	text = str;
			} break;

			default:
				stream.back();
				end = true;
				break;
		}
	}
}
