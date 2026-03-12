/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/players/player.hpp"
#include "items/containers/inbox/inbox.hpp"
#include "items/item.hpp"
#include "lib/logging/in_memory_logger.hpp"

class PlayerItemBatchTest : public ::testing::Test {
protected:
	static constexpr uint16_t kNonStackableItemId = 65000;
	static constexpr uint16_t kStackableItemId = 65001;

	static void SetUpTestSuite() {
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);

		auto &items = Item::items.getItems();
		originalItemsSize = items.size();

		if (kNonStackableItemId < originalItemsSize) {
			hadOriginalNonStackableItem = true;
			originalNonStackableItem = items[kNonStackableItemId];
		}

		if (kStackableItemId < originalItemsSize) {
			hadOriginalStackableItem = true;
			originalStackableItem = items[kStackableItemId];
		}

		if (items.size() <= kStackableItemId) {
			items.resize(kStackableItemId + 1);
		}

		configureNonStackableItem(items[kNonStackableItemId]);
		configureStackableItem(items[kStackableItemId]);
	}

	static void TearDownTestSuite() {
		auto &items = Item::items.getItems();

		if (hadOriginalNonStackableItem && kNonStackableItemId < items.size()) {
			items[kNonStackableItemId] = originalNonStackableItem;
		}

		if (hadOriginalStackableItem && kStackableItemId < items.size()) {
			items[kStackableItemId] = originalStackableItem;
		}

		if (items.size() > originalItemsSize) {
			items.resize(originalItemsSize);
		}
	}

	static void configureNonStackableItem(ItemType &itemType) {
		itemType = ItemType {};
		itemType.id = kNonStackableItemId;
		itemType.name = "test non stackable";
		itemType.pickupable = true;
		itemType.movable = true;
	}

	static void configureStackableItem(ItemType &itemType) {
		itemType = ItemType {};
		itemType.id = kStackableItemId;
		itemType.name = "test stackable";
		itemType.pickupable = true;
		itemType.movable = true;
		itemType.stackable = true;
		itemType.stackSize = 100;
	}

	static std::shared_ptr<Player> makePlayer() {
		return std::make_shared<Player>(std::shared_ptr<ProtocolGame> {});
	}

	inline static di::extension::injector<> injector {};
	inline static size_t originalItemsSize = 0;
	inline static bool hadOriginalNonStackableItem = false;
	inline static bool hadOriginalStackableItem = false;
	inline static ItemType originalNonStackableItem {};
	inline static ItemType originalStackableItem {};
};

TEST_F(PlayerItemBatchTest, RejectsNonStackableBatchWhenInboxWouldOverflow) {
	auto player = makePlayer();
	ASSERT_NE(player, nullptr);
	auto inbox = player->getInbox();
	ASSERT_NE(inbox, nullptr);
	auto container = std::static_pointer_cast<Container>(inbox);

	inbox->setMaxInboxItems(1);

	uint32_t actuallyAdded = 0;
	ReturnValue result = player->addItemBatchToPaginedContainer(container, kNonStackableItemId, 2, actuallyAdded, FLAG_NOLIMIT);

	EXPECT_EQ(RETURNVALUE_DEPOTISFULL, result);
	EXPECT_EQ(0U, actuallyAdded);
	EXPECT_TRUE(inbox->empty());
}

TEST_F(PlayerItemBatchTest, RejectsStackableBatchWhenItNeedsMoreThanOneInboxSlot) {
	auto player = makePlayer();
	ASSERT_NE(player, nullptr);
	auto inbox = player->getInbox();
	ASSERT_NE(inbox, nullptr);
	auto container = std::static_pointer_cast<Container>(inbox);

	inbox->setMaxInboxItems(1);

	uint32_t actuallyAdded = 0;
	ReturnValue result = player->addItemBatchToPaginedContainer(container, kStackableItemId, 101, actuallyAdded, FLAG_NOLIMIT);

	EXPECT_EQ(RETURNVALUE_DEPOTISFULL, result);
	EXPECT_EQ(0U, actuallyAdded);
	EXPECT_TRUE(inbox->empty());
}

TEST_F(PlayerItemBatchTest, AcceptsStackableBatchWhenItFitsExactlyOneInboxSlot) {
	auto player = makePlayer();
	ASSERT_NE(player, nullptr);
	auto inbox = player->getInbox();
	ASSERT_NE(inbox, nullptr);
	auto container = std::static_pointer_cast<Container>(inbox);

	inbox->setMaxInboxItems(1);

	uint32_t actuallyAdded = 0;
	ReturnValue result = player->addItemBatchToPaginedContainer(container, kStackableItemId, 100, actuallyAdded, FLAG_NOLIMIT);

	ASSERT_EQ(RETURNVALUE_NOERROR, result);
	ASSERT_EQ(100U, actuallyAdded);
	ASSERT_EQ(1U, inbox->size());

	const auto &item = inbox->getItemByIndex(0);
	ASSERT_NE(item, nullptr);
	EXPECT_EQ(kStackableItemId, item->getID());
	EXPECT_EQ(100, item->getItemCount());
}

TEST_F(PlayerItemBatchTest, ReusesExistingInboxStackBeforeConsumingNewSlot) {
	auto player = makePlayer();
	ASSERT_NE(player, nullptr);
	auto inbox = player->getInbox();
	ASSERT_NE(inbox, nullptr);
	auto container = std::static_pointer_cast<Container>(inbox);

	inbox->setMaxInboxItems(1);

	const auto existingStack = Item::createItemBatch(kStackableItemId, 60, 0);
	ASSERT_NE(existingStack, nullptr);
	inbox->addThing(existingStack);

	uint32_t actuallyAdded = 0;
	ReturnValue result = player->addItemBatchToPaginedContainer(container, kStackableItemId, 40, actuallyAdded, FLAG_NOLIMIT);

	ASSERT_EQ(RETURNVALUE_NOERROR, result);
	ASSERT_EQ(40U, actuallyAdded);
	ASSERT_EQ(1U, inbox->size());

	const auto &item = inbox->getItemByIndex(0);
	ASSERT_NE(item, nullptr);
	EXPECT_EQ(kStackableItemId, item->getID());
	EXPECT_EQ(100, item->getItemCount());
}
