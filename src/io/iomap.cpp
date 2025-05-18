/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "io/iomap.hpp"

#include "game/movement/teleport.hpp"
#include "game/game.hpp"
#include "io/filestream.hpp"

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

void IOMap::loadMap(Map* map, const Position &pos) {
	Benchmark bm_mapLoad;

	const auto &fileByte = mio::mmap_source(map->path.string());

	const auto begin = fileByte.begin() + sizeof(OTB::Identifier { { 'O', 'T', 'B', 'M' } });

	FileStream stream { begin, fileByte.end() };

	if (!stream.startNode()) {
		throw IOMapException("Could not read map node.");
	}

	stream.skip(1); // Type Node

	uint32_t version = stream.getU32();
	map->width = stream.getU16();
	map->height = stream.getU16();
	uint32_t majorVersionItems = stream.getU32();
	stream.getU32(); // minorVersionItems

	if (version > 2) {
		throw IOMapException("Unknown OTBM version detected.");
	}

	if (majorVersionItems < 3) {
		throw IOMapException("This map need to be upgraded by using the latest map editor version to be able to load correctly.");
	}

	if (stream.startNode(OTBM_MAP_DATA)) {
		parseMapDataAttributes(stream, map);
		parseTileArea(stream, *map, pos);
		stream.endNode();
	}

	parseTowns(stream, *map);
	parseWaypoints(stream, *map);

	map->flush();

	g_logger().debug("Map Loaded {} ({}x{}) in {} milliseconds", map->path.filename().string(), map->width, map->height, bm_mapLoad.duration());
}

void IOMap::parseMapDataAttributes(FileStream &stream, Map* map) {
	bool end = false;
	while (!end) {
		const uint8_t attr = stream.getU8();
		switch (attr) {
			case OTBM_ATTR_DESCRIPTION: {
				stream.getString();
			} break;

			case OTBM_ATTR_EXT_SPAWN_MONSTER_FILE: {
				map->monsterfile = map->path.string().substr(0, map->path.string().rfind('/') + 1);
				map->monsterfile += stream.getString();
			} break;

			case OTBM_ATTR_EXT_SPAWN_NPC_FILE: {
				map->npcfile = map->path.string().substr(0, map->path.string().rfind('/') + 1);
				map->npcfile += stream.getString();
			} break;
			case OTBM_ATTR_EXT_HOUSE_FILE: {
				map->housefile = map->path.string().substr(0, map->path.string().rfind('/') + 1);
				map->housefile += stream.getString();
			} break;

			case OTBM_ATTR_EXT_ZONE_FILE: {
				map->zonesfile = map->path.string().substr(0, map->path.string().rfind('/') + 1);
				map->zonesfile += stream.getString();
			} break;

			default:
				stream.back();
				end = true;
				break;
		}
	}
}

