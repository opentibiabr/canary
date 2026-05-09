/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "creatures/players/player.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "utils/utils_definitions.hpp"

// ---------------------------------------------------------------------------
// Focused unit tests for forge pre-validation helper functions.
//
// These tests cover the player-side state that the pre-validation blocks in
// Player::forgeFuseItems and Player::forgeTransferItemTier rely on:
//   * getForgeDusts() / setForgeDusts()
//   * hasItemCountById() — checked via the stash public API
//
// Full flow tests (chest reservation failure, successful forge, late
// precondition failure) require g_game() infrastructure (internalAddItem,
// internalRemoveItem, item classification data, config values) and therefore
// belong in an integration test.  The scenarios are documented as follow-up
// ---------------------------------------------------------------------------

class ForgePlayerTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		InMemoryLogger::install(injector_);
		DI::setTestContainer(&injector_);
	}

	static void TearDownTestSuite() {
		if (DI::getTestContainer() == &injector_) {
			DI::setTestContainer(nullptr);
		}
	}

private:
	inline static di::extension::injector<> injector_ {};
};

// ---------------------------------------------------------------------------
// getForgeDusts / setForgeDusts
// ---------------------------------------------------------------------------

TEST_F(ForgePlayerTest, ForgeDusts_InitiallyZero) {
	auto player = std::make_shared<Player>();
	EXPECT_EQ(0u, player->getForgeDusts());
}

TEST_F(ForgePlayerTest, SetForgeDusts_UpdatesValue) {
	auto player = std::make_shared<Player>();
	player->setForgeDusts(500);
	EXPECT_EQ(500u, player->getForgeDusts());
}

TEST_F(ForgePlayerTest, SetForgeDusts_OverwritesPreviousValue) {
	auto player = std::make_shared<Player>();
	player->setForgeDusts(100);
	player->setForgeDusts(250);
	EXPECT_EQ(250u, player->getForgeDusts());
}

// ---------------------------------------------------------------------------
// hasItemCountById — via stash (public addItemOnStash API, no game state needed)
// ---------------------------------------------------------------------------

TEST_F(ForgePlayerTest, HasItemCountById_EmptyInventoryAndStash_ReturnsFalse) {
	auto player = std::make_shared<Player>();
	EXPECT_FALSE(player->hasItemCountById(ITEM_FORGE_CORE, 1, true));
}

TEST_F(ForgePlayerTest, HasItemCountById_EnoughInStash_ReturnsTrue) {
	auto player = std::make_shared<Player>();
	player->addItemOnStash(ITEM_FORGE_CORE, 5);
	EXPECT_TRUE(player->hasItemCountById(ITEM_FORGE_CORE, 5, true));
}

TEST_F(ForgePlayerTest, HasItemCountById_NotEnoughInStash_ReturnsFalse) {
	auto player = std::make_shared<Player>();
	player->addItemOnStash(ITEM_FORGE_CORE, 3);
	EXPECT_FALSE(player->hasItemCountById(ITEM_FORGE_CORE, 4, true));
}

TEST_F(ForgePlayerTest, HasItemCountById_ZeroRequired_AlwaysTrue) {
	auto player = std::make_shared<Player>();
	// Zero requirement must pass even with an empty inventory — matches the
	// behavior of removeItemCountById(id, 0) which succeeds immediately.
	EXPECT_TRUE(player->hasItemCountById(ITEM_FORGE_CORE, 0, true));
}

TEST_F(ForgePlayerTest, HasItemCountById_StashNotCheckedWhenFlagFalse) {
	auto player = std::make_shared<Player>();
	player->addItemOnStash(ITEM_FORGE_CORE, 10);
	// checkStash = false: stash items must be ignored.
	EXPECT_FALSE(player->hasItemCountById(ITEM_FORGE_CORE, 1, false));
}
