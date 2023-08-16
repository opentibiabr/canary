/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map.h"
#include "utils/astarnodes.h"

#include <io/iomap.h>
#include <io/iomapserialize.h>
#include <creatures/combat/combat.h>
#include <creatures/creature.h>
#include <game/game.h>
#include <creatures/monsters/monster.h>

bool Map::load(const std::string &identifier, const Position &pos, bool unload) {
	try {
		IOMap::loadMap(this, identifier, pos, unload);
		return true;
	} catch (const IOMapException &e) {
		g_logger().error("[Map::load] - {}", e.what());
	} catch (const std::exception &) {
		g_logger().error("[Map::load] - The map in folder {} is missing or corrupted", identifier);
	}
	return false;
}

bool Map::loadMap(const std::string &identifier, bool mainMap /*= false*/, bool loadHouses /*= false*/, bool loadMonsters /*= false*/, bool loadNpcs /*= false*/, const Position &pos /*= Position()*/, bool unload /*= false*/) {
	// Only download map if is loading the main map and it is not already downloaded
	if (mainMap && g_configManager().getBoolean(TOGGLE_DOWNLOAD_MAP) && !std::filesystem::exists(identifier)) {
		const auto mapDownloadUrl = g_configManager().getString(MAP_DOWNLOAD_URL);
		if (mapDownloadUrl.empty()) {
			g_logger().warn("Map download URL in config.lua is empty, download disabled");
		}

		if (CURL* curl = curl_easy_init(); curl && !mapDownloadUrl.empty()) {
			g_logger().info("Downloading " + g_configManager().getString(MAP_NAME) + ".otbm to world folder");
			FILE* otbm = fopen(identifier.c_str(), "wb");
			curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
			curl_easy_setopt(curl, CURLOPT_URL, mapDownloadUrl.c_str());
			curl_easy_setopt(curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_TLSv1_2);
			curl_easy_setopt(curl, CURLOPT_WRITEDATA, otbm);
			curl_easy_perform(curl);
			curl_easy_cleanup(curl);
			fclose(otbm);
		}
	}

	// Load the map
	load(identifier, pos, unload);

	// Only create items from lua functions if is loading main map
	// It needs to be after the load map to ensure the map already exists before creating the items
	if (mainMap) {
		// Create items from lua scripts per position
		// Example: ActionFunctions::luaActionPosition
		g_game().createLuaItemsOnMap();
	}

	if (loadMonsters) {
		if (!IOMap::loadMonsters(this)) {
			g_logger().warn("Failed to load spawn data");
		}
	}

	if (loadHouses) {
		if (!IOMap::loadHouses(this)) {
			g_logger().warn("Failed to load house data");
		}

		/**
		 * Only load houses items if map custom load is disabled
		 * If map custom is enabled, then it is load in loadMapCustom function
		 * NOTE: This will ensure that the information is not duplicated
		 */
		if (!g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
			IOMapSerialize::loadHouseInfo();
			IOMapSerialize::loadHouseItems(this);
		}
	}

	if (loadNpcs) {
		if (!IOMap::loadNpcs(this)) {
			g_logger().warn("Failed to load npc spawn data");
		}
	}

	// Files need to be cleaned up if custom map is enabled to open, or will try to load main map files
	if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
		monsterfile.clear();
		housefile.clear();
		npcfile.clear();
	}
	return true;
}

bool Map::loadMapCustom(const std::string &mapName, bool loadHouses, bool loadMonsters, bool loadNpcs, int customMapIndex) {
	// Load the map
	std::string path = g_configManager().getString(DATA_DIRECTORY) + "/world/custom/" + mapName + ".otbm";
	load(path, Position(0, 0, 0), true);
	load(path);

	if (loadMonsters) {
		if (!IOMap::loadMonstersCustom(this, mapName, customMapIndex)) {
			g_logger().warn("Failed to load monster custom data");
		}
	}

	if (loadHouses) {
		if (!IOMap::loadHousesCustom(this, mapName, customMapIndex)) {
			g_logger().warn("Failed to load house custom data");
		}
	}

	if (loadNpcs) {
		if (!IOMap::loadNpcsCustom(this, mapName, customMapIndex)) {
			g_logger().warn("Failed to load npc custom spawn data");
		}
	}

	// Files need to be cleaned up or will try to load previous map files again
	monsterfile.clear();
	housefile.clear();
	npcfile.clear();
	return true;
}

void Map::loadHouseInfo() {
	IOMapSerialize::loadHouseInfo();
	IOMapSerialize::loadHouseItems(this);
}

bool Map::save() {
	bool saved = false;
	for (uint32_t tries = 0; tries < 6; tries++) {
		if (IOMapSerialize::saveHouseInfo()) {
			saved = true;
		}
		if (saved && IOMapSerialize::saveHouseItems()) {
			return true;
		}
	}
	return false;
}