void IOMap::parseTileArea(FileStream &stream, Map &map, const Position &pos) {
	while (stream.startNode(OTBM_TILE_AREA)) {
		const uint16_t base_x = stream.getU16();
		const uint16_t base_y = stream.getU16();
		const uint8_t base_z = stream.getU8();

		while (stream.startNode()) {
			const uint8_t tileType = stream.getU8();
			if (tileType != OTBM_HOUSETILE && tileType != OTBM_TILE) {
				throw IOMapException("Could not read tile type node.");
			}

			const auto tile = std::make_shared<BasicTile>();

			const uint8_t tileCoordsX = stream.getU8();
			const uint8_t tileCoordsY = stream.getU8();

			const uint16_t x = base_x + tileCoordsX + pos.x;
			const uint16_t y = base_y + tileCoordsY + pos.y;
			const auto z = static_cast<uint8_t>(base_z + pos.z);

			if (tileType == OTBM_HOUSETILE) {
				tile->houseId = stream.getU32();
				if (!map.houses.addHouse(tile->houseId)) {
					throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not create house id: {}", x, y, z, tile->houseId));
				}
			}

			if (stream.isProp(OTBM_ATTR_TILE_FLAGS)) {
				const uint32_t flags = stream.getU32();
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
			}

			if (stream.isProp(OTBM_ATTR_ITEM)) {
				const uint16_t id = stream.getU16();
				const auto &iType = Item::items[id];

				if (!tile->isHouse() || !iType.isBed()) {
					const auto item = std::make_shared<BasicItem>();
					item->id = id;

					if (tile->isHouse() && iType.movable) {
						g_logger().warn("[IOMap::loadMap] - "
						                "Movable item with ID: {}, in house: {}, "
						                "at position: x {}, y {}, z {}",
						                id, tile->houseId, x, y, z);
					} else if (iType.isGroundTile()) {
						tile->ground = map.tryReplaceItemFromCache(item);
					} else {
						tile->items.emplace_back(map.tryReplaceItemFromCache(item));
					}
				}
			}

			while (stream.startNode()) {
				auto type = stream.getU8();
				switch (type) {
					case OTBM_ITEM: {
						const uint16_t id = stream.getU16();
						const auto &iType = Item::items[id];
						const auto item = std::make_shared<BasicItem>();
						item->id = id;

						if (!item->unserializeItemNode(stream, x, y, z)) {
							throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Failed to load item {}, Node Type.", x, y, z, id));
						}

						if (tile->isHouse() && (iType.isBed() || iType.isTrashHolder())) {
							// nothing
						} else if (tile->isHouse() && iType.movable) {
							g_logger().warn("[IOMap::loadMap] - "
							                "Movable item with ID: {}, in house: {}, "
							                "at position: x {}, y {}, z {}",
							                id, tile->houseId, x, y, z);
						} else if (iType.isGroundTile()) {
							tile->ground = map.tryReplaceItemFromCache(item);
						} else {
							tile->items.emplace_back(map.tryReplaceItemFromCache(item));
						}
					} break;
					case OTBM_TILE_ZONE: {
						const auto zoneCount = stream.getU16();
						for (uint16_t i = 0; i < zoneCount; ++i) {
							const auto zoneId = stream.getU16();
							if (!zoneId) {
								throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Invalid zone id.", x, y, z));
							}
							auto zone = Zone::getZone(zoneId);
							zone->addPosition(Position(x, y, z));
						}
					} break;
					default:
						throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not read item/zone node.", x, y, z));
				}

				if (!stream.endNode()) {
					throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not end node.", x, y, z));
				}
			}

			if (!stream.endNode()) {
				throw IOMapException(fmt::format("[x:{}, y:{}, z:{}] Could not end node.", x, y, z));
			}

			if (tile->isEmpty(true)) {
				continue;
			}

			map.setBasicTile(x, y, z, tile);
		}

		if (!stream.endNode()) {
			throw IOMapException("Could not end node.");
		}
	}
}

void IOMap::parseTowns(FileStream &stream, Map &map) {
	if (!stream.startNode(OTBM_TOWNS)) {
		throw IOMapException("Could not read towns node.");
	}

	while (stream.startNode(OTBM_TOWN)) {
		const uint32_t townId = stream.getU32();
		const auto &townName = stream.getString();
		const uint16_t x = stream.getU16();
		const uint16_t y = stream.getU16();
		const uint8_t z = stream.getU8();

		auto town = map.towns.getOrCreateTown(townId);
		town->setName(townName);
		town->setTemplePos(Position(x, y, z));

		if (!stream.endNode()) {
			throw IOMapException("Could not end node.");
		}
	}

	if (!stream.endNode()) {
		throw IOMapException("Could not end node.");
	}
}

void IOMap::parseWaypoints(FileStream &stream, Map &map) {
	if (!stream.startNode(OTBM_WAYPOINTS)) {
		throw IOMapException("Could not read waypoints node.");
	}

	while (stream.startNode(OTBM_WAYPOINT)) {
		const auto &name = stream.getString();
		const uint16_t x = stream.getU16();
		const uint16_t y = stream.getU16();
		const uint8_t z = stream.getU8();

		map.waypoints[name] = Position(x, y, z);

		if (!stream.endNode()) {
			throw IOMapException("Could not end node.");
		}
	}

	if (!stream.endNode()) {
		throw IOMapException("Could not end node.");
	}
}
