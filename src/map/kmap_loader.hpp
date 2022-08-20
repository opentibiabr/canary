/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_MAP_KMAP_LOADER_HPP_
#define SRC_MAP_KMAP_LOADER_HPP_

#include "game/movement/position.h"
#include "items/item.h"
#include "map/map.h"
#include "flatbuffer/kmap_generated.h"
#include "flatbuffers/flatbuffers.h"

class Map;

class KmapLoader {

	public:
		KmapLoader() = default;

		bool load(Map &map, const std::string &fileName);

	private:
		std::vector<uint8_t> buffer;

		bool loadFile(const std::string &fileName);
		void loadHeader(Map &map, const Kmap::MapHeader *header, const std::string &fileName);
		void loadData(Map &map, const Kmap::MapData *mapData);
		void loadTile(Map &map, const Kmap::Tile *tile, const Kmap::Position *areaPosition);
		void loadHouses(Map &map, Tile *tile, House *house, const Position &tilePosition, const uint32_t houseId);
		void loadItem(Map &map, const Kmap::Item *item);
		void loadTown(Map &map, const Kmap::Town *town);
		void loadWaypoint(Map &map, const Kmap::Waypoint *waypoint);

		std::string readResourceFile(const std::string &fileName, const flatbuffers::String &resourceFile);
		TileFlags_t readFlags(uint32_t encodedflags);

		Tile* createTile(Item* ground, Item* item, const Position &position);
};

#endif // SRC_MAP_KMAP_LOADER_HPP_
