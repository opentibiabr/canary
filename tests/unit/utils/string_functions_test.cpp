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

TEST(HashFunctionsTest, TransformToSHA1MatchesCanonicalVectors) {
	EXPECT_EQ("da39a3ee5e6b4b0d3255bfef95601890afd80709", transformToSHA1(""));
	EXPECT_EQ("a9993e364706816aba3e25717850c26c9cd0d89d", transformToSHA1("abc"));
}

TEST(HashFunctionsTest, TransformToSHA256MatchesCanonicalVectors) {
	EXPECT_EQ("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", transformToSHA256(""));
	EXPECT_EQ("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", transformToSHA256("abc"));
}
