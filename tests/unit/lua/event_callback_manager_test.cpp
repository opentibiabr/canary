#include "pch.hpp"

#include <gtest/gtest.h>

#include "lua/callbacks/event_callback_manager.hpp"
#include "lua/scripts/luascript.hpp"

struct DummyScriptInterface final : LuaScriptInterface {
	mutable int calls = 0;
	bool result = true;
	explicit DummyScriptInterface(bool r = true) :
		LuaScriptInterface("test"), result(r) { }

	lua_State* getLuaState() override {
		return nullptr;
	}
	bool pushFunction(int32_t) const override {
		return true;
	}
	bool callFunction(int) const override {
		++calls;
		return result;
	}
};

struct MutatingScriptInterface final : LuaScriptInterface {
	std::unique_ptr<lua_State, decltype(&lua_close)> L { luaL_newstate(), &lua_close };
	int addPrimary;
	int addSecondary;
	bool result;
	mutable int calls { 0 };

	MutatingScriptInterface(int dp, int ds, bool r) :
		LuaScriptInterface("test"),
		addPrimary(dp),
		addSecondary(ds),
		result(r) {
	}
	lua_State* getLuaState() override {
		return L.get();
	}
	bool pushFunction(int32_t) const override {
		return true;
	}
	bool callFunction(int) const override {
		++calls;
		const int index = lua_gettop(L.get());
		lua_getfield(L.get(), index, "primary");
		if (lua_istable(L.get(), -1)) {
			lua_getfield(L.get(), -1, "value");
			const auto value = static_cast<int32_t>(lua_tointeger(L.get(), -1));
			lua_pop(L.get(), 1);
			lua_pushnumber(L.get(), value + addPrimary);
			lua_setfield(L.get(), -2, "value");
		}
		lua_pop(L.get(), 1);
		lua_getfield(L.get(), index, "secondary");
		if (lua_istable(L.get(), -1)) {
			lua_getfield(L.get(), -1, "value");
			const auto value = static_cast<int32_t>(lua_tointeger(L.get(), -1));
			lua_pop(L.get(), 1);
			lua_pushnumber(L.get(), value + addSecondary);
			lua_setfield(L.get(), -2, "value");
		}
		lua_pop(L.get(), 1);
		return result;
	}
};

TEST(EventCallbackManagerTest, RegistrationSorting) {
	DummyScriptInterface iface;
	EventCallbackManager mgr;

	auto cb1 = std::make_shared<EventCallback>("cb1", false, &iface);
	cb1->setType(EventCallback_t::playerOnTradeRequest);
	cb1->setPriority(5);
	cb1->setScriptId(1);

	auto cb2 = std::make_shared<EventCallback>("cb2", false, &iface);
	cb2->setType(EventCallback_t::playerOnTradeRequest);
	cb2->setPriority(10);
	cb2->setScriptId(1);

	mgr.registerCallback(cb1);
	mgr.registerCallback(cb2);

	const auto &vec = mgr.getCallbacks(EventCallback_t::playerOnTradeRequest);
	ASSERT_EQ(vec.size(), std::size_t { 2 });
	EXPECT_EQ(vec[0], cb2);
	EXPECT_EQ(vec[1], cb1);
}

TEST(EventCallbackManagerTest, RegistrationTieOrder) {
	DummyScriptInterface iface;
	EventCallbackManager mgr;

	auto cb1 = std::make_shared<EventCallback>("a", false, &iface);
	cb1->setType(EventCallback_t::playerOnTradeRequest);
	cb1->setPriority(5);
	cb1->setScriptId(1);

	auto cb2 = std::make_shared<EventCallback>("b", false, &iface);
	cb2->setType(EventCallback_t::playerOnTradeRequest);
	cb2->setPriority(5);
	cb2->setScriptId(1);

	mgr.registerCallback(cb1);
	mgr.registerCallback(cb2);

	const auto &vec = mgr.getCallbacks(EventCallback_t::playerOnTradeRequest);
	ASSERT_EQ(vec.size(), std::size_t { 2 });
	EXPECT_EQ(vec[0], cb1);
	EXPECT_EQ(vec[1], cb2);
}

