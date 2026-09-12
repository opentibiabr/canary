#include "lua/functions/core/game/world_functions.hpp"
#include "lua/functions/lua_functions_loader.hpp"
#include "game/game.hpp"
#include "world/world_runtime.hpp"
#include "lib/logging/in_memory_logger.hpp"

#ifndef USE_PRECOMPILED_HEADERS
	#include <gtest/gtest.h>
#endif

class WorldFunctionsTest : public ::testing::Test {
protected:
	void SetUp() override {
		previous = DI::getTestContainer();
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);
		L = luaL_newstate();
		ASSERT_NE(L, nullptr);
		luaL_openlibs(L);
		WorldFunctions::init(L);
	}
	void TearDown() override {
		lua_close(L);
		DI::setTestContainer(previous);
	}
	void run(const char* source) {
		ASSERT_TRUE(Lua::reserveScriptEnv());
		const auto result = luaL_dostring(L, source);
		Lua::resetScriptEnv();
		ASSERT_EQ(result, LUA_OK) << lua_tostring(L, -1);
	}
	di::extension::injector<> injector;
	di::extension::injector<>* previous = nullptr;
	lua_State* L = nullptr;
};

TEST_F(WorldFunctionsTest, ContextCopiesCompositeValuesAndExpiresAfterInvocation) {
	using world_layers::Value;
	world_layers::Parameter count;
	count.type = "integer";
	count.defaultValue = Value { int64_t(5) };
	world_layers::Parameter entry;
	entry.type = "record";
	entry.fields["count"] = count;
	world_layers::Parameter entries;
	entries.type = "list";
	entries.element.push_back(entry);
	world_layers::BehaviorDescriptor descriptor;
	descriptor.parameters["rewards"] = entries;
	world_layers::BehaviorBinding binding;
	binding.parameters["rewards"] = Value { Value::List { Value { Value::Record {} } } };
	const auto active = std::make_shared<bool>(true);
	WorldFunctions::pushContext(L, { "test.object", 1, g_game().worldLayers().callbackEpoch() }, binding, descriptor, active);
	lua_setglobal(L, "context");
	run(R"(
		local rewards = context:parameter('rewards')
		assert(rewards[1].count == 5)
		rewards[1].count = 100
		assert(context:parameter('rewards')[1].count == 5)
		assert(context:parameter('missing') == nil)
	)");
	EXPECT_TRUE(std::get<Value::Record>(std::get<Value::List>(binding.parameters.at("rewards").data)[0].data).empty());
	*active = false;
	run("assert(context:parameter('rewards') == nil); assert(context:object() == nil)");
}

TEST_F(WorldFunctionsTest, ScriptEpochInvalidatesContextEvenWhileCallerRetainsIt) {
	world_layers::BehaviorDescriptor descriptor;
	descriptor.parameters["allowed"].type = "boolean";
	descriptor.parameters["allowed"].defaultValue = world_layers::Value { true };
	const auto active = std::make_shared<bool>(true);
	WorldFunctions::pushContext(L, { "test.object", 1, g_game().worldLayers().callbackEpoch() }, {}, descriptor, active);
	lua_setglobal(L, "context");
	run("assert(context:parameter('allowed') == true)");
	g_game().worldLayers().invalidateCallbacks();
	run("assert(context:parameter('allowed') == nil)");
}

TEST_F(WorldFunctionsTest, InvalidTokensAndWrongUserdataAreRejected) {
	run(R"(
		assert(World.resolve(nil) == nil)
		assert(World.resolve({id='test', generation=1, epoch=1}) == nil)
		assert(World.resolve({id='test', generation='-1', epoch='1'}) == nil)
		assert(World.resolve({id='test', generation='18446744073709551616', epoch='1'}) == nil)
		assert(World.resolve({id='test', generation='0', epoch='1'}) == nil)
		assert(World.get('undeclared') == nil)
		assert(WorldObject.getItem({}) == nil)
		assert(WorldContext.parameter({}, 'value') == nil)
		assert(WorldReference.getObject({}) == nil)
		assert(WorldBehavior('test', 0) == nil)
		assert(WorldBehavior('test', 1.5) == nil)
		assert(WorldBehavior('test', '1') == nil)
		assert(WorldBehavior('test', 4294967296) == nil)
		assert(WorldBehavior('test', 0/0) == nil)
		collectgarbage('collect')
	)");
}
