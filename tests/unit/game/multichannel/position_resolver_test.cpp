/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/position_resolver.hpp"

#include <gtest/gtest.h>
#include <set>
#include <utility>

namespace {
	// Pure fake, no engine/DB dependency - exactly the abstraction
	// PositionResolver is designed against (see IPositionLegality).
	class FakeLegality : public IPositionLegality {
	public:
		std::set<std::pair<uint16_t, uint16_t>> blocked;
		std::set<std::pair<uint16_t, uint16_t>> inaccessibleHouses;
		std::set<std::pair<uint16_t, uint16_t>> restrictedInstances;
		std::set<std::pair<uint16_t, uint16_t>> noSwitchZones;
		std::set<std::pair<uint16_t, uint16_t>> specialEntry;

		[[nodiscard]] bool tileExists(const Position &p) const override {
			return !blocked.contains({ p.getX(), p.getY() });
		}
		[[nodiscard]] bool isInaccessibleHouse(const Position &p) const override {
			return inaccessibleHouses.contains({ p.getX(), p.getY() });
		}
		[[nodiscard]] bool isRestrictedInstance(const Position &p) const override {
			return restrictedInstances.contains({ p.getX(), p.getY() });
		}
		[[nodiscard]] bool isNoChannelSwitchZone(const Position &p) const override {
			return noSwitchZones.contains({ p.getX(), p.getY() });
		}
		[[nodiscard]] bool requiresSpecialEntryCondition(const Position &p) const override {
			return specialEntry.contains({ p.getX(), p.getY() });
		}
	};
} // namespace

TEST(PositionResolverTest, LegalSameTileIsAcceptedAsIs) {
	FakeLegality legality;
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 10;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_EQ(PositionResolutionReason::SamePosition, result.reason);
	EXPECT_EQ(input.requestedPosition, result.position);
}

TEST(PositionResolverTest, BlockedOriginFallsThroughToNearestTileSearch) {
	FakeLegality legality;
	legality.blocked.insert({ 100, 100 });
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 10;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_EQ(PositionResolutionReason::NearestPublicTile, result.reason);
	EXPECT_EQ(Position(99, 99, 7), result.position);
}

TEST(PositionResolverTest, HouseAccessDenialIsRespectedDuringSearch) {
	FakeLegality legality;
	for (int32_t dx = -3; dx <= 3; ++dx) {
		for (int32_t dy = -3; dy <= 3; ++dy) {
			legality.inaccessibleHouses.insert({ static_cast<uint16_t>(100 + dx), static_cast<uint16_t>(100 + dy) });
		}
	}
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.lastSafePosition = Position(50, 50, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 3;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_EQ(PositionResolutionReason::LastSafePosition, result.reason);
	EXPECT_EQ(Position(50, 50, 7), result.position);
}

TEST(PositionResolverTest, RestrictedInstanceIsRespectedDuringSearch) {
	FakeLegality legality;
	legality.restrictedInstances.insert({ 100, 100 });
	legality.restrictedInstances.insert({ 99, 99 });
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 1;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_NE(Position(99, 99, 7), result.position);
}

TEST(PositionResolverTest, NoChannelSwitchZoneIsRespected) {
	FakeLegality legality;
	legality.noSwitchZones.insert({ 100, 100 });
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 5;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_NE(PositionResolutionReason::SamePosition, result.reason);
}

TEST(PositionResolverTest, FallsBackToTempleWhenNothingElseWorks) {
	FakeLegality legality;
	for (int32_t dx = -2; dx <= 2; ++dx) {
		for (int32_t dy = -2; dy <= 2; ++dy) {
			legality.blocked.insert({ static_cast<uint16_t>(100 + dx), static_cast<uint16_t>(100 + dy) });
		}
	}
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 2;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_EQ(PositionResolutionReason::Temple, result.reason);
	EXPECT_EQ(input.templePosition, result.position);
}

TEST(PositionResolverTest, IllegalLastSafePositionIsNotTrustedBlindly) {
	FakeLegality legality;
	legality.blocked.insert({ 100, 100 });
	legality.blocked.insert({ 50, 50 });
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.lastSafePosition = Position(50, 50, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 0;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_EQ(PositionResolutionReason::Temple, result.reason);
}

TEST(PositionResolverTest, SearchRadiusIsHardCappedRegardlessOfInput) {
	FakeLegality legality;
	const auto found = PositionResolver::findNearestLegalTile(Position(100, 100, 7), 1'000'000, legality);
	ASSERT_TRUE(found.has_value());
	EXPECT_LE(std::abs(static_cast<int32_t>(found->getX()) - 100), PositionResolver::MaxSearchRadius);
	EXPECT_LE(std::abs(static_cast<int32_t>(found->getY()) - 100), PositionResolver::MaxSearchRadius);
}

TEST(PositionResolverTest, SearchNearCoordinateOriginDoesNotCrash) {
	FakeLegality legality;
	legality.blocked.insert({ 0, 0 });
	const auto found = PositionResolver::findNearestLegalTile(Position(0, 0, 7), 3, legality);
	EXPECT_TRUE(found.has_value());
}

TEST(PositionResolverTest, RequiresSpecialEntryConditionIsRespected) {
	FakeLegality legality;
	legality.specialEntry.insert({ 100, 100 });
	PositionResolutionInput input;
	input.requestedPosition = Position(100, 100, 7);
	input.templePosition = Position(0, 0, 7);
	input.searchRadius = 1;

	const auto result = PositionResolver::resolve(input, legality);
	EXPECT_NE(PositionResolutionReason::SamePosition, result.reason);
}
