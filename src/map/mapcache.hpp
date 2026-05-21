/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/items_definitions.hpp"
#include "utils/mapsector.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
#endif

class Map;
class MapCache;
class Tile;
class Item;
struct Position;
class FileStream;

struct BasicItem {
	std::string text;
	// size_t description { 0 };

	uint16_t id { 0 };

	uint16_t charges { 0 }; // Runecharges and Count Too
	uint16_t actionId { 0 };
	uint16_t uniqueId { 0 };
	uint16_t destX { 0 }, destY { 0 };
	uint16_t doorOrDepotId { 0 };

	uint8_t destZ { 0 };

	std::vector<std::shared_ptr<BasicItem>> items;

	bool unserializeItemNode(FileStream &propStream, uint16_t x, uint16_t y, uint8_t z);
	void readAttr(FileStream &propStream);

	bool isSimple() const {
		return charges == 0
			&& actionId == 0
			&& uniqueId == 0
			&& destX == 0
			&& destY == 0
			&& destZ == 0
			&& doorOrDepotId == 0
			&& text.empty()
			&& items.empty();
	}

	size_t hash() const {
		if (cachedHashValid) {
			return cachedHash;
		}

		size_t h = 0;
		hash(h);
		cachedHash = h;
		cachedHashValid = true;
		return cachedHash;
	}

private:
	void hash(size_t &h) const;

	mutable size_t cachedHash { 0 };
	mutable bool cachedHashValid { false };

	friend struct BasicTile;
};

struct BasicTile {
	std::shared_ptr<BasicItem> ground { nullptr };
	std::vector<std::shared_ptr<BasicItem>> items;

	uint32_t flags { 0 }, houseId { 0 };
	uint8_t type { TILESTATE_NONE };

	bool isStatic { false };

	void reset() {
		ground.reset();
		items.clear();
		flags = 0;
		houseId = 0;
		type = TILESTATE_NONE;
		isStatic = false;
		retainedByMapCacheOwner = nullptr;
		cachedHash = 0;
		cachedHashValid = false;
	}

	bool isEmpty(bool ignoreFlag = false) const {
		return (ignoreFlag || flags == 0) && ground == nullptr && items.empty();
	}

	bool isHouse() const {
		return houseId != 0;
	}

	[[nodiscard]] bool isCacheShareable() const {
		if (isHouse()) {
			return false;
		}

		if (ground && !ground->isSimple()) {
			return false;
		}

		return std::ranges::none_of(items, [](const auto &item) {
			return item && !item->isSimple();
		});
	}

	size_t hash() const {
		if (cachedHashValid) {
			return cachedHash;
		}

		size_t h = 0;
		hash(h);
		cachedHash = h;
		cachedHashValid = true;
		return cachedHash;
	}

private:
	void hash(size_t &h) const;

	const MapCache* retainedByMapCacheOwner = nullptr;
	mutable size_t cachedHash { 0 };
	mutable bool cachedHashValid { false };

	friend class MapCache;
};

struct MapCacheFloorCursor {
	bool valid { false };
	uint32_t sectorIndex { 0 };
	uint8_t z { 0 };
	std::shared_ptr<Floor> floor;
};

class MapCache {
public:
	virtual ~MapCache() = default;

	void setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTile &basicTile);
	void setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTile &basicTile, MapCacheFloorCursor &floorCursor);

	std::shared_ptr<BasicItem> getBasicItemFromCache(uint16_t id) const;
	std::shared_ptr<BasicItem> tryReplaceItemFromCache(const std::shared_ptr<BasicItem> &ref) const;

	void reserveForMap(uint16_t width, uint16_t height, size_t fileSize);
	void flush() const;

	/**
	 * Creates a map sector.
	 * \returns A pointer to that map sector.
	 */
	MapSector* createMapSector(uint32_t x, uint32_t y);
	MapSector* getBestMapSector(uint32_t x, uint32_t y);

	/**
	 * Gets a map sector.
	 * \returns A pointer to that map sector.
	 */
	MapSector* getMapSector(const uint32_t x, const uint32_t y) {
		const auto it = mapSectors.find(x / SECTOR_SIZE | y / SECTOR_SIZE << 16);
		return it != mapSectors.end() ? &it->second : nullptr;
	}

	const MapSector* getMapSector(const uint32_t x, const uint32_t y) const {
		const auto it = mapSectors.find(x / SECTOR_SIZE | y / SECTOR_SIZE << 16);
		return it != mapSectors.end() ? &it->second : nullptr;
	}

protected:
	std::shared_ptr<Tile> getOrCreateTileFromCache(const std::shared_ptr<Floor> &floor, uint16_t x, uint16_t y);

	std::unordered_map<uint32_t, MapSector> mapSectors;

private:
	const BasicTile* getOrCreateBasicTileFromCache(const BasicTile &basicTile);
	const BasicTile* retainBasicTile(const std::shared_ptr<BasicTile> &tile);
	void resetBasicTileLookupCache() const;
	void parseItemAttr(const std::shared_ptr<BasicItem> &BasicItem, const std::shared_ptr<Item> &item) const;
	std::shared_ptr<Item> createItem(const std::shared_ptr<BasicItem> &BasicItem, Position position);

	// Floor tile caches store observer pointers; these shared owners keep them valid after flush().
	std::vector<std::shared_ptr<BasicTile>> retainedBasicTiles;

	mutable uint64_t lastFlaggedGroundTileKey { 0 };
	mutable const BasicTile* lastFlaggedGroundTile { nullptr };
	mutable uint64_t lastFlaggedItemTileKey { 0 };
	mutable const BasicTile* lastFlaggedItemTile { nullptr };
	mutable uint64_t lastGroundAndItemTileKey { 0 };
	mutable const BasicTile* lastGroundAndItemTile { nullptr };
};
