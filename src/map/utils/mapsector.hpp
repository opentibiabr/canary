/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "map/map_const.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <atomic>
	#include <cstdint>
#endif

class Creature;
class Tile;
struct BasicTile;

struct Floor {
	using TileGrid = std::array<std::array<std::shared_ptr<Tile>, SECTOR_SIZE>, SECTOR_SIZE>;
	using BasicTileGrid = std::array<std::array<const BasicTile*, SECTOR_SIZE>, SECTOR_SIZE>;

	struct TileAndCache {
		std::shared_ptr<Tile> tile;
		const BasicTile* cachedTile = nullptr;
	};

	explicit Floor(uint8_t z) :
		z(z) { }

	std::shared_ptr<Tile> getTile(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK];
	}

	// Reads both slots under one shared lock; callers must materialize cached
	// tiles after this lock has been released.
	TileAndCache getTileAndCache(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		const auto maskedX = x & SECTOR_MASK;
		const auto maskedY = y & SECTOR_MASK;
		return {
			.tile = tiles[maskedX][maskedY],
			.cachedTile = tileCache[maskedX][maskedY],
		};
	}

	void setTile(uint16_t x, uint16_t y, std::shared_ptr<Tile> tile) {
		tiles[x & SECTOR_MASK][y & SECTOR_MASK] = std::move(tile);
	}

	const BasicTile* getTileCache(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tileCache[x & SECTOR_MASK][y & SECTOR_MASK];
	}

	void setTileCache(uint16_t x, uint16_t y, const BasicTile* newTile) {
		tileCache[x & SECTOR_MASK][y & SECTOR_MASK] = newTile;
	}

	const auto &getTiles() const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles;
	}

	uint8_t getZ() const {
		return z;
	}

	auto &getMutex() const {
		return mutex;
	}

private:
	TileGrid tiles {};
	BasicTileGrid tileCache {};

	mutable std::shared_mutex mutex;

	uint8_t z { 0 };
};

class MapSector {
public:
	MapSector();

	MapSector(const MapSector &) = delete;
	MapSector &operator=(const MapSector &) = delete;
	MapSector(const MapSector &&) = delete;
	MapSector &operator=(const MapSector &&) = delete;

	std::shared_ptr<Floor> createFloor(uint32_t z) {
		if (z >= MAP_MAX_LAYERS) {
			g_logger().error("Attempt to create floor on invalid coordinate: {}", z);
			return nullptr;
		}
		std::scoped_lock lock(floors_mutex);
		if (!floors[z]) {
			floors[z] = std::make_shared<Floor>(static_cast<uint8_t>(z));
		}
		return floors[z];
	}

	std::shared_ptr<Floor> getFloor(uint8_t z) {
		if (z >= MAP_MAX_LAYERS) {
			g_logger().error("Attempt to get floor on invalid coordinate: {}", z);
			return nullptr;
		}
		std::scoped_lock lock(floors_mutex);
		return floors[z];
	}

	void addCreature(const std::shared_ptr<Creature> &c);

	void removeCreature(const std::shared_ptr<Creature> &c);

	uint64_t markTopologyChanged(uint8_t z);
	uint64_t markOccupancyChanged(uint8_t z);

	[[nodiscard]] uint64_t getTopologyRevision(uint8_t z) const {
		return z < MAP_MAX_LAYERS ? topologyRevisions[z].load(std::memory_order_relaxed) : 0;
	}

	[[nodiscard]] uint64_t getOccupancyRevision(uint8_t z) const {
		return z < MAP_MAX_LAYERS ? occupancyRevisions[z].load(std::memory_order_relaxed) : 0;
	}

private:
	static bool newSector;

	MapSector* sectorS = nullptr;
	MapSector* sectorE = nullptr;

	std::vector<std::shared_ptr<Creature>> creature_list;
	std::vector<std::shared_ptr<Creature>> player_list;
	std::vector<std::shared_ptr<Creature>> monster_list;
	std::vector<std::shared_ptr<Creature>> npc_list;

	mutable std::mutex floors_mutex;

	std::array<std::shared_ptr<Floor>, MAP_MAX_LAYERS> floors {};
	std::array<std::atomic_uint64_t, MAP_MAX_LAYERS> topologyRevisions {};
	std::array<std::atomic_uint64_t, MAP_MAX_LAYERS> occupancyRevisions {};

	uint32_t floorBits = 0;

	friend class Spectators;
	friend class MapCache;
};
