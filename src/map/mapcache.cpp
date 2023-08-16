/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "mapcache.h"

#include <game/movement/teleport.h>
#include <items/bed.h>
#include <io/iologindata.h>
#include <game/game.h>
#include <map/map.h>
#include <utils/hash.h>

static phmap::flat_hash_map<size_t, BasicItemPtr> items;
static phmap::flat_hash_map<size_t, BasicTilePtr> tiles;

BasicItemPtr static_tryGetItemFromCache(const BasicItemPtr &ref) {
	return ref ? items.try_emplace(ref->hash(), ref).first->second : nullptr;
}

BasicTilePtr static_tryGetTileFromCache(const BasicTilePtr &ref) {
	return ref ? tiles.try_emplace(ref->hash(), ref).first->second : nullptr;
}

void MapCache::flush() {
	items.clear();
	tiles.clear();
}

void MapCache::parseItemAttr(const BasicItemPtr &BasicItem, Item* item) {
	if (BasicItem->charges > 0)
		item->setSubType(BasicItem->charges);

	if (BasicItem->actionId > 0)
		item->setAttribute(ItemAttribute_t::ACTIONID, BasicItem->actionId);

	if (BasicItem->uniqueId > 0)
		item->setAttribute(ItemAttribute_t::UNIQUEID, BasicItem->actionId);

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

	if (item->getBed()) {
		if (BasicItem->guid > 0) {
			const auto &name = IOLoginData::getNameByGuid(BasicItem->guid);
			if (!name.empty()) {
				item->setAttribute(ItemAttribute_t::DESCRIPTION, name + " is sleeping there.");
				g_game().setBedSleeper(item->getBed(), BasicItem->guid);
				item->getBed()->sleeperGUID = BasicItem->guid;
			}
		}

		if (BasicItem->sleepStart > 0)
			item->getBed()->sleepStart = static_cast<uint64_t>(BasicItem->sleepStart);
	}

	if (!BasicItem->text.empty())
		item->setAttribute(ItemAttribute_t::TEXT, BasicItem->text);

	/* if (BasicItem.description != 0)
		item->setAttribute(ItemAttribute_t::DESCRIPTION, STRING_CACHE[BasicItem.description]);*/
}

Item* MapCache::createItem(const BasicItemPtr &BasicItem, Position position) {
	auto item = Item::CreateItem(BasicItem->id, position);
	if (!item)
		return nullptr;

	parseItemAttr(BasicItem, item);

	if (item->getContainer() && !BasicItem->items.empty()) {
		for (const auto &BasicItemInside : BasicItem->items) {
			if (auto itemInsede = createItem(BasicItemInside, position)) {
				item->getContainer()->addItem(itemInsede);
				item->getContainer()->updateItemWeight(itemInsede->getWeight());
			}
		}
	}

	if (item->getItemCount() == 0)
		item->setItemCount(1);

	item->startDecaying();
	item->setLoadedFromMap(true);

	return item;
}

Tile* MapCache::getOrCreateTileFromCache(const std::unique_ptr<Floor> &floor, uint16_t x, uint16_t y) {
	const auto &cachedTile = floor->getTileCache(x, y);
	if (!cachedTile)
		return floor->getTile(x, y);

	const uint8_t z = floor->getZ();

	auto map = static_cast<Map*>(this);

	Tile* tile = nullptr;
	if (cachedTile->isHouse()) {
		const auto house = map->houses.getHouse(cachedTile->houseId);
		tile = new HouseTile(x, y, z, house);
		house->addTile(static_cast<HouseTile*>(tile));
	} else if (cachedTile->isStatic) {
		tile = new StaticTile(x, y, z);
	} else
		tile = new DynamicTile(x, y, z);

	auto pos = Position(x, y, z);

	if (cachedTile->ground != nullptr)
		tile->internalAddThing(createItem(cachedTile->ground, pos));

	for (const auto &BasicItemd : cachedTile->items)
		tile->internalAddThing(createItem(BasicItemd, pos));

	tile->setFlag(static_cast<TileFlags_t>(cachedTile->flags));

	floor->setTile(x, y, tile);

	// Remove Tile from cache
	floor->setTileCache(x, y, nullptr);

	return tile;
}