Tile* Map::getOrCreateTile(uint16_t x, uint16_t y, uint8_t z, bool isDynamic) {
	auto tile = getTile(x, y, z);
	if (!tile) {
		if (isDynamic)
			tile = new DynamicTile(x, y, z);
		else
			tile = new StaticTile(x, y, z);

		setTile(x, y, z, tile);
	}

	return tile;
}

Tile* Map::getTile(uint16_t x, uint16_t y, uint8_t z) {
	if (z >= MAP_MAX_LAYERS)
		return nullptr;

	const auto leaf = getQTNode(x, y);
	if (!leaf)
		return nullptr;

	const auto &floor = leaf->getFloor(z);
	if (!floor)
		return nullptr;

	const auto tile = floor->getTile(x, y);
	return tile ? tile : getOrCreateTileFromCache(floor, x, y);
}

void Map::setTile(uint16_t x, uint16_t y, uint8_t z, Tile* newTile) {
	if (z >= MAP_MAX_LAYERS) {
		g_logger().error("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	root.getBestLeaf(x, y, 15)->createFloor(z)->setTile(x, y, newTile);
}

bool Map::placeCreature(const Position &centerPos, Creature* creature, bool extendedPos /* = false*/, bool forceLogin /* = false*/) {
	Monster* monster = creature->getMonster();
	if (monster) {
		monster->ignoreFieldDamage = true;
	}

	bool foundTile;
	bool placeInPZ;

	Tile* tile = getTile(centerPos.x, centerPos.y, centerPos.z);
	if (tile) {
		placeInPZ = tile->hasFlag(TILESTATE_PROTECTIONZONE);
		ReturnValue ret = tile->queryAdd(0, *creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE);
		foundTile = forceLogin || ret == RETURNVALUE_NOERROR || ret == RETURNVALUE_PLAYERISNOTINVITED;
		if (monster) {
			monster->ignoreFieldDamage = false;
		}
	} else {
		placeInPZ = false;
		foundTile = false;
	}

	if (!foundTile) {
		static std::vector<std::pair<int32_t, int32_t>> extendedRelList {
			{ 0, -2 },
			{ -1, -1 },
			{ 0, -1 },
			{ 1, -1 },
			{ -2, 0 },
			{ -1, 0 },
			{ 1, 0 },
			{ 2, 0 },
			{ -1, 1 },
			{ 0, 1 },
			{ 1, 1 },
			{ 0, 2 }
		};

		static std::vector<std::pair<int32_t, int32_t>> normalRelList {
			{ -1, -1 }, { 0, -1 }, { 1, -1 }, { -1, 0 }, { 1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 }
		};

		std::vector<std::pair<int32_t, int32_t>> &relList = (extendedPos ? extendedRelList : normalRelList);

		if (extendedPos) {
			std::shuffle(relList.begin(), relList.begin() + 4, getRandomGenerator());
			std::shuffle(relList.begin() + 4, relList.end(), getRandomGenerator());
		} else {
			std::shuffle(relList.begin(), relList.end(), getRandomGenerator());
		}

		for (const auto &it : relList) {
			Position tryPos(centerPos.x + it.first, centerPos.y + it.second, centerPos.z);

			tile = getTile(tryPos.x, tryPos.y, tryPos.z);
			if (!tile || (placeInPZ && !tile->hasFlag(TILESTATE_PROTECTIONZONE))) {
				continue;
			}

			// Will never add the creature inside a teleport, avoiding infinite loop bug
			if (tile->hasFlag(TILESTATE_TELEPORT)) {
				continue;
			}

			if (monster) {
				monster->ignoreFieldDamage = true;
			}

			if (tile->queryAdd(0, *creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE) == RETURNVALUE_NOERROR) {
				if (!extendedPos || isSightClear(centerPos, tryPos, false)) {
					foundTile = true;
					break;
				}
			}
		}

		if (!foundTile) {
			return false;
		} else {
			if (monster) {
				monster->ignoreFieldDamage = false;
			}
		}
	}

	int32_t index = 0;
	uint32_t flags = 0;
	Item* toItem = nullptr;

	Cylinder* toCylinder = tile->queryDestination(index, *creature, &toItem, flags);
	toCylinder->internalAddThing(creature);

	const Position &dest = toCylinder->getPosition();
	getQTNode(dest.x, dest.y)->addCreature(creature);
	return true;
}

void Map::moveCreature(Creature &creature, Tile &newTile, bool forceTeleport /* = false*/) {
	Tile &oldTile = *creature.getTile();

	Position oldPos = oldTile.getPosition();
	Position newPos = newTile.getPosition();

	bool teleport = forceTeleport || !newTile.getGround() || !Position::areInRange<1, 1, 0>(oldPos, newPos);

	SpectatorHashSet spectators;
	getSpectators(spectators, oldPos, true);
	getSpectators(spectators, newPos, true);

	std::vector<int32_t> oldStackPosVector;
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			if (tmpPlayer->canSeeCreature(&creature)) {
				oldStackPosVector.push_back(oldTile.getClientIndexOfCreature(tmpPlayer, &creature));
			} else {
				oldStackPosVector.push_back(-1);
			}
		}
	}

	// remove the creature
	oldTile.removeThing(&creature, 0);

	auto leaf = getQTNode(oldPos.x, oldPos.y);
	auto new_leaf = getQTNode(newPos.x, newPos.y);

	// Switch the node ownership
	if (leaf != new_leaf) {
		leaf->removeCreature(&creature);
		new_leaf->addCreature(&creature);
	}

	// add the creature
	newTile.addThing(&creature);

	if (!teleport) {
		if (oldPos.y > newPos.y) {
			creature.setDirection(DIRECTION_NORTH);
		} else if (oldPos.y < newPos.y) {
			creature.setDirection(DIRECTION_SOUTH);
		}

		if (oldPos.x < newPos.x) {
			creature.setDirection(DIRECTION_EAST);
		} else if (oldPos.x > newPos.x) {
			creature.setDirection(DIRECTION_WEST);
		}
	}

	// send to client
	size_t i = 0;
	for (Creature* spectator : spectators) {
		if (Player* tmpPlayer = spectator->getPlayer()) {
			// Use the correct stackpos
			int32_t stackpos = oldStackPosVector[i++];
			if (stackpos != -1) {
				tmpPlayer->sendCreatureMove(&creature, newPos, newTile.getStackposOfCreature(tmpPlayer, &creature), oldPos, stackpos, teleport);
			}
		}
	}

	// event method
	for (Creature* spectator : spectators) {
		spectator->onCreatureMove(&creature, &newTile, newPos, &oldTile, oldPos, teleport);
	}

	oldTile.postRemoveNotification(&creature, &newTile, 0);
	newTile.postAddNotification(&creature, &oldTile, 0);
}

