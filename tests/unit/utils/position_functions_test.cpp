#include "pch.hpp"

#include <gtest/gtest.h>

#include "game/movement/position.hpp"
#include "utils/tools.hpp"

struct GetDirectionToTestCase {
	Position from;
	Position to;
	Direction expected;
	Direction expectedForExactDiagonal;
	std::string description;
};

class GetDirectionToTest : public ::testing::TestWithParam<GetDirectionToTestCase> { };

TEST_P(GetDirectionToTest, ReturnsExpectedDirections) {
	const auto &testCase = GetParam();
	SCOPED_TRACE(testCase.description);

	auto result = getDirectionTo(testCase.from, testCase.to);
	EXPECT_EQ(testCase.expectedForExactDiagonal, result);

	result = getDirectionTo(testCase.from, testCase.to, false);
	EXPECT_EQ(testCase.expected, result);
}

static const std::vector<GetDirectionToTestCase> kGetDirectionToTestCases {
	{ Position {}, Position {}, DIRECTION_NONE, DIRECTION_NONE, "origin" },
	{ Position { 0, 0, 0 }, Position { 0, 0, 0 }, DIRECTION_NONE, DIRECTION_NONE, "zero" },
	{ Position { 100, 100, 100 }, Position { 100, 100, 100 }, DIRECTION_NONE, DIRECTION_NONE, "same coords" },
	{ Position { 125, 1123, 5 }, Position { 125, 1153, 5 }, DIRECTION_SOUTH, DIRECTION_SOUTH, "south" },
	{ Position { 5555, 3212, 15 }, Position { 5555, 3211, 15 }, DIRECTION_NORTH, DIRECTION_NORTH, "north" },
	{ Position { 32132, 65000, 11 }, Position { 31512, 65000, 11 }, DIRECTION_WEST, DIRECTION_WEST, "west" },
	{ Position { 5123, 6554, 7 }, Position { 40000, 6554, 7 }, DIRECTION_EAST, DIRECTION_EAST, "east" },
	{ Position { 25200, 33173, 8 }, Position { 5200, 13173, 7 }, DIRECTION_NORTHWEST, DIRECTION_NORTHWEST, "northwest far" },
	{ Position { 22137, 6, 9 }, Position { 22141, 2, 15 }, DIRECTION_NORTHEAST, DIRECTION_NORTHEAST, "northeast far" },
	{ Position { 32011, 2197, 1 }, Position { 32135, 2321, 13 }, DIRECTION_SOUTHEAST, DIRECTION_SOUTHEAST, "southeast far" },
	{ Position { 13121, 5213, 5 }, Position { 5213, 13121, 5 }, DIRECTION_SOUTHWEST, DIRECTION_SOUTHWEST, "southwest far" },
	{ Position { 123, 122, 0 }, Position { 0, 0, 0 }, DIRECTION_NORTHWEST, DIRECTION_WEST, "northwest bias west" },
	{ Position { 122, 123, 0 }, Position { 0, 0, 0 }, DIRECTION_NORTHWEST, DIRECTION_NORTH, "northwest bias north" },
	{ Position { 0, 122, 0 }, Position { 123, 0, 0 }, DIRECTION_NORTHEAST, DIRECTION_EAST, "northeast bias east" },
	{ Position { 0, 123, 0 }, Position { 122, 0, 0 }, DIRECTION_NORTHEAST, DIRECTION_NORTH, "northeast bias north" },
	{ Position { 0, 0, 0 }, Position { 123, 122, 0 }, DIRECTION_SOUTHEAST, DIRECTION_EAST, "southeast bias east" },
	{ Position { 0, 0, 0 }, Position { 122, 123, 0 }, DIRECTION_SOUTHEAST, DIRECTION_SOUTH, "southeast bias south" },
	{ Position { 123, 0, 0 }, Position { 0, 122, 0 }, DIRECTION_SOUTHWEST, DIRECTION_WEST, "southwest bias west" },
	{ Position { 122, 0, 0 }, Position { 0, 123, 0 }, DIRECTION_SOUTHWEST, DIRECTION_SOUTH, "southwest bias south" },
};

INSTANTIATE_TEST_SUITE_P(
	GetDirectionTo,
	GetDirectionToTest,
	::testing::ValuesIn(kGetDirectionToTestCases),
	[](const ::testing::TestParamInfo<GetDirectionToTest::ParamType> &info) {
		return fmt::format("Case{}", info.index);
	}
);
