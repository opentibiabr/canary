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

Tile* IOMap::createTile(Item*&ground, Item* item, uint16_t x, uint16_t y, uint8_t z) {
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

bool IOMap::loadMap(Map* map, const std::string &fileName, const Position &pos, bool unload) {
	int64_t start = OTSYS_TIME();
	OTB::Loader loader { fileName, OTB::Identifier { { 'O', 'T', 'B', 'M' } } };
	auto &root = loader.parseTree();

	PropStream propStream;
	if (!loader.getProps(root, propStream)) {
		setLastErrorString("Could not read root property.");
		return false;
	}

	OTBM_root_header root_header;
	if (!propStream.read(root_header)) {
		setLastErrorString("Could not read header.");
		return false;
	}

	uint32_t headerVersion = root_header.version;
	if (headerVersion <= 0) {
		// In otbm version 1 the count variable after splashes/fluidcontainers and stackables
		// are saved as attributes instead, this solves alot of problems with items
		// that is changed (stackable/charges/fluidcontainer/splash) during an update.
		setLastErrorString("This map need to be upgraded by using the latest map editor version to be able to load correctly.");
		return false;
	}

	if (headerVersion > 2) {
		setLastErrorString("Unknown OTBM version detected.");
		return false;
	}

	if (root_header.majorVersionItems < 3) {
		setLastErrorString("This map need to be upgraded by using the latest map editor version to be able to load correctly.");
		return false;
	}

	g_logger().info("Map size: {}x{}", root_header.width, root_header.height);
	map->width = root_header.width;
	map->height = root_header.height;

	if (root.children.size() != 1 || root.children.front().type != OTBM_MAP_DATA) {
		setLastErrorString("Could not read data node.");
		return false;
	}

	auto &mapNode = root.children.front();
	if (!parseMapDataAttributes(loader, mapNode, *map, fileName)) {
		return false;
	}

	for (auto &mapDataNode : mapNode.children) {
		if (mapDataNode.type == OTBM_TILE_AREA) {
			if (!parseTileArea(loader, mapDataNode, *map, pos, unload)) {
				return false;
			}
		} else if (mapDataNode.type == OTBM_TOWNS) {
			if (!parseTowns(loader, mapDataNode, *map)) {
				return false;
			}
		} else if (mapDataNode.type == OTBM_WAYPOINTS && headerVersion > 1) {
			if (!parseWaypoints(loader, mapDataNode, *map)) {
				return false;
			}
		} else {
			setLastErrorString("Unknown map node.");
			return false;
		}
	}

	map->cache.clear();

	g_logger().info("Map loading time: {} seconds", (OTSYS_TIME() - start) / (1000.));
	return true;
}

bool IOMap::parseMapDataAttributes(OTB::Loader &loader, const OTB::Node &mapNode, Map &map, const std::string &fileName) {
	PropStream propStream;
	if (!loader.getProps(mapNode, propStream)) {
		setLastErrorString("Could not read map data attributes.");
		return false;
	}

	std::string mapDescription;
	std::string tmp;

	uint8_t attribute;
	while (propStream.read<uint8_t>(attribute)) {
		switch (attribute) {
			case OTBM_ATTR_DESCRIPTION:
				if (!propStream.readString(mapDescription)) {
					setLastErrorString("Invalid description tag.");
					return false;
				}
				break;

			case OTBM_ATTR_EXT_SPAWN_MONSTER_FILE:
				if (!propStream.readString(tmp)) {
					setLastErrorString("Invalid monster spawn tag. Make sure you are using the correct version of the map editor.");
					return false;
				}

				map.monsterfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.monsterfile += tmp;
				break;

			case OTBM_ATTR_EXT_HOUSE_FILE:
				if (!propStream.readString(tmp)) {
					setLastErrorString("Invalid house tag.");
					return false;
				}

				map.housefile = fileName.substr(0, fileName.rfind('/') + 1);
				map.housefile += tmp;
				break;

			case OTBM_ATTR_EXT_SPAWN_NPC_FILE:
				if (!propStream.readString(tmp)) {
					setLastErrorString("Invalid npc spawn tag. Make sure you are using the correct version of the map editor.");
					return false;
				}

				map.npcfile = fileName.substr(0, fileName.rfind('/') + 1);
				map.npcfile += tmp;
				break;

			default:
				setLastErrorString("Unknown header node.");
				return false;
		}
	}
	return true;
}

bool IOMap::parseTileArea(OTB::Loader &loader, const OTB::Node &tileAreaNode, Map &map, const Position &pos, bool unload) {
	PropStream propStream;
	if (!loader.getProps(tileAreaNode, propStream)) {
		setLastErrorString("Invalid map node.");
		return false;
	}

	OTBM_Destination_coords area_coord;
	if (!propStream.read(area_coord)) {
		setLastErrorString("Invalid map node.");
		return false;
	}

	const uint16_t base_x = area_coord.x;
	const uint16_t base_y = area_coord.y;
	const uint16_t base_z = area_coord.z;

	for (auto &tileNode : tileAreaNode.children) {
		if (tileNode.type != OTBM_TILE && tileNode.type != OTBM_HOUSETILE) {
			setLastErrorString("Unknown tile node.");
			return false;
		}

		if (!loader.getProps(tileNode, propStream)) {
			setLastErrorString("Could not read node data.");
			return false;
		}

		OTBM_Tile_coords tile_coord;
		if (!propStream.read(tile_coord)) {
			setLastErrorString("Could not read tile position.");
			return false;
		}

		const auto &tile = std::make_shared<BasicTile>();

		const uint16_t x = base_x + tile_coord.x + pos.x;
		const uint16_t y = base_y + tile_coord.y + pos.y;
		const uint8_t z = static_cast<uint8_t>(base_z + pos.z);

		uint32_t houseId = 0;
		bool tileIsStatic = false;

		if (tileNode.type == OTBM_HOUSETILE) {
			if (!propStream.read<uint32_t>(houseId)) {
				std::ostringstream ss;
				ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Could not read house id.";
				setLastErrorString(ss.str());
				return false;
			}

			if (!map.houses.addHouse(houseId)) {
				std::ostringstream ss;
				ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Could not create house id: " << houseId;
				setLastErrorString(ss.str());
				return false;
			}

			tile->houseId = houseId;
		}

		uint8_t attribute;
		// read tile attributes
		while (propStream.read<uint8_t>(attribute)) {
			switch (attribute) {
				case OTBM_ATTR_TILE_FLAGS: {
					uint32_t flags;
					if (!propStream.read<uint32_t>(flags)) {
						std::ostringstream ss;
						ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Failed to read tile flags.";
						setLastErrorString(ss.str());
						return false;
					}

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
					if (!propStream.read<uint16_t>(id)) {
						std::ostringstream ss;
						ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Failed to create item.";
						setLastErrorString(ss.str());
						break;
					}

					const ItemType &iType = Item::items[id];
					if (tile->isHouse() && iType.isBed()) {
						continue;
					}

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
						tile->ground = map.cache.tryReplaceItemFromCache(item);
					} else {
						tile->items.emplace_back(map.cache.tryReplaceItemFromCache(item));
					}

					break;
				}

				default:
					std::ostringstream ss;
					ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Unknown tile attribute.";
					setLastErrorString(ss.str());
					return false;
			}
		}

		for (auto &itemNode : tileNode.children) {
			if (itemNode.type != OTBM_ITEM) {
				std::ostringstream ss;
				ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Unknown node type.";
				setLastErrorString(ss.str());
				return false;
			}

			PropStream stream;
			if (!loader.getProps(itemNode, stream)) {
				setLastErrorString("Invalid item node.");
				return false;
			}

			uint16_t id;
			if (!stream.read<uint16_t>(id)) {
				std::ostringstream ss;
				ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Failed to create item.";
				setLastErrorString(ss.str());
				break;
			}

			const auto &iType = Item::items[id];
			if (tile->isHouse() && iType.isBed())
				continue;

			if (iType.blockSolid)
				tileIsStatic = true;

			const auto &item = std::make_shared<BasicItem>();
			item->id = id;

			if (!item->unserializeItemNode(loader, itemNode, stream)) {
				std::ostringstream ss;
				ss << "[x:" << x << ", y:" << y << ", z:" << z << "] Failed to load item " << id << '.';
				setLastErrorString(ss.str());
				continue;
			}

			if (tile->isHouse() && iType.moveable) {
				g_logger().warn("[IOMap::loadMap] - "
								"Moveable item with ID: {}, in house: {}, "
								"at position: x {}, y {}, z {}",
								id, houseId, x, y, z);
			} else if (iType.isGroundTile()) {
				tile->ground = map.cache.tryReplaceItemFromCache(item);
			} else {
				tile->items.emplace_back(map.cache.tryReplaceItemFromCache(item));
			}
		}

		if (tile->isEmpty())
			continue;

		map.cache.setTile(x, y, z, tile);
	}
	return true;
}

