#include "pch.hpp"

#include <gtest/gtest.h>

#include "creatures/players/player.hpp"

TEST(PlayerDepotTest, FailedLockerActivationDoesNotMarkStorageLoaded) {
	auto player = std::make_shared<Player>();

	EXPECT_FALSE(player->hasLoadedDepotStorage());
	EXPECT_EQ(player->activateDepotLocker(1), nullptr);
	EXPECT_FALSE(player->hasLoadedDepotStorage());
	EXPECT_EQ(player->getActiveDepotLocker(), nullptr);
}

TEST(PlayerDepotTest, FailedLockerActivationPreservesLoadedStorageState) {
	auto player = std::make_shared<Player>();
	player->markDepotStorageLoaded();

	EXPECT_EQ(player->activateDepotLocker(1), nullptr);
	EXPECT_TRUE(player->hasLoadedDepotStorage());
	EXPECT_EQ(player->getActiveDepotLocker(), nullptr);
}
