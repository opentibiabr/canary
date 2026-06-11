/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <gtest/gtest.h>

#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "game/game.hpp"
#include "items/item.hpp"
#include "items/items.hpp"
#include "items/items_classification.hpp"
#include "utils/tools.hpp"
#include "utils/utils_definitions.hpp"

namespace {
	constexpr char kTestPathSuffix1[] = "\\tests\\integration\\game\\forge_it.cpp";
	constexpr char kTestPathSuffix2[] = "/tests/integration/game/forge_it.cpp";

	std::string detectRepoRoot() {
		std::string filePath = __FILE__;
		const auto markerPos1 = filePath.find(kTestPathSuffix1);
		if (markerPos1 != std::string::npos) {
			return filePath.substr(0, markerPos1);
		}

		const auto markerPos2 = filePath.find(kTestPathSuffix2);
		if (markerPos2 != std::string::npos) {
			return filePath.substr(0, markerPos2);
		}

		auto repoMarkerPos = filePath.find("\\tests\\");
		if (repoMarkerPos != std::string::npos) {
			return filePath.substr(0, repoMarkerPos);
		}

		repoMarkerPos = filePath.find("/tests/");
		if (repoMarkerPos != std::string::npos) {
			return filePath.substr(0, repoMarkerPos);
		}
		return {};
	}

	bool hasItem(const Player &player, uint16_t itemId, uint8_t tier = 0) {
		for (const auto &item : player.getAllInventoryItems(false)) {
			if (!item) {
				continue;
			}
			if (item->getID() == itemId && item->getTier() == tier) {
				return true;
			}
		}
		return false;
	}

	size_t countItem(const Player &player, uint16_t itemId, uint8_t tier = 0) {
		size_t total = 0;
		for (const auto &item : player.getAllInventoryItems(false)) {
			if (!item) {
				continue;
			}
			if (item->getID() == itemId && item->getTier() == tier) {
				++total;
			}
		}
		return total;
	}

	struct ForgeIntegrationState {
		ForgeIntegrationState() {
			originalItemTypeSize = Item::items.getItems().size();

			firstForgeItemId = static_cast<uint16_t>(originalItemTypeSize + 10);
			secondForgeItemId = static_cast<uint16_t>(firstForgeItemId + 1);
			donorItemId = static_cast<uint16_t>(firstForgeItemId + 2);
			receiveItemId = static_cast<uint16_t>(firstForgeItemId + 3);

			auto &items = Item::items.getItems();
			items.resize(firstForgeItemId + 20);

			classificationId = pickAvailableClassificationId();
			auto* classification = g_game().getItemsClassification(classificationId, true);
			if (classification == nullptr) {
				ready = false;
				return;
			}
			classification->addTier(1, 3, 200, 140, 120);
			classification->addTier(2, 4, 320, 160, 140);

			setupItemType(firstForgeItemId);
			setupItemType(secondForgeItemId);
			setupItemType(donorItemId);
			setupItemType(receiveItemId);
			ready = true;
		}

		~ForgeIntegrationState() {
			auto &items = Item::items.getItems();
			if (items.size() > originalItemTypeSize) {
				items.resize(originalItemTypeSize);
			}
		}

		[[nodiscard]] const ItemClassification* getClassification() const {
			if (!ready) {
				return nullptr;
			}
			return g_game().getItemsClassification(classificationId, true);
		}

		[[nodiscard]] bool isReady() const {
			return ready;
		}

		[[nodiscard]] uint16_t fusionCostForTier(uint8_t tier) const {
			const auto* classification = getClassification();
			if (!classification || !classification->tiers.contains(tier)) {
				return 0;
			}
			return static_cast<uint16_t>(classification->tiers.at(tier).regularPrice);
		}

		uint16_t firstForgeItemId {};
		uint16_t secondForgeItemId {};
		uint16_t donorItemId {};
		uint16_t receiveItemId {};
		uint8_t classificationId {};
		bool ready = false;

	private:
		size_t originalItemTypeSize {};

		[[nodiscard]] uint8_t pickAvailableClassificationId() const {
			const auto &classifications = g_game().getItemsClassifications();
			for (uint16_t id = 1; id <= 255; ++id) {
				bool exists = false;
				for (const auto* classification : classifications) {
					if (classification && classification->id == static_cast<uint8_t>(id)) {
						exists = true;
						break;
					}
				}
				if (!exists) {
					return static_cast<uint8_t>(id);
				}
			}
			return 1;
		}