void Map::getSpectatorsInternal(SpectatorHashSet &spectators, const Position &centerPos, int32_t minRangeX, int32_t maxRangeX, int32_t minRangeY, int32_t maxRangeY, int32_t minRangeZ, int32_t maxRangeZ, bool onlyPlayers) const {
	int_fast32_t min_y = centerPos.y + minRangeY;
	int_fast32_t min_x = centerPos.x + minRangeX;
	int_fast32_t max_y = centerPos.y + maxRangeY;
	int_fast32_t max_x = centerPos.x + maxRangeX;

	int32_t minoffset = centerPos.getZ() - maxRangeZ;
	uint16_t x1 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (min_x + minoffset)));
	uint16_t y1 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (min_y + minoffset)));

	int32_t maxoffset = centerPos.getZ() - minRangeZ;
	uint16_t x2 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (max_x + maxoffset)));
	uint16_t y2 = std::min<uint32_t>(0xFFFF, std::max<int32_t>(0, (max_y + maxoffset)));

	int32_t startx1 = x1 - (x1 % FLOOR_SIZE);
	int32_t starty1 = y1 - (y1 % FLOOR_SIZE);
	int32_t endx2 = x2 - (x2 % FLOOR_SIZE);
	int32_t endy2 = y2 - (y2 % FLOOR_SIZE);

	const auto startLeaf = QTreeNode<Floor>::getLeafStatic<const QTreeLeafNode<Floor>*, const QTreeNode<Floor>*>(&root, startx1, starty1);
	const QTreeLeafNode<Floor>* leafS = startLeaf;
	const QTreeLeafNode<Floor>* leafE;

	for (int_fast32_t ny = starty1; ny <= endy2; ny += FLOOR_SIZE) {
		leafE = leafS;
		for (int_fast32_t nx = startx1; nx <= endx2; nx += FLOOR_SIZE) {
			if (leafE) {
				const auto &node_list = (onlyPlayers ? leafE->player_list : leafE->creature_list);
				for (Creature* creature : node_list) {
					const Position &cpos = creature->getPosition();
					if (minRangeZ > cpos.z || maxRangeZ < cpos.z) {
						continue;
					}

					int_fast16_t offsetZ = Position::getOffsetZ(centerPos, cpos);
					if ((min_y + offsetZ) > cpos.y || (max_y + offsetZ) < cpos.y || (min_x + offsetZ) > cpos.x || (max_x + offsetZ) < cpos.x) {
						continue;
					}

					spectators.insert(creature);
				}
				leafE = leafE->leafE;
			} else {
				leafE = QTreeNode<Floor>::getLeafStatic<const QTreeLeafNode<Floor>*, const QTreeNode<Floor>*>(&root, nx + FLOOR_SIZE, ny);
			}
		}

		if (leafS) {
			leafS = leafS->leafS;
		} else {
			leafS = QTreeNode<Floor>::getLeafStatic<const QTreeLeafNode<Floor>*, const QTreeNode<Floor>*>(&root, startx1, ny + FLOOR_SIZE);
		}
	}
}

