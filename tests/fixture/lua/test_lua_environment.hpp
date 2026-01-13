/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include "lua/scripts/lua_environment.hpp"
#include "lib/di/container.hpp"
#include "test_injection.hpp"

namespace di = boost::di;

class TestLuaEnvironment final : public LuaEnvironment {
public:
	TestLuaEnvironment() = default;
	~TestLuaEnvironment() override = default;

	static di::extension::injector<> &install(di::extension::injector<> &injector) {
		injector.install(di::bind<LuaEnvironment>.to<TestLuaEnvironment>().in(di::singleton));
		return injector;
	}

	bool initState() override {
		luaState = luaL_newstate();
		return luaState != nullptr;
	}

	bool reInitState() override {
		closeState();
		return initState();
	}

	bool closeState() override {
		if (luaState) {
			lua_close(luaState);
			luaState = nullptr;
		}
		return true;
	}

	lua_State* getLuaState() override {
		if (!luaState) {
			initState();
		}
		return luaState;
	}
};

template <>
struct TestInjection<LuaEnvironment> {
	using type = TestLuaEnvironment;
};
