#include <boost/ut.hpp>

#include "lua/callbacks/event_callback_manager.hpp"
#include "lua/scripts/luascript.hpp"

#include "injection_fixture.hpp"

using namespace boost::ut;

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

struct FakeEventCallback : EventCallback {
	using EventCallback::EventCallback;
	bool creatureOnCombat(const Creature* /*caster*/, const Creature* /*target*/, CombatDamage &damage) const {
		damage.primary.value += 50;
		damage.secondary.value += 5;
		return true;
	}
};

static void reg_registration_sorting() {
	test("registration_sorting") = [] {
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
		expect(vec.size() == std::size_t { 2 });
		expect(vec[0] == cb2);
		expect(vec[1] == cb1);
	};
}

static void reg_registration_tie_order() {
	test("registration_tie_order") = [] {
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
		expect(vec[0] == cb1);
		expect(vec[1] == cb2);
	};
}

static void reg_dispatch_short_circuit() {
	test("dispatch_short_circuit") = [] {
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
		expect(!ok);
		expect(first.calls == 1);
		expect(second.calls == 0);
	};
}

static void reg_can_execute() {
	test("can_execute") = [] {
		DummyScriptInterface iface;
		EventCallback cb("cb", false, &iface);

		cb.setEnabled(false);
		expect(!cb.canExecute());

		cb.setEnabled(true);
		cb.setScriptId(1);
		expect(cb.canExecute());

		cb.setScriptId(EventCallback::kInvalidScriptId);
		expect(!cb.canExecute());
	};
}

static void reg_dispatch_all_ok() {
	test("dispatch_all_ok") = [] {
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
		expect(ok);
		expect(a.calls == 1);
		expect(b.calls == 1);
	};
}

static void dispatch_skips_disabled_and_invalid_body() {
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
	expect(allOk);
	expect(a.calls == 0);
	expect(b.calls == 0);
	expect(c.calls == 1);
}

static void reg_dispatch_skips_disabled_and_invalid() {
	test("dispatch_skips_disabled_and_invalid") = [] {
		dispatch_skips_disabled_and_invalid_body();
	};
}

static void type_isolation_body() {
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
	expect(okTrade);
	expect(trade.calls == 1);
	expect(move.calls == 0);

	const bool okMove = mgr.checkCallback(EventCallback_t::playerOnMoveCreature);
	expect(okMove);
	expect(trade.calls == 1);
	expect(move.calls == 1);
}

static void reg_type_isolation() {
	test("type_isolation") = [] {
		type_isolation_body();
	};
}

static void reg_register_dup_blocks_when_skip_false() {
	test("register_dup_blocks_when_skip_false") = [] {
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
		expect(v.size() == std::size_t { 1 });
		expect(v[0] == a);
	};
}

static void reg_register_dup_allowed_when_skip_true() {
	test("register_dup_allowed_when_skip_true") = [] {
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
		expect(v.size() == std::size_t { 2 });
		expect(v[0] == a);
		expect(v[1] == b);
	};
}

struct MutatingScriptInterface final : LuaScriptInterface {
	std::unique_ptr<lua_State, decltype(&lua_close)> L;
	CombatDamage* dmg;
	int addPrimary;
	int addSecondary;
	bool result;
	mutable int calls { 0 };

	MutatingScriptInterface(CombatDamage* d, int dp, int ds, bool r) :
		LuaScriptInterface("test"),
		L(luaL_newstate(), lua_close),
		dmg(d),
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
		if (dmg) {
			dmg->primary.value += addPrimary;
			dmg->secondary.value += addSecondary;
		}
		return result;
	}
};

static void damage_roundtrip_mutation_ok_body() {
	CombatDamage dmg {};
	dmg.primary.value = 100;
	dmg.secondary.value = 10;

	MutatingScriptInterface a(&dmg, 50, 5, true);
	MutatingScriptInterface b(&dmg, 20, 2, true);

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

	expect(ok);
	expect(a.calls == 1);
	expect(b.calls == 1);
	expect(dmg.primary.value == 170);
	expect(dmg.secondary.value == 17);
}

