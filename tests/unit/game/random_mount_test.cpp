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

#include <appearances.pb.h>

TEST(RandomMountOutfitRegressionTest, InvalidRandomMountIdResolvesToNoMount) {
	Mounts mounts;

	EXPECT_EQ(0, Game::resolveRandomMountClientId(mounts, 42));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithoutMountedPatternDepthRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	auto &idleFrameGroup = *appearance.add_frame_group();
	idleFrameGroup.set_fixed_frame_group(Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE);
	idleFrameGroup.mutable_sprite_info()->set_pattern_depth(1);

	auto &movingFrameGroup = *appearance.add_frame_group();
	movingFrameGroup.set_fixed_frame_group(Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING);
	movingFrameGroup.mutable_sprite_info()->set_pattern_depth(1);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithMountedPatternDepthAllowsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	auto &idleFrameGroup = *appearance.add_frame_group();
	idleFrameGroup.set_fixed_frame_group(Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE);
	idleFrameGroup.mutable_sprite_info()->set_pattern_depth(2);

	auto &movingFrameGroup = *appearance.add_frame_group();
	movingFrameGroup.set_fixed_frame_group(Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING);
	movingFrameGroup.mutable_sprite_info()->set_pattern_depth(2);

	EXPECT_TRUE(Game::outfitAppearanceSupportsMount(appearance));
}
