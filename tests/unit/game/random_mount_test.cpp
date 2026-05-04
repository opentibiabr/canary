/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"
#include "game/game.hpp"

TEST(RandomMountOutfitRegressionTest, InvalidRandomMountIdResolvesToNoMount) {
	Mounts mounts;

	EXPECT_EQ(0, Game::resolveRandomMountClientId(mounts, 42));
}
