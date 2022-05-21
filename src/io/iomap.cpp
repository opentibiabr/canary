/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "io/iomap.h"

#include "items/bed.h"
#include "game/movement/teleport.h"

/*
	OTBM_ROOTV1
	|
	|--- OTBM_MAP_DATA
	|	|
	|	|--- OTBM_TILE_AREA
	|	|	|--- OTBM_TILE
	|	|	|--- OTBM_TILE_SQUARE (not implemented)
	|	|	|--- OTBM_TILE_REF (not implemented)
	|	|	|--- OTBM_HOUSETILE
	|	|
	|	|--- OTBM_SPAWNS (not implemented)
	|	|	|--- OTBM_SPAWN_AREA (not implemented)
	|	|	|--- OTBM_MONSTER (not implemented)
	|	|
	|	|--- OTBM_TOWNS
	|	|	|--- OTBM_TOWN
	|	|
	|	|--- OTBM_WAYPOINTS
	|		|--- OTBM_WAYPOINT
	|
	|--- OTBM_ITEM_DEF (not implemented)
*/

Tile* IOMap::createTile(Item*& ground, Item* item, uint16_t x, uint16_t y, uint8_t z)
{
	if (!ground) {
		return new StaticTile(x, y, z);
	}

	Tile *tile;
	if ((item && item->isBlocking()) || ground->isBlocking()) {
		tile = new StaticTile(x, y, z);
	} else {
		tile = new DynamicTile(x, y, z);
	}

	tile->internalAddThing(ground);
	ground->startDecaying();
	ground = nullptr;
	return tile;
}

