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
#include "utils/worldpointer.hpp"

class Creature;
class Tile;
struct BasicTile;

struct Floor {
	explicit Floor(uint8_t z) :
		z(z) { }

	PolyPtr<Tile>::Borrowed getTile(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].first;
	}

	// Borrows the previous tile out atomically (under the same exclusive lock)
	// so callers can chain a swap-then-look-at-old without racing concurrent
	// readers. Returns the OLD owning, which the caller may move-assign or
	// allow to retire on scope exit.
	[[nodiscard]] PolyPtr<Tile>::Owning swapTile(uint16_t x, uint16_t y, PolyPtr<Tile>::Owning tile) {
		std::scoped_lock<std::shared_mutex> sl(mutex);
		auto &slot = tiles[x & SECTOR_MASK][y & SECTOR_MASK].first;
		auto prev = std::move(slot);
		slot = std::move(tile);
		return prev;
	}

	void setTile(uint16_t x, uint16_t y, PolyPtr<Tile>::Owning tile) {
		// Exclusive lock — `getTile` (and other readers like `getTiles`) take
		// shared_lock. Without this, an in-flight reader would observe a
		// half-updated `Owning` slot (header_/value_ pair).
		// std::scoped_lock<std::shared_mutex> sl(mutex);
		tiles[x & SECTOR_MASK][y & SECTOR_MASK].first = std::move(tile);
	}

	const BasicTile* getTileCache(uint16_t x, uint16_t y) const {
		std::shared_lock<std::shared_mutex> sl(mutex);
		return tiles[x & SECTOR_MASK][y & SECTOR_MASK].second;
	}

	void setTileCache(uint16_t x, uint16_t y, const BasicTile* newTile) {
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
	// `.second` is a non-owning raw pointer — the BasicTile is owned by
	// `MapCache::retainedBasicTiles` (vector of shared_ptr) for the
	// lifetime of the MapCache. Floor just observes.
	// NOSONAR(cpp:S5945) — fixed-size 2D C-array is the hot-path tile lookup
	// (constant-time, no bounds check, no allocator state). std::array of
	// std::array compiles to the same code but doesn't compose cleanly
	// with the surrounding pre-existing array idioms in this header.
	std::pair<PolyPtr<Tile>::Owning, const BasicTile*> tiles[SECTOR_SIZE][SECTOR_SIZE] = {};

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

	// NOSONAR(cpp:S5945) — fixed-size per-z floor array; see `tiles` above.
	std::shared_ptr<Floor> floors[MAP_MAX_LAYERS] = {};

	uint32_t floorBits = 0;

	friend class Spectators;
	friend class MapCache;
};
