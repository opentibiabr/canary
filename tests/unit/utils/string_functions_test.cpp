#include "pch.hpp"

#include <gtest/gtest.h>

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
