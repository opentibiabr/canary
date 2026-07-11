/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "items/functions/item/item_parse_policy.hpp"

TEST(ItemParsePolicyTest, RegistersAddItemHandlerForMagicFieldStepIn) {
	EXPECT_TRUE(ItemParsePolicy::shouldRegisterAddItemField(true, true));
	EXPECT_FALSE(ItemParsePolicy::shouldRegisterAddItemField(true, false));
	EXPECT_FALSE(ItemParsePolicy::shouldRegisterAddItemField(false, true));
}