		void setupItemType(uint16_t itemId) const {
			auto &itemType = Item::items.getItemType(itemId);
			itemType = ItemType {};
			itemType.id = itemId;
			itemType.name = "Forge test item";
			itemType.pickupable = true;
			itemType.movable = true;
			itemType.slotPosition = 0;
			itemType.type = ITEM_TYPE_TOOLS;
			itemType.upgradeClassification = classificationId;
		}
	};

} // namespace

class ForgeIntegrationTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		suiteReady = false;
		skipReason.clear();

		repositoryRoot = detectRepoRoot();
		if (repositoryRoot.empty()) {
			skipReason = "Repository root was not detected from test source path.";
			return;
		}

		state = std::make_unique<ForgeIntegrationState>();
		if (!state || !state->isReady()) {
			skipReason = "Forge test state setup failed.";
			return;
		}

		nextPlayerGuid = 1000u;
		suiteReady = true;
	}

	static void TearDownTestSuite() {
		state.reset();
	}

	void SetUp() override {
		if (!suiteReady) {
			GTEST_SKIP() << skipReason;
		}

		auto currentPlayer = std::make_shared<Player>(nullptr);
		auto currentGroup = std::make_shared<Group>();
		currentGroup->id = 1;
		currentGroup->name = "Test Player Group";
		currentGroup->access = false;
		currentGroup->maxDepotItems = 2000;
		currentGroup->maxVipEntries = 100;
		currentPlayer->setGroup(currentGroup);

		currentPlayer->setGUID(nextPlayerGuid++);
		currentPlayer->setID();
		currentPlayer->setName("ForgeItPlayer" + std::to_string(currentPlayer->getGUID()));
		g_game().addPlayer(currentPlayer);
		player = std::move(currentPlayer);
	}

	void TearDown() override {
		if (player) {
			g_game().removePlayer(player);
		}
		player.reset();
	}

	static void seedGameRng(uint32_t seed) {
		getRandomGenerator().seed(seed);
	}

	const ForgeIntegrationState &testState() const {
		return *state;
	}

	void ensureBackpack() const {
		const auto &backpack = Item::CreateItem(ITEM_BACKPACK, 1);
		ASSERT_NE(nullptr, backpack);
		EXPECT_EQ(RETURNVALUE_NOERROR, g_game().internalPlayerAddItem(player, backpack, false, CONST_SLOT_BACKPACK));
		ASSERT_NE(nullptr, player->getBackpack());
	}

	void addPlayerItemBackpack(uint16_t itemId, uint8_t tier, uint8_t count = 1) const {
		for (uint8_t i = 0; i < count; ++i) {
			const auto &item = Item::CreateItem(itemId, 1);
			ASSERT_NE(nullptr, item);
			item->setTier(tier);
			EXPECT_EQ(RETURNVALUE_NOERROR, g_game().internalPlayerAddItem(player, item, false, CONST_SLOT_BACKPACK));
		}
	}

	void fillBackpackWithCopies(uint16_t itemId) const {
		ASSERT_NE(nullptr, player->getBackpack());
		while (player->getFreeBackpackSlots() > 0) {
			const auto &item = Item::CreateItem(itemId, 1);
			ASSERT_NE(nullptr, item);
			item->setTier(1);
			EXPECT_EQ(RETURNVALUE_NOERROR, g_game().internalPlayerAddItem(player, item, false, CONST_SLOT_BACKPACK));
		}
	}

	void setPlayerResources(uint64_t dust, uint64_t bankBalance) const {
		player->setForgeDusts(dust);
		player->setBankBalance(bankBalance);
	}

	inline static std::unique_ptr<ForgeIntegrationState> state;
	inline static uint32_t nextPlayerGuid = 1;
	inline static std::string repositoryRoot {};
	inline static bool suiteReady = false;
	inline static std::string skipReason {};
	std::shared_ptr<Player> player;
};

