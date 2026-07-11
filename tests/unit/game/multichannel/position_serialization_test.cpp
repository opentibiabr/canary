/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "game/multichannel/position_serialization.hpp"

#include <gtest/gtest.h>

TEST(PositionSerializationTest, FormatProducesCommaSeparatedTriplet) {
	EXPECT_EQ("1000,2000,7", multichannel::formatPosition(Position(1000, 2000, 7)));
	EXPECT_EQ("0,0,0", multichannel::formatPosition(Position(0, 0, 0)));
}

TEST(PositionSerializationTest, RoundTripsThroughFormatAndParse) {
	const Position original(12345, 54321, 15);
	const auto formatted = multichannel::formatPosition(original);
	const auto parsed = multichannel::parsePosition(formatted);
	ASSERT_TRUE(parsed.has_value());
	EXPECT_EQ(original.x, parsed->x);
	EXPECT_EQ(original.y, parsed->y);
	EXPECT_EQ(original.z, parsed->z);
}

TEST(PositionSerializationTest, ParsesMaxBoundaryValues) {
	const auto parsed = multichannel::parsePosition("65535,65535,255");
	ASSERT_TRUE(parsed.has_value());
	EXPECT_EQ(65535, parsed->x);
	EXPECT_EQ(65535, parsed->y);
	EXPECT_EQ(255, parsed->z);
}

TEST(PositionSerializationTest, RejectsTooFewComponents) {
	EXPECT_FALSE(multichannel::parsePosition("100,200").has_value());
}

TEST(PositionSerializationTest, RejectsTooManyComponents) {
	EXPECT_FALSE(multichannel::parsePosition("100,200,7,8").has_value());
}

TEST(PositionSerializationTest, RejectsNonNumericComponent) {
	EXPECT_FALSE(multichannel::parsePosition("100,abc,7").has_value());
}

TEST(PositionSerializationTest, RejectsOutOfRangeComponent) {
	EXPECT_FALSE(multichannel::parsePosition("70000,200,7").has_value());
	EXPECT_FALSE(multichannel::parsePosition("100,200,300").has_value());
}

TEST(PositionSerializationTest, RejectsNegativeComponent) {
	EXPECT_FALSE(multichannel::parsePosition("-1,200,7").has_value());
}

TEST(PositionSerializationTest, RejectsEmptyString) {
	EXPECT_FALSE(multichannel::parsePosition("").has_value());
}

TEST(PositionSerializationTest, RejectsTrailingGarbageInComponent) {
	EXPECT_FALSE(multichannel::parsePosition("100,200,7x").has_value());
}
