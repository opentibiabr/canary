#include <gtest/gtest.h>

#include "creatures/players/imbuements/imbuements.hpp"
#include "creatures/players/player.hpp"
#include "items/item.hpp"
#include "items/items.hpp"
#include "../../shared/imbuements/imbuements_test_fixture.hpp"

namespace {

	class ImbuementsIntegrationTest : public test::imbuements::ImbuementsTestBase {
	};

	constexpr uint16_t kTestItemId = 100;

	struct ItemTypeScope {
		ItemTypeScope() {
			originalSize = Item::items.getItems().size();
			auto &items = Item::items.getItems();
			if (items.size() <= kTestItemId) {
				items.resize(kTestItemId + 1);
			}

			auto &itemType = Item::items.getItemType(kTestItemId);
			itemType = ItemType {};
			itemType.id = kTestItemId;
			itemType.name = "Imbued Bow";
			itemType.imbuementSlot = 1;
			itemType.setImbuementType(IMBUEMENT_SKILLBOOST_DISTANCE, 1);
		}

		// Rule of Zero: This struct uses a custom destructor for RAII cleanup of global state.
		// While it doesn't strictly follow the Rule of Zero, its purpose is limited to test scoping.
		~ItemTypeScope() noexcept {
			auto &items = Item::items.getItems();
			if (items.size() == originalSize) {
				return;
			}
			try {
				items.resize(originalSize);
			} catch (const std::exception &e) {
				// If resize fails during cleanup, leave the vector state as is.
				(void)e;
			}
		}

		size_t originalSize = 0;
	};

	TEST_F(ImbuementsIntegrationTest, AppliesAndRemovesImbuementSkillBonus) {
		ItemTypeScope itemScope;

		auto player = std::make_shared<Player>();
		ASSERT_TRUE(player->setVocation(1));
		auto* imbuement = g_imbuements().getImbuement(1);
		ASSERT_NE(nullptr, imbuement);

		const auto baseline = player->getSkillLevel(SKILL_DISTANCE);
		player->addItemImbuementStats(imbuement);
		EXPECT_EQ(baseline + 3, player->getSkillLevel(SKILL_DISTANCE));
		player->removeItemImbuementStats(imbuement);
		EXPECT_EQ(baseline, player->getSkillLevel(SKILL_DISTANCE));
	}

	TEST_F(ImbuementsIntegrationTest, FiltersImbuementsByItemType) {
		ItemTypeScope itemScope;

		auto player = std::make_shared<Player>();
		auto item = Item::CreateItem(kTestItemId, 1);
		ASSERT_NE(nullptr, item);

		auto imbuements = g_imbuements().getImbuements(player, item);
		ASSERT_EQ(1u, imbuements.size());
		EXPECT_EQ("Precision", imbuements.front()->getName());
	}

} // namespace