static void reg_damage_roundtrip_mutation_ok() {
	test("damage_roundtrip_mutation_ok") = [] {
		damage_roundtrip_mutation_ok_body();
	};
}

static void damage_short_circuit_mutation_stops_body() {
	CombatDamage dmg {};
	dmg.primary.value = 100;
	dmg.secondary.value = 10;

	MutatingScriptInterface stop(&dmg, 77, 7, false);
	MutatingScriptInterface after(&dmg, 99, 9, true);

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

	expect(!ok);
	expect(stop.calls == 1);
	expect(after.calls == 0);
	expect(dmg.primary.value == 177);
	expect(dmg.secondary.value == 17);
}

static void reg_damage_short_circuit_mutation_stops() {
	test("damage_short_circuit_mutation_stops") = [] {
		damage_short_circuit_mutation_stops_body();
	};
}

static void dup_skip_true_priority_order_body() {
	CombatDamage dmg {};
	dmg.primary.value = 0;
	dmg.secondary.value = 0;

	MutatingScriptInterface hi(&dmg, 10, 1, true);
	MutatingScriptInterface lo(&dmg, 1, 0, true);

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
	expect(v.size() == std::size_t { 2 });
	expect(v[0] == b);
	expect(v[1] == a);

	const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
	expect(ok);
	expect(hi.calls == 1);
	expect(lo.calls == 1);
	expect(dmg.primary.value == 11);
}

static void reg_dup_skip_true_priority_order() {
	test("dup_skip_true_priority_order") = [] {
		dup_skip_true_priority_order_body();
	};
}

static void same_name_different_types_ok_body() {
	using enum EventCallback_t;
	DummyScriptInterface a(true);
	DummyScriptInterface b(true);
	EventCallbackManager mgr;

	auto c1 = std::make_shared<EventCallback>("dup", false, &a);
	c1->setType(playerOnTradeRequest);
	c1->setScriptId(1);

	auto c2 = std::make_shared<EventCallback>("dup", false, &b);
	c2->setType(playerOnMoveCreature);
	c2->setScriptId(1);

	mgr.registerCallback(c1);
	mgr.registerCallback(c2);

	expect(mgr.checkCallback(playerOnTradeRequest));
	expect(a.calls == 1);
	expect(b.calls == 0);

	expect(mgr.checkCallback(playerOnMoveCreature));
	expect(a.calls == 1);
	expect(b.calls == 1);
}

static void reg_same_name_different_types_ok() {
	test("same_name_different_types_ok") = [] {
		same_name_different_types_ok_body();
	};
}

static void reg_no_listeners_returns_true() {
	test("no_listeners_returns_true") = [] {
		EventCallbackManager mgr;
		CombatDamage dmg {};
		const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
		expect(ok);
	};
}

static void reg_no_listeners_ok() {
	test("no_listeners_ok") = [] {
		EventCallbackManager mgr;
		CombatDamage dmg {};
		dmg.primary.value = 1;
		dmg.secondary.value = 2;
		const bool ok = mgr.checkCallback(EventCallback_t::creatureOnCombat, nullptr, nullptr, std::ref(dmg));
		expect(ok);
		expect(dmg.primary.value == 1);
		expect(dmg.secondary.value == 2);
	};
}

suite<"event_callbacks"> eventCallbacksTests = [] {
	static di::extension::injector<> injector {};
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);
	(void)injector.create<Logger &>();

	reg_registration_sorting();
	reg_registration_tie_order();
	reg_dispatch_short_circuit();
	reg_can_execute();
	reg_dispatch_all_ok();
	reg_dispatch_skips_disabled_and_invalid();
	reg_type_isolation();
	reg_register_dup_blocks_when_skip_false();
	reg_register_dup_allowed_when_skip_true();
	reg_damage_roundtrip_mutation_ok();
	reg_damage_short_circuit_mutation_stops();
	reg_dup_skip_true_priority_order();
	reg_same_name_different_types_ok();
	reg_no_listeners_returns_true();
	reg_no_listeners_ok();
};
