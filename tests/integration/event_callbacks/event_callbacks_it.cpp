#include <gtest/gtest.h>
#include <magic_enum/magic_enum.hpp>
#include <functional>
#include <memory>
#include <string>
#include <vector>
#include <lua.hpp>

#include "lua/callbacks/events_callbacks.hpp"
#include "lua/callbacks/event_callback.hpp"
#include "lua/scripts/luascript.hpp"
#include "game/movement/position.hpp"
#include "creatures/creatures_definitions.hpp"
#include "items/items_definitions.hpp"
#include "utils/utils_definitions.hpp"

namespace {

	struct DummyScriptInterface final : LuaScriptInterface {
		mutable int calls = 0;
		bool result = true;
		mutable std::function<void(lua_State*, int)> hook;
		std::unique_ptr<lua_State, decltype(&lua_close)> L { luaL_newstate(), &lua_close };
		explicit DummyScriptInterface(bool r = true) :
			LuaScriptInterface("test"), result(r) {
		}
		lua_State* getLuaState() override {
			return L.get();
		}

		bool pushFunction(int32_t) const override {
			return true;
		}
		bool callFunction(int params) const override {
			++calls;
			if (hook) {
				hook(L.get(), params);
			}
			Lua::resetScriptEnv();
			return result;
		}
	};

	void setDamageTablePrimary(lua_State* L, int index, CombatType_t type, int32_t value) {
		lua_getfield(L, index, "primary");
		if (!lua_istable(L, -1)) {
			lua_pop(L, 1);
			return;
		}

		lua_pushnumber(L, value);
		lua_setfield(L, -2, "value");
		lua_pushnumber(L, static_cast<int32_t>(type));
		lua_setfield(L, -2, "type");
		lua_pop(L, 1);
	}

	std::shared_ptr<EventCallback> createCallback(EventCallback_t type, DummyScriptInterface &iface) {
		auto cb = std::make_shared<EventCallback>("cb", false, &iface);
		cb->setType(type);
		cb->setScriptId(1);
		return cb;
	}

	void addCallback(EventCallback_t type, DummyScriptInterface &iface) {
		auto &mgr = g_callbacks();
		mgr.clear();
		mgr.addCallback(createCallback(type, iface));
	}

	struct BoolEventTest {
		EventCallback_t type;
		std::function<bool()> call;
	};

	struct ReturnEventTest {
		EventCallback_t type;
		std::function<ReturnValue()> call;
	};

	struct VoidEventTest {
		EventCallback_t type;
		std::function<void()> call;
	};

	class EventCallbacksIntegrationTest : public ::testing::Test {
	protected:
		void SetUp() override {
			g_callbacks().clear();
		}
	};

