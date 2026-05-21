/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/mapcache.hpp"

#include <array>
#include <limits>

#include "game/movement/teleport.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/zones/zone.hpp"
#include "io/filestream.hpp"
#include "io/iomap.hpp"
#include "items/containers/depot/depotlocker.hpp"
#include "items/item.hpp"
#include "map/map.hpp"
#include "utils/hash.hpp"

namespace {
uint64_t makeFlagsAndIdKey(uint32_t flags, uint16_t id) {
	return (static_cast<uint64_t>(flags) << 16) | id;
}

uint64_t makeGroundAndItemKey(uint32_t flags, uint16_t groundId, uint16_t itemId) {
	return (static_cast<uint64_t>(flags) << 32) | (static_cast<uint64_t>(groundId) << 16) | itemId;
}

std::shared_ptr<BasicTile> getOrCreateTile(std::shared_ptr<BasicTile> &cachedTile, const BasicTile &ref) {
	if (!cachedTile) {
		cachedTile = std::make_shared<BasicTile>(ref);
	}

	return cachedTile;
}
}

static phmap::flat_hash_map<size_t, std::shared_ptr<BasicItem>> items;
static phmap::flat_hash_map<size_t, std::shared_ptr<BasicTile>> tiles;
static phmap::flat_hash_map<uint64_t, std::shared_ptr<BasicTile>> flaggedGroundTiles;
static phmap::flat_hash_map<uint64_t, std::shared_ptr<BasicTile>> flaggedItemTiles;
static phmap::flat_hash_map<uint64_t, std::shared_ptr<BasicTile>> groundAndItemTiles;
static std::array<std::shared_ptr<BasicItem>, std::numeric_limits<uint16_t>::max() + 1> simpleItems;
static std::array<std::shared_ptr<BasicTile>, std::numeric_limits<uint16_t>::max() + 1> groundOnlyTiles;
static std::array<std::shared_ptr<BasicTile>, std::numeric_limits<uint16_t>::max() + 1> itemOnlyTiles;

std::shared_ptr<BasicItem> static_tryGetItemFromCache(const std::shared_ptr<BasicItem> &ref) {
	return ref ? items.try_emplace(ref->hash(), ref).first->second : nullptr;
}

std::shared_ptr<BasicItem> static_getBasicItemFromCache(uint16_t id) {
	auto &cachedItem = simpleItems[id];
	if (!cachedItem) {
		cachedItem = std::make_shared<BasicItem>();
		cachedItem->id = id;
	}

	return cachedItem;
}

std::shared_ptr<BasicTile> static_tryGetTileFromCache(const BasicTile &ref) {
	if (!ref.isHouse() && ref.type == TILESTATE_NONE && !ref.isStatic) {
		if (ref.ground && ref.ground->isSimple() && ref.items.empty()) {
			if (ref.flags == 0) {
				return getOrCreateTile(groundOnlyTiles[ref.ground->id], ref);
			}

			const auto key = makeFlagsAndIdKey(ref.flags, ref.ground->id);
			if (const auto it = flaggedGroundTiles.find(key); it != flaggedGroundTiles.end()) {
				return it->second;
			}

			auto tile = std::make_shared<BasicTile>(ref);
			return flaggedGroundTiles.try_emplace(key, std::move(tile)).first->second;
		}

		if (!ref.ground && ref.items.size() == 1 && ref.items.front() && ref.items.front()->isSimple()) {
			const auto itemId = ref.items.front()->id;
			if (ref.flags == 0) {
				return getOrCreateTile(itemOnlyTiles[itemId], ref);
			}

			const auto key = makeFlagsAndIdKey(ref.flags, itemId);
			if (const auto it = flaggedItemTiles.find(key); it != flaggedItemTiles.end()) {
				return it->second;
			}

			auto tile = std::make_shared<BasicTile>(ref);
			return flaggedItemTiles.try_emplace(key, std::move(tile)).first->second;
		}

		if (ref.ground && ref.ground->isSimple() && ref.items.size() == 1 && ref.items.front() && ref.items.front()->isSimple()) {
			const auto key = makeGroundAndItemKey(ref.flags, ref.ground->id, ref.items.front()->id);
			if (const auto it = groundAndItemTiles.find(key); it != groundAndItemTiles.end()) {
				return it->second;
			}

			auto tile = std::make_shared<BasicTile>(ref);
			return groundAndItemTiles.try_emplace(key, std::move(tile)).first->second;
		}
	}

	if (!ref.isCacheShareable()) {
		return std::make_shared<BasicTile>(ref);
	}

	const auto hash = ref.hash();
	if (const auto it = tiles.find(hash); it != tiles.end()) {
		return it->second;
	}

	auto tile = std::make_shared<BasicTile>(ref);
	return tiles.try_emplace(hash, std::move(tile)).first->second;
}

void MapCache::flush() const {
	items.clear();
	tiles.clear();
	flaggedGroundTiles.clear();
	flaggedItemTiles.clear();
	groundAndItemTiles.clear();
	for (auto &item : simpleItems) {
		item.reset();
	}
	for (auto &tile : groundOnlyTiles) {
		tile.reset();
	}
	for (auto &tile : itemOnlyTiles) {
		tile.reset();
	}
}

void MapCache::parseItemAttr(const std::shared_ptr<BasicItem> &BasicItem, const std::shared_ptr<Item> &item) const {
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
		const auto dest = Position(BasicItem->destX, BasicItem->destY, BasicItem->destZ);
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
	const auto &item = Item::CreateItem(BasicItem->id, position);
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

	if (item->canDecay()) {
		item->startDecaying();
	}
	item->loadedFromMap = true;
	item->decayDisabled = Item::items[item->getID()].decayTo != -1;

	return item;
}

