/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "game/movement/position.hpp"
#include "map/map_const.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <cstdint>
	#include <memory>
	#include <utility>
	#include <vector>
#endif

enum class NavCellFlag : uint16_t {
	None = 0,
	HasGround = 1 << 0,
	ProtectionZone = 1 << 1,
	FloorChange = 1 << 2,
	Teleport = 1 << 3,
	ImmovableBlockSolid = 1 << 4,
	ImmovableNoFieldBlockPath = 1 << 5,
	BlockSolid = 1 << 6,
	NoFieldBlockPath = 1 << 7,
	HarmfulField = 1 << 8,
	WalkableSea = 1 << 9,
	BlockProjectile = 1 << 10,
	FloorChangeWest = 1 << 11,
};

[[nodiscard]] constexpr NavCellFlag operator|(NavCellFlag left, NavCellFlag right) {
	return static_cast<NavCellFlag>(static_cast<uint16_t>(left) | static_cast<uint16_t>(right));
}

struct NavCell {
	NavCellFlag flags = NavCellFlag::None;
	uint32_t houseId = 0;
	uint16_t groundId = 0;
	uint8_t harmfulFieldCombatType = 0;
	uint8_t blockingCreatures = 0;
	uint8_t pushableMonsters = 0;
	bool hasNonInvisibleCreature = false;
	bool hasUnpushableCreature = false;

	[[nodiscard]] bool hasFlag(NavCellFlag flag) const {
		return (static_cast<uint16_t>(flags) & static_cast<uint16_t>(flag)) != 0;
	}
};

class NavSectorSnapshot {
public:
	using Cells = std::array<NavCell, SECTOR_SIZE * SECTOR_SIZE>;

	NavSectorSnapshot(uint32_t sectorIndex, uint8_t z, uint64_t topologyRevision, uint64_t occupancyRevision, Cells cells);

	[[nodiscard]] const NavCell* getCell(uint16_t x, uint16_t y, uint8_t z) const;
	[[nodiscard]] uint32_t getSectorIndex() const {
		return sectorIndex;
	}
	[[nodiscard]] uint8_t getZ() const {
		return z;
	}
	[[nodiscard]] uint64_t getTopologyRevision() const {
		return topologyRevision;
	}
	[[nodiscard]] uint64_t getOccupancyRevision() const {
		return occupancyRevision;
	}
	[[nodiscard]] const Cells &getCells() const {
		return cells;
	}

private:
	uint32_t sectorIndex = 0;
	uint8_t z = 0;
	uint64_t topologyRevision = 0;
	uint64_t occupancyRevision = 0;
	Cells cells {};
};

class NavRegionSnapshot {
public:
	using SectorList = std::vector<std::shared_ptr<const NavSectorSnapshot>>;

	NavRegionSnapshot(uint64_t epoch, Position center, uint8_t radius, SectorList sectors);

	[[nodiscard]] const NavCell* getCell(const Position &position) const;
	[[nodiscard]] uint64_t getEpoch() const {
		return epoch;
	}
	[[nodiscard]] const Position &getCenter() const {
		return center;
	}
	[[nodiscard]] uint8_t getRadius() const {
		return radius;
	}
	[[nodiscard]] const SectorList &getSectors() const {
		return sectors;
	}

private:
	uint64_t epoch = 0;
	Position center;
	uint8_t radius = 0;
	SectorList sectors;
};
