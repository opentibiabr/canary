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

	Tile* tile;
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
	BinaryNode* binaryNodeRoot = mapFile.getRootNode();
	if (!binaryNodeRoot) {
		setLastErrorString("Could not read map root node");
		return false;
	}

	// Skip type byte (uint8_t), this is outdated
	binaryNodeRoot->skip(1);
	// Skip onde uint32_t from the map version (deprecated before protobuf)
	binaryNodeRoot->skip(4);

	map->width = binaryNodeRoot->getU16();
	map->height = binaryNodeRoot->getU16();
	SPDLOG_INFO("Map size: {}x{}", map->width, map->height);
	// Skip two U32 from otb version major and minor (outdated before implementation of protobuf)
	binaryNodeRoot->skip(4);

	// This get node of "OTBM_MAP_DATA"
	BinaryNode* binaryNodeMapData = binaryNodeRoot->getChild();
	// Parsing map data attributes information (monster, npc, house, etc)
	if (!parseMapDataAttributes(*binaryNodeMapData, *map, fileName)) {
		return false;
	}

	for (BinaryNode *binaryNodeMapTileArea = binaryNodeMapData->getChild();
	binaryNodeMapTileArea != nullptr; binaryNodeMapTileArea = binaryNodeMapTileArea->advance())
	{
		const uint8_t mapDataType = binaryNodeMapTileArea->getU8();
		if (mapDataType == OTBM_TILE_AREA) {
			if (!parseTileArea(*binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else if (mapDataType == OTBM_TOWNS) {
			if (!parseTowns(*binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else if (mapDataType == OTBM_WAYPOINTS) {
			if (!parseWaypoints(*binaryNodeMapTileArea, *map)) {
				continue;
			}
		} else {
			setLastErrorString("Unknown map data node");
			continue;
		}
	}

	SPDLOG_INFO("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
	return true;
}

bool IOMap::parseMapDataAttributes(BinaryNode &binaryNodeMapData, Map& map, const std::string& fileName)
{
	if (binaryNodeMapData.getU8() != OTBM_MAP_DATA) {
		setLastErrorString("Could not read root data node, type");
		return false;
	}

	while (binaryNodeMapData.canRead()) {
		const uint8_t attribute = binaryNodeMapData.getU8();
		std::string mapDataString = binaryNodeMapData.getString();
		switch (attribute) {
			case OTBM_ATTR_DESCRIPTION:
				//map.setDescription(mapDataString);
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
				std::ostringstream string;
				string << "Could not get map data node. Invalid map data attribute: " << attribute;
				setLastErrorString(string.str());
				return false;
		}
	}
	return true;
}

bool IOMap::parseTileArea(BinaryNode &binaryNodeMapData, Map& map)
{
	Position basePos;
	basePos.x = binaryNodeMapData.getU16();
	basePos.y = binaryNodeMapData.getU16();
	basePos.z = binaryNodeMapData.getU8();

	static std::map<Position, Position> teleportMap;
	for (BinaryNode *binaryTreeMapTile = binaryNodeMapData.getChild();
	binaryTreeMapTile != nullptr; binaryTreeMapTile = binaryTreeMapTile->advance()) {
		const uint8_t type = binaryTreeMapTile->getU8();
		if (unlikely(type != OTBM_TILE && type != OTBM_HOUSETILE)) {
			std::ostringstream string;
			string << "Invalid node tile node with type " << type;
			setLastErrorString(string.str());
			continue;
		}

		Position position;
		position.x = basePos.x + binaryTreeMapTile->getU8();
		position.y = basePos.y + binaryTreeMapTile->getU8();
		position.z = basePos.z;

		bool isHouseTile = false;
		House* house = nullptr;
		Tile* tile = nullptr;
		Item* ground_item = nullptr;
		uint32_t tileflags = TILESTATE_NONE;

		if (type == OTBM_HOUSETILE) {
			const uint32_t houseId = binaryTreeMapTile->getU32();
			house = map.houses.addHouse(houseId);
			if (!house) {
				std::ostringstream ss;
				ss << "[" << position << "] Could not create house id: " << houseId;
				setLastErrorString(ss.str());
				continue;
			}

			tile = new HouseTile(position.x, position.y, position.z, house);
			house->addTile(static_cast<HouseTile*>(tile));
			isHouseTile = true;
		}

		while (binaryTreeMapTile->canRead()) {
			const uint8_t tileAttr = binaryTreeMapTile->getU8();
			switch (tileAttr) {
			case OTBM_ATTR_TILE_FLAGS:
			{
				const uint32_t flags = binaryTreeMapTile->getU32();
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
				Item* item = Item::createMapItem(*binaryTreeMapTile);
				if (!item) {
					std::ostringstream ss;
					ss << "Failed to create item on position {" << position << "}";
					setLastErrorString(ss.str());
					continue;
				}

				if (const Teleport* teleport = item->getTeleport()) {
					const Position& destPos = teleport->getDestPos();
					Position teleportPosition = position;
					Position destinationPosition = destPos;
					teleportMap.emplace(teleportPosition, destinationPosition);
					auto it = teleportMap.find(destinationPosition);
					if (it != teleportMap.end()) {
						SPDLOG_WARN("[IOMap::loadMap] - "
									"Teleport in position: {} "
									"is leading to another teleport", position.toString());
						continue;
					}
					for (auto const& [mapTeleportPosition, mapDestinationPosition] : teleportMap) {
						if (mapDestinationPosition == teleportPosition) {
							SPDLOG_WARN("[IOMap::loadMap] - "
										"Teleport in position: {} "
										"is leading to another teleport",
										mapDestinationPosition.toString());
							continue;
						}
					}
				}

				if (isHouseTile && item->isMoveable()) {
					SPDLOG_WARN("[IOMap::loadMap] - "
								"Moveable item with ID: {}, in house: {}, "
								"at position: {}, discarding item",
								item->getID(), house->getId(), position.toString());
					delete item;
				} else {
					if (tile) {
						tile->internalAddThing(item);
						item->startDecaying();
						item->setLoadedFromMap(true);
					} else if (item->isGroundTile()) {
						delete ground_item;
						ground_item = item;
					} else {
						tile = createTile(ground_item, item, position.x, position.y, position.z);
						tile->internalAddThing(item);
						item->startDecaying();
						item->setLoadedFromMap(true);
					}
				}
				break;
			}
			default:
				std::ostringstream string;
				string << "Invalid tile attribute "<< static_cast<int>(tileAttr) << ", at position {" << position << "}";
				setLastErrorString(string.str());
				return false;
			}
		}

		for (BinaryNode *nodeItem = binaryTreeMapTile->getChild(); nodeItem != nullptr; nodeItem = nodeItem->advance()) {
			if (unlikely(nodeItem->getU8() != OTBM_ITEM)) {
				std::ostringstream ss;
				ss << "Unknown item node with type: "<< type << ", at position: {" << position << "}";
				setLastErrorString(ss.str());
				continue;
			}

			Item* item = Item::createMapItem(*nodeItem);
			if (!item) {
				std::ostringstream ss;
				ss << "Failed to create item on position: {" << position << "}";
				setLastErrorString(ss.str());
				continue;;
			}

			if (!item->unserializeMapItem(*nodeItem, position)) {
				std::ostringstream ss;
				ss << "[" << position << "] Failed to load item with id " << item->getID() << '.';
				setLastErrorString(ss.str());
				delete item;
				continue;
			}

			if (isHouseTile && item->isMoveable()) {
				SPDLOG_WARN("[IOMap::loadMap] - "
							"Moveable item with ID: {}, in house: {}, "
							"at position: {}, discarding item",
							item->getID(), house->getId(), position.toString());
				delete item;
				continue;
			} else {
				if (tile) {
					tile->internalAddThing(item);
					item->startDecaying();
					item->setLoadedFromMap(true);
				} else if (item->isGroundTile()) {
					delete ground_item;
					ground_item = item;
				} else {
					tile = createTile(ground_item, item, position.x, position.y, position.z);
					tile->internalAddThing(item);
					item->startDecaying();
					item->setLoadedFromMap(true);
				}
			}
		}

		if (!tile) {
			tile = createTile(ground_item, nullptr, position.x, position.y, position.z);
		}

		tile->setFlag(static_cast<TileFlags_t>(tileflags));

		map.setTile(position.x, position.y, position.z, tile);
	}
	return true;
}

bool IOMap::parseTowns(BinaryNode &binaryNodeMapData, Map& map)
{
	Town *town = nullptr;
	for (BinaryNode *binaryNodeTown = binaryNodeMapData.getChild();
	binaryNodeTown != nullptr; binaryNodeTown = binaryNodeTown->advance())
	{
		if (binaryNodeTown->getU8() != OTBM_TOWN) {
			setLastErrorString("Invalid town node");
			continue;
		}

		const uint32_t townId = binaryNodeTown->getU32();
		town = map.towns.getTown(townId);
		if(town) {
			std::ostringstream string;
			string << "Duplicate town id: " << townId << ", discarding town";
			setLastErrorString(string.str());
			continue;
		}
		town = new Town(townId);
		if(!map.towns.addTown(townId, town)) {
			std::ostringstream string;
			string << "Cannot create town with id: " << townId << ", discarding town";
			setLastErrorString(string.str());
			delete town;
			continue;
		}

		const std::string townName = binaryNodeTown->getString();
		if (townName.empty()) {
			setLastErrorString("Could not read town name.");
			continue;
		}
		town->setName(townName);

		uint16_t positionX = binaryNodeTown->getU16();
		uint16_t positionY = binaryNodeTown->getU16();
		uint8_t positionZ = binaryNodeTown->getU8();
		if(!positionX || !positionY || !positionZ) {
			setLastErrorString("Invalid town position");
			continue;
		}

		Position townPosition;
		townPosition.x = positionX;
		townPosition.y = positionY;
		townPosition.z = positionZ;

		town->setTemplePos(townPosition);
	}
	return true;
}

bool IOMap::parseWaypoints(BinaryNode &binaryNodeMapData, Map& map)
{
	for(BinaryNode* binaryNodeWaypoint = binaryNodeMapData.getChild();
	binaryNodeWaypoint != nullptr; binaryNodeWaypoint = binaryNodeWaypoint->advance())
	{
		if (binaryNodeWaypoint->getU8() != OTBM_WAYPOINT) {
			setLastErrorString("Invalid waypoint node");
			continue;
		}

		const std::string waypointName = binaryNodeWaypoint->getString();
		if (waypointName.empty()) {
			setLastErrorString("Could not read waypoint name.");
			continue;
		}

		uint16_t positionX = binaryNodeWaypoint->getU16();
		uint16_t positionY = binaryNodeWaypoint->getU16();
		uint8_t positionZ = binaryNodeWaypoint->getU8();
		if(!positionX || !positionY || !positionZ) {
			setLastErrorString("Invalid waypoint position");
			continue;
		}

		Position waypointPosition;
		waypointPosition.x = positionX;
		waypointPosition.y = positionY;
		waypointPosition.z = positionZ;

		map.waypoints[waypointName] = waypointPosition;
	}
	return true;
}
