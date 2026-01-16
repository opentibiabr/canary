#include "pch.hpp"

#include <gtest/gtest.h>

#include <algorithm>

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"
#include "test_items.hpp"
#include "injection_fixture.hpp"

class PlayerRewardIterationTest : public ::testing::Test {
protected:
	void SetUp() override {
		TestItems::init();
	}

private:
	InjectionFixture fixture_ {};
};

TEST_F(PlayerRewardIterationTest, ForEachRewardItemSkipsRewardContainersAndVisitsItems) {
	auto player = std::make_shared<Player>();
	auto root = std::make_shared<Container>(ITEM_REWARD_CHEST, 10);
	auto itemA = std::make_shared<Item>(100);
	root->addItem(itemA);
	auto reward1 = std::make_shared<Container>(ITEM_REWARD_CONTAINER, 10);
	auto itemB = std::make_shared<Item>(101);
	reward1->addItem(itemB);
	auto reward2 = std::make_shared<Container>(ITEM_REWARD_CONTAINER, 10);
	auto itemC = std::make_shared<Item>(102);
	reward2->addItem(itemC);
	reward1->addItem(reward2);
	root->addItem(reward1);
	auto normal = std::make_shared<Container>(1987, 10);
	auto itemD = std::make_shared<Item>(103);
	normal->addItem(itemD);
	root->addItem(normal);

	const auto rewards = player->getRewardsFromContainer(root);
	ASSERT_EQ(rewards.size(), std::size_t { 4 });
	std::vector<uint16_t> ids;
	ids.reserve(rewards.size());
	for (const auto &item : rewards) {
		const auto &added = ids.emplace_back(item->getID());
		(void)added;
	}
	std::ranges::sort(ids);
	EXPECT_EQ(ids, (std::vector<uint16_t> { 100, 101, 102, 1987 }));
}

TEST_F(PlayerRewardIterationTest, ForEachRewardItemHandlesNullRoot) {
	auto player = std::make_shared<Player>();
	const auto rewards = player->getRewardsFromContainer(nullptr);
	EXPECT_TRUE(rewards.empty());
}

TEST_F(PlayerRewardIterationTest, ForEachRewardItemTraversesNestedNormalContainersInsideRewards) {
	auto player = std::make_shared<Player>();
	auto root = std::make_shared<Container>(ITEM_REWARD_CHEST, 10);
	auto reward = std::make_shared<Container>(ITEM_REWARD_CONTAINER, 10);
	auto nestedNormal = std::make_shared<Container>(1987, 10);
	reward->addItem(nestedNormal);
	auto plainItem = std::make_shared<Item>(105);
	reward->addItem(plainItem);
	root->addItem(reward);

	const auto rewards = player->getRewardsFromContainer(root);
	std::vector<uint16_t> visited;
	visited.reserve(rewards.size());
	for (const auto &item : rewards) {
		const auto &added = visited.emplace_back(item->getID());
		(void)added;
	}
	std::ranges::sort(visited);
	EXPECT_EQ(visited, (std::vector<uint16_t> { 105, 1987 }));
}
