/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "map/map_const.hpp"

class Creature;
class Tile;
struct BasicTile;

struct Floor {
	explicit Floor(uint8_t z) :
		z(z) { }

	std::shared_ptr<Tile> getTile(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].first;
	}

	void setTile(uint16_t x, uint16_t y, std::shared_ptr<Tile> tile) {
		tiles[x & SECTOR_MASK][y & SECTOR_MASK].first = std::move(tile);
	}

	std::shared_ptr<BasicTile> getTileCache(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].second;
	}

	void setTileCache(uint16_t x, uint16_t y, const std::shared_ptr<BasicTile> &newTile) {
		tiles[x & SECTOR_MASK][y & SECTOR_MASK].second = newTile;
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
	std::pair<std::shared_ptr<Tile>, std::shared_ptr<BasicTile>> tiles[SECTOR_SIZE][SECTOR_SIZE] = {};

	mutable std::shared_mutex mutex;

	uint8_t z { 0 };
};

class MapSector {
public:
	MapSector() = default;

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

private:
	static bool newSector;

	MapSector* sectorS = nullptr;
	MapSector* sectorE = nullptr;

	std::vector<std::shared_ptr<Creature>> creature_list;
	std::vector<std::shared_ptr<Creature>> player_list;
	std::vector<std::shared_ptr<Creature>> monster_list;
	std::vector<std::shared_ptr<Creature>> npc_list;

	mutable std::mutex floors_mutex;

	std::shared_ptr<Floor> floors[MAP_MAX_LAYERS] = {};

	uint32_t floorBits = 0;

	friend class Spectators;
	friend class MapCache;
};
