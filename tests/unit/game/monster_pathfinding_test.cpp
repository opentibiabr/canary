/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/monsters/monster_pathfinding.hpp"

#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <functional>
#endif

namespace {
	using CellModifier = std::function<void(const Position &, NavCell &)>;

	std::shared_ptr<const NavRegionSnapshot> makeNavigation(const Position &center, uint8_t radius, const CellModifier &modifier = {}) {
		const auto firstSectorX = static_cast<uint32_t>(center.x - radius) / SECTOR_SIZE;
		const auto firstSectorY = static_cast<uint32_t>(center.y - radius) / SECTOR_SIZE;
		const auto lastSectorX = static_cast<uint32_t>(center.x + radius) / SECTOR_SIZE;
		const auto lastSectorY = static_cast<uint32_t>(center.y + radius) / SECTOR_SIZE;
		NavRegionSnapshot::SectorList sectors;

		for (uint32_t sectorY = firstSectorY; sectorY <= lastSectorY; ++sectorY) {
			for (uint32_t sectorX = firstSectorX; sectorX <= lastSectorX; ++sectorX) {
				NavSectorSnapshot::Cells cells;
				for (uint32_t localX = 0; localX < SECTOR_SIZE; ++localX) {
					for (uint32_t localY = 0; localY < SECTOR_SIZE; ++localY) {
						Position position(static_cast<uint16_t>(sectorX * SECTOR_SIZE + localX), static_cast<uint16_t>(sectorY * SECTOR_SIZE + localY), center.z);
						auto &cell = cells[localX * SECTOR_SIZE + localY];
						cell.flags = NavCellFlag::HasGround;
						cell.groundId = 4526;
						if (modifier) {
							modifier(position, cell);
						}
					}
				}

				const auto sectorIndex = sectorX | (sectorY << 16);
				sectors.emplace_back(std::make_shared<const NavSectorSnapshot>(sectorIndex, center.z, 1, 1, std::move(cells)));
			}
		}
		return std::make_shared<const NavRegionSnapshot>(1, center, radius, std::move(sectors));
	}

	MonsterPathRequest makeRequest(std::shared_ptr<const NavRegionSnapshot> navigation, Position start, Position target) {
		MonsterPathRequest request;
		request.navigation = std::move(navigation);
		request.start = start;
		request.target = target;
		request.params.fullPathSearch = true;
		request.params.clearSight = false;
		request.params.maxSearchDist = request.navigation->getRadius();
		request.params.minTargetDist = 1;
		request.params.maxTargetDist = 1;
		return request;
	}

	std::vector<Position> expandPath(const MonsterPathRequest &request, const MonsterPathResult &result) {
		std::vector<Position> positions;
		Position position = request.start;
		for (auto it = result.directions.rbegin(); it != result.directions.rend(); ++it) {
			position = getNextPosition(*it, position);
			positions.emplace_back(position);
		}
		return positions;
	}
}

TEST(MonsterPathfinderTest, FindsAValidBoundedFollowPath) {
	const Position start(100, 100, 7);
	const Position target(106, 100, 7);
	auto request = makeRequest(makeNavigation(start, 12), start, target);

	const auto result = MonsterPathfinder::find(request);
	ASSERT_TRUE(result.found());
	EXPECT_FALSE(result.directions.empty());
	EXPECT_EQ(Position::getDiagonalDistance(result.endpoint, target), 1);

	const auto positions = expandPath(request, result);
	ASSERT_FALSE(positions.empty());
	EXPECT_EQ(positions.back(), result.endpoint);
	for (const auto &position : positions) {
		const auto* cell = request.navigation->getCell(position);
		ASSERT_NE(cell, nullptr);
		EXPECT_TRUE(MonsterPathfinder::canEnter(*cell, request.traits));
		EXPECT_LE(Position::getDistanceX(start, position), 12);
		EXPECT_LE(Position::getDistanceY(start, position), 12);
	}
}