TEST_F(ForgeIntegrationTest, ForgeFuseItemsViaGameFlowAddsExaltationChestAndConsumesInputs) {
	ensureBackpack();
	const auto &fixture = testState();

	seedGameRng(1337);
	const uint64_t dustCost = g_configManager().getNumber(FORGE_FUSION_DUST_COST);
	const uint64_t goldCost = fixture.fusionCostForTier(2);
	setPlayerResources(dustCost + 5, goldCost + 7);
	addPlayerItemBackpack(fixture.firstForgeItemId, 1);
	addPlayerItemBackpack(fixture.secondForgeItemId, 1);

	const auto startDust = player->getForgeDusts();
	const auto startBalance = player->getBankBalance();
	const auto startChest = countItem(*player, ITEM_EXALTATION_CHEST, 0);
	const auto startFirstTier = countItem(*player, fixture.firstForgeItemId, 1);
	const auto startSecondTier = countItem(*player, fixture.secondForgeItemId, 1);

	player->forgeFuseItems(ForgeAction_t::FUSION, fixture.firstForgeItemId, 1, fixture.secondForgeItemId, true, false, false, 0, 0);

	EXPECT_EQ(player->getForgeDusts(), startDust - dustCost);
	EXPECT_EQ(player->getBankBalance(), startBalance - goldCost);
	EXPECT_GT(countItem(*player, ITEM_EXALTATION_CHEST, 0), startChest);
	EXPECT_EQ(countItem(*player, fixture.firstForgeItemId, 1), startFirstTier - 1u);
	EXPECT_EQ(countItem(*player, fixture.secondForgeItemId, 1), startSecondTier - 1u);
}

TEST_F(ForgeIntegrationTest, ForgeTransferItemTierViaGameFlowTransfersHigherTierIntoExaltationChest) {
	ensureBackpack();
	const auto &fixture = testState();

	const uint8_t transferToTier = 1;
	const uint8_t transferFromTier = 2;
	const auto* classification = fixture.getClassification();
	ASSERT_NE(nullptr, classification);
	const auto transferCoreCost = classification->tiers.contains(transferToTier) ? classification->tiers.at(transferToTier).corePrice : 0;
	const auto transferGoldCost = fixture.fusionCostForTier(transferToTier);
	const uint64_t dustCost = g_configManager().getNumber(FORGE_TRANSFER_DUST_COST);

	setPlayerResources(dustCost, transferGoldCost + 7);
	const auto startDust = player->getForgeDusts();
	const auto startBalance = player->getBankBalance();
	const auto startChest = countItem(*player, ITEM_EXALTATION_CHEST, 0);

	addPlayerItemBackpack(fixture.donorItemId, transferFromTier);
	addPlayerItemBackpack(fixture.receiveItemId, 0);

	const auto &forgeCore = Item::CreateItem(ITEM_FORGE_CORE, transferCoreCost);
	ASSERT_NE(nullptr, forgeCore);
	ASSERT_EQ(RETURNVALUE_NOERROR, g_game().internalPlayerAddItem(player, forgeCore, false, CONST_SLOT_BACKPACK));

	player->forgeTransferItemTier(ForgeAction_t::TRANSFER, fixture.donorItemId, transferFromTier, fixture.receiveItemId, false);

	EXPECT_EQ(player->getForgeDusts(), startDust - dustCost);
	EXPECT_EQ(player->getBankBalance(), startBalance - transferGoldCost);
	EXPECT_FALSE(hasItem(*player, fixture.donorItemId, transferFromTier));
	EXPECT_FALSE(hasItem(*player, fixture.receiveItemId, 0));
	EXPECT_TRUE(hasItem(*player, fixture.receiveItemId, 1));
	EXPECT_GT(countItem(*player, ITEM_EXALTATION_CHEST, 0), startChest);
}

TEST_F(ForgeIntegrationTest, ForgeFuseItemsFromGameFlowFailsWhenBackpackIsFull) {
	ensureBackpack();
	const auto &fixture = testState();

	setPlayerResources(10, 1000);
	const auto startDust = player->getForgeDusts();
	const auto startBalance = player->getBankBalance();

	addPlayerItemBackpack(fixture.firstForgeItemId, 1, 1);
	addPlayerItemBackpack(fixture.secondForgeItemId, 1, 1);
	fillBackpackWithCopies(fixture.receiveItemId);

	ASSERT_EQ(0u, player->getFreeBackpackSlots());

	player->forgeFuseItems(ForgeAction_t::FUSION, fixture.firstForgeItemId, 1, fixture.secondForgeItemId, true, false, false, 0, 0);

	EXPECT_FALSE(hasItem(*player, ITEM_EXALTATION_CHEST));
	EXPECT_EQ(player->getBankBalance(), startBalance);
	EXPECT_EQ(player->getForgeDusts(), startDust);
	EXPECT_TRUE(hasItem(*player, fixture.firstForgeItemId, 1));
	EXPECT_TRUE(hasItem(*player, fixture.secondForgeItemId, 1));
}
