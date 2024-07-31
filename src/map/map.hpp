/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "mapcache.hpp"
#include "map/town.hpp"
#include "map/house/house.hpp"
#include "creatures/monsters/spawns/spawn_monster.hpp"
#include "creatures/npcs/spawns/spawn_npc.hpp"

class Creature;
class Player;
class Game;
class Tile;
class Map;

struct FindPathParams;

class FrozenPathingConditionCall;

/**
 * Map class.
 * Holds all the actual map-data
 */
class Map : public MapCache {
public:
	uint32_t clean();

	std::filesystem::path getPath() const {
		return path;
	}

	/**
	 * Load a map.
	 * \returns true if the map was loaded successfully
	 */
	void load(const std::string &identifier, const Position &pos = Position());
	/**
	 * Load the main map
	 * \param identifier Is the main map name (name of file .otbm)
	 * \param loadHouses if true, the main map houses is loaded
	 * \param loadMonsters if true, the main map monsters is loaded
	 * \param loadNpcs if true, the main map npcs is loaded
	 * \returns true if the main map was loaded successfully
	 */
	void loadMap(const std::string &identifier, bool mainMap = false, bool loadHouses = false, bool loadMonsters = false, bool loadNpcs = false, bool loadZones = false, const Position &pos = Position());
	/**
	 * Load the custom map
	 * \param identifier Is the map custom folder
	 * \param loadHouses if true, the map custom houses is loaded
	 * \param loadMonsters if true, the map custom monsters is loaded
	 * \param loadNpcs if true, the map custom npcs is loaded
	 * \returns true if the custom map was loaded successfully
	 */
	void loadMapCustom(const std::string &mapName, bool loadHouses, bool loadMonsters, bool loadNpcs, bool loadZones, const int customMapIndex);

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
	std::shared_ptr<Tile> getTile(uint16_t x, uint16_t y, uint8_t z);
	std::shared_ptr<Tile> getTile(const Position &pos) {
		return getTile(pos.x, pos.y, pos.z);
	}

	void refreshZones(uint16_t x, uint16_t y, uint8_t z);
	void refreshZones(const Position &pos) {
		refreshZones(pos.x, pos.y, pos.z);
	}

	std::shared_ptr<Tile> getOrCreateTile(uint16_t x, uint16_t y, uint8_t z, bool isDynamic = false);
	std::shared_ptr<Tile> getOrCreateTile(const Position &pos, bool isDynamic = false) {
		return getOrCreateTile(pos.x, pos.y, pos.z, isDynamic);
	}

	/**
	 * Place a creature on the map
	 * \param centerPos The position to place the creature
	 * \param creature Creature to place on the map
	 * \param extendedPos If true, the creature will in first-hand be placed 2 tiles away
	 * \param forceLogin If true, placing the creature will not fail becase of obstacles (creatures/chests)
	 */
	bool placeCreature(const Position &centerPos, std::shared_ptr<Creature> creature, bool extendedPos = false, bool forceLogin = false);

	void moveCreature(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, bool forceTeleport = false);

	/**
	 * Checks if you can throw an object to that position
	 *	\param fromPos from Source point
	 *	\param toPos Destination point
	 *	\param rangex maximum allowed range horizontially
	 *	\param rangey maximum allowed range vertically
	 *	\param checkLineOfSight checks if there is any blocking objects in the way
	 *	\returns The result if you can throw there or not
	 */
	bool canThrowObjectTo(const Position &fromPos, const Position &toPos, SightLines_t lineOfSight = SightLine_CheckSightLine, int32_t rangex = MAP_MAX_CLIENT_VIEW_PORT_X, int32_t rangey = MAP_MAX_CLIENT_VIEW_PORT_Y);
	/**
	 * Checks if path is clear from fromPos to toPos
	 * Notice: This only checks a straight line if the path is clear, for path finding use getPathTo.
	 *	\param fromPos from Source point
	 *	\param toPos Destination point
	 *	\param floorCheck if true then view is not clear if fromPos.z is not the same as toPos.z
	 *	\returns The result if there is no obstacles
	 */
	bool isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck);
	bool checkSightLine(Position start, Position destination);

	std::shared_ptr<Tile> canWalkTo(const std::shared_ptr<Creature> &creature, const Position &pos);

	bool getPathMatching(const std::shared_ptr<Creature> &creature, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp);
	bool getPathMatching(const std::shared_ptr<Creature> &creature, const Position &targetPos, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp);
	bool getPathMatchingCond(const std::shared_ptr<Creature> &creature, const Position &targetPos, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp);

	bool getPathMatching(const Position &startPos, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
		return getPathMatching(nullptr, startPos, dirList, pathCondition, fpp);
	}

	std::map<std::string, Position> waypoints;

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
	void setTile(uint16_t x, uint16_t y, uint8_t z, std::shared_ptr<Tile> newTile);
	void setTile(const Position &pos, std::shared_ptr<Tile> newTile) {
		setTile(pos.x, pos.y, pos.z, newTile);
	}
	std::shared_ptr<Tile> getLoadedTile(uint16_t x, uint16_t y, uint8_t z);

	std::filesystem::path path;
	std::string monsterfile;
	std::string housefile;
	std::string npcfile;
	std::string zonesfile;

	uint32_t width = 0;
	uint32_t height = 0;

	friend class Game;
	friend class IOMap;
	friend class MapCache;
};
