/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef USE_PRECOMPILED_HEADERS
	#include <optional>
	#include <utility>
#endif

#include <gtest/gtest.h>

#include "items/item.hpp"
#include "items/items.hpp"

namespace {
	constexpr uint16_t TEST_PAUSED_EQUIPMENT_ID = 65002;
	constexpr uint16_t TEST_ACTIVE_EQUIPMENT_ID = 65003;

	class ItemCreationTest : public testing::Test {
	protected:
		void SetUp() override {
			auto &items = Item::items.getItems();
			originalItemsSize = items.size();

			if (TEST_PAUSED_EQUIPMENT_ID < originalItemsSize) {
				originalPausedItem.emplace(std::move(items[TEST_PAUSED_EQUIPMENT_ID]));
			}
			if (TEST_ACTIVE_EQUIPMENT_ID < originalItemsSize) {
				originalActiveItem.emplace(std::move(items[TEST_ACTIVE_EQUIPMENT_ID]));
			}
			if (items.size() <= TEST_ACTIVE_EQUIPMENT_ID) {
				items.resize(TEST_ACTIVE_EQUIPMENT_ID + 1);
			}

			auto &pausedType = items[TEST_PAUSED_EQUIPMENT_ID];
			pausedType = ItemType {};
			pausedType.id = TEST_PAUSED_EQUIPMENT_ID;
			pausedType.stopTime = true;

			auto &activeType = items[TEST_ACTIVE_EQUIPMENT_ID];
			activeType = ItemType {};
			activeType.id = TEST_ACTIVE_EQUIPMENT_ID;
			activeType.transformDeEquipTo = TEST_PAUSED_EQUIPMENT_ID;
			activeType.decayTime = 3600;
		}

		void TearDown() override {
			auto &items = Item::items.getItems();
			if (originalPausedItem) {
				items[TEST_PAUSED_EQUIPMENT_ID] = std::move(*originalPausedItem);
			}
			if (originalActiveItem) {
				items[TEST_ACTIVE_EQUIPMENT_ID] = std::move(*originalActiveItem);
			}
			if (items.size() > originalItemsSize) {
				items.resize(originalItemsSize);
			}
		}

		size_t originalItemsSize = 0;
		std::optional<ItemType> originalPausedItem;
		std::optional<ItemType> originalActiveItem;
	};
} // namespace

TEST_F(ItemCreationTest, CreatesActiveEquipmentAsItsPausedXmlType) {
	const auto item = Item::CreateItem(TEST_ACTIVE_EQUIPMENT_ID);

	ASSERT_NE(item, nullptr);
	EXPECT_EQ(TEST_PAUSED_EQUIPMENT_ID, item->getID());
	EXPECT_EQ(0, item->getDuration());
}
