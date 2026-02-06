#include "config/configmanager.hpp"
#include "creatures/players/player.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "game/game.hpp"
#include "items/containers/container.hpp"
#include "items/item.hpp"
#include "items/items.hpp"
#include "utils/utils_definitions.hpp"

namespace {

	class MoneyIntegrationTest : public ::testing::Test {
	protected:
		void SetUp() override {
			previousPath_ = std::filesystem::current_path();
			repoRoot_ = detectRepoRoot(previousPath_);
			ASSERT_FALSE(repoRoot_.empty()) << "Could not locate repository root";
			std::filesystem::current_path(repoRoot_);

			previousConfigFile_ = g_configManager().getConfigFileLua();
			g_configManager().setConfigFileLua("tests/fixture/config/imbuements_test.lua");
			ASSERT_TRUE(g_configManager().reload());
		}

		void TearDown() override {
			g_configManager().setConfigFileLua(previousConfigFile_);
			(void)g_configManager().reload();
			std::filesystem::current_path(previousPath_);
		}

	private:
		std::filesystem::path repoRoot_ {};
		std::filesystem::path previousPath_ {};
		std::string previousConfigFile_ {};

		[[nodiscard]] static std::filesystem::path detectRepoRoot(std::filesystem::path start) {
			const auto configPath = std::filesystem::path("tests/fixture/config/imbuements_test.lua");
			while (!start.empty()) {
				std::error_code configEc;
				const auto configExists = std::filesystem::exists(start / configPath, configEc);
				if (!configEc && configExists) {
					return start;
				}

				if (!start.has_parent_path() || start.parent_path() == start) {
					break;
				}
				start = start.parent_path();
			}

			return {};
		}
	};

	struct ItemTypeScope {
		ItemTypeScope() {
			auto &items = Item::items.getItems();
			originalSize_ = items.size();

			containerSmallId_ = static_cast<uint16_t>(items.size() + 1);
			containerLargeId_ = static_cast<uint16_t>(items.size() + 2);

			const uint16_t maxId = std::max<uint16_t>(
				containerLargeId_,
				std::max<uint16_t>(ITEM_GOLD_COIN, std::max<uint16_t>(ITEM_PLATINUM_COIN, ITEM_CRYSTAL_COIN))
			);
			if (items.size() <= maxId) {
				items.resize(static_cast<size_t>(maxId) + 1);
			}

			setupCoin(ITEM_GOLD_COIN);
			setupCoin(ITEM_PLATINUM_COIN);
			setupCoin(ITEM_CRYSTAL_COIN);

			setupContainer(containerSmallId_, 1);
			setupContainer(containerLargeId_, 2);
		}

		~ItemTypeScope() noexcept {
			auto &items = Item::items.getItems();
			if (items.size() > originalSize_) {
				try {
					items.resize(originalSize_);
				} catch (const std::exception &) {
					// If resize fails during cleanup, leave the vector state as is.
				}
			}
		}

		uint16_t containerSmallId() const {
			return containerSmallId_;
		}

		uint16_t containerLargeId() const {
			return containerLargeId_;
		}

	private:
		static void setupCoin(uint16_t id) {
			auto &itemType = Item::items.getItemType(id);
			if (itemType.id != 0) {
				return;
			}
			itemType = ItemType {};
			itemType.id = id;
			itemType.stackable = true;
			itemType.pickupable = true;
		}

		static void setupContainer(uint16_t id, uint16_t capacity) {
			auto &itemType = Item::items.getItemType(id);
			itemType = ItemType {};
			itemType.id = id;
			itemType.group = ITEM_GROUP_CONTAINER;
			itemType.maxItems = capacity;
			itemType.pickupable = true;
		}

		size_t originalSize_ = 0;
		uint16_t containerSmallId_ = 0;
		uint16_t containerLargeId_ = 0;
	};

} // namespace

TEST_F(MoneyIntegrationTest, RemovesMoneyAndReturnsChangeWhenPossible) {
	ItemTypeScope itemScope;
	const auto container = Container::create(itemScope.containerLargeId());
	ASSERT_NE(nullptr, container);

	const auto platinum = Item::CreateItem(ITEM_PLATINUM_COIN, 1);
	ASSERT_NE(nullptr, platinum);
	container->addThing(platinum);

	EXPECT_TRUE(g_game().removeMoney(container, 30, 0, false));

	ASSERT_EQ(1u, container->size());
	uint32_t totalWorth = 0;
	uint16_t itemId = 0;
	uint32_t itemCount = 0;
	for (const auto &item : container->getItemList()) {
		ASSERT_NE(nullptr, item);
		totalWorth += item->getWorth();
		itemId = item->getID();
		itemCount = item->getItemCount();
	}
	EXPECT_EQ(70u, totalWorth);
	EXPECT_EQ(ITEM_GOLD_COIN, itemId);
	EXPECT_EQ(70u, itemCount);
}

TEST_F(MoneyIntegrationTest, FailsWhenChangeCannotBeDelivered) {
	ItemTypeScope itemScope;
	const auto container = Container::create(itemScope.containerSmallId());
	ASSERT_NE(nullptr, container);

	const auto platinum = Item::CreateItem(ITEM_PLATINUM_COIN, 1);
	ASSERT_NE(nullptr, platinum);
	container->addThing(platinum);

	EXPECT_FALSE(g_game().removeMoney(container, 30, 0, false));

	ASSERT_EQ(1u, container->size());
	const auto &item = container->getItemList().front();
	ASSERT_NE(nullptr, item);
	EXPECT_EQ(ITEM_PLATINUM_COIN, item->getID());
	EXPECT_EQ(1u, item->getItemCount());
}

TEST_F(MoneyIntegrationTest, DebitsBankBalanceWhenEnabled) {
	ItemTypeScope itemScope;
	const auto player = std::make_shared<Player>();
	player->setGroup(std::make_shared<Group>());
	player->setBankBalance(1000);

	EXPECT_TRUE(g_game().removeMoney(player, 250, 0, true));
	EXPECT_EQ(750u, player->getBankBalance());
}
