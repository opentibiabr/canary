/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "io/iomap.h"
#include "io/iomapserialize.h"
#include "creatures/combat/combat.h"
#include "creatures/creature.h"
#include "game/game.h"
#include "creatures/monsters/monster.h"

bool Map::load(const std::string &identifier, const Position &pos, bool unload) {
	try {
		IOMap loader;
		if (!loader.loadMap(this, identifier, pos, unload)) {
			SPDLOG_ERROR("[Map::load] - {}", loader.getLastErrorString());
			return false;
		}
	} catch (const std::exception) {
		SPDLOG_ERROR("[Map::load] - The map in folder {} is missing or corrupted", identifier);
		return false;
	}
	return true;
}

bool Map::loadMap(const std::string &identifier, bool mainMap /*= false*/, bool loadHouses /*= false*/, bool loadMonsters /*= false*/, bool loadNpcs /*= false*/, const Position &pos /*= Position()*/, bool unload /*= false*/) {
	// Only download map if is loading the main map and it is not already downloaded
	if (mainMap && g_configManager().getBoolean(TOGGLE_DOWNLOAD_MAP) && !std::filesystem::exists(identifier)) {
		const auto mapDownloadUrl = g_configManager().getString(MAP_DOWNLOAD_URL);
		if (mapDownloadUrl.empty()) {
			SPDLOG_WARN("Map download URL in config.lua is empty, download disabled");
		}

		if (CURL* curl = curl_easy_init(); curl && !mapDownloadUrl.empty()) {
			SPDLOG_INFO("Downloading " + g_configManager().getString(MAP_NAME) + ".otbm to world folder");
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
	this->load(identifier, pos, unload);

	// Only create items from lua functions if is loading main map
	// It needs to be after the load map to ensure the map already exists before creating the items
	if (mainMap) {
		// Create items from lua scripts per position
		// Example: ActionFunctions::luaActionPosition
		g_game().createLuaItemsOnMap();
	}

	if (loadMonsters) {
		if (!IOMap::loadMonsters(this)) {
			SPDLOG_WARN("Failed to load spawn data");
		}
	}

	if (loadHouses) {
		if (!IOMap::loadHouses(this)) {
			SPDLOG_WARN("Failed to load house data");
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
			SPDLOG_WARN("Failed to load npc spawn data");
		}
	}

	// Files need to be cleaned up if custom map is enabled to open, or will try to load main map files
	if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
		this->monsterfile.clear();
		this->housefile.clear();
		this->npcfile.clear();
	}
	return true;
}

bool Map::loadMapCustom(const std::string &mapName, bool loadHouses, bool loadMonsters, bool loadNpcs, int customMapIndex) {
	// Load the map
	std::string path = g_configManager().getString(DATA_DIRECTORY) + "/world/custom/" + mapName + ".otbm";
	this->load(path, Position(0, 0, 0), true);
	this->load(path);

	if (loadMonsters) {
		if (!IOMap::loadMonstersCustom(this, mapName, customMapIndex)) {
			SPDLOG_WARN("Failed to load monster custom data");
		}
	}

	if (loadHouses) {
		if (!IOMap::loadHousesCustom(this, mapName, customMapIndex)) {
			SPDLOG_WARN("Failed to load house custom data");
		}
	}

	if (loadNpcs) {
		if (!IOMap::loadNpcsCustom(this, mapName, customMapIndex)) {
			SPDLOG_WARN("Failed to load npc custom spawn data");
		}
	}

	// Files need to be cleaned up or will try to load previous map files again
	this->monsterfile.clear();
	this->housefile.clear();
	this->npcfile.clear();
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

Tile* Map::getTile(uint16_t x, uint16_t y, uint8_t z) const {
	if (z >= MAP_MAX_LAYERS) {
		return nullptr;
	}

	const QTreeLeafNode* leaf = QTreeNode::getLeafStatic<const QTreeLeafNode*, const QTreeNode*>(&root, x, y);
	if (!leaf) {
		return nullptr;
	}

	const Floor* floor = leaf->getFloor(z);
	if (!floor) {
		return nullptr;
	}
	return floor->tiles[x & FLOOR_MASK][y & FLOOR_MASK];
}

void Map::setTile(uint16_t x, uint16_t y, uint8_t z, Tile* newTile) {
	if (z >= MAP_MAX_LAYERS) {
		SPDLOG_ERROR("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	QTreeLeafNode::newLeaf = false;
	QTreeLeafNode* leaf = root.createLeaf(x, y, 15);

	if (QTreeLeafNode::newLeaf) {
		// update north
		QTreeLeafNode* northLeaf = root.getLeaf(x, y - FLOOR_SIZE);
		if (northLeaf) {
			northLeaf->leafS = leaf;
		}

		// update west leaf
		QTreeLeafNode* westLeaf = root.getLeaf(x - FLOOR_SIZE, y);
		if (westLeaf) {
			westLeaf->leafE = leaf;
		}

		// update south
		QTreeLeafNode* southLeaf = root.getLeaf(x, y + FLOOR_SIZE);
		if (southLeaf) {
			leaf->leafS = southLeaf;
		}

		// update east
		QTreeLeafNode* eastLeaf = root.getLeaf(x + FLOOR_SIZE, y);
		if (eastLeaf) {
			leaf->leafE = eastLeaf;
		}
	}

	Floor* floor = leaf->createFloor(z);
	uint32_t offsetX = x & FLOOR_MASK;
	uint32_t offsetY = y & FLOOR_MASK;

	Tile*&tile = floor->tiles[offsetX][offsetY];
	if (tile) {
		TileItemVector* items = newTile->getItemList();
		if (items) {
			for (auto it = items->rbegin(), end = items->rend(); it != end; ++it) {
				tile->addThing(*it);
			}
			items->clear();
		}

		Item* ground = newTile->getGround();
		if (ground) {
			tile->addThing(ground);
			newTile->setGround(nullptr);
		}
		delete newTile;
	} else {
		tile = newTile;
	}
}

bool Map::placeCreature(const Position &centerPos, Creature* creature, bool extendedPos /* = false*/, bool forceLogin /* = false*/) {
	auto monster = creature->getMonster();
	if (monster) {
		monster->ignoreFieldDamage = true;
	}

	auto tile = getTile(centerPos.x, centerPos.y, centerPos.z);
	if (!tile) {
		return false;
	}

	auto placeInPZ = tile->hasFlag(TILESTATE_PROTECTIONZONE);
	auto ret = tile->queryAdd(0, *creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE);
	if (forceLogin || ret == RETURNVALUE_NOERROR || ret == RETURNVALUE_PLAYERISNOTINVITED) {
		if (monster) {
			monster->ignoreFieldDamage = false;
		}
	} else {
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

		auto &relList = (extendedPos ? extendedRelList : normalRelList);
		std::shuffle(relList.begin(), relList.end(), getRandomGenerator());

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

			ret = tile->queryAdd(0, *creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE);
			if (ret == RETURNVALUE_NOERROR && (!extendedPos || isSightClear(centerPos, tryPos, false))) {
				break;
			}
		}

		if (monster) {
			monster->ignoreFieldDamage = false;
		}

		if (ret != RETURNVALUE_NOERROR) {
			return false;
		}
	}

	int32_t index = 0;
	uint32_t flags = 0;
	Item* toItem = nullptr;

	auto toCylinder = tile->queryDestination(index, *creature, &toItem, flags);
	toCylinder->internalAddThing(creature);

	const auto &dest = toCylinder->getPosition();
	getQTNode(dest.x, dest.y)->addCreature(creature);
	return true;
}

void Map::moveCreature(Creature &creature, Tile &newTile, bool forceTeleport /* = false*/) {
	Tile &oldTile = *creature.getTile();

	auto &oldPos = oldTile.getPosition();
	auto &newPos = newTile.getPosition();

	auto teleport = forceTeleport || !newTile.getGround() || !Position::areInRange<1, 1, 0>(oldPos, newPos);

	SpectatorHashSet spectators;
	getSpectators(spectators, oldPos, true);
	getSpectators(spectators, newPos, true);

	// Caching positions of spectators
	std::vector<int32_t> oldStackPosVector;
	std::vector<std::pair<Position, int32_t>> spectatorPositions;
	for (auto spectator : spectators) {
		if (auto tmpPlayer = spectator->getPlayer()) {
			if (tmpPlayer->canSeeCreature(&creature)) {
				oldStackPosVector.push_back(oldTile.getClientIndexOfCreature(tmpPlayer, &creature));
			} else {
				oldStackPosVector.push_back(-1);
			}
			spectatorPositions.emplace_back(spectator->getPosition(), oldStackPosVector.back());
		}
	}

	// Remove the creature from the old tile
	oldTile.removeThing(&creature, 0);

	// Switch the node ownership
	auto leaf = getQTNode(oldPos.x, oldPos.y);
	auto new_leaf = getQTNode(newPos.x, newPos.y);

	if (leaf != new_leaf) {
		leaf->removeCreature(&creature);
		new_leaf->addCreature(&creature);
	}

	// Add the creature to the new tile
	newTile.addThing(&creature);

	// Update the direction of the creature
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
	int32_t maxoffset = centerPos.getZ() - minRangeZ;
	uint16_t x1 = std::clamp(static_cast<uint16_t>(min_x + minoffset), static_cast<uint16_t>(0), static_cast<uint16_t>(0xFFFF));
	uint16_t y1 = std::clamp(static_cast<uint16_t>(min_y + minoffset), static_cast<uint16_t>(0), static_cast<uint16_t>(0xFFFF));
	uint16_t x2 = std::clamp(static_cast<uint16_t>(max_x + maxoffset), static_cast<uint16_t>(0), static_cast<uint16_t>(0xFFFF));
	uint16_t y2 = std::clamp(static_cast<uint16_t>(max_y + maxoffset), static_cast<uint16_t>(0), static_cast<uint16_t>(0xFFFF));
	int32_t startx1 = static_cast<int32_t>(x1) - (static_cast<int32_t>(x1) % FLOOR_SIZE);
	int32_t starty1 = static_cast<int32_t>(y1) - (static_cast<int32_t>(y1) % FLOOR_SIZE);
	int32_t endx2 = static_cast<int32_t>(x2) - (static_cast<int32_t>(x2) % FLOOR_SIZE);
	int32_t endy2 = static_cast<int32_t>(y2) - (static_cast<int32_t>(y2) % FLOOR_SIZE);

	const QTreeLeafNode* startLeaf = QTreeNode::getLeafStatic<const QTreeLeafNode*, const QTreeNode*>(&root, startx1, starty1);
	const QTreeLeafNode* leafS = startLeaf;
	const QTreeLeafNode* leafE;

	auto inRange = [&](const Position &pos) {
		int_fast16_t offsetZ = Position::getOffsetZ(centerPos, pos);
		return minRangeZ <= pos.z && pos.z <= maxRangeZ && (min_y + offsetZ) <= pos.y && pos.y <= (max_y + offsetZ) && (min_x + offsetZ) <= pos.x && pos.x <= (max_x + offsetZ);
	};

	auto insertIfInRange = [&](Creature* creature) {
		if (creature != nullptr && inRange(creature->getPosition())) {
			spectators.insert(creature);
		}
	};

	for (int_fast32_t ny = starty1; ny <= endy2; ny += FLOOR_SIZE) {
		leafE = leafS;
		for (int_fast32_t nx = startx1; nx <= endx2; nx += FLOOR_SIZE) {
			if (leafE) {
				const auto &node_list = onlyPlayers ? leafE->player_list : leafE->creature_list;
				std::ranges::for_each(node_list, insertIfInRange);
				leafE = leafE->leafE;
			} else {
				leafE = QTreeNode::getLeafStatic<const QTreeLeafNode*, const QTreeNode*>(&root, nx + FLOOR_SIZE, ny);
			}
		}

		if (leafS) {
			leafS = leafS->leafS;
		} else {
			leafS = QTreeNode::getLeafStatic<const QTreeLeafNode*, const QTreeNode*>(&root, startx1, ny + FLOOR_SIZE);
		}
	}
}

void Map::getSpectators(SpectatorHashSet &spectators, const Position &centerPos, bool multifloor /*= false*/, bool onlyPlayers /*= false*/, int32_t minRangeX /*= 0*/, int32_t maxRangeX /*= 0*/, int32_t minRangeY /*= 0*/, int32_t maxRangeY /*= 0*/) {
	if (centerPos.z >= MAP_MAX_LAYERS) {
		return;
	}

	minRangeX = (minRangeX == 0 ? -maxViewportX : -minRangeX);
	maxRangeX = (maxRangeX == 0 ? maxViewportX : maxRangeX);
	minRangeY = (minRangeY == 0 ? -maxViewportY : -minRangeY);
	maxRangeY = (maxRangeY == 0 ? maxViewportY : maxRangeY);

	int32_t minRangeZ;
	int32_t maxRangeZ;
	if (multifloor) {
		if (centerPos.z > MAP_INIT_SURFACE_LAYER) {
			minRangeZ = std::max(centerPos.z - MAP_LAYER_VIEW_LIMIT, 0);
			maxRangeZ = std::min(centerPos.z + MAP_LAYER_VIEW_LIMIT, MAP_MAX_LAYERS - 1);
		} else {
			maxRangeZ = std::min(MAP_INIT_SURFACE_LAYER + MAP_LAYER_VIEW_LIMIT, MAP_MAX_LAYERS - 1);
		}
	} else {
		minRangeZ = centerPos.z;
		maxRangeZ = centerPos.z;
	}

	SpectatorCache &cache = onlyPlayers ? playersSpectatorCache : spectatorCache;
	auto it = cache.find(centerPos);
	if (it != cache.end()) {
		spectators = it->second;
		if (onlyPlayers) {
			for (auto itSpec = spectators.begin(); itSpec != spectators.end();) {
				if (!(*itSpec)->getPlayer()) {
					itSpec = spectators.erase(itSpec);
				} else {
					++itSpec;
				}
			}
		}
	} else {
		getSpectatorsInternal(spectators, centerPos, minRangeX, maxRangeX, minRangeY, maxRangeY, minRangeZ, maxRangeZ, onlyPlayers);
		cache[centerPos] = spectators;
	}
}

void Map::clearSpectatorCache() {
	spectatorCache.clear();
	playersSpectatorCache.clear();
}

bool Map::canThrowObjectTo(const Position &fromPos, const Position &toPos, bool checkLineOfSight /*= true*/, int32_t rangex /*= Map::maxClientViewportX*/, int32_t rangey /*= Map::maxClientViewportY*/) const {
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

bool Map::checkSightLine(const Position &fromPos, const Position &toPos) const {
	if (fromPos == toPos) {
		return true;
	}

	Position start(std::min(fromPos, toPos));
	Position destination(std::max(fromPos, toPos));

	const int8_t mx = (start.x < destination.x) ? 1 : (start.x == destination.x ? 0 : -1);
	const int8_t my = (start.y < destination.y) ? 1 : (start.y == destination.y ? 0 : -1);

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

	while (start.z != destination.z) {
		const Tile* tile = getTile(start.x, start.y, start.z);
		if (tile && tile->getThingCount() > 0) {
			return false;
		}

		start.z++;
	}

	return true;
}

bool Map::isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck) const {
	if (floorCheck && fromPos.z != toPos.z) {
		return false;
	}

	// Cast two converging rays and see if either yields a result.
	return checkSightLine(fromPos, toPos) || checkSightLine(toPos, fromPos);
}

const Tile* Map::canWalkTo(const Creature &creature, const Position &pos) const {
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

bool Map::getPathMatching(const Creature &creature, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) const {
	try {
		Position start = creature.getPosition();
		return getPathMatching(start, dirList, pathCondition, fpp);
	} catch (const std::invalid_argument &e) {
		SPDLOG_ERROR("Invalid argument in the '[{}]' function: {}", __FUNCTION__, e.what());
		return false;
	} catch (const std::exception &e) {
		SPDLOG_ERROR("An unexpected error occurred in the '[{}]' function: {}", __FUNCTION__, e.what());
		return false;
	}
}

bool Map::getPathMatching(const Position &start, std::forward_list<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) const {
	try {
		Position pos = start;
		Position endPos;

		AStarNodes nodes(pos.x, pos.y);

		int32_t bestMatch = 0;

		static constexpr int_fast32_t dirNeighbors[8][5][2] = {
			{ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 1, 1 }, { -1, 1 } },
			{ { -1, 0 }, { 0, 1 }, { 0, -1 }, { -1, -1 }, { -1, 1 } },
			{ { -1, 0 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 } },
			{ { 0, 1 }, { 1, 0 }, { 0, -1 }, { 1, -1 }, { 1, 1 } },
			{ { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 } },
			{ { -1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { -1, 1 } },
			{ { 0, 1 }, { 1, 0 }, { 1, -1 }, { 1, 1 }, { -1, 1 } },
			{ { -1, 0 }, { 0, 1 }, { -1, -1 }, { 1, 1 }, { -1, 1 } }
		};

		static constexpr int_fast32_t allNeighbors[8][2] = {
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
			const int_fast32_t* neighbors;
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
	} catch (const std::invalid_argument &e) {
		SPDLOG_ERROR("Invalid argument in the '[{}]' function: {}", __FUNCTION__, e.what());
		return false;
	} catch (const std::exception &e) {
		SPDLOG_ERROR("An unexpected error occurred in the '[{}]' function: {}", __FUNCTION__, e.what());
		return false;
	}
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
	std::vector<AStarNode*> bestNodes;

	for (size_t i = 0; i < curNode; i++) {
		if (openNodes[i] && nodes[i].f < best_node_f) {
			best_node_f = nodes[i].f;
			bestNodes.clear();
			bestNodes.push_back(&nodes[i]);
		} else if (openNodes[i] && nodes[i].f == best_node_f) {
			bestNodes.push_back(&nodes[i]);
		}
	}

	if (!bestNodes.empty()) {
		return *std::ranges::min_element(bestNodes.begin(), bestNodes.end(), [](const AStarNode* a, const AStarNode* b) {
			return a->f < b->f;
		});
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
	auto iter = nodeTable.find((x << 16) | y);

	if (iter == nodeTable.end()) {
		return nullptr;
	}

	return iter->second;
}

int_fast32_t AStarNodes::getMapWalkCost(AStarNode* node, const Position &neighborPos, bool preferDiagonal) {
	constexpr int diagonalWalkCost = MAP_DIAGONALWALKCOST;
	constexpr int preferDiagonalWalkCost = MAP_PREFERDIAGONALWALKCOST;
	constexpr int normalWalkCost = MAP_NORMALWALKCOST;

	if (std::abs(node->x - neighborPos.x) == std::abs(node->y - neighborPos.y)) {
		// diagonal movement extra cost
		return preferDiagonal ? preferDiagonalWalkCost : diagonalWalkCost;
	}

	return normalWalkCost;
}

int_fast32_t AStarNodes::getTileWalkCost(const Creature &creature, const Tile* tile) {
	constexpr int destroyCreatureCost = MAP_NORMALWALKCOST * 3;
	constexpr int difficultTerrainCost = MAP_NORMALWALKCOST * 18;

	int_fast32_t cost = 0;

	if (tile->getTopVisibleCreature(&creature) != nullptr) {
		cost += destroyCreatureCost;
	}

	if (const MagicField* field = tile->getFieldItem()) {
		CombatType_t combatType = field->getCombatType();
		const Monster* monster = creature.getMonster();

		if (!creature.isImmune(combatType) && !creature.hasCondition(Combat::DamageToConditionType(combatType)) && (monster && !monster->canWalkOnFieldType(combatType))) {
			cost += difficultTerrainCost;
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

// Floor
Floor::~Floor() {
	for (auto &row : tiles) {
		for (auto tile : row) {
			if (tile) {
				delete tile;
				tile = nullptr;
			}
		}
	}
}

// QTreeNode
QTreeNode::~QTreeNode() {
	for (int i = 0; i < 4; ++i) {
		if (child[i]) {
			delete child[i];
			child[i] = nullptr;
		}
	}
}

QTreeLeafNode* QTreeNode::getLeaf(uint32_t x, uint32_t y) {
	if (leaf) {
		return static_cast<QTreeLeafNode*>(this);
	}

	QTreeNode* node = child[((x & 0x8000) >> 15) | ((y & 0x8000) >> 14)];
	if (!node) {
		return nullptr;
	}
	return node->getLeaf(x << 1, y << 1);
}

QTreeLeafNode* QTreeNode::createLeaf(uint32_t x, uint32_t y, uint32_t level) {
	if (!isLeaf()) {
		uint32_t index = ((x & 0x8000) >> 15) | ((y & 0x8000) >> 14);
		if (!child[index]) {
			if (level != FLOOR_BITS) {
				child[index] = new QTreeNode();
			} else {
				child[index] = new QTreeLeafNode();
				QTreeLeafNode::newLeaf = true;
			}
		}
		return child[index]->createLeaf(x * 2, y * 2, level - 1);
	}
	return static_cast<QTreeLeafNode*>(this);
}

// QTreeLeafNode
bool QTreeLeafNode::newLeaf = false;

QTreeLeafNode::~QTreeLeafNode() {
	for (auto i = 0; i < MAP_MAX_LAYERS; ++i) {
		if (array[i]) {
			delete array[i];
			array[i] = nullptr;
		}
	}
}

Floor* QTreeLeafNode::createFloor(uint32_t z) {
	if (array[z] == nullptr) {
		array[z] = new Floor();
	}
	return array[z];
}

void QTreeLeafNode::addCreature(Creature* c) {
	creature_list.emplace_back(c);

	if (c->getPlayer()) {
		player_list.emplace_back(c);
	}
}

void QTreeLeafNode::removeCreature(Creature* c) {
	auto iter = std::find(creature_list.begin(), creature_list.end(), c);
	assert(iter != creature_list.end());
	*iter = std::move(creature_list.back());
	creature_list.pop_back();

	if (c->getPlayer()) {
		iter = std::find(player_list.begin(), player_list.end(), c);
		assert(iter != player_list.end());
		*iter = std::move(player_list.back());
		player_list.pop_back();
	}
}

uint32_t Map::clean() const {
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

	SPDLOG_INFO("CLEAN: Removed {} item{} from {} tile{} in {} seconds", count, (count != 1 ? "s" : ""), tiles, (tiles != 1 ? "s" : ""), (OTSYS_TIME() - start) / (1000.));
	return count;
}
