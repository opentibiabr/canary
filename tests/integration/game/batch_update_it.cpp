#include <gtest/gtest.h>

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"
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

	TEST_F(BatchUpdateIntegrationTest, EndsBatchUpdatesWhenActorLeavesScope) {
		auto player = std::make_shared<Player>();
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
}
