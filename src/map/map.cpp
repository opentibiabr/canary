/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/map.hpp"

#include "creatures/combat/combat.hpp"
#include "creatures/combat/condition.hpp"
#include "creatures/monsters/monster.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "game/scheduling/dispatcher.hpp"
#include "game/zones/zone.hpp"
#include "io/iomap.hpp"
#include "io/iomapserialize.hpp"
#include "lua/callbacks/events_callbacks.hpp"
#include "map/map_download.hpp"
#include "map/spectators.hpp"
#include "utils/astarnodes.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <algorithm>
	#include <functional>
	#include <limits>
#endif

namespace {
	[[nodiscard]] uint64_t navigationSectorKey(uint32_t sectorIndex, uint8_t z) {
		return (static_cast<uint64_t>(z) << 32) | sectorIndex;
	}

	void setNavFlag(NavCell &cell, NavCellFlag flag, bool enabled) {
		if (enabled) {
			cell.flags = cell.flags | flag;
		}
	}

	[[nodiscard]] bool hasTileFlag(uint32_t flags, TileFlags_t flag) {
		return (flags & static_cast<uint32_t>(flag)) != 0;
	}

	void addCachedItemNavigationTopology(NavCell &cell, const std::shared_ptr<BasicItem> &item) {
		if (!item || !Item::items.hasItemType(item->id)) {
			return;
		}

		const auto &itemType = Item::items[item->id];
		const auto floorChange = static_cast<uint32_t>(itemType.floorChange);
		const bool movable = itemType.movable && item->uniqueId == 0 && item->actionId != IMMOVABLE_ACTION_ID;
		const bool noFieldBlockPath = !itemType.isMagicField() && itemType.blockPathFind;
		setNavFlag(cell, NavCellFlag::FloorChange, floorChange != 0);
		setNavFlag(cell, NavCellFlag::FloorChangeWest, hasTileFlag(floorChange, TILESTATE_FLOORCHANGE_WEST));
		setNavFlag(cell, NavCellFlag::Teleport, itemType.isTeleport());
		setNavFlag(cell, NavCellFlag::ImmovableBlockSolid, itemType.blockSolid && !movable);
		setNavFlag(cell, NavCellFlag::ImmovableNoFieldBlockPath, noFieldBlockPath && !movable);
		setNavFlag(cell, NavCellFlag::BlockSolid, itemType.blockSolid);
		setNavFlag(cell, NavCellFlag::NoFieldBlockPath, noFieldBlockPath);
		setNavFlag(cell, NavCellFlag::BlockProjectile, itemType.blockProjectile);

		if (!cell.hasFlag(NavCellFlag::HarmfulField) && itemType.isMagicField() && !itemType.blockSolid && itemType.conditionDamage && itemType.conditionDamage->getTotalDamage() > 0) {
			setNavFlag(cell, NavCellFlag::HarmfulField, true);
			cell.harmfulFieldCombatType = static_cast<uint8_t>(itemType.combatType);
		}
	}

	void populateCachedTileNavigationTopology(NavCell &cell, const BasicTile &tile) {
		cell.houseId = tile.houseId;
		if (tile.ground) {
			cell.groundId = tile.ground->id;
			setNavFlag(cell, NavCellFlag::HasGround, true);
			setNavFlag(cell, NavCellFlag::WalkableSea, cell.groundId >= ITEM_WALKABLE_SEA_START && cell.groundId <= ITEM_WALKABLE_SEA_END);
			addCachedItemNavigationTopology(cell, tile.ground);
		}

		setNavFlag(cell, NavCellFlag::ProtectionZone, tile.houseId != 0 || hasTileFlag(tile.flags, TILESTATE_PROTECTIONZONE));
		setNavFlag(cell, NavCellFlag::FloorChange, hasTileFlag(tile.flags, TILESTATE_FLOORCHANGE));
		setNavFlag(cell, NavCellFlag::FloorChangeWest, hasTileFlag(tile.flags, TILESTATE_FLOORCHANGE_WEST));
		setNavFlag(cell, NavCellFlag::Teleport, hasTileFlag(tile.flags, TILESTATE_TELEPORT));
		setNavFlag(cell, NavCellFlag::ImmovableBlockSolid, hasTileFlag(tile.flags, TILESTATE_IMMOVABLEBLOCKSOLID));
		setNavFlag(cell, NavCellFlag::ImmovableNoFieldBlockPath, hasTileFlag(tile.flags, TILESTATE_IMMOVABLENOFIELDBLOCKPATH));
		setNavFlag(cell, NavCellFlag::BlockSolid, hasTileFlag(tile.flags, TILESTATE_BLOCKSOLID));
		setNavFlag(cell, NavCellFlag::NoFieldBlockPath, hasTileFlag(tile.flags, TILESTATE_NOFIELDBLOCKPATH));
		setNavFlag(cell, NavCellFlag::BlockProjectile, hasTileFlag(tile.flags, TILESTATE_BLOCKPROJECTILE));

		for (const auto &item : tile.items) {
			addCachedItemNavigationTopology(cell, item);
		}
	}

	// Path searches call this for every candidate node; pass the creature's
	// current tile captured once per search to avoid repeated weak_ptr locks.
	std::shared_ptr<Tile> getPathfindingTile(
		Map &map,
		const std::shared_ptr<Creature> &creature,
		const std::shared_ptr<Tile> &creatureTile,
		const Position &pos,
		MapCacheFloorCursor &floorCursor
	) {
		const auto &tile = map.getTileWithFloorCursor(pos.x, pos.y, pos.z, floorCursor);
		if (creatureTile != tile) {
			if (!tile || tile->queryAdd(0, creature, 1, FLAG_PATHFINDING | FLAG_IGNOREFIELDDAMAGE) != RETURNVALUE_NOERROR) {
				return nullptr;
			}
		}

		return tile;
	}
}

