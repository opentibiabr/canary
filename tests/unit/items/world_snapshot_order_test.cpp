#include "world/world_runtime_items.hpp"
#include "items/item.hpp"
#include "items/tile.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
#endif

TEST(WorldSnapshotOrder, OccurrencesUseAuthoredOrderInsteadOfGameplayOrder) {
	const auto firstDown = std::make_shared<Item>(0);
	const auto secondDown = std::make_shared<Item>(0);
	const auto bottom = std::make_shared<Item>(0);
	const auto upper = std::make_shared<Item>(0);
	TileItemVector gameplay;
	gameplay.push_back(secondDown);
	gameplay.push_back(firstDown);
	gameplay.increaseDownItemCount();
	gameplay.increaseDownItemCount();
	gameplay.push_back(bottom);
	gameplay.push_back(upper);
	const auto authored = world_runtime::mapOrderedItems(gameplay);
	EXPECT_EQ(authored, (std::vector<std::shared_ptr<Item>> { bottom, upper, firstDown, secondDown }));
	EXPECT_EQ(gameplay.getTopDownItem(), secondDown);
	EXPECT_EQ(gameplay.getTopTopItem(), upper);
}
