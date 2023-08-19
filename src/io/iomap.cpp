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
#include "game/movement/teleport.h"
#include "game/game.h"

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

void IOMap::loadMap(Map* map, const std::string &fileName, const Position &pos, bool unload) {
	int64_t start = OTSYS_TIME();
	OTB::Loader loader { fileName, OTB::Identifier { { 'O', 'T', 'B', 'M' } } };
	auto &root = loader.parseTree();

	PropStream propStream;
	if (!loader.getProps(root, propStream))
		throw IOMapException("Could not read root property.");

	OTBM_root_header root_header;
	if (!propStream.read(root_header))
		throw IOMapException("Could not read header.");

	uint32_t headerVersion = root_header.version;
	if (headerVersion <= 0) {
		// In otbm version 1 the count variable after splashes/fluidcontainers and stackables
		// are saved as attributes instead, this solves alot of problems with items
		// that is changed (stackable/charges/fluidcontainer/splash) during an update.
		throw IOMapException("This map need to be upgraded by using the latest map editor version to be able to load correctly.");
	}

	if (headerVersion > 2)
		throw IOMapException("Unknown OTBM version detected.");

	if (root_header.majorVersionItems < 3)
		throw IOMapException("This map need to be upgraded by using the latest map editor version to be able to load correctly.");

	g_logger().info("Map size: {}x{}", root_header.width, root_header.height);
	map->width = root_header.width;
	map->height = root_header.height;

	if (root.children.size() != 1 || root.children.front().type != OTBM_MAP_DATA)
		throw IOMapException("Could not read data node.");

	auto &mapNode = root.children.front();
	parseMapDataAttributes(loader, mapNode, *map, fileName);

	for (auto &mapDataNode : mapNode.children) {
		if (mapDataNode.type == OTBM_TILE_AREA)
			parseTileArea(loader, mapDataNode, *map, pos, unload);
		else if (mapDataNode.type == OTBM_TOWNS) {
			parseTowns(loader, mapDataNode, *map);
		} else if (mapDataNode.type == OTBM_WAYPOINTS && headerVersion > 1) {
			parseWaypoints(loader, mapDataNode, *map);
		} else
			throw IOMapException("Unknown map node.");
	}

	map->flush();

	g_logger().info("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
}

void IOMap::parseMapDataAttributes(OTB::Loader &loader, const OTB::Node &mapNode, Map &map, const std::string &fileName) {
	PropStream propStream;
	if (!loader.getProps(mapNode, propStream))
		throw IOMapException("Could not read map data attributes.");

	std::string mapDescription;
	std::string tmp;

	uint8_t attribute;
	while (propStream.read<uint8_t>(attribute))
		switch (attribute) {
			case OTBM_ATTR_DESCRIPTION:
				if (!propStream.readString(mapDescription))
					throw IOMapException("Invalid description tag.");
				break;

			case OTBM_ATTR_EXT_SPAWN_MONSTER_FILE:
				if (!propStream.readString(tmp))
					throw IOMapException("Invalid monster spawn tag. Make sure you are using the correct version of the map editor.");

				map.monsterfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.monsterfile += tmp;
				break;

			case OTBM_ATTR_EXT_HOUSE_FILE:
				if (!propStream.readString(tmp))
					throw IOMapException("Invalid house tag.");

				map.housefile = fileName.substr(0, fileName.rfind('/') + 1);
				map.housefile += tmp;
				break;

			case OTBM_ATTR_EXT_SPAWN_NPC_FILE:
				if (!propStream.readString(tmp))
					throw IOMapException("Invalid npc spawn tag. Make sure you are using the correct version of the map editor.");

				map.npcfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.npcfile += tmp;
				break;

			default:
				throw IOMapException("Unknown header node.");
		}
}

void IOMap::parseTileArea(OTB::Loader &loader, const OTB::Node &tileAreaNode, Map &map, const Position &pos, bool unload) {
	PropStream propStream;
	if (!loader.getProps(tileAreaNode, propStream))
		throw IOMapException("Invalid map node.");

	OTBM_Destination_coords area_coord;
	if (!propStream.read(area_coord))
		throw IOMapException("Invalid map node.");

	const uint16_t base_x = area_coord.x;
	const uint16_t base_y = area_coord.y;
	const uint16_t base_z = area_coord.z;

	for (auto &tileNode : tileAreaNode.children) {
		if (tileNode.type != OTBM_TILE && tileNode.type != OTBM_HOUSETILE)
			throw IOMapException("Unknown tile node.");

		if (!loader.getProps(tileNode, propStream))
			throw IOMapException("Could not read node data.");

		OTBM_Tile_coords tile_coord;
		if (!propStream.read(tile_coord))
			throw IOMapException("Could not read tile position.");

		const auto &tile = std::make_shared<BasicTile>();

		const uint16_t x = base_x + tile_coord.x + pos.x;
		const uint16_t y = base_y + tile_coord.y + pos.y;
		const uint8_t z = static_cast<uint8_t>(base_z + pos.z);

		uint32_t houseId = 0;
		bool tileIsStatic = false;

		if (tileNode.type == OTBM_HOUSETILE) {
			if (!propStream.read<uint32_t>(houseId))
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not read house id.", x, y, z));

			if (!map.houses.addHouse(houseId))
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not create house id: {}", x, y, z, houseId));

			tile->houseId = houseId;
		}

		uint8_t attribute;
		// read tile attributes
		while (propStream.read<uint8_t>(attribute)) {
			switch (attribute) {
				case OTBM_ATTR_TILE_FLAGS: {
					uint32_t flags;
					if (!propStream.read<uint32_t>(flags))
						throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to read tile flags.", x, y, z));

					if ((flags & OTBM_TILEFLAG_PROTECTIONZONE) != 0) {
						tile->flags |= TILESTATE_PROTECTIONZONE;
					} else if ((flags & OTBM_TILEFLAG_NOPVPZONE) != 0) {
						tile->flags |= TILESTATE_NOPVPZONE;
					} else if ((flags & OTBM_TILEFLAG_PVPZONE) != 0) {
						tile->flags |= TILESTATE_PVPZONE;
					}

					if ((flags & OTBM_TILEFLAG_NOLOGOUT) != 0) {
						tile->flags |= TILESTATE_NOLOGOUT;
					}
				} break;

				case OTBM_ATTR_ITEM: {
					uint16_t id;
					if (!propStream.read<uint16_t>(id))
						throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to create item.", x, y, z));

					const ItemType &iType = Item::items[id];
					if (tile->isHouse() && iType.isBed())
						continue;

					if (iType.blockSolid)
						tileIsStatic = true;

					const auto &item = std::make_shared<BasicItem>();
					item->id = id;

					if (tile->isHouse() && iType.moveable) {
						g_logger().warn("[IOMap::loadMap] - "
										"Moveable item with ID: {}, in house: {}, "
										"at position: x {}, y {}, z {}",
										id, houseId, x, y, z);
					} else if (iType.isGroundTile()) {
						tile->ground = map.tryReplaceItemFromCache(item);
					} else {
						tile->items.emplace_back(map.tryReplaceItemFromCache(item));
					}

					break;
				}

				default:
					throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Unknown tile attribute.", x, y, z));
			}
		}

		for (auto &itemNode : tileNode.children) {
			if (itemNode.type != OTBM_ITEM)
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Unknown node type.", x, y, z));

			PropStream stream;
			if (!loader.getProps(itemNode, stream))
				throw IOMapException("Invalid item node.");

			uint16_t id;
			if (!stream.read<uint16_t>(id))
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to create item.", x, y, z));

			const auto &iType = Item::items[id];
			if (tile->isHouse() && iType.isBed())
				continue;

			if (iType.blockSolid)
				tileIsStatic = true;

			const auto &item = std::make_shared<BasicItem>();
			item->id = id;

			if (!item->unserializeItemNode(loader, itemNode, stream))
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to load item {}.", x, y, z, id));

			if (tile->isHouse() && iType.moveable) {
				g_logger().warn("[IOMap::loadMap] - "
								"Moveable item with ID: {}, in house: {}, "
								"at position: x {}, y {}, z {}",
								id, houseId, x, y, z);
			} else if (iType.isGroundTile()) {
				tile->ground = map.tryReplaceItemFromCache(item);
			} else {
				tile->items.emplace_back(map.tryReplaceItemFromCache(item));
			}
		}

		if (tile->isEmpty())
			continue;

		map.setBasicTile(x, y, z, tile);
	}
}

void IOMap::parseTowns(OTB::Loader &loader, const OTB::Node &townsNode, Map &map) {
	for (auto &townNode : townsNode.children) {
		PropStream propStream;
		if (townNode.type != OTBM_TOWN)
			throw IOMapException("Unknown town node.");

		if (!loader.getProps(townNode, propStream))
			throw IOMapException("Could not read town data.");

		uint32_t townId;
		if (!propStream.read<uint32_t>(townId))
			throw IOMapException("Could not read town id.");

		std::string townName;
		if (!propStream.readString(townName))
			throw IOMapException("Could not read town name.");

		OTBM_Destination_coords town_coords;
		if (!propStream.read(town_coords))
			throw IOMapException("Could not read town coordinates.");

		auto town = map.towns.getOrCreateTown(townId);
		town->setName(townName);
		town->setTemplePos(Position(town_coords.x, town_coords.y, town_coords.z));
	}
}

void IOMap::parseWaypoints(OTB::Loader &loader, const OTB::Node &waypointsNode, Map &map) {
	PropStream propStream;
	for (auto &node : waypointsNode.children) {
		if (node.type != OTBM_WAYPOINT)
			throw IOMapException("Unknown waypoint node.");

		if (!loader.getProps(node, propStream)) {
			throw IOMapException("Could not read waypoint data.");

			std::string name;
			if (!propStream.readString(name))
				throw IOMapException("Could not read waypoint name.");

			OTBM_Destination_coords waypoint_coords;
			if (!propStream.read(waypoint_coords))
				throw IOMapException("Could not read waypoint coordinates.");

			map.waypoints[name] = Position(waypoint_coords.x, waypoint_coords.y, waypoint_coords.z);
		}
	}
}