bool IOMap::loadMap(Map* map, NodeFileReadHandle& mapFile, const std::string& fileName)
{
	int64_t start = OTSYS_TIME();
	std::shared_ptr<BinaryNode> binaryNodeRoot = mapFile.getRootNode();
	if (!binaryNodeRoot) {
		SPDLOG_ERROR("[IOMap::loadMap] - Could not read map root node");
		return false;
	}

	// Skip type byte (uint8_t), this is outdated
	if (!binaryNodeRoot->skip(1)) {
		SPDLOG_ERROR("[IOMap::loadMap] - Could not skip type byte");
		return false;
	}
	// Skip onde uint32_t from the map version (deprecated before protobuf)
	if (!binaryNodeRoot->skip(4)) {
		SPDLOG_ERROR("[IOMap::loadMap] - Could not skip map version byte");
		return false;
	}

	uint16_t mapWidth = binaryNodeRoot->getU16();
	uint16_t mapHeigth = binaryNodeRoot->getU16();
	// Sanity check, if there is a problem loading the byte then we will know where it is
	if (mapWidth == 0 || mapHeigth == 0) {
		SPDLOG_ERROR("[IOMap::loadMap] - Cannot read map width or map weight");
		return false;
	}

	map->width = mapWidth;
	map->height = mapHeigth;
	SPDLOG_INFO("Map size: {}x{}", map->width, map->height);
	// Skip two U32 from otb version major and minor (outdated before implementation of protobuf)
	if (!binaryNodeRoot->skip(4)) {
		SPDLOG_ERROR("[IOMap::loadMap] - Could not skip otb major and minor version byte");
		return false;
	}

	// This get node of "OTBM_MAP_DATA"
	std::shared_ptr<BinaryNode> binaryNodeMapData = binaryNodeRoot->getChild();
	// Parsing map data attributes information (monster, npc, house, etc)
	if (!parseMapDataAttributes(binaryNodeMapData, *map, fileName)) {
		return false;
	}

	for (std::shared_ptr<BinaryNode> binaryNodeMapTileArea = binaryNodeMapData->getChild();
	binaryNodeMapTileArea != nullptr; binaryNodeMapTileArea = binaryNodeMapTileArea->advance())
	{
		const uint8_t mapDataType = binaryNodeMapTileArea->getU8();
		if (mapDataType == OTBM_TILE_AREA) {
			if (!parseTileArea(binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else if (mapDataType == OTBM_TOWNS) {
			if (!parseTowns(binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else if (mapDataType == OTBM_WAYPOINTS) {
			if (!parseWaypoints(binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else {
			SPDLOG_ERROR("[IOMap::loadMap] - Unknown map data node");
			continue;
		}
	}

	SPDLOG_INFO("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
	return true;
}

bool IOMap::parseMapDataAttributes(std::shared_ptr<BinaryNode> binaryNodeMapData, Map& map, const std::string& fileName)
{
	if (binaryNodeMapData->getU8() != OTBM_MAP_DATA) {
		SPDLOG_ERROR("[IOMap::parseMapDataAttributes] - Could not read root data node");
		return false;
	}

	while (binaryNodeMapData->canRead()) {
		const uint8_t attribute = binaryNodeMapData->getU8();
		std::string mapDataString = binaryNodeMapData->getString();
		switch (attribute) {
			case OTBM_ATTR_DESCRIPTION:
				break;
			case OTBM_ATTR_EXT_SPAWN_MONSTER_FILE:
				map.monsterfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.monsterfile += mapDataString;
				break;
			case OTBM_ATTR_EXT_HOUSE_FILE:
				map.housefile = fileName.substr(0, fileName.rfind('/') + 1);
				map.housefile += mapDataString;
				break;
			case OTBM_ATTR_EXT_SPAWN_NPC_FILE:
				map.npcfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.npcfile += mapDataString;
				break;
			default:
				SPDLOG_ERROR("[IOMap::parseMapDataAttributes] - Could not get map data node. Invalid map data attribute: {}", attribute);
				return false;
		}
	}
	return true;
}

bool IOMap::parseTileArea(std::shared_ptr<BinaryNode> binaryNodeMapData, Map& map)
{
	Position baseMapPosition;
	baseMapPosition.x = binaryNodeMapData->getU16();
	baseMapPosition.y = binaryNodeMapData->getU16();
	baseMapPosition.z = binaryNodeMapData->getU8();

	static std::map<Position, Position> teleportMap;
	for (std::shared_ptr<BinaryNode> binaryNodeMapTile = binaryNodeMapData->getChild();
	binaryNodeMapTile != nullptr; binaryNodeMapTile = binaryNodeMapTile->advance()) {
		const uint8_t type = binaryNodeMapTile->getU8();
		if (type == 0) {
			SPDLOG_ERROR("[IOMap::parseTileArea] - Invalid node tile with type {}", type);
			break;
		}

		Position tilePosition;
		tilePosition.x = baseMapPosition.x + binaryNodeMapTile->getU8();
		tilePosition.y = baseMapPosition.y + binaryNodeMapTile->getU8();
		tilePosition.z = baseMapPosition.z;

		bool isHouseTile = false;
		House *house = nullptr;
		Tile *tile = nullptr;
		Item *groundItem = nullptr;
		uint32_t tileflags = TILESTATE_NONE;

		// Parsing houses load and creation
		if (type == OTBM_HOUSETILE) {
			const uint32_t houseId = binaryNodeMapTile->getU32();
			house = map.houses.addHouse(houseId);
			if (!house) {
				SPDLOG_ERROR("[IOMap::parseTileArea] - Could not create house id: {}, on position: {}", houseId, tilePosition.toString());
				continue;
			}

			tile = new HouseTile(tilePosition.x, tilePosition.y, tilePosition.z, house);
			house->addTile(static_cast<HouseTile*>(tile));
			isHouseTile = true;
		}

		while (binaryNodeMapTile->canRead()) {
			const uint8_t tileAttr = binaryNodeMapTile->getU8();
			switch (tileAttr) {
			case OTBM_ATTR_TILE_FLAGS:
			{
				const uint32_t flags = binaryNodeMapTile->getU32();
				if ((flags & OTBM_TILEFLAG_PROTECTIONZONE) != 0) {
					tileflags |= TILESTATE_PROTECTIONZONE;
				} else if ((flags & OTBM_TILEFLAG_NOPVPZONE) != 0) {
					tileflags |= TILESTATE_NOPVPZONE;
				} else if ((flags & OTBM_TILEFLAG_PVPZONE) != 0) {
					tileflags |= TILESTATE_PVPZONE;
				}

				if ((tileflags & OTBM_TILEFLAG_NOLOGOUT) != 0) {
					tileflags |= TILESTATE_NOLOGOUT;
				}
				break;
			}
			case OTBM_ATTR_ITEM:
			{
				Item* item = Item::createMapItem(*binaryNodeMapTile);
				if (!item) {
					SPDLOG_ERROR("[IOMap::parseTileArea] - Failed to create item on position: {}", tilePosition.toString());
					continue;
				}

				if (const Teleport* teleport = item->getTeleport()) {
					// Teleport position / teleport destination
					teleportMap.emplace(tilePosition, teleport->getDestination());
					if (teleportMap.contains(teleport->getDestination())) {
						SPDLOG_WARN("[IOMap::parseTileArea] - "
									"Teleport in position: {} "
									"is leading to another teleport", tilePosition.toString());
						continue;
					}
					for (auto const& [mapTeleportPosition, mapDestinationPosition] : teleportMap) {
						if (mapDestinationPosition == tilePosition) {
							SPDLOG_WARN("IOMap::parseTileArea] - "
										"Teleport in position: {} "
										"is leading to another teleport",
										mapDestinationPosition.toString());
							continue;
						}
					}
				}

				if (isHouseTile && item->isMoveable()) {
					SPDLOG_WARN("[IOMap::parseTileArea] - "
								"Moveable item with ID: {}, in house: {}, "
								"at position: {}, discarding item",
								item->getID(), house->getId(), tilePosition.toString());
					delete item;
					continue;
				}

				// Check if is house items
				if (tile) {
					tile->internalAddThing(0, item);
					item->startDecaying();
					item->setLoadedFromMap(true);
				} else if (item->isGroundTile()) {
					delete groundItem;
					groundItem = item;
				} else {
					// Creating walls and others blocking items
					tile = createTile(groundItem, item, tilePosition.x, tilePosition.y, tilePosition.z);
					tile->internalAddThing(item);
					item->startDecaying();
					item->setLoadedFromMap(true);
				}
				break;
			}
			default:
				SPDLOG_ERROR("[[IOMap::parseTileArea] - Invalid tile attribute: {}, at position: {}", tileAttr, tilePosition.toString());
				return false;
			}
		}

		for (std::shared_ptr<BinaryNode> nodeItem = binaryNodeMapTile->getChild(); nodeItem != nullptr; nodeItem = nodeItem->advance()) {
			if (nodeItem->getU8() != OTBM_ITEM) {
				SPDLOG_ERROR("[[IOMap::parseTileArea] - Unknown item node with type {}, at position {}", type, tilePosition.toString());
				continue;
			}

			Item* item = Item::createMapItem(*nodeItem);
			if (!item) {
				SPDLOG_ERROR("[[IOMap::parseTileArea] - Failed to create item on position {}", tilePosition.toString());
				continue;;
			}

			if (!item->unserializeMapItem(*nodeItem, tilePosition)) {
				SPDLOG_ERROR("[[IOMap::parseTileArea] - Failed to load item with id: {}, on position {}", item->getID(), tilePosition.toString());
				delete item;
				continue;
			}

			if (isHouseTile && item->isMoveable()) {
				SPDLOG_WARN("[IOMap::parseTileArea] - "
							"Moveable item with ID: {}, in house: {}, "
							"at position: {}, discarding item",
							item->getID(), house->getId(), tilePosition.toString());
				delete item;
				continue;
			}

			if (tile) {
				tile->internalAddThing(item);
				item->startDecaying();
				item->setLoadedFromMap(true);
			} else if (item->isGroundTile()) {
				delete groundItem;
				groundItem = item;
			} else {
				tile = createTile(groundItem, item, tilePosition.x, tilePosition.y, tilePosition.z);
				tile->internalAddThing(item);
				item->startDecaying();
				item->setLoadedFromMap(true);
			}
		}

		if (!tile) {
			tile = createTile(groundItem, nullptr, tilePosition.x, tilePosition.y, tilePosition.z);
		}

		// Sanity check, it will probably never happen, but it doesn't hurt to put this
		if (!tile) {
			SPDLOG_ERROR("[IOMap::parseTileArea] - Tile is nullptr");
			continue;
		}

		tile->setFlag(static_cast<TileFlags_t>(tileflags));
		map.setTile(tilePosition, tile);
	}
	return true;
}

// Parse towns information data
bool IOMap::parseTowns(std::shared_ptr<BinaryNode> binaryNodeMapData, Map& map)
{
	Town *town = nullptr;
	for (std::shared_ptr<BinaryNode> binaryNodeTown = binaryNodeMapData->getChild();
	binaryNodeTown != nullptr; binaryNodeTown = binaryNodeTown->advance())
	{
		if (binaryNodeTown->getU8() != OTBM_TOWN) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Invalid town node");
			continue;
		}

		// Sanity check, if the town id is wrong then we know where the problem is
		const uint32_t townId = binaryNodeTown->getU32();
		if (townId == 0) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Invalid town id");
			continue;
		}

		town = map.towns.getTown(townId);
		if(town) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Duplicate town with id: {}, discarding town", townId);
			continue;
		}

		// Creating new town variable to avoid use of "new"
		town = new Town(townId);
		if(!map.towns.addTown(townId, town)) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Cannot create town with id: {}, discarding town", townId);
			delete town;
			continue;
		}

		// Sanity check, if the string is empty then we know where the problem is
		const std::string townName = binaryNodeTown->getString();
		if (townName.empty()) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Could not read town name");
			continue;
		}
		town->setName(townName);

		uint16_t positionX = binaryNodeTown->getU16();
		uint16_t positionY = binaryNodeTown->getU16();
		uint8_t positionZ = binaryNodeTown->getU8();
		// Sanity check, if there is an error in the get, we will know where the problem is
		if(positionX == 0 || positionY == 0 || positionZ == 0) {
			SPDLOG_ERROR("[IOMap::parseTowns] - Invalid town position");
			continue;
		}

		town->setTemplePos(Position(positionX, positionY, positionZ));
	}
	return true;
}

// Parse waypoints information data
bool IOMap::parseWaypoints(std::shared_ptr<BinaryNode> binaryNodeMapData, Map& map)
{
	for(std::shared_ptr<BinaryNode> binaryNodeWaypoint = binaryNodeMapData->getChild();
	binaryNodeWaypoint != nullptr; binaryNodeWaypoint = binaryNodeWaypoint->advance())
	{
		if (binaryNodeWaypoint->getU8() != OTBM_WAYPOINT) {
			SPDLOG_ERROR("[IOMap::parseWaypoints] - Invalid waypoint node");
			continue;
		}

		// Sanity check, if the string is empty then we know where the problem is
		const std::string waypointName = binaryNodeWaypoint->getString();
		if (waypointName.empty()) {
			SPDLOG_ERROR("[IOMap::parseWaypoints] - Could not read waypoint name");
			continue;
		}

		uint16_t positionX = binaryNodeWaypoint->getU16();
		uint16_t positionY = binaryNodeWaypoint->getU16();
		uint8_t positionZ = binaryNodeWaypoint->getU8();
		// Sanity check, if there is an error in the get, we will know where the problem is
		if(positionX == 0 || positionY == 0 || positionZ == 0) {
			SPDLOG_ERROR("[IOMap::parseWaypoints] - Invalid waypoint position");
			continue;
		}

		map.waypoints[waypointName] = Position(positionX, positionY, positionZ);
	}
	return true;
}
