#include <gtest/gtest.h>

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"

#include "creatures/npcs/npc.hpp"
#include "creatures/npcs/npcs.hpp"
#include "items/item.hpp"
#include "items/items_definitions.hpp"
#include "server/network/protocol/protocolgame.hpp"
#include "test_items.hpp"
#include "utils/batch_update.hpp"

namespace it_batch_update {

	class FakeContainer : public Container {
	public:
		using Container::Container;
		int beginCount { 0 };
		int endCount { 0 };

		void beginBatchUpdate() override {
			++beginCount;
			Container::beginBatchUpdate();
		}

		void endBatchUpdate(Player* actor) override {
			++endCount;
			Container::endBatchUpdate(actor);
		}
	};

	class BatchUpdateIntegrationTest : public ::testing::Test {
	protected:
		void SetUp() override {
			TestItems::init();
		}
	};

	std::shared_ptr<Npc> createShopNpc(uint16_t itemId, uint32_t sellPrice) {
		auto npcType = std::make_shared<NpcType>("BatchNpc");
		npcType->name = "BatchNpc";
		npcType->nameDescription = "BatchNpc";
		npcType->info.shopItemVector.emplace_back(itemId, "TestItem", 0, 0, sellPrice);
		return std::make_shared<Npc>(npcType);
	}

	TEST_F(BatchUpdateIntegrationTest, EndsBatchUpdatesWhenActorLeavesScope) {
		auto player = Player::createForTests();
		auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
		auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);

		{
			BatchUpdate batch(player);
			EXPECT_TRUE(batch.add(c1));
			EXPECT_TRUE(batch.add(c2));
			EXPECT_TRUE(player->isBatching());
			EXPECT_EQ(c1->beginCount, 1);
			EXPECT_EQ(c2->beginCount, 1);
		}

		EXPECT_FALSE(player->isBatching());
		EXPECT_EQ(c1->endCount, 1);
		EXPECT_EQ(c2->endCount, 1);
	}

	TEST_F(BatchUpdateIntegrationTest, DeduplicatesContainersWithinScope) {
		auto player = Player::createForTests();
		auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);

		{
			BatchUpdate batch(player);
			EXPECT_TRUE(batch.add(c1));
			EXPECT_FALSE(batch.add(c1));
			EXPECT_TRUE(player->isBatching());
			EXPECT_EQ(c1->beginCount, 1);
		}

		EXPECT_FALSE(player->isBatching());
		EXPECT_EQ(c1->endCount, 1);
	}

	TEST_F(BatchUpdateIntegrationTest, SendsLootSaleWithBatchingAcrossContainers) {
		auto player = Player::createForTests();

		auto lootPouch = std::make_shared<FakeContainer>(ITEM_GOLD_POUCH, 10);
		auto storeInbox = std::make_shared<FakeContainer>(ITEM_STORE_INBOX, 10);

		player->internalAddThing(CONST_SLOT_BACKPACK, lootPouch);
		player->internalAddThing(CONST_SLOT_STORE_INBOX, storeInbox);

		{
			BatchUpdate batch(player);
			batch.add(lootPouch);
			batch.add(storeInbox);

			lootPouch->removeAllItems(player);
			storeInbox->addItem(Item::CreateItem(ITEM_LETTER_STAMPED, 1));
		}

		EXPECT_TRUE(lootPouch->empty());
		EXPECT_EQ(storeInbox->beginCount, 1);
		EXPECT_EQ(storeInbox->endCount, 1);
	}

	ReturnValue addItemBatchToPaginatedContainerFake(
		const std::shared_ptr<Container> &container,
		uint16_t itemId,
		uint32_t totalCount,
		uint32_t &actuallyAdded,
		uint32_t maxStackSize = 100
	) {
		actuallyAdded = 0;

		if (!container) {
			return RETURNVALUE_NOTPOSSIBLE;
		}
		if (totalCount == 0) {
			return RETURNVALUE_NOERROR;
		}

		uint32_t remaining = totalCount;

		while (remaining > 0) {
			uint32_t toAdd = std::min(remaining, maxStackSize);

			auto item = Item::CreateItem(itemId, 1);
			if (!item) {
				return RETURNVALUE_NOTPOSSIBLE;
			}

			if (item->isStackable()) {
				item->setItemCount(static_cast<uint8_t>(toAdd));
			} else {
				toAdd = 1;
			}

			container->addThing(item);

			actuallyAdded += toAdd;
			remaining -= toAdd;
		}

		return RETURNVALUE_NOERROR;
	}

	TEST_F(BatchUpdateIntegrationTest, AddsItemsToPaginatedContainerBatch_BatchesOnlyOnce) {
		auto player = Player::createForTests();

		auto storeInbox = std::make_shared<FakeContainer>(ITEM_STORE_INBOX, 10);
		player->internalAddThing(CONST_SLOT_STORE_INBOX, storeInbox);

		uint32_t actuallyAdded = 0;
		constexpr uint32_t kAddCount = 250;

		{
			BatchUpdate batch(player);
			EXPECT_TRUE(batch.add(storeInbox));

			const auto result = addItemBatchToPaginatedContainerFake(storeInbox, ITEM_GOLD_COIN, kAddCount, actuallyAdded);

			EXPECT_EQ(result, RETURNVALUE_NOERROR);
			EXPECT_EQ(actuallyAdded, kAddCount);

			EXPECT_EQ(storeInbox->beginCount, 1);
		}

		EXPECT_EQ(storeInbox->endCount, 1);

		uint32_t totalCount = 0;
		for (const auto &item : storeInbox->getItemList()) {
			if (item) {
				totalCount += item->getItemCount();
			}
		}
		EXPECT_EQ(totalCount, kAddCount);
	}
}