std::shared_ptr<Tile> MapCache::getOrCreateTileFromCache(const std::shared_ptr<Floor> &floor, uint16_t x, uint16_t y) {
	const auto &cachedTile = floor->getTileCache(x, y);
	const auto oldTile = floor->getTile(x, y);
	if (!cachedTile) {
		return oldTile;
	}

	std::unique_lock l(floor->getMutex());

	const uint8_t z = floor->getZ();
	const auto map = static_cast<Map*>(this);

	std::vector<std::shared_ptr<Creature>> oldCreatureList;
	if (oldTile) {
		if (CreatureVector* creatures = oldTile->getCreatures()) {
			for (const auto &creature : *creatures) {
				oldCreatureList.emplace_back(creature);
			}
		}
	}

	std::shared_ptr<Tile> tile = nullptr;

	auto pos = Position(x, y, z);

	if (cachedTile->isHouse()) {
		if (const auto &house = map->houses.getHouse(cachedTile->houseId)) {
			tile = std::make_shared<HouseTile>(pos, house);
			tile->safeCall([tile] {
				tile->getHouse()->addTile(tile->static_self_cast<HouseTile>());
			});
		} else {
			g_logger().error("[{}] house not found for houseId {}", std::source_location::current().function_name(), cachedTile->houseId);
		}
	} else if (cachedTile->isStatic) {
		tile = std::make_shared<StaticTile>(pos);
	} else {
		tile = std::make_shared<DynamicTile>(pos);
	}

	if (cachedTile->ground != nullptr) {
		tile->internalAddThing(createItem(cachedTile->ground, pos));
	}

	for (const auto &BasicItemd : cachedTile->items) {
		tile->internalAddThing(createItem(BasicItemd, pos));
	}

	tile->setFlag(static_cast<TileFlags_t>(cachedTile->flags));

	tile->safeCall([tile, pos, movedOldCreatureList = std::move(oldCreatureList)]() {
		for (const auto &creature : movedOldCreatureList) {
			tile->internalAddThing(creature);
		}

		for (const auto &zone : Zone::getZones(pos)) {
			tile->addZone(zone);
		}
	});

	floor->setTile(x, y, tile);

	// Remove Tile from cache
	floor->setTileCache(x, y, nullptr);

	return tile;
}

void MapCache::setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTile &newTile) {
	MapCacheFloorCursor floorCursor;
	setBasicTile(x, y, z, newTile, floorCursor);
}

void MapCache::setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTile &newTile, MapCacheFloorCursor &floorCursor) {
	if (z >= MAP_MAX_LAYERS) {
		g_logger().error("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	const auto &tile = static_tryGetTileFromCache(newTile);
	const auto sectorIndex = static_cast<uint32_t>(x / SECTOR_SIZE) | (static_cast<uint32_t>(y / SECTOR_SIZE) << 16);
	Floor* floor = nullptr;

	if (floorCursor.valid && floorCursor.sectorIndex == sectorIndex && floorCursor.z == z) {
		floor = floorCursor.floor.get();
	}

	if (!floor) {
		std::shared_ptr<Floor> cachedFloor;
		if (const auto sector = getMapSector(x, y)) {
			cachedFloor = sector->createFloor(z);
		} else {
			cachedFloor = getBestMapSector(x, y)->createFloor(z);
		}

		floorCursor.valid = true;
		floorCursor.sectorIndex = sectorIndex;
		floorCursor.z = z;
		floorCursor.floor = std::move(cachedFloor);
		floor = floorCursor.floor.get();
	}

	if (floor) {
		floor->setTileCache(x, y, tile);
	}
}

std::shared_ptr<BasicItem> MapCache::tryReplaceItemFromCache(const std::shared_ptr<BasicItem> &ref) const {
	return static_tryGetItemFromCache(ref);
}

std::shared_ptr<BasicItem> MapCache::getBasicItemFromCache(uint16_t id) const {
	return static_getBasicItemFromCache(id);
}

MapSector* MapCache::createMapSector(const uint32_t x, const uint32_t y) {
	const uint32_t index = x / SECTOR_SIZE | y / SECTOR_SIZE << 16;
	const auto it = mapSectors.find(index);
	if (it != mapSectors.end()) {
		return &it->second;
	}

	MapSector::newSector = true;
	return &mapSectors[index];
}

MapSector* MapCache::getBestMapSector(uint32_t x, uint32_t y) {
	MapSector::newSector = false;
	const auto sector = createMapSector(x, y);

	if (MapSector::newSector) {
		// update north sector
		if (const auto northSector = getMapSector(x, y - SECTOR_SIZE)) {
			northSector->sectorS = sector;
		}

		// update west sector
		if (const auto westSector = getMapSector(x - SECTOR_SIZE, y)) {
			westSector->sectorE = sector;
		}

		// update south sector
		if (const auto southSector = getMapSector(x, y + SECTOR_SIZE)) {
			sector->sectorS = southSector;
		}

		// update east sector
		if (const auto eastSector = getMapSector(x + SECTOR_SIZE, y)) {
			sector->sectorE = eastSector;
		}
	}

	return sector;
}

void BasicTile::hash(size_t &h) const {
	const std::array<uint32_t, 4> arr = { flags, houseId, type, isStatic };
	for (const auto v : arr) {
		if (v > 0) {
			stdext::hash_combine(h, v);
		}
	}

	if (ground != nullptr) {
		stdext::hash_combine(h, ground->hash());
	}

	if (!items.empty()) {
		stdext::hash_combine(h, items.size());
		for (const auto &item : items) {
			stdext::hash_combine(h, item->hash());
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
			stdext::hash_combine(h, item->hash());
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

		items.emplace_back(item->isSimple() ? static_getBasicItemFromCache(streamId) : static_tryGetItemFromCache(item));

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
