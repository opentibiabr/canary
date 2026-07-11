/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "game/functions/use_with_policy.hpp"

TEST(UseWithPolicyTest, BlocksOnlyDisabledAimbotHotkeys) {
	EXPECT_TRUE(UseWithPolicy::shouldBlockAimbotHotkey(false, true));
	EXPECT_FALSE(UseWithPolicy::shouldBlockAimbotHotkey(false, false));
	EXPECT_FALSE(UseWithPolicy::shouldBlockAimbotHotkey(true, true));
	EXPECT_FALSE(UseWithPolicy::shouldBlockAimbotHotkey(true, false));
}
