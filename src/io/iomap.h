/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.org/
*/

#ifndef SRC_IO_IOMAP_H_
#define SRC_IO_IOMAP_H_

#include <utility>

#include "declarations.hpp"

#include "config/configmanager.h"
#include "core/file_handle.hpp"
#include "map/house/house.h"
#include "items/item.h"
#include "map/map.h"
#include "creatures/monsters/spawns/spawn_monster.h"
#include "creatures/npcs/spawns/spawn_npc.h"

class IOMap
{
	static Tile* createTile(Item* ground, Item* item, uint16_t x, uint16_t y, uint8_t z);

	public:
		void clearBuffer() {
			buffer.clear();
		}
		bool loadMap(Map &serverMap, const std::string& fileName);

		/**
		* Load main map monsters
		 * \param map Is the map class
		 * \returns true if the monsters spawn map was loaded successfully
		*/
		static bool loadMonsters(Map* map) {
			if (map->monsterfile.empty()) {
				// OTBM file doesn't tell us about the monsterfile,
				// Lets guess it is mapname-monster.xml.
				map->monsterfile = g_configManager().getString(MAP_NAME);
				map->monsterfile += "-monster.xml";
			}

			return map->spawnsMonster.loadFromXML(map->monsterfile);
		}

		/**
		* Load main map npcs
		 * \param map Is the map class
		 * \returns true if the npcs spawn map was loaded successfully
		*/
		static bool loadNpcs(Map* map) {
			if (map->npcfile.empty()) {
				// OTBM file doesn't tell us about the npcfile,
				// Lets guess it is mapname-npc.xml.
				map->npcfile = g_configManager().getString(MAP_NAME);
				map->npcfile += "-npc.xml";
			}

			return map->spawnsNpc.loadFromXml(map->npcfile);
		}

		/**
		* Load main map houses
		 * \param map Is the map class
		 * \returns true if the main map houses was loaded successfully
		*/
		static bool loadHouses(Map* map) {
			if (map->housefile.empty()) {
				// OTBM file doesn't tell us about the housefile,
				// Lets guess it is mapname-house.xml.
				map->housefile = g_configManager().getString(MAP_NAME);
				map->housefile += "-house.xml";
			}

			return map->houses.loadHousesXML(map->housefile);
		}

		/**
		* Load custom  map monsters
		 * \param map Is the map class
		 * \returns true if the monsters spawn map custom was loaded successfully
		*/
		static bool loadMonstersCustom(Map* map) {
			if (map->monsterfile.empty()) {
				// OTBM file doesn't tell us about the monsterfile,
				// Lets guess it is mapname-monster.xml.
				map->monsterfile = g_configManager().getString(MAP_CUSTOM_NAME);
				map->monsterfile += "-monster.xml";
			}

			return map->spawnsMonsterCustom.loadFromXML(map->monsterfile);
		}

		/**
		* Load custom map npcs
		 * \param map Is the map class
		 * \returns true if the npcs spawn map custom was loaded successfully
		*/
		static bool loadNpcsCustom(Map* map) {
			if (map->npcfile.empty()) {
				// OTBM file doesn't tell us about the npcfile,
				// Lets guess it is mapname-npc.xml.
				map->npcfile = g_configManager().getString(MAP_CUSTOM_NAME);
				map->npcfile += "-npc.xml";
			}

			return map->spawnsNpcCustom.loadFromXml(map->npcfile);
		}

		/**
		* Load custom map houses
		 * \param map Is the map class
		 * \returns true if the map custom houses was loaded successfully
		*/
		static bool loadHousesCustom(Map* map) {
			if (map->housefile.empty()) {
				// OTBM file doesn't tell us about the housefile,
				// Lets guess it is mapname-house.xml.
				map->housefile = g_configManager().getString(MAP_CUSTOM_NAME);
				map->housefile += "-house.xml";
			}

			return map->housesCustom.loadHousesXML(map->housefile);
		}

	private:
		bool parseMapDataAttributes(BinaryNode &binaryNodeMapData, Map& map, const std::string& fileName) const;
		bool parseWaypoints(BinaryNode &binaryNodeMapData, Map& map) const;
		bool parseTowns(BinaryNode &binaryNodeMapData, Map& map);

		void readAttributeTileFlags(BinaryNode &binaryNodeMapTile, uint32_t &tileflags) const;
		std::tuple<Tile*, Item*> readAttributeTileItem(BinaryNode &binaryNodeMapTile, std::map<Position, Position> &teleportMap, bool isHouseTile, const House *house, Item *groundItem, Tile *tile, Position tilePosition) const;
		
		std::tuple<Tile*, Item*> parseCreateTileItem(BinaryNode &nodeItem, bool isHouseTile, const House *house, Item *groundItem, Tile *tile, Position tilePosition) const;
		bool parseTileArea(BinaryNode &binaryNodeMapData, Map& map) const;

		bool fileLoaded = false;
		std::vector<uint8_t> buffer;
};

#endif // SRC_IO_IOMAP_H_
