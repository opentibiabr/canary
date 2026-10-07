/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#ifndef USE_PRECOMPILED_HEADERS
	#include <array>
	#include <optional>
	#include <utility>
#endif

#include <gtest/gtest.h>

#include "items/item.hpp"
#include "items/items.hpp"

namespace {
	constexpr uint16_t TEST_RECIPROCAL_TRANSFORM_TARGET_ID = 64998;
	constexpr uint16_t TEST_RECIPROCAL_NON_EQUIPMENT_ID = 64999;
	constexpr uint16_t TEST_TIMED_TRANSFORM_TARGET_ID = 65000;
	constexpr uint16_t TEST_TIMED_TARGET_NON_EQUIPMENT_ID = 65001;
	constexpr uint16_t TEST_PAUSED_EQUIPMENT_ID = 65002;
	constexpr uint16_t TEST_ACTIVE_EQUIPMENT_ID = 65003;
	constexpr uint16_t TEST_TIMED_ACTIVE_EQUIPMENT_ID = 65004;
	constexpr std::array TEST_ITEM_IDS = {
		TEST_RECIPROCAL_TRANSFORM_TARGET_ID,
		TEST_RECIPROCAL_NON_EQUIPMENT_ID,
		TEST_TIMED_TRANSFORM_TARGET_ID,
		TEST_TIMED_TARGET_NON_EQUIPMENT_ID,
		TEST_PAUSED_EQUIPMENT_ID,
		TEST_ACTIVE_EQUIPMENT_ID,
		TEST_TIMED_ACTIVE_EQUIPMENT_ID,
	};

	class ItemCreationTest : public testing::Test {
	protected:
		void SetUp() override {
			auto &items = Item::items.getItems();
			originalItemsSize = items.size();

			for (size_t index = 0; index < TEST_ITEM_IDS.size(); ++index) {
				if (TEST_ITEM_IDS[index] < originalItemsSize) {
					originalItems[index].emplace(std::move(items[TEST_ITEM_IDS[index]]));
				}
			}
			if (items.size() <= TEST_TIMED_ACTIVE_EQUIPMENT_ID) {
				items.resize(TEST_TIMED_ACTIVE_EQUIPMENT_ID + 1);
			}

			auto &reciprocalTransformTarget = items[TEST_RECIPROCAL_TRANSFORM_TARGET_ID];
			reciprocalTransformTarget = ItemType {};
			reciprocalTransformTarget.id = TEST_RECIPROCAL_TRANSFORM_TARGET_ID;
			reciprocalTransformTarget.transformEquipTo = TEST_RECIPROCAL_NON_EQUIPMENT_ID;

			auto &reciprocalNonEquipmentType = items[TEST_RECIPROCAL_NON_EQUIPMENT_ID];
			reciprocalNonEquipmentType = ItemType {};
			reciprocalNonEquipmentType.id = TEST_RECIPROCAL_NON_EQUIPMENT_ID;
			reciprocalNonEquipmentType.transformDeEquipTo = TEST_RECIPROCAL_TRANSFORM_TARGET_ID;

			auto &timedTransformTarget = items[TEST_TIMED_TRANSFORM_TARGET_ID];
			timedTransformTarget = ItemType {};
			timedTransformTarget.id = TEST_TIMED_TRANSFORM_TARGET_ID;
			timedTransformTarget.decayTime = 86400;

			auto &timedTargetNonEquipmentType = items[TEST_TIMED_TARGET_NON_EQUIPMENT_ID];
			timedTargetNonEquipmentType = ItemType {};
			timedTargetNonEquipmentType.id = TEST_TIMED_TARGET_NON_EQUIPMENT_ID;
			timedTargetNonEquipmentType.transformDeEquipTo = TEST_TIMED_TRANSFORM_TARGET_ID;

			auto &pausedType = items[TEST_PAUSED_EQUIPMENT_ID];
			pausedType = ItemType {};
			pausedType.id = TEST_PAUSED_EQUIPMENT_ID;
			pausedType.stopTime = true;

			auto &activeType = items[TEST_ACTIVE_EQUIPMENT_ID];
			activeType = ItemType {};
			activeType.id = TEST_ACTIVE_EQUIPMENT_ID;
			activeType.transformDeEquipTo = TEST_PAUSED_EQUIPMENT_ID;
			activeType.decayTime = 3600;
			activeType.hasDeEquipEvent = true;

			auto &timedActiveType = items[TEST_TIMED_ACTIVE_EQUIPMENT_ID];
			timedActiveType = ItemType {};
			timedActiveType.id = TEST_TIMED_ACTIVE_EQUIPMENT_ID;
			timedActiveType.transformDeEquipTo = TEST_PAUSED_EQUIPMENT_ID;
			timedActiveType.decayTime = 3600;
			timedActiveType.decayTo = TEST_PAUSED_EQUIPMENT_ID;
		}

		void TearDown() override {
			auto &items = Item::items.getItems();
			for (size_t index = 0; index < TEST_ITEM_IDS.size(); ++index) {
				if (originalItems[index]) {
					items[TEST_ITEM_IDS[index]] = std::move(*originalItems[index]);
				}
			}
			if (items.size() > originalItemsSize) {
				items.resize(originalItemsSize);
			}
		}

		size_t originalItemsSize = 0;
		std::array<std::optional<ItemType>, TEST_ITEM_IDS.size()> originalItems;
	};
} // namespace

TEST_F(ItemCreationTest, CreatesActiveEquipmentAsItsPausedXmlType) {
	const auto item = Item::CreateItem(TEST_ACTIVE_EQUIPMENT_ID);

	ASSERT_NE(item, nullptr);
	EXPECT_EQ(TEST_PAUSED_EQUIPMENT_ID, item->getID());
	EXPECT_EQ(0, item->getDuration());
}

TEST_F(ItemCreationTest, CreatesTimedActiveEquipmentWithoutMoveEventAsItsPausedXmlType) {
	const auto item = Item::CreateItem(TEST_TIMED_ACTIVE_EQUIPMENT_ID);

	ASSERT_NE(item, nullptr);
	EXPECT_EQ(TEST_PAUSED_EQUIPMENT_ID, item->getID());
	EXPECT_EQ(0, item->getDuration());
}

TEST_F(ItemCreationTest, PreservesNonEquipmentWithReciprocalTransformMetadata) {
	const auto item = Item::CreateItem(TEST_RECIPROCAL_NON_EQUIPMENT_ID);

	ASSERT_NE(item, nullptr);
	EXPECT_EQ(TEST_RECIPROCAL_NON_EQUIPMENT_ID, item->getID());
	EXPECT_EQ(0, item->getDuration());
}

TEST_F(ItemCreationTest, PreservesNonEquipmentWhenTransformTargetHasDuration) {
	const auto item = Item::CreateItem(TEST_TIMED_TARGET_NON_EQUIPMENT_ID);

	ASSERT_NE(item, nullptr);
	EXPECT_EQ(TEST_TIMED_TARGET_NON_EQUIPMENT_ID, item->getID());
	EXPECT_EQ(0, item->getDuration());
}
