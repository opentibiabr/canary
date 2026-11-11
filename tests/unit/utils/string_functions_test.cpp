/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/tools.hpp"

#include <cstdlib>
#include <ctime>

#ifndef USE_PRECOMPILED_HEADERS
	#include <limits>
#endif

class DateFormattingTest : public ::testing::Test {
protected:
	void SetUp() override {
		const char* timezone = std::getenv("TZ");
		hadTimezone = timezone != nullptr;
		if (hadTimezone) {
			originalTimezone = timezone;
		}
	}

	void TearDown() override {
		setTimezone(hadTimezone ? originalTimezone.c_str() : nullptr);
	}

	static void setTimezone(const char* timezone) {
#if defined(_WIN32) || defined(_WIN64)
		ASSERT_EQ(_putenv_s("TZ", timezone ? timezone : ""), 0);
		_tzset();
#else
		ASSERT_EQ(timezone ? setenv("TZ", timezone, 1) : unsetenv("TZ"), 0);
		tzset();
#endif
	}

private:
	bool hadTimezone = false;
	std::string originalTimezone;
};

TEST_F(DateFormattingTest, FormatsUtcWithWholeSeconds) {
	setTimezone("UTC0");
	constexpr time_t timestamp = 1792449706;
	EXPECT_EQ(formatDate(timestamp), "19/10/2026 22:41:46");
	EXPECT_EQ(formatDateShort(timestamp), "2026-10-19 22:41:46");
	EXPECT_EQ(formatDateTime(static_cast<int64_t>(timestamp) * 1000 + 987), "2026-10-19 22:41:46");
}

TEST_F(DateFormattingTest, FormatsLocalTimeAcrossPreviousYearBoundary) {
	setTimezone("BRT3");
	constexpr time_t timestamp = 1767229323;
	EXPECT_EQ(formatDate(timestamp), "31/12/2025 22:02:03");
	EXPECT_EQ(formatDateShort(timestamp), "2025-12-31 22:02:03");
	EXPECT_EQ(formatDateTime(static_cast<int64_t>(timestamp) * 1000 + 999), "2025-12-31 22:02:03");
}

TEST_F(DateFormattingTest, FormatsLocalTimeAcrossNextDayBoundary) {
	setTimezone("JST-9");
	constexpr time_t timestamp = 1792449706;
	EXPECT_EQ(formatDate(timestamp), "20/10/2026 07:41:46");
	EXPECT_EQ(formatDateShort(timestamp), "2026-10-20 07:41:46");
	EXPECT_EQ(formatDateTime(static_cast<int64_t>(timestamp) * 1000), "2026-10-20 07:41:46");
}

TEST_F(DateFormattingTest, ReturnsEmptyWhenLocalTimeConversionFails) {
	setTimezone("UTC0");
#if defined(_WIN32) || defined(_WIN64)
	constexpr time_t timestamp = -1;
	EXPECT_TRUE(formatDateTime(-1000).empty());
#else
	if constexpr (std::numeric_limits<time_t>::digits <= 32) {
		GTEST_SKIP() << "time_t range fits in std::tm";
	}
	constexpr time_t timestamp = std::numeric_limits<time_t>::max();
#endif
	EXPECT_TRUE(formatDate(timestamp).empty());
	EXPECT_TRUE(formatDateShort(timestamp).empty());
}

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