void Map::load(const std::string &identifier, const Position &pos) {
	invalidateNavigationEpoch();
	try {
		path = identifier;
		IOMap::loadMap(this, pos);
	} catch (const std::exception &e) {
		g_logger().warn("[Map::load] - The map in folder {} is missing or corrupted", identifier);
	}
}

void Map::loadMap(const std::string &identifier, bool mainMap /*= false*/, bool loadHouses /*= false*/, bool loadMonsters /*= false*/, bool loadNpcs /*= false*/, bool loadZones /*= false*/, const Position &pos /*= Position()*/) {
	// Only download map if is loading the main map and it is not already downloaded
	if (mainMap && g_configManager().getBoolean(TOGGLE_DOWNLOAD_MAP) && !std::filesystem::exists(identifier)) {
		const auto mapDownloadUrl = g_configManager().getString(MAP_DOWNLOAD_URL);
		if (mapDownloadUrl.empty()) {
			g_logger().warn("Map download URL in config.lua is empty, download disabled");
		}

		if (!mapDownloadUrl.empty()) {
			MapDownload::warnIfOutdatedMapDownloadUrl(mapDownloadUrl);
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
	load(identifier, pos);

	// Only create items from lua functions if is loading main map
	// It needs to be after the load map to ensure the map already exists before creating the items
	if (mainMap) {
		// Create items from lua scripts per position
		// Example: ActionFunctions::luaActionPosition
		g_game().createLuaItemsOnMap();
	}

	if (loadMonsters) {
		IOMap::loadMonsters(this);
	}

	if (loadHouses) {
		IOMap::loadHouses(this);

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
		IOMap::loadNpcs(this);
	}

	if (loadZones) {
		IOMap::loadZones(this);
	}

	// Files need to be cleaned up if custom map is enabled to open, or will try to load main map files
	if (g_configManager().getBoolean(TOGGLE_MAP_CUSTOM)) {
		monsterfile.clear();
		housefile.clear();
		npcfile.clear();
	}

	if (!mainMap) {
		g_callbacks().executeCallback(EventCallback_t::mapOnLoad, path.string());
	}
}

void Map::loadMapCustom(const std::string &mapName, bool loadHouses, bool loadMonsters, bool loadNpcs, bool loadZones, int customMapIndex) {
	// Load the map
	load(g_configManager().getString(DATA_DIRECTORY) + "/world/custom/" + mapName + ".otbm");

	if (loadMonsters && !IOMap::loadMonstersCustom(this, mapName, customMapIndex)) {
		g_logger().warn("Failed to load monster custom data");
	}

	if (loadHouses && !IOMap::loadHousesCustom(this, mapName, customMapIndex)) {
		g_logger().warn("Failed to load house custom data");
	}

	if (loadNpcs && !IOMap::loadNpcsCustom(this, mapName, customMapIndex)) {
		g_logger().warn("Failed to load npc custom spawn data");
	}

	if (loadZones && !IOMap::loadZonesCustom(this, mapName, customMapIndex)) {
		g_logger().warn("Failed to load zones custom data");
	}

	// Files need to be cleaned up or will try to load previous map files again
	monsterfile.clear();
	housefile.clear();
	npcfile.clear();
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

std::shared_ptr<Tile> Map::getOrCreateTile(uint16_t x, uint16_t y, uint8_t z, bool isDynamic) {
	auto tile = getTile(x, y, z);
	if (!tile) {
		if (isDynamic) {
			tile = std::make_shared<DynamicTile>(x, y, z);
		} else {
			tile = std::make_shared<StaticTile>(x, y, z);
		}

		setTile(x, y, z, tile);
	}

	return tile;
}

std::shared_ptr<Tile> Map::getLoadedTile(uint16_t x, uint16_t y, uint8_t z) {
	if (z >= MAP_MAX_LAYERS) {
		return nullptr;
	}

	const auto &leaf = getMapSector(x, y);
	if (!leaf) {
		return nullptr;
	}

	const auto &floor = leaf->getFloor(z);
	if (!floor) {
		return nullptr;
	}

	const auto &tile = floor->getTile(x, y);
	return tile;
}

std::shared_ptr<Tile> Map::getTile(uint16_t x, uint16_t y, uint8_t z) {
	// Check if the coordinates are valid
	if (x == 0 && y == 0 && z == 0) {
		return nullptr;
	}

	if (z >= MAP_MAX_LAYERS) {
		return nullptr;
	}

	const auto &sector = getMapSector(x, y);
	if (!sector) {
		return nullptr;
	}

	const auto &floor = sector->getFloor(z);
	if (!floor) {
		return nullptr;
	}

	return getOrCreateTileFromCache(floor, x, y);
}

std::shared_ptr<Tile> Map::getTileWithFloorCursor(uint16_t x, uint16_t y, uint8_t z, MapCacheFloorCursor &floorCursor) {
	// Check if the coordinates are valid
	if (x == 0 && y == 0 && z == 0) {
		return nullptr;
	}

	if (z >= MAP_MAX_LAYERS) {
		return nullptr;
	}

	const auto sectorIndex = static_cast<uint32_t>(x / SECTOR_SIZE) | (static_cast<uint32_t>(y / SECTOR_SIZE) << 16);
	std::shared_ptr<Floor> floor;

	if (floorCursor.valid && floorCursor.sectorIndex == sectorIndex && floorCursor.z == z) {
		floor = floorCursor.floor;
	}

	if (!floor) {
		const auto &sector = getMapSector(x, y);
		if (!sector) {
			return nullptr;
		}

		floor = sector->getFloor(z);
		if (!floor) {
			return nullptr;
		}

		floorCursor.valid = true;
		floorCursor.sectorIndex = sectorIndex;
		floorCursor.z = z;
		floorCursor.floor = floor;
	}

	return getOrCreateTileFromCache(floor, x, y);
}

void Map::refreshZones(uint16_t x, uint16_t y, uint8_t z) {
	const auto &tile = getLoadedTile(x, y, z);
	if (!tile) {
		return;
	}

	tile->clearZones();
	const auto &zones = Zone::getZones(tile->getPosition());
	for (const auto &zone : zones) {
		tile->addZone(zone);
	}
}

void Map::setTile(uint16_t x, uint16_t y, uint8_t z, const std::shared_ptr<Tile> &newTile) {
	if (z >= MAP_MAX_LAYERS) {
		g_logger().error("Attempt to set tile on invalid coordinate: {}", Position(x, y, z).toString());
		return;
	}

	if (const auto &sector = getMapSector(x, y)) {
		sector->createFloor(z)->setTile(x, y, newTile);
	} else {
		getBestMapSector(x, y)->createFloor(z)->setTile(x, y, newTile);
	}
	markNavigationTopologyChanged(Position(x, y, z));
}

std::shared_ptr<const NavRegionSnapshot> Map::getNavigationSnapshot(const Position &center, uint8_t radius) {
	NavRegionSnapshot::SectorList sectors;
	if (center.z >= MAP_MAX_LAYERS) {
		return std::make_shared<const NavRegionSnapshot>(navigationEpoch, center, radius, std::move(sectors));
	}

	const auto minX = static_cast<uint32_t>(std::max<int32_t>(0, static_cast<int32_t>(center.x) - radius));
	const auto minY = static_cast<uint32_t>(std::max<int32_t>(0, static_cast<int32_t>(center.y) - radius));
	const auto maxX = static_cast<uint32_t>(std::min<int32_t>(std::numeric_limits<uint16_t>::max(), static_cast<int32_t>(center.x) + radius));
	const auto maxY = static_cast<uint32_t>(std::min<int32_t>(std::numeric_limits<uint16_t>::max(), static_cast<int32_t>(center.y) + radius));
	const auto firstSectorX = minX / SECTOR_SIZE;
	const auto firstSectorY = minY / SECTOR_SIZE;
	const auto lastSectorX = maxX / SECTOR_SIZE;
	const auto lastSectorY = maxY / SECTOR_SIZE;
	sectors.reserve((lastSectorX - firstSectorX + 1) * (lastSectorY - firstSectorY + 1));

	for (uint32_t sectorY = firstSectorY; sectorY <= lastSectorY; ++sectorY) {
		for (uint32_t sectorX = firstSectorX; sectorX <= lastSectorX; ++sectorX) {
			const auto sectorIndex = sectorX | (sectorY << 16);
			sectors.emplace_back(getOrBuildNavigationSector(sectorIndex, center.z));
		}
	}

	return std::make_shared<const NavRegionSnapshot>(navigationEpoch, center, radius, std::move(sectors));
}

std::shared_ptr<const NavSectorSnapshot> Map::getOrBuildNavigationSector(uint32_t sectorIndex, uint8_t z) {
	const auto baseX = static_cast<uint16_t>((sectorIndex & 0xFFFF) * SECTOR_SIZE);
	const auto baseY = static_cast<uint16_t>((sectorIndex >> 16) * SECTOR_SIZE);
	auto* sector = getMapSector(baseX, baseY);
	const uint64_t topologyRevision = sector ? sector->getTopologyRevision(z) : 0;
	const uint64_t occupancyRevision = sector ? sector->getOccupancyRevision(z) : 0;
	const auto key = navigationSectorKey(sectorIndex, z);

	std::shared_ptr<const NavSectorSnapshot> cached;
	if (const auto it = navigationSnapshots.find(key); it != navigationSnapshots.end()) {
		cached = it->second;
		if (cached->getTopologyRevision() == topologyRevision && cached->getOccupancyRevision() == occupancyRevision) {
			return cached;
		}
	}

	NavSectorSnapshot::Cells cells;
	const bool reuseTopology = cached && cached->getTopologyRevision() == topologyRevision;
	if (reuseTopology) {
		cells = cached->getCells();
		for (auto &cell : cells) {
			cell.blockingCreatures = 0;
			cell.pushableMonsters = 0;
			cell.hasNonInvisibleCreature = false;
			cell.hasUnpushableCreature = false;
		}
	}

	const auto floor = sector ? sector->getFloor(z) : nullptr;
	if (floor) {
		for (uint32_t localX = 0; localX < SECTOR_SIZE; ++localX) {
			for (uint32_t localY = 0; localY < SECTOR_SIZE; ++localY) {
				const auto x = static_cast<uint16_t>(baseX + localX);
				const auto y = static_cast<uint16_t>(baseY + localY);
				const auto [tile, cachedTile] = floor->getTileAndCache(x, y);
				if (!tile && !cachedTile) {
					continue;
				}

				auto &cell = cells[localX * SECTOR_SIZE + localY];
				if (!reuseTopology) {
					if (tile) {
						if (const auto &house = tile->getHouse()) {
							cell.houseId = house->getId();
						}
						const auto &ground = tile->getGround();
						if (ground) {
							cell.groundId = ground->getID();
							setNavFlag(cell, NavCellFlag::HasGround, true);
							setNavFlag(cell, NavCellFlag::WalkableSea, cell.groundId >= ITEM_WALKABLE_SEA_START && cell.groundId <= ITEM_WALKABLE_SEA_END);
						}

						setNavFlag(cell, NavCellFlag::ProtectionZone, tile->hasFlag(TILESTATE_PROTECTIONZONE));
						setNavFlag(cell, NavCellFlag::FloorChange, tile->hasFlag(TILESTATE_FLOORCHANGE));
						setNavFlag(cell, NavCellFlag::FloorChangeWest, tile->hasFlag(TILESTATE_FLOORCHANGE_WEST));
						setNavFlag(cell, NavCellFlag::Teleport, tile->hasFlag(TILESTATE_TELEPORT));
						setNavFlag(cell, NavCellFlag::ImmovableBlockSolid, tile->hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID));
						setNavFlag(cell, NavCellFlag::ImmovableNoFieldBlockPath, tile->hasFlag(TILESTATE_IMMOVABLENOFIELDBLOCKPATH));
						setNavFlag(cell, NavCellFlag::BlockSolid, tile->hasFlag(TILESTATE_BLOCKSOLID));
						setNavFlag(cell, NavCellFlag::NoFieldBlockPath, tile->hasFlag(TILESTATE_NOFIELDBLOCKPATH));
						setNavFlag(cell, NavCellFlag::BlockProjectile, tile->hasFlag(TILESTATE_BLOCKPROJECTILE));

						if (const auto &field = tile->getFieldItem(); field && !field->isBlocking() && field->getDamage() > 0) {
							setNavFlag(cell, NavCellFlag::HarmfulField, true);
							cell.harmfulFieldCombatType = static_cast<uint8_t>(field->getCombatType());
						}
					} else {
						populateCachedTileNavigationTopology(cell, *cachedTile);
					}
				}

				if (!tile) {
					continue;
				}
				if (const auto* creatures = tile->getCreatures()) {
					for (const auto &creature : *creatures) {
						if (!creature || creature->isInGhostMode()) {
							continue;
						}
						if (cell.blockingCreatures < std::numeric_limits<uint8_t>::max()) {
							++cell.blockingCreatures;
						}
						if (!creature->isInvisible()) {
							cell.hasNonInvisibleCreature = true;
						}

						const auto &monster = creature->getMonster();
						const auto &master = monster && monster->isSummon() ? monster->getMaster() : nullptr;
						const bool pushableMonster = monster && monster->isPushable() && (!master || !master->getPlayerRaw());
						if (pushableMonster && cell.pushableMonsters < std::numeric_limits<uint8_t>::max()) {
							++cell.pushableMonsters;
						} else if (!pushableMonster) {
							cell.hasUnpushableCreature = true;
						}
					}
				}
			}
		}
	}

	sector = getMapSector(baseX, baseY);
	const auto builtTopologyRevision = sector ? sector->getTopologyRevision(z) : 0;
	const auto builtOccupancyRevision = sector ? sector->getOccupancyRevision(z) : 0;
	if (reuseTopology && builtTopologyRevision != topologyRevision) {
		navigationSnapshots.erase(key);
		return getOrBuildNavigationSector(sectorIndex, z);
	}
	auto snapshot = std::make_shared<const NavSectorSnapshot>(sectorIndex, z, builtTopologyRevision, builtOccupancyRevision, std::move(cells));
	navigationSnapshots.insert_or_assign(key, snapshot);
	return snapshot;
}

bool Map::isNavigationTopologyCurrent(const NavRegionSnapshot &snapshot) const {
	if (snapshot.getEpoch() != navigationEpoch) {
		return false;
	}

	return std::ranges::all_of(snapshot.getSectors(), [this](const auto &snapshotSector) {
		const auto sectorIndex = snapshotSector->getSectorIndex();
		const auto x = static_cast<uint16_t>((sectorIndex & 0xFFFF) * SECTOR_SIZE);
		const auto y = static_cast<uint16_t>((sectorIndex >> 16) * SECTOR_SIZE);
		const auto* sector = getMapSector(x, y);
		const auto revision = sector ? sector->getTopologyRevision(snapshotSector->getZ()) : 0;
		return revision == snapshotSector->getTopologyRevision();
	});
}

bool Map::isNavigationOccupancyCurrent(const NavRegionSnapshot &snapshot) const {
	if (snapshot.getEpoch() != navigationEpoch) {
		return false;
	}

	return std::ranges::all_of(snapshot.getSectors(), [this](const auto &snapshotSector) {
		const auto sectorIndex = snapshotSector->getSectorIndex();
		const auto x = static_cast<uint16_t>((sectorIndex & 0xFFFF) * SECTOR_SIZE);
		const auto y = static_cast<uint16_t>((sectorIndex >> 16) * SECTOR_SIZE);
		const auto* sector = getMapSector(x, y);
		const auto revision = sector ? sector->getOccupancyRevision(snapshotSector->getZ()) : 0;
		return revision == snapshotSector->getOccupancyRevision();
	});
}

void Map::markNavigationTopologyChanged(const Position &position) {
	if (auto* sector = getMapSector(position.x, position.y)) {
		sector->markTopologyChanged(position.z);
	}
}

void Map::markNavigationOccupancyChanged(const Position &position) {
	if (auto* sector = getMapSector(position.x, position.y)) {
		sector->markOccupancyChanged(position.z);
	}
}

void Map::invalidateNavigationEpoch() {
	if (++navigationEpoch == 0) {
		navigationEpoch = 1;
	}
	navigationSnapshots.clear();
}

bool Map::placeCreature(
	const Position &centerPos,
	const std::shared_ptr<Creature> &creature,
	bool extendedPos /* = false*/,
	bool forceLogin /* = false*/,
	const std::shared_ptr<Tile> &centerTile /* = nullptr */
) {
	auto* monster = creature ? creature->getMonsterRaw() : nullptr;
	if (monster) {
		monster->ignoreFieldDamage = true;
	}

	bool foundTile;
	bool placeInPZ;

	auto tile = centerTile ? centerTile : getTile(centerPos.x, centerPos.y, centerPos.z);
	if (tile) {
		placeInPZ = tile->hasFlag(TILESTATE_PROTECTIONZONE);
		ReturnValue ret = tile->queryAdd(0, creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE);
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

		auto shuffleRange = [](auto begin, auto end) {
			std::random_device randomDevice;
			const auto size = static_cast<size_t>(std::distance(begin, end));
			if (size < 2) {
				return;
			}

			for (size_t i = size - 1; i > 0; --i) {
				std::uniform_int_distribution<size_t> dist(0, i);
				auto left = std::next(begin, static_cast<std::ptrdiff_t>(i));
				auto right = std::next(begin, static_cast<std::ptrdiff_t>(dist(randomDevice)));
				std::iter_swap(left, right);
			}
		};

		if (extendedPos) {
			shuffleRange(relList.begin(), relList.begin() + 4);
			shuffleRange(relList.begin() + 4, relList.end());
		} else {
			shuffleRange(relList.begin(), relList.end());
		}

		for (const auto &[xOffset, yOffset] : relList) {
			Position tryPos(centerPos.x + xOffset, centerPos.y + yOffset, centerPos.z);

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

			if (tile->queryAdd(0, creature, 1, FLAG_IGNOREBLOCKITEM | FLAG_IGNOREFIELDDAMAGE) == RETURNVALUE_NOERROR) {
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
	std::shared_ptr<Item> toItem = nullptr;

	if (tile) {
		const auto toCylinder = tile->queryDestination(index, creature, toItem, flags);
		toCylinder->internalAddThing(creature);

		const Position &dest = toCylinder->getPosition();
		getMapSector(dest.x, dest.y)->addCreature(creature);
	}
	return true;
}

void Map::moveCreature(const std::shared_ptr<Creature> &creature, const std::shared_ptr<Tile> &newTile, bool forceTeleport /* = false*/) {
	if (!creature || creature->isRemoved() || !newTile) {
		return;
	}

	const auto &oldTile = creature->getTile();

	if (!oldTile) {
		return;
	}

	const auto &oldPos = oldTile->getPosition();
	const auto &newPos = newTile->getPosition();

	if (oldPos == newPos) {
		return;
	}

	const auto &fromZones = oldTile->getZones();
	const auto &toZones = newTile->getZones();

	if (const auto &ret = g_game().beforeCreatureZoneChange(creature, fromZones, toZones); ret != RETURNVALUE_NOERROR) {
		return;
	}

	const bool teleport = forceTeleport || !newTile->getGround() || !Position::areInRange<1, 1, 0>(oldPos, newPos);

	Spectators spectators;
	if (!teleport && oldPos.z == newPos.z) {
		int32_t minRangeX = MAP_MAX_VIEW_PORT_X;
		int32_t maxRangeX = MAP_MAX_VIEW_PORT_X;
		int32_t minRangeY = MAP_MAX_VIEW_PORT_Y;
		int32_t maxRangeY = MAP_MAX_VIEW_PORT_Y;

		if (oldPos.y > newPos.y) {
			++minRangeY;
		} else if (oldPos.y < newPos.y) {
			++maxRangeY;
		}

		if (oldPos.x < newPos.x) {
			++maxRangeX;
		} else if (oldPos.x > newPos.x) {
			++minRangeX;
		}

		spectators.find<Creature>(oldPos, true, minRangeX, maxRangeX, minRangeY, maxRangeY, false);
	} else {
		spectators.find<Creature>(oldPos, true, 0, 0, 0, 0, false);
		spectators.find<Creature>(newPos, true, 0, 0, 0, 0, false);
	}

	std::vector<Player*> playerSpectators;
	playerSpectators.reserve(spectators.size());
	for (const auto &spectator : spectators) {
		if (auto* player = spectator->getPlayerRaw()) {
			playerSpectators.emplace_back(player);
		}
	}

	std::vector<int32_t> oldStackPosVector;
	oldStackPosVector.reserve(playerSpectators.size());
	for (const auto* player : playerSpectators) {
		if (player->canSeeCreature(creature)) {
			oldStackPosVector.push_back(oldTile->getClientIndexOfCreature(player, creature));
		} else {
			oldStackPosVector.push_back(-1);
		}
	}

	// remove the creature
	oldTile->removeThing(creature, 0);

	MapSector* old_sector = getMapSector(oldPos.x, oldPos.y);
	MapSector* new_sector = getMapSector(newPos.x, newPos.y);

	// Switch the node ownership
	if (old_sector != new_sector) {
		old_sector->removeCreature(creature);
		new_sector->addCreature(creature);
	}

	// add the creature
	newTile->addThing(creature);

	if (!teleport) {
		if (oldPos.y > newPos.y) {
			creature->setDirection(DIRECTION_NORTH);
		} else if (oldPos.y < newPos.y) {
			creature->setDirection(DIRECTION_SOUTH);
		}

		if (oldPos.x < newPos.x) {
			creature->setDirection(DIRECTION_EAST);
		} else if (oldPos.x > newPos.x) {
			creature->setDirection(DIRECTION_WEST);
		}
	}

	// send to client
	size_t i = 0;
	for (const auto* player : playerSpectators) {
		// Use the correct stackpos
		const int32_t stackpos = oldStackPosVector[i++];
		if (stackpos != -1) {
			player->sendCreatureMove(creature, newPos, newTile->getClientIndexOfCreature(player, creature), oldPos, stackpos, teleport);
		}
	}

	// event method
	for (const auto &spectator : spectators) {
		spectator->onCreatureMove(creature, newTile, newPos, oldTile, oldPos, teleport);
	}

	std::function<void()> events = [creature, oldTile, newTile] {
		oldTile->postRemoveNotification(creature, newTile, 0);
		newTile->postAddNotification(creature, oldTile, 0);
		g_game().afterCreatureZoneChange(creature, oldTile->getZones(), newTile->getZones());
	};

	if (g_dispatcher().context().isMovementCommit()) {
		// Monster movement observers enqueue barrier-parallel work, so post-move actions stay deferred.
		if (!g_dispatcher().addEvent(std::move(events), "Map::moveCreature")) {
			events();
		}
	} else {
		events();
	}

	if (forceTeleport) {
		if (auto* player = creature->getPlayerRaw()) {
			player->sendMagicEffect(oldPos, CONST_ME_TELEPORT);
			player->sendMagicEffect(newPos, CONST_ME_TELEPORT);
		}
	}
}

bool Map::canThrowObjectTo(const Position &fromPos, const Position &toPos, const SightLines_t lineOfSight /*= SightLine_CheckSightLine*/, const int32_t rangex /*= Map::maxClientViewportX*/, const int32_t rangey /*= Map::maxClientViewportY*/) {
	// z checks
	// underground 8->15
	// ground level and above 7->0
	if ((fromPos.z >= 8 && toPos.z <= MAP_INIT_SURFACE_LAYER) || (toPos.z >= MAP_INIT_SURFACE_LAYER + 1 && fromPos.z <= MAP_INIT_SURFACE_LAYER)) {
		return false;
	}

	const int32_t deltaz = Position::getDistanceZ(fromPos, toPos);
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

	if (!(lineOfSight & SightLine_CheckSightLine)) {
		return true;
	}

	return isSightClear(fromPos, toPos, lineOfSight & SightLine_FloorCheck);
}

bool Map::checkSightLine(Position start, Position destination) {
	if (start.x == destination.x && start.y == destination.y) {
		return true;
	}

	int32_t distanceX = Position::getDistanceX(start, destination);
	int32_t distanceY = Position::getDistanceY(start, destination);

	if (start.y == destination.y) {
		// Horizontal line
		const uint16_t delta = start.x < destination.x ? 0x0001 : 0xFFFF;
		while (--distanceX > 0) {
			start.x += delta;

			const auto &tile = getTile(start.x, start.y, start.z);
			if (tile && tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
				return false;
			}
		}
	} else if (start.x == destination.x) {
		// Vertical line
		const uint16_t delta = start.y < destination.y ? 0x0001 : 0xFFFF;
		while (--distanceY > 0) {
			start.y += delta;

			const auto &tile = getTile(start.x, start.y, start.z);
			if (tile && tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
				return false;
			}
		}
	} else {
		// Xiaolin Wu's line algorithm - https://en.wikipedia.org/wiki/Xiaolin_Wu%27s_line_algorithm
		// based on Michael Abrash's implementation - https://www.amazon.com/gp/product/1576101746/102-5103244-8168911
		uint16_t eAdj;
		uint16_t eAcc = 0;
		uint16_t deltaX = 0x0001;
		uint16_t deltaY = 0x0001;

		if (distanceY > distanceX) {
			eAdj = (static_cast<uint32_t>(distanceX) << 16) / static_cast<uint32_t>(distanceY);

			if (start.y > destination.y) {
				std::swap(start.x, destination.x);
				std::swap(start.y, destination.y);
			}
			if (start.x > destination.x) {
				deltaX = 0xFFFF;
				eAcc -= eAdj;
			}

			while (--distanceY > 0) {
				uint16_t xIncrease = 0;
				const uint16_t eAccTemp = eAcc;
				eAcc += eAdj;
				if (eAcc <= eAccTemp) {
					xIncrease = deltaX;
				}

				const auto &tile = getTile(start.x + xIncrease, start.y + deltaY, start.z);
				if (tile && tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
					if (Position::areInRange<1, 1>(start, destination)) {
						return true;
					}
					return false;
				}

				start.x += xIncrease;
				start.y += deltaY;
			}
		} else {
			eAdj = (static_cast<uint32_t>(distanceY) << 16) / static_cast<uint32_t>(distanceX);

			if (start.x > destination.x) {
				std::swap(start.x, destination.x);
				std::swap(start.y, destination.y);
			}
			if (start.y > destination.y) {
				deltaY = 0xFFFF;
				eAcc -= eAdj;
			}

			while (--distanceX > 0) {
				uint16_t yIncrease = 0;
				const uint16_t eAccTemp = eAcc;
				eAcc += eAdj;
				if (eAcc <= eAccTemp) {
					yIncrease = deltaY;
				}

				const auto &tile = getTile(start.x + deltaX, start.y + yIncrease, start.z);
				if (tile && tile->hasProperty(CONST_PROP_BLOCKPROJECTILE)) {
					if (Position::areInRange<1, 1>(start, destination)) {
						return true;
					}
					return false;
				}

				start.x += deltaX;
				start.y += yIncrease;
			}
		}
	}
	return true;
}

bool Map::isSightClear(const Position &fromPos, const Position &toPos, bool floorCheck) {
	// Check if this sight line should be even possible
	if (floorCheck && fromPos.z != toPos.z) {
		return false;
	}

	// Check if we even need to perform line checking
	if (fromPos.z == toPos.z && (Position::areInRange<1, 1>(fromPos, toPos) || (!floorCheck && fromPos.z == 0))) {
		return true;
	}

	// We can only throw one floor up
	if (fromPos.z > toPos.z && Position::getDistanceZ(fromPos, toPos) > 1) {
		return false;
	}

	// Perform check for current floor
	const bool sightClear = checkSightLine(fromPos, toPos);
	if (floorCheck || (fromPos.z == toPos.z && sightClear)) {
		return sightClear;
	}

	uint8_t startZ;
	if (sightClear && (fromPos.z < toPos.z || fromPos.z == toPos.z)) {
		startZ = fromPos.z;
	} else {
		// Check if we can throw above obstacle
		const auto &tile = getTile(fromPos.x, fromPos.y, fromPos.z - 1);
		if ((tile && (tile->getGround() || tile->hasProperty(CONST_PROP_BLOCKPROJECTILE))) || !checkSightLine(Position(fromPos.x, fromPos.y, fromPos.z - 1), Position(toPos.x, toPos.y, toPos.z - 1))) {
			return false;
		}

		// We can throw above obstacle
		if (fromPos.z > toPos.z) {
			return true;
		}

		startZ = fromPos.z - 1;
	}

	// now we need to perform a jump between floors to see if everything is clear (literally)
	for (; startZ != toPos.z; ++startZ) {
		const auto &tile = getTile(toPos.x, toPos.y, startZ);
		if (tile && (tile->getGround() || tile->hasProperty(CONST_PROP_BLOCKPROJECTILE))) {
			return false;
		}
	}
	return true;
}

std::shared_ptr<Tile> Map::canWalkTo(const std::shared_ptr<Creature> &creature, const Position &pos) {
	if (!creature || creature->isRemoved()) {
		return nullptr;
	}

	MapCacheFloorCursor floorCursor;
	return getPathfindingTile(*this, creature, creature->getTile(), pos, floorCursor);
}

bool Map::getPathMatching(const std::shared_ptr<Creature> &creature, const Position &_targetPos, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
	static int_fast32_t allNeighbors[8][2] = {
		{ -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 }
	};

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

	const bool withoutCreature = creature == nullptr;
	if (!withoutCreature && creature->isRemoved()) {
		return false;
	}

	Position pos = withoutCreature ? _targetPos : creature->getPosition();
	Position endPos;
	MapCacheFloorCursor floorCursor;

	const auto creatureTile = withoutCreature ? std::shared_ptr<Tile>() : creature->getTile();
	const auto startTile = withoutCreature || !creatureTile ? getTileWithFloorCursor(pos.x, pos.y, pos.z, floorCursor) : creatureTile;
	AStarNodes nodes(pos.x, pos.y, AStarNodes::getTileWalkCost(creature, startTile));

	int32_t bestMatch = 0;

	const auto &startPos = pos;
	const auto &targetPos = withoutCreature ? pathCondition.getTargetPos() : _targetPos;

	const int_fast32_t sX = std::abs(targetPos.getX() - pos.getX());
	const int_fast32_t sY = std::abs(targetPos.getY() - pos.getY());

	uint_fast16_t cntDirs = 0;

	const AStarNode* found = nullptr;
	do {
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

		++cntDirs;

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
			} else if (offset_x == 0) {
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
			dirCount = 5;
		} else {
			dirCount = 8;
			neighbors = *allNeighbors;
		}

		const int_fast32_t f = n->f;
		for (uint_fast32_t i = 0; i < dirCount; ++i) {
			pos.x = x + *neighbors++;
			pos.y = y + *neighbors++;

			int_fast32_t extraCost;
			AStarNode* neighborNode = nodes.getNodeByPosition(pos.x, pos.y);
			if (neighborNode) {
				extraCost = neighborNode->c;
			} else {
				const auto &tile = withoutCreature ? getTileWithFloorCursor(pos.x, pos.y, pos.z, floorCursor) : getPathfindingTile(*this, creature, creatureTile, pos, floorCursor);
				if (!tile) {
					continue;
				}
				extraCost = AStarNodes::getTileWalkCost(creature, tile);
			}

			// The cost (g) for this neighbor
			const int_fast32_t cost = AStarNodes::getMapWalkCost(n, pos);
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
				const int_fast32_t dX = std::abs(targetPos.getX() - pos.getX());
				const int_fast32_t dY = std::abs(targetPos.getY() - pos.getY());
				if (!nodes.createOpenNode(n, pos.x, pos.y, newf, ((dX - sX) << 3) + ((dY - sY) << 3) + (std::max(dX, dY) << 3), extraCost)) {
					if (found) {
						break;
					}
					return false;
				}
			}
		}
		nodes.closeNode(n);
	} while (nodes.getClosedNodes() < 100);
	if (!found) {
		return false;
	}

	int_fast32_t prevx = endPos.x;
	int_fast32_t prevy = endPos.y;

	dirList.reserve(cntDirs);

	found = found->parent;
	while (found) {
		pos.x = found->x;
		pos.y = found->y;

		const int_fast32_t dx = pos.getX() - prevx;
		const int_fast32_t dy = pos.getY() - prevy;

		prevx = pos.x;
		prevy = pos.y;
		if (dx == 1) {
			if (dy == 1) {
				dirList.emplace_back(DIRECTION_NORTHWEST);
			} else if (dy == -1) {
				dirList.emplace_back(DIRECTION_SOUTHWEST);
			} else {
				dirList.emplace_back(DIRECTION_WEST);
			}
		} else if (dx == -1) {
			if (dy == 1) {
				dirList.emplace_back(DIRECTION_NORTHEAST);
			} else if (dy == -1) {
				dirList.emplace_back(DIRECTION_SOUTHEAST);
			} else {
				dirList.emplace_back(DIRECTION_EAST);
			}
		} else if (dy == 1) {
			dirList.emplace_back(DIRECTION_NORTH);
		} else if (dy == -1) {
			dirList.emplace_back(DIRECTION_SOUTH);
		}
		found = found->parent;
	}

	return true;
}

bool Map::getPathMatching(const std::shared_ptr<Creature> &creature, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
	return getPathMatching(creature, creature->getPosition(), dirList, pathCondition, fpp);
}

bool Map::getPathMatchingCond(const std::shared_ptr<Creature> &creature, const Position &targetPos, std::vector<Direction> &dirList, const FrozenPathingConditionCall &pathCondition, const FindPathParams &fpp) {
	if (!creature || creature->isRemoved()) {
		return false;
	}

	Position pos = creature->getPosition();
	Position endPos;
	MapCacheFloorCursor floorCursor;

	const auto creatureTile = creature->getTile();
	const auto startTile = creatureTile ? creatureTile : getTileWithFloorCursor(pos.x, pos.y, pos.z, floorCursor);
	AStarNodes nodes(pos.x, pos.y, AStarNodes::getTileWalkCost(creature, startTile));

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

	const int_fast32_t sX = std::abs(targetPos.getX() - pos.getX());
	const int_fast32_t sY = std::abs(targetPos.getY() - pos.getY());

	uint_fast16_t cntDirs = 0;

	const AStarNode* found = nullptr;
	do {
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

		++cntDirs;

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
			} else if (offset_x == 0) {
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
			dirCount = 5;
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

			int_fast32_t extraCost;
			AStarNode* neighborNode = nodes.getNodeByPosition(pos.x, pos.y);
			if (neighborNode) {
				extraCost = neighborNode->c;
			} else {
				const auto &tile = getPathfindingTile(*this, creature, creatureTile, pos, floorCursor);
				if (!tile) {
					continue;
				}
				extraCost = AStarNodes::getTileWalkCost(creature, tile);
			}

			// The cost (g) for this neighbor
			const int_fast32_t cost = AStarNodes::getMapWalkCost(n, pos);
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
				const int_fast32_t dX = std::abs(targetPos.getX() - pos.getX());
				const int_fast32_t dY = std::abs(targetPos.getY() - pos.getY());
				if (!nodes.createOpenNode(n, pos.x, pos.y, newf, ((dX - sX) << 3) + ((dY - sY) << 3) + (std::max(dX, dY) << 3), extraCost)) {
					if (found) {
						break;
					}
					return false;
				}
			}
		}
		nodes.closeNode(n);
	} while (fpp.maxSearchDist != 0 || nodes.getClosedNodes() < 100);

	if (!found) {
		return false;
	}

	int_fast32_t prevx = endPos.x;
	int_fast32_t prevy = endPos.y;

	dirList.reserve(cntDirs);

	found = found->parent;
	while (found) {
		pos.x = found->x;
		pos.y = found->y;

		const int_fast32_t dx = pos.getX() - prevx;
		const int_fast32_t dy = pos.getY() - prevy;

		prevx = pos.x;
		prevy = pos.y;
		if (dx == 1) {
			if (dy == 1) {
				dirList.emplace_back(DIRECTION_NORTHWEST);
			} else if (dy == -1) {
				dirList.emplace_back(DIRECTION_SOUTHWEST);
			} else {
				dirList.emplace_back(DIRECTION_WEST);
			}
		} else if (dx == -1) {
			if (dy == 1) {
				dirList.emplace_back(DIRECTION_NORTHEAST);
			} else if (dy == -1) {
				dirList.emplace_back(DIRECTION_SOUTHEAST);
			} else {
				dirList.emplace_back(DIRECTION_EAST);
			}
		} else if (dy == 1) {
			dirList.emplace_back(DIRECTION_NORTH);
		} else if (dy == -1) {
			dirList.emplace_back(DIRECTION_SOUTH);
		}
		found = found->parent;
	}

	return true;
}

uint32_t Map::clean() const {
	const uint64_t start = OTSYS_TIME();
	size_t qntTiles = 0;

	if (g_game().getGameState() == GAME_STATE_NORMAL) {
		g_game().setGameState(GAME_STATE_MAINTAIN);
	}

	ItemVector toRemove;
	toRemove.reserve(128);

	for (const auto &tile : g_game().getTilesToClean()) {
		if (!tile) {
			continue;
		}

		if (const auto &items = tile->getItemList()) {
			++qntTiles;
			for (const auto &item : *items) {
				if (item->isCleanable()) {
					toRemove.emplace_back(item);
				}
			}
		}
	}

	const size_t count = toRemove.size();
	for (const auto &item : toRemove) {
		g_game().internalRemoveItem(item, -1);
	}

	g_game().clearTilesToClean();

	if (g_game().getGameState() == GAME_STATE_MAINTAIN) {
		g_game().setGameState(GAME_STATE_NORMAL);
	}

	const uint64_t end = OTSYS_TIME();
	g_logger().info("CLEAN: Removed {} item{} from {} tile{} in {} seconds", count, (count != 1 ? "s" : ""), qntTiles, (qntTiles != 1 ? "s" : ""), (end - start) / (1000.f));
	return count;
}