void Map::getSpectators(SpectatorHashSet &spectators, const Position &centerPos, bool multifloor /*= false*/, bool onlyPlayers /*= false*/, int32_t minRangeX /*= 0*/, int32_t maxRangeX /*= 0*/, int32_t minRangeY /*= 0*/, int32_t maxRangeY /*= 0*/) {
	if (centerPos.z >= MAP_MAX_LAYERS) {
		return;
	}

	bool foundCache = false;
	bool cacheResult = false;

	minRangeX = (minRangeX == 0 ? -MAP_MAX_VIEW_PORT_X : -minRangeX);
	maxRangeX = (maxRangeX == 0 ? MAP_MAX_VIEW_PORT_X : maxRangeX);
	minRangeY = (minRangeY == 0 ? -MAP_MAX_VIEW_PORT_Y : -minRangeY);
	maxRangeY = (maxRangeY == 0 ? MAP_MAX_VIEW_PORT_Y : maxRangeY);

	if (minRangeX == -MAP_MAX_VIEW_PORT_X && maxRangeX == MAP_MAX_VIEW_PORT_X && minRangeY == -MAP_MAX_VIEW_PORT_Y && maxRangeY == MAP_MAX_VIEW_PORT_Y && multifloor) {
		if (onlyPlayers) {
			auto it = playersSpectatorCache.find(centerPos);
			if (it != playersSpectatorCache.end()) {
				if (!spectators.empty()) {
					const SpectatorHashSet &cachedSpectators = it->second;
					spectators.insert(cachedSpectators.begin(), cachedSpectators.end());
				} else {
					spectators = it->second;
				}

				foundCache = true;
			}
		}

		if (!foundCache) {
			auto it = spectatorCache.find(centerPos);
			if (it != spectatorCache.end()) {
				if (!onlyPlayers) {
					if (!spectators.empty()) {
						const SpectatorHashSet &cachedSpectators = it->second;
						spectators.insert(cachedSpectators.begin(), cachedSpectators.end());
					} else {
						spectators = it->second;
					}
				} else {
					const SpectatorHashSet &cachedSpectators = it->second;
					for (Creature* spectator : cachedSpectators) {
						if (spectator->getPlayer()) {
							spectators.insert(spectator);
						}
					}
				}

				foundCache = true;
			} else {
				cacheResult = true;
			}
		}
	}

	if (!foundCache) {
		int32_t minRangeZ;
		int32_t maxRangeZ;

		if (multifloor) {
			if (centerPos.z > MAP_INIT_SURFACE_LAYER) {
				// underground

				// 8->15
				minRangeZ = std::max<int32_t>(centerPos.getZ() - MAP_LAYER_VIEW_LIMIT, 0);
				maxRangeZ = std::min<int32_t>(centerPos.getZ() + MAP_LAYER_VIEW_LIMIT, MAP_MAX_LAYERS - 1);
			} else if (centerPos.z == MAP_INIT_SURFACE_LAYER - 1) {
				minRangeZ = 0;
				maxRangeZ = (MAP_INIT_SURFACE_LAYER - 1) + MAP_LAYER_VIEW_LIMIT;
			} else if (centerPos.z == MAP_INIT_SURFACE_LAYER) {
				minRangeZ = 0;
				maxRangeZ = MAP_INIT_SURFACE_LAYER + MAP_LAYER_VIEW_LIMIT;
			} else {
				minRangeZ = 0;
				maxRangeZ = MAP_INIT_SURFACE_LAYER;
			}
		} else {
			minRangeZ = centerPos.z;
			maxRangeZ = centerPos.z;
		}

		getSpectatorsInternal(spectators, centerPos, minRangeX, maxRangeX, minRangeY, maxRangeY, minRangeZ, maxRangeZ, onlyPlayers);

		if (cacheResult) {
			if (onlyPlayers) {
				playersSpectatorCache[centerPos] = spectators;
			} else {
				spectatorCache[centerPos] = spectators;
			}
		}
	}
}

void Map::clearSpectatorCache() {
	spectatorCache.clear();
	playersSpectatorCache.clear();
}

