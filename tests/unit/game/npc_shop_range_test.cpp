/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
#endif

#include "creatures/npcs/npc.hpp"
#include "creatures/npcs/npcs.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "items/tile.hpp"
#include "items/items_definitions.hpp"
#include "lib/logging/in_memory_logger.hpp"

namespace {
	constexpr uint32_t kPlayerGuid = 3974;
	constexpr auto kPlayerName = "NpcShopRangeTestPlayer";
	constexpr auto kNpcName = "NpcShopRangeTestNpc";
	constexpr uint16_t kShopItemId = ITEM_GOLD_COIN;
	const Position kPlayerPosition { 100, 100, 7 };
	const Position kOutOfRangeNpcPosition { 100, 106, 7 };

	void placeCreature(const std::shared_ptr<Creature> &creature, const Position &position) {
		auto tile = std::make_shared<DynamicTile>(position);
		tile->addThing(creature);
	}

	std::shared_ptr<Player> createRegisteredPlayer(Game &game) {
		auto player = std::make_shared<Player>();
		player->setGUID(kPlayerGuid);
		player->setName(kPlayerName);
		player->setID();
		placeCreature(player, kPlayerPosition);
		game.addPlayer(player);
		return player;
	}

	std::shared_ptr<Npc> createOutOfRangeShopNpc() {
		auto npcType = std::make_shared<NpcType>(kNpcName);
		npcType->name = kNpcName;
		npcType->nameDescription = kNpcName;
		auto &shopItem = npcType->info.shopItemVector.emplace_back();
		shopItem.itemId = kShopItemId;
		shopItem.itemName = "gold coin";
		shopItem.itemBuyPrice = 1;
		shopItem.itemSellPrice = 1;

		auto npc = std::make_shared<Npc>(npcType);
		npc->setID();
		placeCreature(npc, kOutOfRangeNpcPosition);
		return npc;
	}

	void openOutOfRangeShop(const std::shared_ptr<Player> &player, const std::shared_ptr<Npc> &npc) {
		ASSERT_FALSE(npc->canInteract(player->getPosition()));
		ASSERT_TRUE(player->openShopWindow(npc, npc->getShopItemVector(player->getGUID())));
		ASSERT_NE(nullptr, player->getShopOwner());
	}

	class NpcShopRangeTest : public ::testing::Test {
	public:
		static void SetUpTestSuite() {
			previousTestContainer = DI::getTestContainer();
			injector = std::make_unique<di::extension::injector<>>();
			InMemoryLogger::install(*injector);
			DI::setTestContainer(injector.get());
		}

		static void TearDownTestSuite() {
			DI::setTestContainer(previousTestContainer);
			injector.reset();
		}

		void openOutOfRangeShop() const {
			::openOutOfRangeShop(player, npc);
		}

		void buyItemFromOutOfRangeNpc() {
			game.playerBuyItem(player->getID(), kShopItemId, 0, 1);
		}

		void sellItemToOutOfRangeNpc() {
			game.playerSellItem(player->getID(), kShopItemId, 0, 1);
		}

		void lookAtShopItemFromOutOfRangeNpc() {
			game.playerLookInShop(player->getID(), kShopItemId, 0);
		}

		void expectShopClosedWithoutTransaction() const {
			EXPECT_EQ(nullptr, player->getShopOwner());
			EXPECT_EQ(startBankBalance, player->getBankBalance());
			EXPECT_EQ(startHasShopItem, player->hasItemCountById(kShopItemId, 1, false));
		}

	private:
		void SetUp() override {
			player = createRegisteredPlayer(game);
			npc = createOutOfRangeShopNpc();
			startBankBalance = player->getBankBalance();
			startHasShopItem = player->hasItemCountById(kShopItemId, 1, false);
		}

		Game game;
		std::shared_ptr<Player> player;
		std::shared_ptr<Npc> npc;
		uint64_t startBankBalance = 0;
		bool startHasShopItem = false;

		inline static std::unique_ptr<di::extension::injector<>> injector;
		inline static di::extension::injector<>* previousTestContainer = nullptr;
	};
}

TEST_F(NpcShopRangeTest, BuyRequestClosesShopAndShortCircuitsWhenNpcIsOutOfRange) {
	openOutOfRangeShop();

	buyItemFromOutOfRangeNpc();

	expectShopClosedWithoutTransaction();
}

TEST_F(NpcShopRangeTest, SellRequestClosesShopAndShortCircuitsWhenNpcIsOutOfRange) {
	openOutOfRangeShop();

	sellItemToOutOfRangeNpc();

	expectShopClosedWithoutTransaction();
}

TEST_F(NpcShopRangeTest, LookRequestClosesShopAndShortCircuitsWhenNpcIsOutOfRange) {
	openOutOfRangeShop();

	lookAtShopItemFromOutOfRangeNpc();

	expectShopClosedWithoutTransaction();
}
