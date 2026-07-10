/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "map/navigation_snapshot.hpp"
#include "map/utils/mapsector.hpp"

TEST(NavigationSnapshotTest, ResolvesCellsOnlyInsideTheCapturedRegion) {
	constexpr uint16_t centerX = 100;
	constexpr uint16_t centerY = 100;
	constexpr uint8_t z = 7;
	constexpr uint32_t sectorIndex = (centerX / SECTOR_SIZE) | ((centerY / SECTOR_SIZE) << 16);

	NavSectorSnapshot::Cells cells;
	auto &expectedCell = cells[(centerX & SECTOR_MASK) * SECTOR_SIZE + ((centerY + 1) & SECTOR_MASK)];
	expectedCell.flags = NavCellFlag::HasGround | NavCellFlag::BlockSolid;
	expectedCell.groundId = 4526;

	auto sector = std::make_shared<const NavSectorSnapshot>(sectorIndex, z, 11, 19, std::move(cells));
	NavRegionSnapshot region(3, Position(centerX, centerY, z), 4, { sector });

	const auto* cell = region.getCell(Position(centerX, static_cast<uint16_t>(centerY + 1), z));
	ASSERT_NE(cell, nullptr);
	EXPECT_EQ(cell->groundId, 4526);
	EXPECT_TRUE(cell->hasFlag(NavCellFlag::HasGround));
	EXPECT_TRUE(cell->hasFlag(NavCellFlag::BlockSolid));
	EXPECT_EQ(region.getCell(Position(centerX + 5, centerY, z)), nullptr);
	EXPECT_EQ(region.getCell(Position(centerX, centerY, z + 1)), nullptr);
}

TEST(NavigationSnapshotTest, TracksTopologyAndOccupancyIndependently) {
	MapSector sector;
	EXPECT_EQ(sector.getTopologyRevision(7), 1);
	EXPECT_EQ(sector.getOccupancyRevision(7), 1);

	EXPECT_EQ(sector.markTopologyChanged(7), 2);
	EXPECT_EQ(sector.getTopologyRevision(7), 2);
	EXPECT_EQ(sector.getOccupancyRevision(7), 1);

	EXPECT_EQ(sector.markOccupancyChanged(7), 2);
	EXPECT_EQ(sector.getTopologyRevision(7), 2);
	EXPECT_EQ(sector.getOccupancyRevision(7), 2);
}
