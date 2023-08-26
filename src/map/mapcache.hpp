/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "items/items_definitions.hpp"
#include "utils/qtreenode.hpp"

class Map;
class Tile;
class BasicItem;
class BasicTile;
class Item;
class Position;
class FileStream;

using TilePtr = std::unique_ptr<Tile>;
using BasicItemPtr = std::shared_ptr<BasicItem>;
using BasicTilePtr = std::shared_ptr<BasicTile>;

#pragma pack(1)
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

	std::vector<BasicItemPtr> items;

	bool unserializeItemNode(FileStream &propStream, uint16_t x, uint16_t y, uint8_t z);
	void readAttr(FileStream &propStream);

	size_t hash() const {
		size_t h = 0;
		hash(h);
		return h;
	}

private:
	void hash(size_t &h) const;

	friend class BasicTile;
};

struct BasicTile {
	BasicItemPtr ground { nullptr };
	std::vector<BasicItemPtr> items;

	uint32_t flags { 0 }, houseId { 0 };
	uint8_t type { TILESTATE_NONE };

	bool isStatic { false };

	bool isEmpty(bool ignoreFlag = false) const {
		return (ignoreFlag || flags == 0) && ground == nullptr && items.empty();
	}

	bool isHouse() const {
		return houseId != 0;
	}

	size_t hash() const {
		size_t h = 0;
		hash(h);
		return h;
	}

private:
	void hash(size_t &h) const;
};

#pragma pack()

struct Floor {
	explicit Floor(uint8_t z) :
		z(z) {};

	Tile* getTile(uint16_t x, uint16_t y) const {
		return tiles[x & FLOOR_MASK][y & FLOOR_MASK].first.get();
	}

	void setTile(uint16_t x, uint16_t y, Tile* tile) {
		tiles[x & FLOOR_MASK][y & FLOOR_MASK].first.reset(tile);
	}

	BasicTilePtr getTileCache(uint16_t x, uint16_t y) const {
		return tiles[x & FLOOR_MASK][y & FLOOR_MASK].second;
	}

	void setTileCache(uint16_t x, uint16_t y, const BasicTilePtr &newTile) {
		tiles[x & FLOOR_MASK][y & FLOOR_MASK].second = newTile;
	}

	uint8_t getZ() const {
		return z;
	}

private:
	std::pair<TilePtr, BasicTilePtr> tiles[FLOOR_SIZE][FLOOR_SIZE] = {};
	uint8_t z { 0 };
};

class MapCache {
public:
	virtual ~MapCache() = default;

	void setBasicTile(uint16_t x, uint16_t y, uint8_t z, const BasicTilePtr &BasicTile);

	BasicItemPtr tryReplaceItemFromCache(const BasicItemPtr &ref);

	void flush();

protected:
	Tile* getOrCreateTileFromCache(const std::unique_ptr<Floor> &floor, uint16_t x, uint16_t y);

	QTreeNode root;

private:
	void parseItemAttr(const BasicItemPtr &BasicItem, Item* item);
	Item* createItem(const BasicItemPtr &BasicItem, Position position);
};
