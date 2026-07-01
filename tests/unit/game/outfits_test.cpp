/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include <gtest/gtest.h>

#include "creatures/appearance/outfit/outfit.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "creatures/players/player.hpp"
#include "utils/worldpointer.hpp"
#include "utils/const.hpp"

#include "../../shared/mounts/mounts_test_fixture.hpp"

namespace {

	[[nodiscard]] inline std::shared_ptr<Player> makePlayer(PlayerSex_t sex) {
		auto player = std::make_shared<Player>();
		auto group = std::make_shared<Group>();
		group->access = false;
		player->setGroup(group);
		player->setSex(sex);
		return player;
	}

	inline void drainOutfits() {
		WorldPtr<Outfit>::quiescentState<Outfits::OutfitAllocator>();
	}

	// NOSONAR(cpp:S3630) — reinterpret_cast is intentional; this mirrors
	// the intrusive recovery the WorldPtr implementation itself relies on.
	[[nodiscard]] inline const WorldPtr<Outfit>::Block* blockOf(const Outfit* o) noexcept {
		return reinterpret_cast<const WorldPtr<Outfit>::Block*>(
			reinterpret_cast<const std::byte*>(o)
			- offsetof(WorldPtr<Outfit>::Block, value)
		);
	}

	class OutfitsApiTest : public test::mounts::MountsTestBase {
	protected:
		void SetUp() override {
			MountsTestBase::SetUp();
			ASSERT_TRUE(Outfits::getInstance().reload());
		}

		void TearDown() override {
			MountsTestBase::TearDown();
			drainOutfits();
		}
	};

	TEST_F(OutfitsApiTest, LoadFromXml_PopulatesBothSexes) {
		EXPECT_EQ(3u, Outfits::getInstance().getOutfits(PLAYERSEX_FEMALE).size());
		EXPECT_EQ(3u, Outfits::getInstance().getOutfits(PLAYERSEX_MALE).size());
	}

	TEST_F(OutfitsApiTest, GetOutfitByLookType_ReturnsCorrectOutfit) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		const auto outfit = Outfits::getInstance().getOutfitByLookType(player, 137);
		ASSERT_TRUE(static_cast<bool>(outfit));
		EXPECT_EQ("Hunter", outfit->name);
		EXPECT_EQ(137, outfit->lookType);
		EXPECT_TRUE(outfit->premium);
	}

	TEST_F(OutfitsApiTest, GetOutfitByLookType_RespectsPlayerSex) {
		const auto male = makePlayer(PLAYERSEX_MALE);
		const auto female = makePlayer(PLAYERSEX_FEMALE);

		EXPECT_FALSE(static_cast<bool>(Outfits::getInstance().getOutfitByLookType(male, 128)));
		EXPECT_TRUE(static_cast<bool>(Outfits::getInstance().getOutfitByLookType(female, 128)));
		EXPECT_TRUE(static_cast<bool>(Outfits::getInstance().getOutfitByLookType(male, 136)));
		EXPECT_FALSE(static_cast<bool>(Outfits::getInstance().getOutfitByLookType(female, 136)));
	}

	TEST_F(OutfitsApiTest, GetOutfitByLookType_OppositeSexFlag) {
		const auto male = makePlayer(PLAYERSEX_MALE);
		const auto outfit = Outfits::getInstance().getOutfitByLookType(male, 128, /*isOppositeOutfit=*/true);
		ASSERT_TRUE(static_cast<bool>(outfit));
		EXPECT_EQ("Citizen", outfit->name);
		EXPECT_EQ(128, outfit->lookType);
	}

	TEST_F(OutfitsApiTest, GetOutfitByName_CaseSensitiveMatch) {
		const auto outfit = Outfits::getInstance().getOutfitByName(PLAYERSEX_FEMALE, "Mage");
		ASSERT_TRUE(static_cast<bool>(outfit));
		EXPECT_EQ(130, outfit->lookType);
		EXPECT_FALSE(outfit->unlocked);
	}

	TEST_F(OutfitsApiTest, GetOutfitByName_MissingReturnsEmpty) {
		EXPECT_FALSE(static_cast<bool>(Outfits::getInstance().getOutfitByName(PLAYERSEX_FEMALE, "Nope")));
	}

	TEST_F(OutfitsApiTest, GetOutfitByLookType_PathIsZeroAtomicOps) {
		const auto player = makePlayer(PLAYERSEX_MALE);

		const auto first = Outfits::getInstance().getOutfitByLookType(player, 137);
		ASSERT_TRUE(static_cast<bool>(first));
		const auto refBefore = blockOf(first.get())->reference_count.load();

		for (int i = 0; i < 100; ++i) {
			(void)Outfits::getInstance().getOutfitByLookType(player, 137);
		}
		EXPECT_EQ(refBefore, blockOf(first.get())->reference_count.load())
			<< "Borrow path must not touch storage's refcount.";
	}

	TEST_F(OutfitsApiTest, BorrowToShared_BumpsExistingBlock) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		const auto borrow = Outfits::getInstance().getOutfitByLookType(player, 137);
		ASSERT_TRUE(static_cast<bool>(borrow));

		const auto refBefore = blockOf(borrow.get())->reference_count.load();
		WorldPtr<Outfit>::Shared<Outfits::OutfitAllocator> escaped = borrow;
		EXPECT_EQ(refBefore + 1, blockOf(borrow.get())->reference_count.load())
			<< "Boundary materialisation must bump the existing block.";
		EXPECT_EQ(borrow.get(), escaped.get());
	}

	TEST_F(OutfitsApiTest, BorrowToShared_LifetimeExtendsPastReload) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		WorldPtr<Outfit>::Shared<Outfits::OutfitAllocator> escaped = Outfits::getInstance().getOutfitByLookType(player, 137);
		ASSERT_TRUE(static_cast<bool>(escaped));
		const Outfit* outfitAddr = escaped.get();
		const std::string originalName = escaped->name;

		ASSERT_TRUE(Outfits::getInstance().reload());
		drainOutfits();

		EXPECT_EQ(originalName, escaped->name)
			<< "Shared extended Outfit lifetime past reload + QSBR drain.";
		EXPECT_EQ(outfitAddr, escaped.get());
		EXPECT_NE(escaped.get(), Outfits::getInstance().getOutfitByLookType(player, 137).get());
	}

	TEST_F(OutfitsApiTest, GetOutfitAddons_FreeOutfitGrantsZeroAddons) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		const auto outfit = Outfits::getInstance().getOutfitByLookType(player, 136);

		uint8_t addons = 99;
		EXPECT_TRUE(player->getOutfitAddons(outfit.get(), addons));
		EXPECT_EQ(0, addons);
	}

	TEST_F(OutfitsApiTest, GetOutfitAddons_PremiumOutfitRejectedForNonPremium) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		const auto outfit = Outfits::getInstance().getOutfitByLookType(player, 137);

		uint8_t addons = 99;
		EXPECT_FALSE(player->getOutfitAddons(outfit.get(), addons));
	}

	TEST_F(OutfitsApiTest, GetOutfitAddons_LockedOutfitRejected) {
		const auto player = makePlayer(PLAYERSEX_MALE);
		const auto outfit = Outfits::getInstance().getOutfitByLookType(player, 138);

		uint8_t addons = 99;
		EXPECT_FALSE(player->getOutfitAddons(outfit.get(), addons));
	}

} // namespace