TEST(EventCallbackManagerTest, DispatchShortCircuit) {
	DummyScriptInterface first(false);
	DummyScriptInterface second(true);
	EventCallbackManager mgr;

	auto cb1 = std::make_shared<EventCallback>("cb1", false, &first);
	cb1->setType(EventCallback_t::playerOnTradeRequest);
	cb1->setScriptId(1);

	auto cb2 = std::make_shared<EventCallback>("cb2", false, &second);
	cb2->setType(EventCallback_t::playerOnTradeRequest);
	cb2->setScriptId(1);

	mgr.registerCallback(cb1);
	mgr.registerCallback(cb2);

	const bool ok = mgr.checkCallback(EventCallback_t::playerOnTradeRequest);
	EXPECT_FALSE(ok);
	EXPECT_EQ(first.calls, 1);
	EXPECT_EQ(second.calls, 0);
}

TEST(EventCallbackTest, CanExecute) {
	DummyScriptInterface iface;
	EventCallback cb("cb", false, &iface);

	cb.setEnabled(false);
	EXPECT_FALSE(cb.canExecute());

	cb.setEnabled(true);
	cb.setScriptId(1);
	EXPECT_TRUE(cb.canExecute());

	cb.setScriptId(EventCallback::kInvalidScriptId);
	EXPECT_FALSE(cb.canExecute());
}

TEST(EventCallbackManagerTest, DispatchAllOk) {
	DummyScriptInterface a(true);
	DummyScriptInterface b(true);
	EventCallbackManager mgr;

	auto cb1 = std::make_shared<EventCallback>("cb1", false, &a);
	cb1->setType(EventCallback_t::playerOnTradeRequest);
	cb1->setScriptId(1);

	auto cb2 = std::make_shared<EventCallback>("cb2", false, &b);
	cb2->setType(EventCallback_t::playerOnTradeRequest);
	cb2->setScriptId(1);

	mgr.registerCallback(cb1);
	mgr.registerCallback(cb2);

	const bool ok = mgr.checkCallback(EventCallback_t::playerOnTradeRequest);
	EXPECT_TRUE(ok);
	EXPECT_EQ(a.calls, 1);
	EXPECT_EQ(b.calls, 1);
}

TEST(EventCallbackManagerTest, DispatchSkipsDisabledAndInvalid) {
	DummyScriptInterface a(true);
	DummyScriptInterface b(true);
	DummyScriptInterface c(true);
	EventCallbackManager mgr;

	auto disabled = std::make_shared<EventCallback>("disabled", false, &a);
	disabled->setType(EventCallback_t::playerOnTradeRequest);
	disabled->setScriptId(1);
	disabled->setEnabled(false);

	auto invalid = std::make_shared<EventCallback>("invalid", false, &b);
	invalid->setType(EventCallback_t::playerOnTradeRequest);

	auto ok = std::make_shared<EventCallback>("ok", false, &c);
	ok->setType(EventCallback_t::playerOnTradeRequest);
	ok->setScriptId(1);

	mgr.registerCallback(disabled);
	mgr.registerCallback(invalid);
	mgr.registerCallback(ok);

	const bool allOk = mgr.checkCallback(EventCallback_t::playerOnTradeRequest);
	EXPECT_TRUE(allOk);
	EXPECT_EQ(a.calls, 0);
	EXPECT_EQ(b.calls, 0);
	EXPECT_EQ(c.calls, 1);
}