bool Map::canThrowObjectTo(const Position &fromPos, const Position &toPos, bool checkLineOfSight /*= true*/, int32_t rangex /*= MAP_MAX_CLIENT_VIEW_PORT_X*/, int32_t rangey /*= MAP_MAX_CLIENT_VIEW_PORT_Y*/) {
	// z checks
	// underground 8->15
	// ground level and above 7->0
	if ((fromPos.z >= 8 && toPos.z <= MAP_INIT_SURFACE_LAYER) || (toPos.z >= MAP_INIT_SURFACE_LAYER + 1 && fromPos.z <= MAP_INIT_SURFACE_LAYER)) {
		return false;
	}

	int32_t deltaz = Position::getDistanceZ(fromPos, toPos);
	if (deltaz > MAP_LAYER_VIEW_LIMIT) {
		return false;
	}

	if ((Position::getDistanceX(fromPos, toPos) - deltaz) > rangex) {
		return false;
	}

	// distance checks
	if ((Position::getDistanceY(fromPos, toPos) - deltaz) > rangey) {
		return false;
	}

	if (!checkLineOfSight) {
		return true;
	}
	return isSightClear(fromPos, toPos, false);
}

bool Map::checkSightLine(const Position &fromPos, const Position &toPos) {
	if (fromPos == toPos) {
		return true;
	}

	Position start(fromPos.z > toPos.z ? toPos : fromPos);
	Position destination(fromPos.z > toPos.z ? fromPos : toPos);

	const int8_t mx = start.x < destination.x ? 1 : start.x == destination.x ? 0
																			 : -1;
	const int8_t my = start.y < destination.y ? 1 : start.y == destination.y ? 0
																			 : -1;

	int32_t A = Position::getOffsetY(destination, start);
	int32_t B = Position::getOffsetX(start, destination);
	int32_t C = -(A * destination.x + B * destination.y);

	while (start.x != destination.x || start.y != destination.y) {
		int32_t move_hor = std::abs(A * (start.x + mx) + B * (start.y) + C);
		int32_t move_ver = std::abs(A * (start.x) + B * (start.y + my) + C);
		int32_t move_cross = std::abs(A * (start.x + mx) + B * (start.y + my) + C);

		if (start.y != destination.y && (start.x == destination.x || move_hor > move_ver || move_hor > move_cross)) {
			start.y += my;
		}

		if (start.x != destination.x && (start.y == destination.y || move_ver > move_hor || move_ver > move_cross)) {
			start.x += mx;
		}

		const Tile* tile = getTile(start.x, start.y, start.z);
		if (tile && tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
			return false;
		}
	}

	// now we need to perform a jump between floors to see if everything is clear (literally)
	while (start.z != destination.z) {
		const Tile* tile = getTile(start.x, start.y, start.z);
		if (tile && tile->getThingCount() > 0) {
			return false;
		}

		start.z++;
	}

	return true;
}

bool Map::isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck) {
	if (floorCheck && fromPos.z != toPos.z) {
		return false;
	}

	// Cast two converging rays and see if either yields a result.
	return checkSightLine(fromPos, toPos) || checkSightLine(toPos, fromPos);
}

const Tile* Map::canWalkTo(const Creature &creature, const Position &pos) {
	int32_t walkCache = creature.getWalkCache(pos);
	if (walkCache == 0) {
		return nullptr;
	} else if (walkCache == 1) {
		return getTile(pos.x, pos.y, pos.z);
	}

	// used for non-cached tiles
	Tile* tile = getTile(pos.x, pos.y, pos.z);
	if (creature.getTile() != tile) {
		if (!tile || tile->queryAdd(0, creature, 1, FLAG_PATHFINDING | FLAG_IGNOREFIELDDAMAGE) != RETURNVALUE_NOERROR) {
			return nullptr;
		}
	}
	return tile;
}

