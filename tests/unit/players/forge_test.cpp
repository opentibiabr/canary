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
// belong in an integration test.  The scenarios are documented as TODOs below.
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

// ---------------------------------------------------------------------------
// TODO: Integration tests requiring g_game() / full item database
//
// The following scenarios cannot be exercised with pure unit tests because
// they depend on g_game().internalAddItem(), Item::CreateItem() with real
// item type data, and g_configManager() forge cost values.  They should be
// added to tests/integration/game/ once that infrastructure is available:
//
//  1. forgeFuseItems — chest reservation failure (internalAddItem fails for
//     ITEM_EXALTATION_CHEST): verify that the forging items remain in the
//     player's inventory and no dust/cores/gold are deducted.
//
//  2. forgeFuseItems — successful flow with minimal free space: after the
//     chest is added to the last open slot, the forged item ends up inside
//     the chest with correct tier, and resources are deducted exactly once.
//
//  3. forgeFuseItems — late precondition failure after chest is reserved
//     (e.g. insufficient dust): verify items are not removed, the chest is
//     the only thing added to the player's inventory.
//
//  4. forgeTransferItemTier — equivalent scenarios for all three cases above.
// ---------------------------------------------------------------------------