TEST(EventCallbackManagerTest, TypeIsolation) {
	DummyScriptInterface trade(true);
	DummyScriptInterface move(true);
	EventCallbackManager mgr;

	auto cbTrade = std::make_shared<EventCallback>("trade", false, &trade);
	cbTrade->setType(EventCallback_t::playerOnTradeRequest);
	cbTrade->setScriptId(1);

	auto cbMove = std::make_shared<EventCallback>("move", false, &move);
	cbMove->setType(EventCallback_t::playerOnMoveCreature);
	cbMove->setScriptId(1);

	mgr.registerCallback(cbTrade);
	mgr.registerCallback(cbMove);

	const bool okTrade = mgr.checkCallback(EventCallback_t::playerOnTradeRequest);
	EXPECT_TRUE(okTrade);
	EXPECT_EQ(trade.calls, 1);
	EXPECT_EQ(move.calls, 0);

	const bool okMove = mgr.checkCallback(EventCallback_t::playerOnMoveCreature);
	EXPECT_TRUE(okMove);
	EXPECT_EQ(trade.calls, 1);
	EXPECT_EQ(move.calls, 1);
}

TEST(EventCallbackManagerTest, RegisterDupBlocksWhenSkipFalse) {
	DummyScriptInterface iface;
	EventCallbackManager mgr;

	auto a = std::make_shared<EventCallback>("X", false, &iface);
	a->setType(EventCallback_t::playerOnTradeRequest);
	a->setScriptId(1);

	auto b = std::make_shared<EventCallback>("X", false, &iface);
	b->setType(EventCallback_t::playerOnTradeRequest);
	b->setScriptId(1);

	mgr.registerCallback(a);
	mgr.registerCallback(b);

	const auto &v = mgr.getCallbacks(EventCallback_t::playerOnTradeRequest);
	ASSERT_EQ(v.size(), std::size_t { 1 });
	EXPECT_EQ(v[0], a);
}

TEST(EventCallbackManagerTest, RegisterDupAllowedWhenSkipTrue) {
	DummyScriptInterface iface;
	EventCallbackManager mgr;

	auto a = std::make_shared<EventCallback>("Y", false, &iface);
	a->setType(EventCallback_t::playerOnTradeRequest);
	a->setScriptId(1);

	auto b = std::make_shared<EventCallback>("Y", false, &iface);
	b->setType(EventCallback_t::playerOnTradeRequest);
	b->setScriptId(1);
	b->setSkipDuplicationCheck(true);

	mgr.registerCallback(a);
	mgr.registerCallback(b);

	const auto &v = mgr.getCallbacks(EventCallback_t::playerOnTradeRequest);
	ASSERT_EQ(v.size(), std::size_t { 2 });
	EXPECT_EQ(v[0], a);
	EXPECT_EQ(v[1], b);
}

TEST(EventCallbackManagerTest, DamageRoundtripMutationOk) {
	CombatDamage dmg {};
	dmg.primary.value = 100;
	dmg.secondary.value = 10;

	MutatingScriptInterface a(50, 5, true);
	MutatingScriptInterface b(20, 2, true);

	EventCallbackManager mgr;

	auto cb1 = std::make_shared<EventCallback>("cb1", false, &a);
	cb1->setType(EventCallback_t::creatureOnCombat);
	cb1->setScriptId(1);

	auto cb2 = std::make_shared<EventCallback>("cb2", false, &b);
	cb2->setType(EventCallback_t::creatureOnCombat);
	cb2->setScriptId(1);

	mgr.registerCallback(cb1);
	mgr.registerCallback(cb2);

	const bool ok = mgr.checkCallback(
		EventCallback_t::creatureOnCombat,
		nullptr, nullptr, std::ref(dmg)
	);

	EXPECT_TRUE(ok);
	EXPECT_EQ(a.calls, 1);
	EXPECT_EQ(b.calls, 1);
	EXPECT_EQ(dmg.primary.value, 170);
	EXPECT_EQ(dmg.secondary.value, 17);
}