bool Map::getPathMatching(const Creature &creature, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
	Position pos = creature.getPosition();
	Position endPos;

	AStarNodes nodes(pos.x, pos.y);

	int32_t bestMatch = 0;

	static int_fast32_t dirNeighbors[8][5][2] = {
		{ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { 0, -1 }, { -1, -1 }, { -1, 1 } },
		{ { -1, 0 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 } },
		{ { 0, 1 }, { 1, 0 }, { 0, -1 }, { 1, -1 }, { 1, 1 } },
		{ { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 } },
		{ { -1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { -1, 1 } },
		{ { 0, 1 }, { 1, 0 }, { 1, -1 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
	};
	static int_fast32_t allNeighbors[8][2] = {
		{ -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 }
	};

	const Position startPos = pos;

	AStarNode* found = nullptr;
	while (fpp.maxSearchDist != 0 || nodes.getClosedNodes() < 100) {
		AStarNode* n = nodes.getBestNode();
		if (!n) {
			if (found) {
				break;
			}
			return false;
		}

		const int_fast32_t x = n->x;
		const int_fast32_t y = n->y;
		pos.x = x;
		pos.y = y;
		if (pathCondition(startPos, pos, fpp, bestMatch)) {
			found = n;
			endPos = pos;
			if (bestMatch == 0) {
				break;
			}
		}

		uint_fast32_t dirCount;
		int_fast32_t* neighbors;
		if (n->parent) {
			const int_fast32_t offset_x = n->parent->x - x;
			const int_fast32_t offset_y = n->parent->y - y;
			if (offset_y == 0) {
				if (offset_x == -1) {
					neighbors = *dirNeighbors[DIRECTION_WEST];
				} else {
					neighbors = *dirNeighbors[DIRECTION_EAST];
				}
			} else if (!fpp.allowDiagonal || offset_x == 0) {
				if (offset_y == -1) {
					neighbors = *dirNeighbors[DIRECTION_NORTH];
				} else {
					neighbors = *dirNeighbors[DIRECTION_SOUTH];
				}
			} else if (offset_y == -1) {
				if (offset_x == -1) {
					neighbors = *dirNeighbors[DIRECTION_NORTHWEST];
				} else {
					neighbors = *dirNeighbors[DIRECTION_NORTHEAST];
				}
			} else if (offset_x == -1) {
				neighbors = *dirNeighbors[DIRECTION_SOUTHWEST];
			} else {
				neighbors = *dirNeighbors[DIRECTION_SOUTHEAST];
			}
			dirCount = fpp.allowDiagonal ? 5 : 3;
		} else {
			dirCount = 8;
			neighbors = *allNeighbors;
		}

		const int_fast32_t f = n->f;
		for (uint_fast32_t i = 0; i < dirCount; ++i) {
			pos.x = x + *neighbors++;
			pos.y = y + *neighbors++;

			if (fpp.maxSearchDist != 0 && (Position::getDistanceX(startPos, pos) > fpp.maxSearchDist || Position::getDistanceY(startPos, pos) > fpp.maxSearchDist)) {
				continue;
			}

			if (fpp.keepDistance && !pathCondition.isInRange(startPos, pos, fpp)) {
				continue;
			}

			const Tile* tile;
			AStarNode* neighborNode = nodes.getNodeByPosition(pos.x, pos.y);
			if (neighborNode) {
				tile = getTile(pos.x, pos.y, pos.z);
			} else {
				tile = canWalkTo(creature, pos);
				if (!tile) {
					continue;
				}
			}

			// The cost (g) for this neighbor
			const int_fast32_t cost = AStarNodes::getMapWalkCost(n, pos);
			const int_fast32_t extraCost = AStarNodes::getTileWalkCost(creature, tile);
			const int_fast32_t newf = f + cost + extraCost;

			if (neighborNode) {
				if (neighborNode->f <= newf) {
					// The node on the closed/open list is cheaper than this one
					continue;
				}

				neighborNode->f = newf;
				neighborNode->parent = n;
				nodes.openNode(neighborNode);
			} else {
				// Does not exist in the open/closed list, create a new node
				neighborNode = nodes.createOpenNode(n, pos.x, pos.y, newf);
				if (!neighborNode) {
					if (found) {
						break;
					}
					return false;
				}
			}
		}

		nodes.closeNode(n);
	}

	if (!found) {
		return false;
	}

	int_fast32_t prevx = endPos.x;
	int_fast32_t prevy = endPos.y;

	found = found->parent;
	while (found) {
		pos.x = found->x;
		pos.y = found->y;

		int_fast32_t dx = pos.getX() - prevx;
		int_fast32_t dy = pos.getY() - prevy;

		prevx = pos.x;
		prevy = pos.y;

		if (dx == 1 && dy == 1) {
			dirList.push_front(DIRECTION_NORTHWEST);
		} else if (dx == -1 && dy == 1) {
			dirList.push_front(DIRECTION_NORTHEAST);
		} else if (dx == 1 && dy == -1) {
			dirList.push_front(DIRECTION_SOUTHWEST);
		} else if (dx == -1 && dy == -1) {
			dirList.push_front(DIRECTION_SOUTHEAST);
		} else if (dx == 1) {
			dirList.push_front(DIRECTION_WEST);
		} else if (dx == -1) {
			dirList.push_front(DIRECTION_EAST);
		} else if (dy == 1) {
			dirList.push_front(DIRECTION_NORTH);
		} else if (dy == -1) {
			dirList.push_front(DIRECTION_SOUTH);
		}

		found = found->parent;
	}
	return true;
}

bool Map::getPathMatching(const Position &start, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
	Position pos = start;
	Position endPos;

	AStarNodes nodes(pos.x, pos.y);

	int32_t bestMatch = 0;

	static int_fast32_t dirNeighbors[8][5][2] = {
		{ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { 0, -1 }, { -1, -1 }, { -1, 1 } },
		{ { -1, 0 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 } },
		{ { 0, 1 }, { 1, 0 }, { 0, -1 }, { 1, -1 }, { 1, 1 } },
		{ { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 } },
		{ { -1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { -1, 1 } },
		{ { 0, 1 }, { 1, 0 }, { 1, -1 }, { 1, 1 }, { -1, 1 } },
		{ { -1, 0 }, { 0, 1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
	};
	static int_fast32_t allNeighbors[8][2] = {
		{ -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 }
	};

	const Position startPos = pos;

	AStarNode* found = nullptr;
	while (fpp.maxSearchDist != 0 || nodes.getClosedNodes() < 100) {
		AStarNode* n = nodes.getBestNode();
		if (!n) {
			if (found) {
				break;
			}
			return false;
		}

		const int_fast32_t x = n->x;
		const int_fast32_t y = n->y;
		pos.x = x;
		pos.y = y;
		if (pathCondition(startPos, pos, fpp, bestMatch)) {
			found = n;
			endPos = pos;
			if (bestMatch == 0) {
				break;
			}
		}

		uint_fast32_t dirCount;
		int_fast32_t* neighbors;
		if (n->parent) {
			const int_fast32_t offset_x = n->parent->x - x;
			const int_fast32_t offset_y = n->parent->y - y;
			if (offset_y == 0) {
				if (offset_x == -1) {
					neighbors = *dirNeighbors[DIRECTION_WEST];
				} else {
					neighbors = *dirNeighbors[DIRECTION_EAST];
				}
			} else if (!fpp.allowDiagonal || offset_x == 0) {
				if (offset_y == -1) {
					neighbors = *dirNeighbors[DIRECTION_NORTH];
				} else {
					neighbors = *dirNeighbors[DIRECTION_SOUTH];
				}
			} else if (offset_y == -1) {
				if (offset_x == -1) {
					neighbors = *dirNeighbors[DIRECTION_NORTHWEST];
				} else {
					neighbors = *dirNeighbors[DIRECTION_NORTHEAST];
				}
			} else if (offset_x == -1) {
				neighbors = *dirNeighbors[DIRECTION_SOUTHWEST];
			} else {
				neighbors = *dirNeighbors[DIRECTION_SOUTHEAST];
			}
			dirCount = fpp.allowDiagonal ? 5 : 3;
		} else {
			dirCount = 8;
			neighbors = *allNeighbors;
		}

		const int_fast32_t f = n->f;
		for (uint_fast32_t i = 0; i < dirCount; ++i) {
			pos.x = x + *neighbors++;
			pos.y = y + *neighbors++;

			if (fpp.maxSearchDist != 0 && (Position::getDistanceX(startPos, pos) > fpp.maxSearchDist || Position::getDistanceY(startPos, pos) > fpp.maxSearchDist)) {
				continue;
			}

			if (fpp.keepDistance && !pathCondition.isInRange(startPos, pos, fpp)) {
				continue;
			}

			const Tile* tile;
			AStarNode* neighborNode = nodes.getNodeByPosition(pos.x, pos.y);
			if (neighborNode) {
				tile = getTile(pos.x, pos.y, pos.z);
			} else {
				tile = getTile(pos.x, pos.y, pos.z);
				if (!tile || tile->hasFlag(TILESTATE_BLOCKSOLID)) {
					continue;
				}
			}

			// The cost (g) for this neighbor
			const int_fast32_t cost = AStarNodes::getMapWalkCost(n, pos, true);
			const int_fast32_t extraCost = 0;
			const int_fast32_t newf = f + cost + extraCost;

			if (neighborNode) {
				if (neighborNode->f <= newf) {
					// The node on the closed/open list is cheaper than this one
					continue;
				}

				neighborNode->f = newf;
				neighborNode->parent = n;
				nodes.openNode(neighborNode);
			} else {
				// Does not exist in the open/closed list, create a new node
				neighborNode = nodes.createOpenNode(n, pos.x, pos.y, newf);
				if (!neighborNode) {
					if (found) {
						break;
					}
					return false;
				}
			}
		}

		nodes.closeNode(n);
	}

	if (!found) {
		return false;
	}

	int_fast32_t prevx = endPos.x;
	int_fast32_t prevy = endPos.y;

	found = found->parent;
	while (found) {
		pos.x = found->x;
		pos.y = found->y;

		int_fast32_t dx = pos.getX() - prevx;
		int_fast32_t dy = pos.getY() - prevy;

		prevx = pos.x;
		prevy = pos.y;

		if (dx == 1 && dy == 1) {
			dirList.push_front(DIRECTION_NORTHWEST);
		} else if (dx == -1 && dy == 1) {
			dirList.push_front(DIRECTION_NORTHEAST);
		} else if (dx == 1 && dy == -1) {
			dirList.push_front(DIRECTION_SOUTHWEST);
		} else if (dx == -1 && dy == -1) {
			dirList.push_front(DIRECTION_SOUTHEAST);
		} else if (dx == 1) {
			dirList.push_front(DIRECTION_WEST);
		} else if (dx == -1) {
			dirList.push_front(DIRECTION_EAST);
		} else if (dy == 1) {
			dirList.push_front(DIRECTION_NORTH);
		} else if (dy == -1) {
			dirList.push_front(DIRECTION_SOUTH);
		}

		found = found->parent;
	}
	return true;
}

// AStarNodes

AStarNodes::AStarNodes(uint32_t x, uint32_t y) :
	nodes(), openNodes() {
	curNode = 1;
	closedNodes = 0;
	openNodes[0] = true;

	AStarNode &startNode = nodes[0];
	startNode.parent = nullptr;
	startNode.x = x;
	startNode.y = y;
	startNode.f = 0;
	nodeTable[(x << 16) | y] = nodes;
}

AStarNode* AStarNodes::createOpenNode(AStarNode* parent, uint32_t x, uint32_t y, int_fast32_t f) {
	if (curNode >= MAX_NODES) {
		return nullptr;
	}

	size_t retNode = curNode++;
	openNodes[retNode] = true;

	AStarNode* node = nodes + retNode;
	nodeTable[(x << 16) | y] = node;
	node->parent = parent;
	node->x = x;
	node->y = y;
	node->f = f;
	return node;
}

AStarNode* AStarNodes::getBestNode() {
	if (curNode == 0) {
		return nullptr;
	}

	int32_t best_node_f = std::numeric_limits<int32_t>::max();
	int32_t best_node = -1;
	for (size_t i = 0; i < curNode; i++) {
		if (openNodes[i] && nodes[i].f < best_node_f) {
			best_node_f = nodes[i].f;
			best_node = i;
		}
	}

	if (best_node >= 0) {
		return nodes + best_node;
	}
	return nullptr;
}

void AStarNodes::closeNode(AStarNode* node) {
	size_t index = node - nodes;
	assert(index < MAX_NODES);
	openNodes[index] = false;
	++closedNodes;
}

void AStarNodes::openNode(AStarNode* node) {
	size_t index = node - nodes;
	assert(index < MAX_NODES);
	if (!openNodes[index]) {
		openNodes[index] = true;
		--closedNodes;
	}
}

int_fast32_t AStarNodes::getClosedNodes() const {
	return closedNodes;
}

AStarNode* AStarNodes::getNodeByPosition(uint32_t x, uint32_t y) {
	auto it = nodeTable.find((x << 16) | y);
	if (it == nodeTable.end()) {
		return nullptr;
	}
	return it->second;
}

int_fast32_t AStarNodes::getMapWalkCost(AStarNode* node, const Position &neighborPos, bool preferDiagonal) {
	if (std::abs(node->x - neighborPos.x) == std::abs(node->y - neighborPos.y)) {
		// diagonal movement extra cost
		if (preferDiagonal)
			return MAP_PREFERDIAGONALWALKCOST;
		else
			return MAP_DIAGONALWALKCOST;
	}
	return MAP_NORMALWALKCOST;
}

int_fast32_t AStarNodes::getTileWalkCost(const Creature &creature, const Tile* tile) {
	int_fast32_t cost = 0;
	if (tile->getTopVisibleCreature(&creature) != nullptr) {
		// destroy creature cost
		cost += MAP_NORMALWALKCOST * 3;
	}

	if (const MagicField* field = tile->getFieldItem()) {
		CombatType_t combatType = field->getCombatType();
		const Monster* monster = creature.getMonster();
		if (!creature.isImmune(combatType) && !creature.hasCondition(Combat::DamageToConditionType(combatType)) && (monster && !monster->canWalkOnFieldType(combatType))) {
			cost += MAP_NORMALWALKCOST * 18;
		}
		/**
		 * Make player try to avoid magic fields, when calculating pathing
		 */
		const Player* player = creature.getPlayer();
		if (player && !field->isBlocking() && field->getDamage() != 0) {
			cost += MAP_NORMALWALKCOST * 18;
		}
	}
	return cost;
}

uint32_t Map::clean() {
	uint64_t start = OTSYS_TIME();
	size_t tiles = 0;

	if (g_game().getGameState() == GAME_STATE_NORMAL) {
		g_game().setGameState(GAME_STATE_MAINTAIN);
	}

	std::vector<Item*> toRemove;
	for (auto tile : g_game().getTilesToClean()) {
		if (!tile) {
			continue;
		}
		if (auto items = tile->getItemList()) {
			++tiles;
			for (auto item : *items) {
				if (item->isCleanable()) {
					toRemove.emplace_back(item);
				}
			}
		}
	}

	for (auto item : toRemove) {
		g_game().internalRemoveItem(item, -1);
	}

	size_t count = toRemove.size();
	g_game().clearTilesToClean();

	if (g_game().getGameState() == GAME_STATE_MAINTAIN) {
		g_game().setGameState(GAME_STATE_NORMAL);
	}

	g_logger().info("CLEAN: Removed {} item{} from {} tile{} in {} seconds", count, (count != 1 ? "s" : ""), tiles, (tiles != 1 ? "s" : ""), (OTSYS_TIME() - start) / (1000.f));
	return count;
}
