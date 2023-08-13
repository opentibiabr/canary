/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <items/item.h>
#include "utils/qtreenode.h"

class Map;
class BasicItem;
class BasicTile;
using BasicItemPtr = std::shared_ptr<BasicItem>;
using BasicTilePtr = std::shared_ptr<BasicTile>;

#pragma pack(1)
struct BasicItem {
		std::string text;
		// size_t description { 0 };

		uint32_t guid { 0 };
		uint32_t sleepStart { 0 };

		uint16_t id { 0 };

		uint16_t charges { 0 }; // Runecharges and Count Too
		uint16_t actionId { 0 };
		uint16_t uniqueId { 0 };
		uint16_t destX { 0 }, destY { 0 };
		uint16_t doorOrDepotId { 0 };

		uint8_t destZ { 0 };

		std::vector<BasicItemPtr> items;

		bool unserializeItemNode(OTB::Loader &, const OTB::Node &, PropStream &propStream);
		Attr_ReadValue readAttr(AttrTypes_t attr, PropStream &propStream);

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

		bool isEmpty() const {
			return flags == 0 && ground == nullptr && items.empty();
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

class MapCache {
	public:
		void setTile(uint16_t x, uint16_t i, uint8_t z, const BasicTilePtr &BasicTile);

		bool tryCreateTile(Map* map, uint16_t x, uint16_t y, uint8_t z);

		BasicItemPtr tryReplaceItemFromCache(const BasicItemPtr &ref);

		void clear();

	private:
		struct Floor {
				BasicTilePtr tiles[FLOOR_SIZE][FLOOR_SIZE] = {};
		};

		BasicTilePtr getTile(uint16_t x, uint16_t i, uint8_t z);
		void parseItemAttr(const BasicItemPtr &BasicItem, Item* item);
		Item* createItem(const BasicItemPtr &BasicItem, Position position);

		QTreeNode<Floor> root;
};