TEST(MonsterPathfinderTest, RoutesAroundTopologyAndOccupancyBlockers) {
	const Position start(100, 100, 7);
	const Position target(106, 100, 7);
	auto navigation = makeNavigation(start, 12, [](const Position &position, NavCell &cell) {
		if (position.x == 102 && position.y != 101) {
			cell.flags = cell.flags | NavCellFlag::BlockSolid;
		}
		if (position.x == 101 && position.y == 100) {
			cell.blockingCreatures = 1;
		}
	});
	auto request = makeRequest(navigation, start, target);

	const auto result = MonsterPathfinder::find(request);
	ASSERT_TRUE(result.found());
	const auto positions = expandPath(request, result);
	for (const auto &position : positions) {
		const auto* cell = navigation->getCell(position);
		ASSERT_NE(cell, nullptr);
		EXPECT_FALSE(cell->hasFlag(NavCellFlag::BlockSolid));
		EXPECT_EQ(cell->blockingCreatures, 0);
	}
}

TEST(MonsterPathfinderTest, AppliesMonsterSpecificTileContracts) {
	NavCell cell;
	cell.flags = NavCellFlag::HasGround | NavCellFlag::ProtectionZone;
	MonsterPathTraits traits;
	EXPECT_FALSE(MonsterPathfinder::canEnter(cell, traits));

	traits.canEnterProtectionZone = true;
	EXPECT_TRUE(MonsterPathfinder::canEnter(cell, traits));

	cell.flags = NavCellFlag::HasGround | NavCellFlag::WalkableSea;
	traits.isSummon = true;
	EXPECT_FALSE(MonsterPathfinder::canEnter(cell, traits));

	traits.isSummon = false;
	cell.flags = NavCellFlag::HasGround;
	cell.blockingCreatures = 1;
	cell.pushableMonsters = 1;
	traits.canPushCreatures = true;
	EXPECT_TRUE(MonsterPathfinder::canEnter(cell, traits));
	cell.hasUnpushableCreature = true;
	EXPECT_FALSE(MonsterPathfinder::canEnter(cell, traits));

	cell.flags = NavCellFlag::HasGround | NavCellFlag::HarmfulField;
	cell.blockingCreatures = 0;
	cell.pushableMonsters = 0;
	cell.hasUnpushableCreature = false;
	cell.harmfulFieldCombatType = COMBAT_FIREDAMAGE;
	EXPECT_FALSE(MonsterPathfinder::canEnter(cell, traits));
	traits.fieldAllowed[COMBAT_FIREDAMAGE] = true;
	EXPECT_TRUE(MonsterPathfinder::canEnter(cell, traits));

	cell.flags = NavCellFlag::HasGround;
	cell.houseId = 42;
	traits.isSummon = true;
	EXPECT_FALSE(MonsterPathfinder::canEnter(cell, traits));
	traits.summonInvitedHouseIds.emplace_back(42);
	EXPECT_TRUE(MonsterPathfinder::canEnter(cell, traits));
}

TEST(MonsterPathfinderTest, UsesSnapshotProjectileTopologyForLineOfSight) {
	const Position start(100, 100, 7);
	const Position target(106, 100, 7);
	auto navigation = makeNavigation(start, 12, [](const Position &position, NavCell &cell) {
		if (position.x == 103 && position.y == 100) {
			cell.flags = cell.flags | NavCellFlag::BlockProjectile;
		}
	});

	EXPECT_FALSE(MonsterPathfinder::isSightClear(*navigation, start, target));
	EXPECT_TRUE(MonsterPathfinder::isSightClear(*navigation, start, Position(101, 100, 7)));
}

TEST(MonsterPathfinderTest, HonorsCancellationBeforeSearch) {
	const Position start(100, 100, 7);
	auto request = makeRequest(makeNavigation(start, 12), start, Position(106, 100, 7));
	std::stop_source stopSource;
	stopSource.request_stop();

	const auto result = MonsterPathfinder::find(request, stopSource.get_token());
	EXPECT_EQ(result.status, MonsterPathStatus::Cancelled);
	EXPECT_TRUE(result.directions.empty());
}
