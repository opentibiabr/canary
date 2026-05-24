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

#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/players/components/player_title.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "utils/worldpointer.hpp"
#include "utils/const.hpp"

#include "../../shared/mounts/mounts_test_fixture.hpp"

namespace {

	[[nodiscard]] inline std::shared_ptr<Player> makeTestPlayer() {
		auto player = std::make_shared<Player>();
		auto group = std::make_shared<Group>();
		group->access = false;
		player->setGroup(group);
		return player;
	}

	inline void tameMountBit(Player &player, uint8_t mountId) {
		const uint8_t tmpId = mountId - 1;
		const uint32_t key = PSTRG_MOUNTS_RANGE_START + (tmpId / 31);
		const int32_t bit = 1 << (tmpId % 31);
		const int32_t prev = player.getStorageValue(key);
		const int32_t next = (prev == -1) ? bit : (prev | bit);
		player.addStorageValue(key, next, /*isLogin=*/true);
	}

	inline void drainMounts() {
		WorldPtr<Mount>::quiescentState<Mounts::MountAllocator>();
	}

	// Recover the Block* from a Mount* via the same offsetof trick the
	// WorldPtr internals use. Used to assert refcount semantics directly.
	// NOSONAR(cpp:S3630) — reinterpret_cast is intentional; this mirrors
	// the intrusive recovery the WorldPtr implementation itself relies on.
	[[nodiscard]] inline const WorldPtr<Mount>::Block* blockOf(const Mount* m) noexcept {
		return reinterpret_cast<const WorldPtr<Mount>::Block*>(
			reinterpret_cast<const std::byte*>(m)
			- offsetof(WorldPtr<Mount>::Block, value)
		);
	}

	class MountsApiTest : public test::mounts::MountsTestBase { };

	class GlobalMountsTest : public test::mounts::MountsTestBase {
	protected:
		void SetUp() override {
			MountsTestBase::SetUp();
			ASSERT_TRUE(g_game().mounts->reload());
		}

		void TearDown() override {
			MountsTestBase::TearDown();
			drainMounts();
		}
	};

	// --- Empty Mounts -----------------------------------------------------

	TEST_F(MountsApiTest, EmptyMounts_GetByID_ReturnsEmptyBorrow) {
		Mounts mounts;
		auto borrow = mounts.getMountByID(1);
		EXPECT_FALSE(static_cast<bool>(borrow));
		EXPECT_TRUE(borrow == nullptr);
	}

	TEST_F(MountsApiTest, EmptyMounts_GetByName_ReturnsEmptyBorrow) {
		Mounts mounts;
		EXPECT_FALSE(static_cast<bool>(mounts.getMountByName("Widow Queen")));
	}

	TEST_F(MountsApiTest, EmptyMounts_GetByClientID_ReturnsEmptyBorrow) {
		Mounts mounts;
		EXPECT_FALSE(static_cast<bool>(mounts.getMountByClientID(368)));
	}

	// --- Populated Mounts -------------------------------------------------

