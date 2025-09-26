#include "pch.hpp"

#include <boost/ut.hpp>

#include "creatures/players/player.hpp"
#include "items/containers/container.hpp"
#include "test_items.hpp"
#include "injection_fixture.hpp"
#include "config/configmanager.hpp"

using namespace boost::ut;

suite<"reward_iteration"> rewardIterationTest = [] {
	test("forEachRewardItem skips reward containers and visits items") = [] {
		TestItems::init();

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

		size_t count = 0;
		player->forEachRewardItem(root.get(), [&](const std::shared_ptr<Item> &) { ++count; });
		expect(eq(count, std::size_t { 4 }));
	};
};
