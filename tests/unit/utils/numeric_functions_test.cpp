/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (c) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "utils/tools.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <limits>
#endif

TEST(NumericFunctionsTest, SubtractsElapsedTimeWithoutCrossingZero) {
	EXPECT_EQ(750, subtractElapsedTime(1000, 250));
	EXPECT_EQ(1000, subtractElapsedTime(1000, 0));
	EXPECT_EQ(0, subtractElapsedTime(1000, 1000));
	EXPECT_EQ(0, subtractElapsedTime(1000, 1001));
	EXPECT_EQ(0, subtractElapsedTime(1, std::numeric_limits<uint32_t>::max()));
	EXPECT_EQ(0, subtractElapsedTime(0, 1));
	EXPECT_EQ(0, subtractElapsedTime(-1, 1));
}