bool IOMap::parseTowns(OTB::Loader &loader, const OTB::Node &townsNode, Map &map) {
	for (auto &townNode : townsNode.children) {
		PropStream propStream;
		if (townNode.type != OTBM_TOWN) {
			setLastErrorString("Unknown town node.");
			return false;
		}

		if (!loader.getProps(townNode, propStream)) {
			setLastErrorString("Could not read town data.");
			return false;
		}

		uint32_t townId;
		if (!propStream.read<uint32_t>(townId)) {
			setLastErrorString("Could not read town id.");
			return false;
		}

		std::string townName;
		if (!propStream.readString(townName)) {
			setLastErrorString("Could not read town name.");
			return false;
		}

		OTBM_Destination_coords town_coords;
		if (!propStream.read(town_coords)) {
			setLastErrorString("Could not read town coordinates.");
			return false;
		}

		auto town = map.towns.getOrCreateTown(townId);
		town->setName(townName);
		town->setTemplePos(Position(town_coords.x, town_coords.y, town_coords.z));
	}
	return true;
}

bool IOMap::parseWaypoints(OTB::Loader &loader, const OTB::Node &waypointsNode, Map &map) {
	PropStream propStream;
	for (auto &node : waypointsNode.children) {
		if (node.type != OTBM_WAYPOINT) {
			setLastErrorString("Unknown waypoint node.");
			return false;
		}

		if (!loader.getProps(node, propStream)) {
			setLastErrorString("Could not read waypoint data.");
			return false;
		}

		std::string name;
		if (!propStream.readString(name)) {
			setLastErrorString("Could not read waypoint name.");
			return false;
		}

		OTBM_Destination_coords waypoint_coords;
		if (!propStream.read(waypoint_coords)) {
			setLastErrorString("Could not read waypoint coordinates.");
			return false;
		}

		map.waypoints[name] = Position(waypoint_coords.x, waypoint_coords.y, waypoint_coords.z);
	}
	return true;
}
