#include "pch.hpp"

#include <gtest/gtest.h>

#include "utils/batch_update.hpp"

#include "creatures/players/player.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "items/containers/container.hpp"
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

	std::shared_ptr<Player> makePlayer() {
		auto player = std::make_shared<Player>();
		player->setGroup(std::make_shared<Group>());
		return player;
	}

}

class BatchUpdateTest : public ::testing::Test {
protected:
	void SetUp() override {
		TestItems::init();
	}
};

TEST_F(BatchUpdateTest, DeduplicatesContainersAndBalancesBeginEndCalls) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&player, &c1](BatchUpdate &batch) {
		EXPECT_TRUE(batch.add(c1));
		EXPECT_FALSE(batch.add(c1));
		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->beginCount, 1);
	});
	EXPECT_FALSE(player->isBatching());
	EXPECT_EQ(c1->endCount, 1);
}

TEST_F(BatchUpdateTest, AddReturnsFalseForNullContainers) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	BatchUpdate batch(player);
	EXPECT_TRUE(batch.add(c1));
	EXPECT_FALSE(batch.add(nullptr));
	EXPECT_TRUE(player->isBatching());
	EXPECT_EQ(c1->beginCount, 1);
}

TEST_F(BatchUpdateTest, AddContainersProcessesUniqueContainersOnce) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&player, &c1, &c2](BatchUpdate &batch) {
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
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&player, &c1](BatchUpdate &batch) {
		EXPECT_TRUE(batch.add(c1));
		player.reset();
	});
	EXPECT_EQ(c1->endCount, 1);
}

TEST_F(BatchUpdateTest, AddSkipsExpiredCachedContainers) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	BatchUpdate batch(player);
	EXPECT_TRUE(batch.add(c1));
	c1.reset();
	EXPECT_TRUE(batch.add(c2));
	EXPECT_EQ(c2->beginCount, 1);
}

TEST_F(BatchUpdateTest, AddContainersSkipsNullAndDuplicates) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	withBatchUpdate(player, [&player, &c1, &c2](BatchUpdate &batch) {
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
	auto player = makePlayer();
	withBatchUpdate(player, [&player](BatchUpdate &) {
		EXPECT_TRUE(player->isBatching());
	});
	EXPECT_FALSE(player->isBatching());
}

TEST_F(BatchUpdateTest, NestedBatchUpdatesKeepBatchingUntilOuterScopeEnds) {
	auto player = makePlayer();
	auto c1 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);
	auto c2 = std::make_shared<FakeContainer>(ITEM_REWARD_CONTAINER, 10);

	{
		BatchUpdate outer(player);
		EXPECT_TRUE(player->isBatching());
		EXPECT_TRUE(outer.add(c1));

		{
			BatchUpdate inner(player);
			EXPECT_TRUE(player->isBatching());
			EXPECT_TRUE(inner.add(c2));
		}

		EXPECT_TRUE(player->isBatching());
		EXPECT_EQ(c1->endCount, 0);
		EXPECT_EQ(c2->endCount, 1);
	}

	EXPECT_FALSE(player->isBatching());
	EXPECT_EQ(c1->endCount, 1);
	EXPECT_EQ(c2->endCount, 1);
}
