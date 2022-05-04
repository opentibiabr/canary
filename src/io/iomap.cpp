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

#include "core/binary_tree.hpp"
#include "core/file_stream.hpp"
#include "core/resource_manager.hpp"

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

bool IOMap::loadMap(Map* map, const std::string& fileName)
{
	try {
		int64_t start = OTSYS_TIME();
		FileStream *fileStream = g_resources().openFile(fileName);
		if (!fileStream) {
			setLastErrorString("Unable to load map");
			SPDLOG_ERROR("Unable to load map '{}'", fileName);
			return false;
		}

		fileStream->cache();

		char identifier[4];
		if (fileStream->read(identifier, 1, 4) < 4) {
			setLastErrorString("Could not read file identifier");
			SPDLOG_ERROR("Could not read file identifier for map: {}", fileName);
			return false;
		}

		if (memcmp(identifier, "OTBM", 4) != 0 && memcmp(identifier, "\0\0\0\0", 4) != 0) {
			setLastErrorString("Invalid file identifier detected");
			SPDLOG_ERROR("Invalid file identifier detected: %s", identifier);
			return false;
		}

		BinaryTree *binaryTreeRoot = fileStream->getBinaryTree();
		if (binaryTreeRoot->getU8()) {
			setLastErrorString("Could not read root property");
			SPDLOG_ERROR("Could not read root property!");
			return false;
		}

		// Skip one u32 from map version (outdated before implementation of protobuf)
		binaryTreeRoot->skip(4);

		SPDLOG_INFO("Map size: {}x{}", binaryTreeRoot->getU16(), binaryTreeRoot->getU16());
		map->width = binaryTreeRoot->getU16();
		map->height = binaryTreeRoot->getU16();

		// Skip two U32 from otb version major and minor (outdated before implementation of protobuf)
		binaryTreeRoot->skip(4);

		BinaryTree *binaryTreeMapData = binaryTreeRoot->getChildren()[0];
		if (!parseMapDataAttributes(*binaryTreeMapData, *map, fileName)) {
			return false;
		}

		for (BinaryTree *binaryTreeMapTileArea : binaryTreeMapData->getChildren()) {
			const uint8_t mapDataType = binaryTreeMapTileArea->getU8();
			if (mapDataType == OTBM_TILE_AREA) {
				if (!parseTileArea(*binaryTreeMapTileArea, *map)) {
					continue;
				}
			} else if (mapDataType == OTBM_TOWNS) {
				if (!parseTowns(*binaryTreeMapTileArea, *map)) {
					continue;
				}
			} else if (mapDataType == OTBM_WAYPOINTS) {
				if (!parseWaypoints(*binaryTreeMapTileArea, *map)) {
					continue;
				}
			} else {
				setLastErrorString("Unknown map data node");
				continue;
			}
		}

		fileStream->close();
		SPDLOG_INFO("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
		return true;
	} catch (std::exception& e) {
		std::ostringstream ss;
		ss << "Failed to load map " << fileName << "], error" << e.what();
		setLastErrorString(ss.str());
		return false;
	}
}

bool IOMap::parseMapDataAttributes(BinaryTree& binaryTreeMapData, Map& map, const std::string& fileName)
{
	if (binaryTreeMapData.getU8() != OTBM_MAP_DATA) {
		setLastErrorString("Could not read root data node");
		return false;
	}

	// OTBM_MAP_DATA node
	while (binaryTreeMapData.canRead()) {
		const uint8_t attribute = binaryTreeMapData.getU8();
		std::string mapDataString = binaryTreeMapData.getString();
		switch (attribute) {
			case OTBM_ATTR_DESCRIPTION:
				map.setDescription(mapDataString);
				break;
			case OTBM_ATTR_EXT_SPAWN_MONSTER_FILE:
				map.setSpawnMonsterFile(fileName.substr(0, fileName.rfind('/') + 1) + mapDataString);
				map.monsterfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.monsterfile += mapDataString;
				break;
			case OTBM_ATTR_EXT_HOUSE_FILE:
				map.setHouseFile(fileName.substr(0, fileName.rfind('/') + 1) + mapDataString);
				map.housefile = fileName.substr(0, fileName.rfind('/') + 1);
				map.housefile += mapDataString;
				break;
			case OTBM_ATTR_EXT_SPAWN_NPC_FILE:
				map.setSpawnNpcFile(fileName.substr(0, fileName.rfind('/') + 1) + mapDataString);
				map.npcfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.npcfile += mapDataString;
				break;
			default:
				setLastErrorString("Invalid map attribute");
				SPDLOG_ERROR("Invalid attribute '{}'", attribute);
				return false;
		}
	}
	return true;
}

bool IOMap::parseTileArea(BinaryTree &binaryTreeMapTileArea, Map& map)
{
	Position basePos;
	basePos.x = binaryTreeMapTileArea.getU16();
	basePos.y = binaryTreeMapTileArea.getU16();
	basePos.z = binaryTreeMapTileArea.getU8();

	static std::map<Position, Position> teleportMap;
	for (BinaryTree *binaryTreeMapTile : binaryTreeMapTileArea.getChildren()) {
		const uint8_t type = binaryTreeMapTile->getU8();
		if (unlikely(type != OTBM_TILE && type != OTBM_HOUSETILE)) {
			setLastErrorString("Invalid node tile type");
			SPDLOG_ERROR("invalid node tile type {}", type);
			continue;
		}

		Position position = basePos + binaryTreeMapTile->getPoint();

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
				return false;
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
					ss << "[" << position << "] Failed to create item.";
					setLastErrorString(ss.str());
					SPDLOG_WARN("[IOMap::loadMap] - {}", ss.str());
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
					}
					for (auto const& [mapTeleportPosition, mapDestinationPosition] : teleportMap) {
						if (mapDestinationPosition == teleportPosition) {
							SPDLOG_WARN("[IOMap::loadMap] - "
										"Teleport in position: {} "
										"is leading to another teleport",
										mapDestinationPosition.toString());
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
				setLastErrorString("Invalid tile attribute");
				SPDLOG_ERROR("invalid tile attribute {} at pos {}", static_cast<int>(tileAttr), basePos.toString());
				return false;
			}
		}

		for (BinaryTree *nodeItem : binaryTreeMapTile->getChildren()) {
			if (unlikely(nodeItem->getU8() != OTBM_ITEM)) {
				std::ostringstream ss;
				ss << "[" << position << "] Unknown node type.";
				setLastErrorString(ss.str());
				SPDLOG_ERROR("invalid item node");
				continue;
			}

			Item* item = Item::createMapItem(*nodeItem);
			if (!item) {
				std::ostringstream ss;
				ss << "[" << position << "] Failed to create item.";
				setLastErrorString(ss.str());
				SPDLOG_WARN("[IOMap::loadMap] - {}", ss.str());
				continue;;
			}
			if (!item->unserializeMapItem(*nodeItem, position)) {
				if (item->getItemCount() == 0) {
					std::ostringstream ss;
					ss << "[" << position << "] Item have count 0, id: " << item->getID() << '.';
					setLastErrorString(ss.str());
					SPDLOG_ERROR("[IOMap::loadMap] - Item have count 0");
					delete item;
					continue;
				}
				std::ostringstream ss;
				ss << "[" << position << "] Failed to load item with id " << item->getID() << '.';
				setLastErrorString(ss.str());
				delete item;
				continue;
			}

			if (isHouseTile && item->isMoveable()) {
				SPDLOG_WARN("[IOMap::loadMap] - "
							"Moveable item with ID: {}, in house: {}, "
							"at position: {}",
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
		}

		if (!tile) {
			tile = createTile(ground_item, nullptr, position.x, position.y, position.z);
		}

		tile->setFlag(static_cast<TileFlags_t>(tileflags));

		map.setTile(position.x, position.y, position.z, tile);
	}
	return true;
}

bool IOMap::parseTowns(BinaryTree &binaryTreeMapTileArea, Map& map)
{
	Town* town = nullptr;
	for (BinaryTree *nodeTown : binaryTreeMapTileArea.getChildren()) {
		if (nodeTown->getU8() != OTBM_TOWN) {
			setLastErrorString("Invalid town node");
			SPDLOG_ERROR("invalid town node.");
			continue;
		}

		const uint32_t townId = nodeTown->getU32();
		town = map.towns.getTown(townId);
		if (!town) {
			town = new Town(townId);
			map.towns.addTown(townId, town);
		}

		const std::string townName = nodeTown->getString();
		if (townName.empty()) {
			setLastErrorString("Could not read town name.");
			continue;
		}

		town->setName(townName);

		Position townCoords;
		townCoords.x = nodeTown->getU16();
		townCoords.y = nodeTown->getU16();
		townCoords.z = nodeTown->getU8();

		town->setTemplePos(Position(townCoords.x, townCoords.y, townCoords.z));
	}
	return true;
}

bool IOMap::parseWaypoints(BinaryTree &binaryTreeMapTileArea, Map& map)
{
	for (BinaryTree *nodeWaypoint : binaryTreeMapTileArea.getChildren()) {
		if (nodeWaypoint->getU8() != OTBM_WAYPOINT) {
			setLastErrorString("Invalid waypoint node");
			SPDLOG_ERROR("invalid waypoint node.");
			continue;
		}

		std::string name = nodeWaypoint->getString();

		Position waypointPos;
		waypointPos.x = nodeWaypoint->getU16();
		waypointPos.y = nodeWaypoint->getU16();
		waypointPos.z = nodeWaypoint->getU8();

		map.waypoints[name] = Position(waypointPos.x, waypointPos.y, waypointPos.z);
	}
	return true;
}
