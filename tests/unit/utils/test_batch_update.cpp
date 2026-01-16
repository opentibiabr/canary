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

	template <typename Func>
	void withBatchUpdate(const std::shared_ptr<Player> &player, Func &&action) {
		BatchUpdate batch(player);
		action(batch);
	}

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
	withBatchUpdate(player, [&](BatchUpdate &batch) {
		EXPECT_TRUE(batch.add(c1));
		EXPECT_FALSE(batch.add(c1));
		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->beginCount, 1);
	});
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
	withBatchUpdate(player, [&](BatchUpdate &batch) {
		EXPECT_TRUE(batch.add(c1));
		batch.addContainers({ c1, c2 });
		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->beginCount, 1);
		EXPECT_EQ(c2->beginCount, 1);
	});
	EXPECT_FALSE(player->isBatching());
	EXPECT_EQ(c1->endCount, 1);
	EXPECT_EQ(c2->endCount, 1);
}

TEST_F(BatchUpdateTest, EndBatchUpdateHandlesExpiredActor) {
	auto player = std::make_shared<Player>();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&](BatchUpdate &batch) {
		EXPECT_TRUE(batch.add(c1));
		player.reset();
	});
	EXPECT_EQ(c1->endCount, 1);
}

TEST_F(BatchUpdateTest, AddSkipsExpiredCachedContainers) {
	auto player = std::make_shared<Player>();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	BatchUpdate batch(player);
	EXPECT_TRUE(batch.add(c1));
	c1.reset();
	EXPECT_TRUE(batch.add(c2));
	EXPECT_EQ(c2->beginCount, 1);
}

TEST_F(BatchUpdateTest, AddContainersSkipsNullAndDuplicates) {
	auto player = std::make_shared<Player>();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&](BatchUpdate &batch) {
		batch.addContainers({ nullptr, c1, c1, c2, nullptr });
		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->beginCount, 1);
		EXPECT_EQ(c2->beginCount, 1);
	});
	EXPECT_FALSE(player->isBatching());
	EXPECT_EQ(c1->endCount, 1);
	EXPECT_EQ(c2->endCount, 1);
}

TEST_F(BatchUpdateTest, EmptyScopeBalancesBatchingState) {
	auto player = std::make_shared<Player>();
	withBatchUpdate(player, [&](BatchUpdate &) {
		EXPECT_TRUE(player->isBatching());
	});
	EXPECT_FALSE(player->isBatching());
}
