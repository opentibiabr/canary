/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "creatures/appearance/mounts/mounts.hpp"
#include "creatures/players/grouping/groups.hpp"
#include "creatures/players/player.hpp"
#include "game/game.hpp"
#include "lua/functions/creatures/creature_functions.hpp"
#include "lua/functions/lua_functions_loader.hpp"
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

	// Lua harness for the Mount/Player Lua bindings. Pulls in the same
	// fixture XML used by the C++ Mounts tests so that Mount(id) and
	// player:hasMount(id) hit real data.
	// NOSONAR(cpp:S3656,cpp:S1242) — `protected:` is the standard GTest
	// fixture access for SetUp/TearDown overrides; the methods ARE virtual
	// (inherited from ::testing::Test) but Sonar can't see GTest's headers.
	class MountLuaTest : public test::mounts::MountsTestBase {
	protected:
		void SetUp() override {
			MountsTestBase::SetUp();
			// reload() = clear + load fixture. Idempotent against any
			// state left over by a previous test suite that touched the
			// g_game().mounts singleton.
			ASSERT_TRUE(g_game().mounts->reload());

			L = luaL_newstate();
			ASSERT_NE(nullptr, L);
			luaL_openlibs(L);
			// CreatureFunctions::init registers Creature (root class) and
			// transitively initialises PlayerFunctions, MountFunctions,
			// and the rest of the player Lua bindings — exactly what the
			// real loader does in lua_loader.cpp.
			CreatureFunctions::init(L);
		}

		void TearDown() override {
			if (L) {
				lua_close(L);
				L = nullptr;
			}
			MountsTestBase::TearDown();
			WorldPtr<Mount>::quiescentState<Mounts::MountAllocator>();
		}

		// Helper: push a Player userdata and bind it to a global name
		// so subsequent Lua snippets can reference it as `p`.
		void bindPlayerAsGlobal(const std::shared_ptr<Player> &player) {
			Lua::pushUserdata<Player>(L, player);
			Lua::setMetatable(L, -1, "Player");
			lua_setglobal(L, "p");
		}

		lua_State* L = nullptr;
	};

	// --- Mount(id) factory (mount_functions.cpp luaCreateMount) -----------

	TEST_F(MountLuaTest, MountFactory_ById_PushesUserdataWithCorrectName) {
		// Lua: Mount(1):getName()
		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return Mount(1):getName()"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isstring(L, -1));
		EXPECT_STREQ("Widow Queen", lua_tostring(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, MountFactory_ByName_ReturnsSameMount) {
		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return Mount('Racing Bird'):getId()"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isnumber(L, -1));
		EXPECT_EQ(2, lua_tointeger(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, MountFactory_NonexistentId_ReturnsNil) {
		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return Mount(99)"))
			<< lua_tostring(L, -1);
		EXPECT_TRUE(lua_isnil(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, MountFactory_GetSpeedAndClientId) {
		ASSERT_EQ(LUA_OK, luaL_dostring(L, R"(
			local m = Mount(2)
			return m:getSpeed(), m:getClientId()
		)")) << lua_tostring(L, -1);
		ASSERT_TRUE(lua_isnumber(L, -2));
		ASSERT_TRUE(lua_isnumber(L, -1));
		EXPECT_EQ(20, lua_tointeger(L, -2));
		EXPECT_EQ(369, lua_tointeger(L, -1));
		lua_pop(L, 2);
	}

	// --- The boundary materialization keeps storage's Mount alive --------
	//
	// Pushing a Mount userdata into Lua stores a `WorldPtr<Mount>::Shared`
	// (8 bytes — just `Mount*`) inside the Lua-managed memory. Construction
	// bumps the existing block's refcount once. When Lua's __gc runs (via
	// `luaAffineGarbageCollection<Mount>`) the Shared destructor decrements
	// the refcount; storage's Owning reference is unaffected.

	TEST_F(MountLuaTest, BoundaryShare_DoesNotInvalidateStorageEntry) {
		ASSERT_EQ(LUA_OK, luaL_dostring(L, R"(
			-- Hold and immediately release the userdata.
			local m = Mount(1)
			m = nil
			collectgarbage("collect")
		)")) << lua_tostring(L, -1);

		// Storage still serves the Mount via getMountByID.
		const auto borrow = g_game().mounts->getMountByID(1);
		ASSERT_TRUE(static_cast<bool>(borrow));
		EXPECT_EQ("Widow Queen", borrow->name);
	}

	// --- player:hasMount Lua binding (luaPlayerHasMount) ------------------
	//
	// The C++ entrypoint uses WorldPtr<Mount>::Borrowed internally and
	// forwards .get() to Player::hasMount(const Mount*). These tests pin
	// the Lua-facing contract.

	TEST_F(MountLuaTest, PlayerHasMount_FalseByDefault) {
		bindPlayerAsGlobal(makeTestPlayer());

		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return p:hasMount(2)"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isboolean(L, -1));
		EXPECT_FALSE(lua_toboolean(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, PlayerHasMount_TrueAfterTaming_ById) {
		auto player = makeTestPlayer();
		tameMountBit(*player, 2); // non-premium fixture mount
		bindPlayerAsGlobal(player);

		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return p:hasMount(2)"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isboolean(L, -1));
		EXPECT_TRUE(lua_toboolean(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, PlayerHasMount_TrueAfterTaming_ByName) {
		auto player = makeTestPlayer();
		tameMountBit(*player, 2);
		bindPlayerAsGlobal(player);

		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return p:hasMount('Racing Bird')"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isboolean(L, -1));
		EXPECT_TRUE(lua_toboolean(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, PlayerHasMount_NonexistentMountReturnsNil) {
		bindPlayerAsGlobal(makeTestPlayer());

		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return p:hasMount(99)"))
			<< lua_tostring(L, -1);
		EXPECT_TRUE(lua_isnil(L, -1));
		lua_pop(L, 1);
	}

	TEST_F(MountLuaTest, PlayerHasMount_PremiumGateBlocksNonPremium) {
		auto player = makeTestPlayer();
		// Mount id 1 (Widow Queen) is premium=yes; default test player is
		// not premium. The Lua call goes through luaPlayerHasMount ->
		// Mounts::BorrowedMount.get() -> Player::hasMount(const Mount*)
		// which must reject via the premium gate.
		tameMountBit(*player, 1);
		bindPlayerAsGlobal(player);

		ASSERT_EQ(LUA_OK, luaL_dostring(L, "return p:hasMount(1)"))
			<< lua_tostring(L, -1);
		ASSERT_TRUE(lua_isboolean(L, -1));
		EXPECT_FALSE(lua_toboolean(L, -1));
		lua_pop(L, 1);
	}

} // namespace
