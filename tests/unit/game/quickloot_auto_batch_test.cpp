/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include <limits>

#include "creatures/players/player.hpp"
#include "enums/object_category.hpp"
#include "game/game.hpp"

TEST(QuickLootAutoBatchSizeTest, EmptyPendingCorpsesProduceEmptyBatch) {
	EXPECT_EQ(0, Game::resolveAutoLootCorpseBatchSize(0, 30));
}

TEST(QuickLootAutoBatchSizeTest, NonPositiveConfigStillProcessesOneCorpsePerRound) {
	EXPECT_EQ(1, Game::resolveAutoLootCorpseBatchSize(42, 0));
	EXPECT_EQ(1, Game::resolveAutoLootCorpseBatchSize(42, -5));
}

TEST(QuickLootAutoBatchSizeTest, ZeroPendingTakesPrecedenceOverNonPositiveConfig) {
	EXPECT_EQ(0, Game::resolveAutoLootCorpseBatchSize(0, 0));
	EXPECT_EQ(0, Game::resolveAutoLootCorpseBatchSize(0, -5));
}

TEST(QuickLootAutoBatchSizeTest, BatchIsLimitedByConfiguredMaximum) {
	EXPECT_EQ(30, Game::resolveAutoLootCorpseBatchSize(42, 30));
}

TEST(QuickLootAutoBatchSizeTest, OversizedPendingIsBoundedByConfiguredMaximum) {
	EXPECT_EQ(30, Game::resolveAutoLootCorpseBatchSize(std::numeric_limits<size_t>::max(), 30));
}

TEST(QuickLootAutoBatchSizeTest, BatchDoesNotExceedPendingCorpses) {
	EXPECT_EQ(12, Game::resolveAutoLootCorpseBatchSize(12, 30));
}

TEST(QuickLootAutoBatchMessageTest, SuccessfulAutoLootBatchUsesSingleSummaryMessage) {
	EXPECT_EQ("You looted everything.", Game::getAutoLootBatchSummaryMessage(true, false));
}

TEST(QuickLootAutoBatchMessageTest, PartialAutoLootBatchDoesNotClaimFullSuccess) {
	EXPECT_EQ("You looted some of the loot.", Game::getAutoLootBatchSummaryMessage(true, true));
	EXPECT_EQ("You looted none of the loot.", Game::getAutoLootBatchSummaryMessage(false, true));
}

TEST(QuickLootAutoBatchMessageTest, SummaryHelperCanRepresentNoLoot) {
	EXPECT_EQ("No loot.", Game::getAutoLootBatchSummaryMessage(false, false));
}

TEST(QuickLootAutoBatchMessageTest, CapacityFailureUsesSingleBatchWarning) {
	EXPECT_EQ(
		"Attention! The loot you are trying to pick up is too heavy for you to carry.",
		Game::getAutoLootBatchFailureMessage(true, false, ObjectCategory_t{})
	);
}

TEST(QuickLootAutoBatchMessageTest, FullContainerFailureUsesSingleBatchWarning) {
	EXPECT_EQ(
		"Attention! The container assigned to category Unassigned Loot is full.",
		Game::getAutoLootBatchFailureMessage(false, true, OBJECTCATEGORY_DEFAULT)
	);
}

TEST(QuickLootAutoBatchMessageTest, NoFailureProducesNoBatchWarning) {
	EXPECT_TRUE(Game::getAutoLootBatchFailureMessage(false, false, OBJECTCATEGORY_DEFAULT).empty());
}

TEST(QuickLootDeferredPageCollapseTest, KeepsCurrentIndexWhenPageStillExists) {
	EXPECT_EQ(20, Player::getDeferredQuickLootContainerFirstIndex(20, 100, 20));
}

TEST(QuickLootDeferredPageCollapseTest, EmptyContainerRewindsToStart) {
	EXPECT_EQ(0, Player::getDeferredQuickLootContainerFirstIndex(20, 0, 20));
}

TEST(QuickLootDeferredPageCollapseTest, PageSizeBoundaryRewindsToStart) {
	EXPECT_EQ(0, Player::getDeferredQuickLootContainerFirstIndex(20, 20, 20));
}

TEST(QuickLootDeferredPageCollapseTest, MultiPageShrinkRewindsOnePage) {
	EXPECT_EQ(40, Player::getDeferredQuickLootContainerFirstIndex(60, 55, 20));
}

TEST(QuickLootDeferredPageCollapseTest, CurrentIndexBeyondItemCountRewindsOnePageFromCurrentOffset) {
	EXPECT_EQ(40, Player::getDeferredQuickLootContainerFirstIndex(60, 30, 20));
}

TEST(QuickLootDeferredPageCollapseTest, UnalignedCurrentIndexIsPreservedWhenPageStillExists) {
	EXPECT_EQ(25, Player::getDeferredQuickLootContainerFirstIndex(25, 50, 20));
}

TEST(QuickLootDeferredPageCollapseTest, LastItemOnCurrentPageRewindsLikeLiveRemovePath) {
	EXPECT_EQ(0, Player::getDeferredQuickLootContainerFirstIndex(20, 21, 20));
}

TEST(QuickLootDeferredPageCollapseTest, ZeroPageSizeWithItemsRewindsToStart) {
	EXPECT_EQ(0, Player::getDeferredQuickLootContainerFirstIndex(20, 30, 0));
}

TEST(QuickLootDeferredPageCollapseTest, ZeroPageSizeRewindsToStart) {
	EXPECT_EQ(0, Player::getDeferredQuickLootContainerFirstIndex(20, 0, 0));
}
