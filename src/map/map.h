/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef SRC_MAP_MAP_H_
#define SRC_MAP_MAP_H_

#include "mapcache.h"
#include "map/town.h"
#include "map/house/house.h"
#include "creatures/monsters/spawns/spawn_monster.h"
#include "creatures/npcs/spawns/spawn_npc.h"

class Creature;
class Player;
class Game;
class Tile;
class Map;

struct FindPathParams;

using SpectatorCache = phmap::btree_map<Position, SpectatorHashSet>;

class FrozenPathingConditionCall;

/**
 * Map class.
 * Holds all the actual map-data
 */
class Map : protected MapCache {
	public:
		uint32_t clean() const;

		/**
		 * Load a map.
		 * \returns true if the map was loaded successfully
		 */
		bool load(const std::string &identifier, const Position &pos = Position(), bool unload = false);
		/**
		 * Load the main map
		 * \param identifier Is the main map name (name of file .otbm)
		 * \param loadHouses if true, the main map houses is loaded
		 * \param loadMonsters if true, the main map monsters is loaded
		 * \param loadNpcs if true, the main map npcs is loaded
		 * \returns true if the main map was loaded successfully
		 */
		bool loadMap(const std::string &identifier, bool mainMap = false, bool loadHouses = false, bool loadMonsters = false, bool loadNpcs = false, const Position &pos = Position(), bool unload = false);
		/**
		 * Load the custom map
		 * \param identifier Is the map custom folder
		 * \param loadHouses if true, the map custom houses is loaded
		 * \param loadMonsters if true, the map custom monsters is loaded
		 * \param loadNpcs if true, the map custom npcs is loaded
		 * \returns true if the custom map was loaded successfully
		 */
		bool loadMapCustom(const std::string &mapName, bool loadHouses, bool loadMonsters, bool loadNpcs, const int customMapIndex);

		void loadHouseInfo();

		/**
		 * Save a map.
		 * \returns true if the map was saved successfully
		 */
		static bool save();

		/**
		 * Get a single tile.
		 * \returns A pointer to that tile.
		 */
		Tile* getTile(uint16_t x, uint16_t y, uint8_t z);
		Tile* getTile(const Position &pos) {
			return getTile(pos.x, pos.y, pos.z);
		}

		Tile* getOrCreateTile(uint16_t x, uint16_t y, uint8_t z, bool isDynamic = false);
		Tile* getOrCreateTile(const Position &pos, bool isDynamic = false) {
			return getOrCreateTile(pos.x, pos.y, pos.z, isDynamic);
		}

		/**
		 * Place a creature on the map
		 * \param centerPos The position to place the creature
		 * \param creature Creature to place on the map
		 * \param extendedPos If true, the creature will in first-hand be placed 2 tiles away
		 * \param forceLogin If true, placing the creature will not fail becase of obstacles (creatures/chests)
		 */
		bool placeCreature(const Position &centerPos, Creature* creature, bool extendedPos = false, bool forceLogin = false);

		void moveCreature(Creature &creature, Tile &newTile, bool forceTeleport = false);

		void getSpectators(SpectatorHashSet &spectators, const Position &centerPos, bool multifloor = false, bool onlyPlayers = false, int32_t minRangeX = 0, int32_t maxRangeX = 0, int32_t minRangeY = 0, int32_t maxRangeY = 0);

		void clearSpectatorCache();

		/**
		 * Checks if you can throw an object to that position
		 *	\param fromPos from Source point
		 *	\param toPos Destination point
		 *	\param rangex maximum allowed range horizontially
		 *	\param rangey maximum allowed range vertically
		 *	\param checkLineOfSight checks if there is any blocking objects in the way
		 *	\returns The result if you can throw there or not
		 */
		bool canThrowObjectTo(const Position &fromPos, const Position &toPos, bool checkLineOfSight = true, int32_t rangex = MAP_MAX_CLIENT_VIEW_PORT_X, int32_t rangey = MAP_MAX_CLIENT_VIEW_PORT_Y);

		/**
		 * Checks if path is clear from fromPos to toPos
		 * Notice: This only checks a straight line if the path is clear, for path finding use getPathTo.
		 *	\param fromPos from Source point
		 *	\param toPos Destination point
		 *	\param floorCheck if true then view is not clear if fromPos.z is not the same as toPos.z
		 *	\returns The result if there is no obstacles
		 */
		bool isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck);
		bool checkSightLine(const Position &fromPos, const Position &toPos);

		const Tile* canWalkTo(const Creature &creature, const Position &pos);

		bool getPathMatching(const Creature &creature, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp);

		bool getPathMatching(const Position &startPos, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp);

		phmap::btree_map<std::string, Position> waypoints;

		QTreeLeafNode<Floor>* getQTNode(uint16_t x, uint16_t y) {
			return QTreeNode<Floor>::getLeafStatic<QTreeLeafNode<Floor>*, QTreeNode<Floor>*>(&root, x, y);
		}

		// Storage made by "loadFromXML" of houses, monsters and npcs for main map
		SpawnsMonster spawnsMonster;
		SpawnsNpc spawnsNpc;
		Towns towns;
		Houses houses;

		// Storage made by "loadFromXML" of houses, monsters and npcs for custom maps
		SpawnsMonster spawnsMonsterCustomMaps[50];
		SpawnsNpc spawnsNpcCustomMaps[50];
		Houses housesCustomMaps[50];

	private:
		/**
		 * Set a single tile.
		 */
		void setTile(uint16_t x, uint16_t y, uint8_t z, Tile* newTile);
		void setTile(const Position &pos, Tile* newTile) {
			setTile(pos.x, pos.y, pos.z, newTile);
		}

		SpectatorCache spectatorCache;
		SpectatorCache playersSpectatorCache;

		std::string monsterfile;
		std::string housefile;
		std::string npcfile;

		uint32_t width = 0;
		uint32_t height = 0;

		// Actually scans the map for spectators
		void getSpectatorsInternal(SpectatorHashSet &spectators, const Position &centerPos, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY, int32_t minRangeZ, int32_t maxRangeZ, bool onlyPlayers) const;

		friend class Game;
		friend class IOMap;
		friend class MapCache;
};

#endif // SRC_MAP_MAP_H_