TEST(EventCallbackManagerTest, DamageShortCircuitMutationStops) {
	CombatDamage dmg {};
	dmg.primary.value = 100;
	dmg.secondary.value = 10;

	MutatingScriptInterface stop(77, 7, false);
	MutatingScriptInterface after(99, 9, true);

	EventCallbackManager mgr;

	auto a = std::make_shared<EventCallback>("a", false, &stop);
	a->setType(EventCallback_t::creatureOnCombat);
	a->setPriority(10);
	a->setScriptId(1);

	auto b = std::make_shared<EventCallback>("b", false, &after);
	b->setType(EventCallback_t::creatureOnCombat);
	b->setPriority(5);
	b->setScriptId(1);

	mgr.registerCallback(a);
	mgr.registerCallback(b);

	const bool ok = mgr.checkCallback(
		EventCallback_t::creatureOnCombat,
		nullptr, nullptr, std::ref(dmg)
	);

	EXPECT_FALSE(ok);
	EXPECT_EQ(stop.calls, 1);
	EXPECT_EQ(after.calls, 0);
	EXPECT_EQ(dmg.primary.value, 177);
	EXPECT_EQ(dmg.secondary.value, 17);
}

TEST(EventCallbackManagerTest, DupSkipTruePriorityOrder) {
	CombatDamage dmg {};
	dmg.primary.value = 0;
	dmg.secondary.value = 0;

	MutatingScriptInterface hi(10, 1, true);
	MutatingScriptInterface lo(1, 0, true);

	EventCallbackManager mgr;

	auto a = std::make_shared<EventCallback>("same", false, &lo);
	a->setType(EventCallback_t::creatureOnCombat);
	a->setPriority(5);
	a->setScriptId(1);

	auto b = std::make_shared<EventCallback>("same", false, &hi);
	b->setType(EventCallback_t::creatureOnCombat);
	b->setPriority(10);
	b->setScriptId(1);
	b->setSkipDuplicationCheck(true);

	mgr.registerCallback(a);
	mgr.registerCallback(b);

	const auto &v = mgr.getCallbacks(EventCallback_t::creatureOnCombat);
	ASSERT_EQ(v.size(), std::size_t { 2 });
	EXPECT_EQ(v[0], b);
	EXPECT_EQ(v[1], a);

	const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
	EXPECT_TRUE(ok);
	EXPECT_EQ(hi.calls, 1);
	EXPECT_EQ(lo.calls, 1);
	EXPECT_EQ(dmg.primary.value, 11);
}

TEST(EventCallbackManagerTest, SameNameDifferentTypesOk) {
	DummyScriptInterface a(true);
	DummyScriptInterface b(true);
	EventCallbackManager mgr;

	auto c1 = std::make_shared<EventCallback>("dup", false, &a);
	c1->setType(EventCallback_t::playerOnTradeRequest);
	c1->setScriptId(1);

	auto c2 = std::make_shared<EventCallback>("dup", false, &b);
	c2->setType(EventCallback_t::playerOnMoveCreature);
	c2->setScriptId(1);

	mgr.registerCallback(c1);
	mgr.registerCallback(c2);

	EXPECT_TRUE(mgr.checkCallback(EventCallback_t::playerOnTradeRequest));
	EXPECT_EQ(a.calls, 1);
	EXPECT_EQ(b.calls, 0);

	EXPECT_TRUE(mgr.checkCallback(EventCallback_t::playerOnMoveCreature));
	EXPECT_EQ(a.calls, 1);
	EXPECT_EQ(b.calls, 1);
}

TEST(EventCallbackManagerTest, NoListenersReturnsTrue) {
	EventCallbackManager mgr;
	CombatDamage dmg {};
	const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
	EXPECT_TRUE(ok);
}

TEST(EventCallbackManagerTest, NoListenersOk) {
	EventCallbackManager mgr;
	CombatDamage dmg {};
	dmg.primary.value = 1;
	dmg.secondary.value = 2;
	const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
	EXPECT_TRUE(ok);
	EXPECT_EQ(dmg.primary.value, 1);
	EXPECT_EQ(dmg.secondary.value, 2);
}