	TEST_F(EventCallbacksIntegrationTest, BoolEventsReturnTrueAndCallOnce) {
		const std::vector<BoolEventTest> boolEvents {
			{ EventCallback_t::creatureOnChangeOutfit, [] {
				 Outfit_t outfit {};
				 return g_callbacks().checkCallback(EventCallback_t::creatureOnChangeOutfit, std::shared_ptr<Creature> {}, outfit);
			 } },
			{ EventCallback_t::partyOnJoin, [] {
				 return g_callbacks().checkCallback(EventCallback_t::partyOnJoin, std::shared_ptr<Party> {}, std::shared_ptr<Player> {});
			 } },
			{ EventCallback_t::partyOnLeave, [] {
				 return g_callbacks().checkCallback(EventCallback_t::partyOnLeave, std::shared_ptr<Party> {}, std::shared_ptr<Player> {});
			 } },
			{ EventCallback_t::partyOnDisband, [] {
				 return g_callbacks().checkCallback(EventCallback_t::partyOnDisband, std::shared_ptr<Party> {});
			 } },
			{ EventCallback_t::playerOnBrowseField, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnBrowseField, std::shared_ptr<Player> {}, Position {});
			 } },
			{ EventCallback_t::playerOnLookInShop, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnLookInShop, std::shared_ptr<Player> {}, static_cast<const ItemType*>(nullptr), 0u);
			 } },
			{ EventCallback_t::playerOnMoveItem, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnMoveItem, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, 0u, Position {}, Position {}, std::shared_ptr<Cylinder> {}, std::shared_ptr<Cylinder> {});
			 } },
			{ EventCallback_t::playerOnMoveCreature, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnMoveCreature, std::shared_ptr<Player> {}, std::shared_ptr<Creature> {}, Position {}, Position {});
			 } },
			{ EventCallback_t::playerOnTurn, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnTurn, std::shared_ptr<Player> {}, Direction::DIRECTION_NORTH);
			 } },
			{ EventCallback_t::playerOnTradeRequest, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnTradeRequest, std::shared_ptr<Player> {}, std::shared_ptr<Player> {}, std::shared_ptr<Item> {});
			 } },
			{ EventCallback_t::playerOnTradeAccept, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnTradeAccept, std::shared_ptr<Player> {}, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, std::shared_ptr<Item> {});
			 } },
			{ EventCallback_t::playerOnRotateItem, [] {
				 return g_callbacks().checkCallback(EventCallback_t::playerOnRotateItem, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, Position {});
			 } },
			{ EventCallback_t::zoneBeforeCreatureEnter, [] {
				 return g_callbacks().checkCallback(EventCallback_t::zoneBeforeCreatureEnter, std::shared_ptr<Zone> {}, std::shared_ptr<Creature> {});
			 } },
			{ EventCallback_t::zoneBeforeCreatureLeave, [] {
				 return g_callbacks().checkCallback(EventCallback_t::zoneBeforeCreatureLeave, std::shared_ptr<Zone> {}, std::shared_ptr<Creature> {});
			 } },
		};

		for (const auto &e : boolEvents) {
			SCOPED_TRACE(std::string(magic_enum::enum_name(e.type)));
			DummyScriptInterface iface;
			addCallback(e.type, iface);
			EXPECT_TRUE(e.call());
			EXPECT_EQ(iface.calls, 1);
		}
	}

	TEST_F(EventCallbacksIntegrationTest, ReturnEventsReturnNoErrorAndCallOnce) {
		const std::vector<ReturnEventTest> returnEvents {
			{ EventCallback_t::creatureOnAreaCombat, [] {
				 return g_callbacks().dispatchReturnValue(EventCallback_t::creatureOnAreaCombat, std::shared_ptr<Creature> {}, std::shared_ptr<Tile> {}, false);
			 } },
			{ EventCallback_t::creatureOnTargetCombat, [] {
				 return g_callbacks().dispatchReturnValue(EventCallback_t::creatureOnTargetCombat, std::shared_ptr<Creature> {}, std::shared_ptr<Creature> {});
			 } },
		};

		for (const auto &e : returnEvents) {
			SCOPED_TRACE(std::string(magic_enum::enum_name(e.type)));
			DummyScriptInterface iface;
			addCallback(e.type, iface);
			EXPECT_EQ(e.call(), RETURNVALUE_NOERROR);
			EXPECT_EQ(iface.calls, 1);
		}
	}

	TEST_F(EventCallbacksIntegrationTest, VoidEventsCallOnce) {
		const std::vector<VoidEventTest> voidEvents {
			{ EventCallback_t::playerOnLook, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnLook, std::shared_ptr<Player> {}, std::shared_ptr<Thing> {}, Position {}, 0);
			 } },
			{ EventCallback_t::playerOnLookInBattleList, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnLookInBattleList, std::shared_ptr<Player> {}, std::shared_ptr<Creature> {}, 0);
			 } },
			{ EventCallback_t::playerOnLookInTrade, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnLookInTrade, std::shared_ptr<Player> {}, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, 0);
			 } },
			{ EventCallback_t::playerOnItemMoved, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnItemMoved, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, 0u, Position {}, Position {}, std::shared_ptr<Cylinder> {}, std::shared_ptr<Cylinder> {});
			 } },
			{ EventCallback_t::playerOnChangeZone, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnChangeZone, std::shared_ptr<Player> {}, ZoneType_t {});
			 } },
			{ EventCallback_t::playerOnChangeHazard, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnChangeHazard, std::shared_ptr<Player> {}, ZoneType_t {});
			 } },
			{ EventCallback_t::playerOnReportRuleViolation, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnReportRuleViolation, std::shared_ptr<Player> {}, std::string {}, uint8_t { 0 }, uint8_t { 0 }, std::string {}, std::string {});
			 } },
			{ EventCallback_t::playerOnReportBug, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnReportBug, std::shared_ptr<Player> {}, std::string {}, Position {}, uint8_t { 0 });
			 } },
			{ EventCallback_t::playerOnRequestQuestLog, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnRequestQuestLog, std::shared_ptr<Player> {});
			 } },
			{ EventCallback_t::playerOnRequestQuestLine, [] {
				 uint16_t questId = 0;
				 g_callbacks().executeCallback(EventCallback_t::playerOnRequestQuestLine, std::shared_ptr<Player> {}, questId);
			 } },
			{ EventCallback_t::playerOnStorageUpdate, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnStorageUpdate, std::shared_ptr<Player> {}, uint32_t { 0 }, int32_t { 0 }, int32_t { 0 }, uint64_t { 0 });
			 } },
			{ EventCallback_t::playerOnRemoveCount, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnRemoveCount, std::shared_ptr<Player> {}, std::shared_ptr<Item> {});
			 } },
			{ EventCallback_t::playerOnInventoryUpdate, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnInventoryUpdate, std::shared_ptr<Player> {}, std::shared_ptr<Item> {}, Slots_t { 0 }, true);
			 } },
			{ EventCallback_t::playerOnWalk, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnWalk, std::shared_ptr<Player> {}, Direction::DIRECTION_NORTH);
			 } },
			{ EventCallback_t::playerOnThink, [] {
				 g_callbacks().executeCallback(EventCallback_t::playerOnThink, std::shared_ptr<Player> {}, uint32_t { 0 });
			 } },
			{ EventCallback_t::monsterOnDropLoot, [] {
				 g_callbacks().executeCallback(EventCallback_t::monsterOnDropLoot, std::shared_ptr<Monster> {}, std::shared_ptr<Item> {});
			 } },
			{ EventCallback_t::monsterPostDropLoot, [] {
				 g_callbacks().executeCallback(EventCallback_t::monsterPostDropLoot, std::shared_ptr<Monster> {}, std::shared_ptr<Item> {});
			 } },
			{ EventCallback_t::zoneAfterCreatureEnter, [] {
				 g_callbacks().executeCallback(EventCallback_t::zoneAfterCreatureEnter, std::shared_ptr<Zone> {}, std::shared_ptr<Creature> {});
			 } },
			{ EventCallback_t::zoneAfterCreatureLeave, [] {
				 g_callbacks().executeCallback(EventCallback_t::zoneAfterCreatureLeave, std::shared_ptr<Zone> {}, std::shared_ptr<Creature> {});
			 } },
			{ EventCallback_t::mapOnLoad, [] {
				 g_callbacks().executeCallback(EventCallback_t::mapOnLoad, std::string {});
			 } },
		};

		for (const auto &e : voidEvents) {
			SCOPED_TRACE(std::string(magic_enum::enum_name(e.type)));
			DummyScriptInterface iface;
			addCallback(e.type, iface);
			e.call();
			EXPECT_EQ(iface.calls, 1);
		}
	}

	TEST_F(EventCallbacksIntegrationTest, ExecuteCallbackRunsAllListeners) {
		DummyScriptInterface first(false);
		DummyScriptInterface second(true);
		auto &mgr = g_callbacks();
		mgr.clear();
		mgr.addCallback(createCallback(EventCallback_t::playerOnReportBug, first));
		auto secondCallback = createCallback(EventCallback_t::playerOnReportBug, second);
		secondCallback->setSkipDuplicationCheck(true);
		mgr.addCallback(secondCallback);

		g_callbacks().executeCallback(EventCallback_t::playerOnReportBug, std::shared_ptr<Player> {}, std::string {}, Position {}, uint8_t { 0 });

		EXPECT_EQ(first.calls, 1);
		EXPECT_EQ(second.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, CreatureOnDrainHealthUpdatesDamageRefs) {
		DummyScriptInterface iface;
		CombatType_t primaryType = COMBAT_NONE;
		int32_t primaryValue = 0;
		CombatType_t secondaryType = COMBAT_NONE;
		int32_t secondaryValue = 0;
		TextColor_t primaryColor = TEXTCOLOR_NONE;
		TextColor_t secondaryColor = TEXTCOLOR_NONE;
		addCallback(EventCallback_t::creatureOnDrainHealth, iface);
		iface.hook = [&primaryType, &primaryValue, &secondaryType, &secondaryValue, &primaryColor, &secondaryColor](lua_State*, int) {
			primaryType = COMBAT_FIREDAMAGE;
			primaryValue = 5;
			secondaryType = COMBAT_ENERGYDAMAGE;
			secondaryValue = 10;
			primaryColor = TEXTCOLOR_RED;
			secondaryColor = TEXTCOLOR_BLUE;
		};
		g_callbacks().executeCallback(EventCallback_t::creatureOnDrainHealth, std::shared_ptr<Creature> {}, std::shared_ptr<Creature> {}, std::ref(primaryType), std::ref(primaryValue), std::ref(secondaryType), std::ref(secondaryValue), std::ref(primaryColor), std::ref(secondaryColor));
		EXPECT_EQ(primaryType, COMBAT_FIREDAMAGE);
		EXPECT_EQ(primaryValue, 5);
		EXPECT_EQ(secondaryType, COMBAT_ENERGYDAMAGE);
		EXPECT_EQ(secondaryValue, 10);
		EXPECT_EQ(primaryColor, TEXTCOLOR_RED);
		EXPECT_EQ(secondaryColor, TEXTCOLOR_BLUE);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, CreatureOnCombatUpdatesDamage) {
		DummyScriptInterface iface;
		CombatDamage dmg {};
		addCallback(EventCallback_t::creatureOnCombat, iface);
		iface.hook = [](lua_State* L, int) {
			setDamageTablePrimary(L, lua_gettop(L), COMBAT_FIREDAMAGE, 5);
		};
		g_callbacks().executeCallback(EventCallback_t::creatureOnCombat, std::shared_ptr<Creature> {}, std::shared_ptr<Creature> {}, std::ref(dmg));
		EXPECT_EQ(dmg.primary.type, COMBAT_FIREDAMAGE);
		EXPECT_EQ(dmg.primary.value, 5);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, PartyOnShareExperienceUpdatesValue) {
		DummyScriptInterface iface;
		uint64_t shareExp = 0;
		addCallback(EventCallback_t::partyOnShareExperience, iface);
		iface.hook = [&shareExp](lua_State*, int) {
			shareExp = 10;
		};
		g_callbacks().executeCallback(EventCallback_t::partyOnShareExperience, std::shared_ptr<Party> {}, std::ref(shareExp));
		EXPECT_EQ(shareExp, 10);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, PlayerOnGainExperienceUpdatesValues) {
		DummyScriptInterface iface;
		uint64_t exp = 0;
		uint64_t raw = 0;
		addCallback(EventCallback_t::playerOnGainExperience, iface);
		iface.hook = [&exp, &raw](lua_State*, int) {
			exp = 100;
			raw = 200;
		};
		g_callbacks().executeCallback(EventCallback_t::playerOnGainExperience, std::shared_ptr<Player> {}, std::shared_ptr<Creature> {}, std::ref(exp), std::ref(raw));
		EXPECT_EQ(exp, 100);
		EXPECT_EQ(raw, 200);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, PlayerOnLoseExperienceUpdatesValue) {
		DummyScriptInterface iface;
		uint64_t exp = 0;
		addCallback(EventCallback_t::playerOnLoseExperience, iface);
		iface.hook = [&exp](lua_State*, int) {
			exp = 50;
		};
		g_callbacks().executeCallback(EventCallback_t::playerOnLoseExperience, std::shared_ptr<Player> {}, std::ref(exp));
		EXPECT_EQ(exp, 50);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, PlayerOnGainSkillTriesUpdatesValue) {
		DummyScriptInterface iface;
		auto skill = skills_t {};
		uint64_t tries = 0;
		addCallback(EventCallback_t::playerOnGainSkillTries, iface);
		iface.hook = [&tries](lua_State*, int) {
			tries = 7;
		};
		g_callbacks().executeCallback(EventCallback_t::playerOnGainSkillTries, std::shared_ptr<Player> {}, skill, std::ref(tries));
		EXPECT_EQ(tries, 7);
		EXPECT_EQ(iface.calls, 1);
	}

	TEST_F(EventCallbacksIntegrationTest, PlayerOnCombatUpdatesDamage) {
		DummyScriptInterface iface;
		CombatDamage dmg {};
		addCallback(EventCallback_t::playerOnCombat, iface);
		iface.hook = [](lua_State* L, int) {
			setDamageTablePrimary(L, lua_gettop(L), COMBAT_FIREDAMAGE, 15);
		};
		g_callbacks().executeCallback(EventCallback_t::playerOnCombat, std::shared_ptr<Player> {}, std::shared_ptr<Creature> {}, std::shared_ptr<Item> {}, std::ref(dmg));
		EXPECT_EQ(dmg.primary.type, COMBAT_FIREDAMAGE);
		EXPECT_EQ(dmg.primary.value, 15);
		EXPECT_EQ(iface.calls, 1);
	}

} // namespace
