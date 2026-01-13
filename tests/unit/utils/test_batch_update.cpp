#include "pch.hpp"

#include <gtest/gtest.h>

#include "utils/batch_update.hpp"
#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "test_items.hpp"

namespace {

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

}

class BatchUpdateTest : public ::testing::Test {
protected:
	void SetUp() override {
		TestItems::init();
	}
};

TEST_F(BatchUpdateTest, DeduplicatesContainersAndBalancesBeginEndCalls) {
	auto player = std::make_shared<Player>();
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

TEST_F(BatchUpdateTest, AddReturnsFalseForNullContainers) {
	auto player = std::make_shared<Player>();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	BatchUpdate batch(player);
	EXPECT_TRUE(batch.add(c1));
	EXPECT_FALSE(batch.add(nullptr));
	EXPECT_TRUE(player->isBatching());
	EXPECT_EQ(c1->beginCount, 1);
}

TEST_F(BatchUpdateTest, AddContainersProcessesUniqueContainersOnce) {
	auto player = std::make_shared<Player>();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	{
		BatchUpdate batch(player);
		EXPECT_TRUE(batch.add(c1));
		batch.addContainers({ c1, c2 });
		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->beginCount, 1);
		EXPECT_EQ(c2->beginCount, 1);
	}
	EXPECT_FALSE(player->isBatching());
	EXPECT_EQ(c1->endCount, 1);
	EXPECT_EQ(c2->endCount, 1);
}
