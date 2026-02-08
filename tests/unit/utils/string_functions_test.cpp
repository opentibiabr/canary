/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/tools.hpp"

struct ReplaceStringTestCase {
	std::string subject;
	std::string search;
	std::string replace;
	std::string expected;
	std::string description;
};

class ReplaceStringTest : public ::testing::TestWithParam<ReplaceStringTestCase> { };

TEST_P(ReplaceStringTest, ReplacesStrings) {
	auto testCase = GetParam();
	SCOPED_TRACE(testCase.description);
	replaceString(testCase.subject, testCase.search, testCase.replace);
	EXPECT_EQ(testCase.expected, testCase.subject);
}

static const std::vector<ReplaceStringTestCase> kReplaceStringTestCases {
	{ "", "", "", "", "empty" },
	{ "subject", "", "x", "subject" },
	{ "all together", " ", "_", "all_together", "spaces" },
	{ "beautiful", "u", "", "beatifl", "remove char" },
	{ "empty_empty_empty_", "empty_", "", "", "remove substr" },
	{ "I am someone", "someone", "Lucas", "I am Lucas", "replace word" },
	{ "[[123[[[[[[124[[asf[[ccc[[[", "[[", "\\[[", "\\[[123\\[[\\[[\\[[124\\[[asf\\[[ccc\\[[[", "escape" },
};

INSTANTIATE_TEST_SUITE_P(
	ReplaceString,
	ReplaceStringTest,
	::testing::ValuesIn(kReplaceStringTestCases),
	[](const ::testing::TestParamInfo<ReplaceStringTest::ParamType> &info) {
		return fmt::format("Case{}", info.index);
	}
);
