/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"

#include <appearances.pb.h>

namespace {
	void addOutfitFrameGroup(Canary::protobuf::appearances::Appearance &appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP fixedFrameGroup, uint32_t patternDepth) {
		auto &frameGroup = *appearance.add_frame_group();
		frameGroup.set_fixed_frame_group(fixedFrameGroup);
		frameGroup.mutable_sprite_info()->set_pattern_depth(patternDepth);
	}
}

TEST(RandomMountOutfitRegressionTest, InvalidRandomMountIdResolvesToNoMount) {
	Mounts mounts;
	constexpr uint8_t nonExistentRandomMountId = 42;

	EXPECT_EQ(0, Game::resolveRandomMountClientId(mounts, nonExistentRandomMountId));
}

TEST(RandomMountOutfitRegressionTest, PlayerChangeOutfitWithoutMountClearsMountedAndRandomState) {
	auto player = std::make_shared<Player>();

	Outfit_t currentOutfit;
	currentOutfit.lookType = 128;
	currentOutfit.lookMount = 1;
	player->setDefaultOutfit(currentOutfit);
	player->setRandomMount(1);

	Outfit_t requestedOutfit = currentOutfit;
	requestedOutfit.lookMount = 1;

	g_game().playerChangeOutfit(player, requestedOutfit, false, 1);

	EXPECT_FALSE(player->isMounted());
	EXPECT_EQ(0, player->isRandomMounted());
}

TEST(RandomMountOutfitRegressionTest, OutfitWithoutMountedPatternDepthRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE, 1);
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING, 1);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithMountedPatternDepthAllowsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	// pattern_depth == 2 encodes the mounted/unmounted sprite-variant axis.
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE, 2);
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING, 2);

	EXPECT_TRUE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithOnlyIdleMountedPatternDepthRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	// Both outfit frame groups need the mounted/unmounted sprite-variant axis.
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE, 2);
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING, 1);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithOnlyMovingMountedPatternDepthRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	// Both outfit frame groups need the mounted/unmounted sprite-variant axis.
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE, 1);
	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING, 2);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithOnlyIdleFrameGroupRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_IDLE, 2);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}

TEST(RandomMountOutfitRegressionTest, OutfitWithOnlyMovingFrameGroupRejectsMount) {
	Canary::protobuf::appearances::Appearance appearance;

	addOutfitFrameGroup(appearance, Canary::protobuf::appearances::FIXED_FRAME_GROUP_OUTFIT_MOVING, 2);

	EXPECT_FALSE(Game::outfitAppearanceSupportsMount(appearance));
}