	TEST_F(MountsApiTest, LoadFromXml_PopulatesMounts) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());
		EXPECT_EQ(3u, mounts.getMounts().size());
	}

	TEST_F(MountsApiTest, GetByID_ReturnsCorrectMount) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const auto borrow = mounts.getMountByID(1);
		ASSERT_TRUE(static_cast<bool>(borrow));
		EXPECT_EQ(1, borrow->id);
		EXPECT_EQ(368, borrow->clientId);
		EXPECT_EQ("Widow Queen", borrow->name);
		EXPECT_EQ(10, borrow->speed);
		EXPECT_TRUE(borrow->premium);
		EXPECT_EQ("quest", borrow->type);
	}

	TEST_F(MountsApiTest, GetByName_CaseInsensitive) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const auto borrow = mounts.getMountByName("racing bird");
		ASSERT_TRUE(static_cast<bool>(borrow));
		EXPECT_EQ(2, borrow->id);
		EXPECT_EQ(20, borrow->speed);
		EXPECT_FALSE(borrow->premium);
	}

	TEST_F(MountsApiTest, GetByClientID_ReturnsCorrectMount) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const auto borrow = mounts.getMountByClientID(370);
		ASSERT_TRUE(static_cast<bool>(borrow));
		EXPECT_EQ(3, borrow->id);
		EXPECT_EQ("War Bear", borrow->name);
	}

	TEST_F(MountsApiTest, GetByMissingID_ReturnsEmpty) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		EXPECT_FALSE(static_cast<bool>(mounts.getMountByID(99)));
		EXPECT_FALSE(static_cast<bool>(mounts.getMountByName("Unicorn")));
		EXPECT_FALSE(static_cast<bool>(mounts.getMountByClientID(999)));
	}

	// --- Strict zero-atomic-op contract for getter path ------------------

	TEST_F(MountsApiTest, Getter_PathIsZeroAtomicOps) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const auto first = mounts.getMountByID(1);
		ASSERT_TRUE(static_cast<bool>(first));
		const auto refBefore = blockOf(first.get())->reference_count.load();

		for (int i = 0; i < 100; ++i) {
			(void)mounts.getMountByID(1);
		}
		EXPECT_EQ(refBefore, blockOf(first.get())->reference_count.load())
			<< "Borrow path must not touch storage's refcount.";
	}

	TEST_F(MountsApiTest, BorrowToShared_BumpsExistingControlBlock) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const auto borrow = mounts.getMountByID(1);
		ASSERT_TRUE(static_cast<bool>(borrow));
		const auto refBefore = blockOf(borrow.get())->reference_count.load();

		WorldPtr<Mount>::Shared<Mounts::MountAllocator> escaped = borrow;

		EXPECT_EQ(refBefore + 1, blockOf(borrow.get())->reference_count.load())
			<< "Boundary materialisation must bump the existing block.";
		EXPECT_EQ(borrow.get(), escaped.get());
	}

	TEST_F(MountsApiTest, BorrowToShared_LifetimeExtendsPastReload) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		WorldPtr<Mount>::Shared<Mounts::MountAllocator> escaped = mounts.getMountByID(1);
		ASSERT_TRUE(static_cast<bool>(escaped));
		const Mount* mountAddr = escaped.get();
		const std::string borrowedName = escaped->name;

		// Reload retires all storage owners. Drain. The escaped Shared
		// keeps the original block alive because it still holds +1 on
		// the refcount.
		ASSERT_TRUE(mounts.reload());
		drainMounts();

		EXPECT_EQ(borrowedName, escaped->name)
			<< "Shared extended Mount lifetime past reload + QSBR drain.";
		EXPECT_EQ(mountAddr, escaped.get());
		EXPECT_NE(escaped.get(), mounts.getMountByID(1).get());
	}

	TEST_F(MountsApiTest, BorrowsToSamePointee_FromMultipleLookups) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		auto a = mounts.getMountByID(3);
		auto b = mounts.getMountByID(3);
		ASSERT_TRUE(static_cast<bool>(a));
		ASSERT_TRUE(static_cast<bool>(b));
		EXPECT_EQ(a.get(), b.get())
			<< "All borrows hand out the same Mount instance from storage.";
		EXPECT_EQ("War Bear", b->name);
	}

	TEST_F(MountsApiTest, TernaryWithEmptyBorrow_CompilesAndWorks) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		bool flag = true;
		const auto a = flag ? mounts.getMountByID(1) : Mounts::BorrowedMount {};
		flag = false;
		const auto b = flag ? mounts.getMountByID(1) : Mounts::BorrowedMount {};

		ASSERT_TRUE(static_cast<bool>(a));
		EXPECT_EQ("Widow Queen", a->name);
		EXPECT_FALSE(static_cast<bool>(b));
	}

	// --- Reload defers via Owning destructors -----------------------------

	TEST_F(MountsApiTest, Reload_DefersOldMountsToQSBR) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		drainMounts();

		ASSERT_TRUE(mounts.reload());

		// Right after reload, refcount on the old blocks dropped to 0
		// in the retire list, but the actual destruction is deferred —
		// they remain "live" allocations until quiescentState runs.
		drainMounts();
		EXPECT_EQ(3u, mounts.getMounts().size());
	}

	TEST_F(MountsApiTest, Reload_PreservesSurroundingTickBorrow) {
		Mounts mounts;
		ASSERT_TRUE(mounts.loadFromXml());

		const Mount* borrow = mounts.getMountByID(1).get();
		ASSERT_NE(nullptr, borrow);
		const std::string borrowedName = borrow->name;

		ASSERT_TRUE(mounts.reload());

		// QSBR-deferred drop keeps the old Mount alive across the reload,
		// up to the next quiescentState.
		EXPECT_EQ(borrowedName, borrow->name);
		EXPECT_EQ(3u, mounts.getMounts().size());

		drainMounts();
	}

	// --- Player::hasMount(const Mount*) direct ----------------------------
	// Use the shared fixture so `g_configManager().reload()` populates every
	// config key — `Player::isPremium()` reads `FREE_PREMIUM`, and without
	// the reload we'd see "invalid or wrong type index" warnings.
	class PlayerHasMountTest : public test::mounts::MountsTestBase { };

	TEST_F(PlayerHasMountTest, FalseWhenStorageBitNotSet) {
		auto player = makeTestPlayer();
		Mount mount(1, 100, "Test", 10, false, "test");
		EXPECT_FALSE(player->hasMount(&mount));
	}

	TEST_F(PlayerHasMountTest, TrueAfterTamingViaStorageBitmask) {
		auto player = makeTestPlayer();
		Mount mount(1, 100, "Test", 10, false, "test");
		tameMountBit(*player, mount.id);
		EXPECT_TRUE(player->hasMount(&mount));
	}

	TEST_F(PlayerHasMountTest, PremiumMountRejectedForNonPremiumPlayer) {
		auto player = makeTestPlayer();
		Mount mount(1, 100, "Premium", 10, true /*premium*/, "test");
		tameMountBit(*player, mount.id);
		EXPECT_FALSE(player->hasMount(&mount));
	}

	TEST_F(PlayerHasMountTest, MountInDifferentStorageWordIsIndependent) {
		auto player = makeTestPlayer();
		Mount mount32(32, 100, "M32", 10, false, "test");

		tameMountBit(*player, 1);
		EXPECT_FALSE(player->hasMount(&mount32));

		tameMountBit(*player, 32);
		EXPECT_TRUE(player->hasMount(&mount32));
	}

	// Player::hasAnyMount + getRandomMountId (need g_game().mounts)

	TEST_F(GlobalMountsTest, HasAnyMount_FalseWhenNothingTamed) {
		auto player = makeTestPlayer();
		EXPECT_FALSE(player->hasAnyMount());
	}

	TEST_F(GlobalMountsTest, HasAnyMount_TrueAfterTaming) {
		auto player = makeTestPlayer();
		tameMountBit(*player, 2);
		EXPECT_TRUE(player->hasAnyMount());
	}

	TEST_F(GlobalMountsTest, GetRandomMountId_ZeroWhenNothingTamed) {
		auto player = makeTestPlayer();
		EXPECT_EQ(0, player->getRandomMountId());
	}

	TEST_F(GlobalMountsTest, GetRandomMountId_ReturnsTamedMountId) {
		auto player = makeTestPlayer();
		tameMountBit(*player, 2);
		EXPECT_EQ(2, player->getRandomMountId());
	}

	// --- PlayerTitle::checkMount ----------------------------------------

	TEST_F(GlobalMountsTest, PlayerTitleCheckMount_FalseUnderThreshold) {
		auto player = makeTestPlayer();
		PlayerTitle title(*player);
		EXPECT_FALSE(title.checkMount(1));
	}

	TEST_F(GlobalMountsTest, PlayerTitleCheckMount_TrueAtThreshold) {
		auto player = makeTestPlayer();
		tameMountBit(*player, 1);
		tameMountBit(*player, 2);

		PlayerTitle title(*player);
		EXPECT_TRUE(title.checkMount(1));
		EXPECT_FALSE(title.checkMount(2));
		EXPECT_FALSE(title.checkMount(3));
	}

} // namespace