void MapCache::setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTilePtr &newTile) {
	if (z >= MAP_MAX_LAYERS) {
		SPDLOG_ERROR("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	root.getBestLeaf(x, y, 15)->createFloor(z)->setTileCache(x, y, static_tryGetTileFromCache(newTile));
}

BasicItemPtr MapCache::tryReplaceItemFromCache(const BasicItemPtr &ref) {
	return static_tryGetItemFromCache(ref);
}

void BasicTile::hash(size_t &h) const {
	const uint32_t arr[] = { flags, houseId, type, isStatic };
	for (const auto v : arr) {
		if (v > 0)
			stdext::hash_combine(h, v);
	}

	if (ground != nullptr)
		ground->hash(h);

	for (const auto &item : items)
		item->hash(h);
}

void BasicItem::hash(size_t &h) const {
	const uint32_t arr[] = { id, guid, sleepStart, charges, actionId, uniqueId, destX, destY, destZ, doorOrDepotId };
	for (const auto v : arr) {
		if (v > 0)
			stdext::hash_combine(h, v);
	}

	if (!text.empty())
		stdext::hash_combine(h, text);

	for (const auto &item : items)
		item->hash(h);
}

bool BasicItem::unserializeItemNode(OTB::Loader &loader, const OTB::Node &node, PropStream &propStream) {
	uint8_t attr_type;
	while (propStream.read<uint8_t>(attr_type) && attr_type != 0) {
		const Attr_ReadValue ret = readAttr(static_cast<AttrTypes_t>(attr_type), propStream);
		if (ret == ATTR_READ_ERROR) {
			return false;
		} else if (ret == ATTR_READ_END) {
			return true;
		}
	}

	for (auto &itemNode : node.children) {
		// load container items
		if (itemNode.type != OTBM_ITEM) {
			// unknown type
			return false;
		}

		PropStream itemPropStream;
		if (!loader.getProps(itemNode, itemPropStream)) {
			return false;
		}

		uint16_t id;
		if (!itemPropStream.read<uint16_t>(id)) {
			return false;
		}

		const auto &item = std::make_shared<BasicItem>();
		item->id = id;

		if (!item->unserializeItemNode(loader, itemNode, itemPropStream)) {
			continue;
		}

		items.emplace_back(static_tryGetItemFromCache(item));
	}

	return true;
}

Attr_ReadValue BasicItem::readAttr(AttrTypes_t attr, PropStream &propStream) {
	switch (attr) {
		case ATTR_COUNT:
		case ATTR_RUNE_CHARGES: {
			uint8_t charges;
			if (!propStream.read<uint8_t>(charges)) {
				return ATTR_READ_ERROR;
			}
			this->charges = charges;
			break;
		}

		case ATTR_ACTION_ID: {
			if (!propStream.read<uint16_t>(actionId))
				return ATTR_READ_ERROR;
			break;
		}

		case ATTR_UNIQUE_ID: {
			if (!propStream.read<uint16_t>(uniqueId))
				return ATTR_READ_ERROR;
			break;
		}

		case ATTR_TEXT: {
			std::string str;
			if (!propStream.readString(str))
				return ATTR_READ_ERROR;

			if (!str.empty()) {
				text = str;
			}

			break;
		}

		case ATTR_DESC: {
			std::string str;
			if (!propStream.readString(str)) {
				return ATTR_READ_ERROR;
			}

			if (!str.empty()) {
				/* stdext::hash<std::string> h;
				size_t hash = h(str);
				description = hash;
				STRING_CACHE.emplace(hash, std::move(str));*/
			}

			break;
		}

		case ATTR_CHARGES: {
			if (!propStream.read<uint16_t>(charges))
				return ATTR_READ_ERROR;
			break;
		}

		// Depot class
		case ATTR_DEPOT_ID: {
			if (!propStream.read<uint16_t>(doorOrDepotId))
				return ATTR_READ_ERROR;
			break;
		}

		// Door class
		case ATTR_HOUSEDOORID: {
			uint8_t v;
			if (!propStream.read<uint8_t>(v))
				return ATTR_READ_ERROR;

			doorOrDepotId = v;

			break;
		}

		// Teleport class
		case ATTR_TELE_DEST: {
			if (!propStream.read<uint16_t>(destX) || !propStream.read<uint16_t>(destY) || !propStream.read<uint8_t>(destZ))
				return ATTR_READ_ERROR;
			break;
		}

		case ATTR_SLEEPERGUID: {
			if (!propStream.read<uint32_t>(guid))
				return ATTR_READ_ERROR;

			break;
		}

		case ATTR_SLEEPSTART: {
			if (!propStream.read<uint32_t>(sleepStart))
				return ATTR_READ_ERROR;

			break;
		}

		default:
			return ATTR_READ_ERROR;
	}

	return ATTR_READ_CONTINUE;
}
