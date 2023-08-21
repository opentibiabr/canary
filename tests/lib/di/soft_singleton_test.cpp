/**
* Canary - A free and open-source MMORPG server emulator
* Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
* Repository: https://github.com/opentibiabr/canary
* License: https://github.com/opentibiabr/canary/blob/main/LICENSE
* Contributors: https://github.com/opentibiabr/canary/graphs/contributors
* Website: https://docs.opentibiabr.com/
*/
#include <boost/ut.hpp>
#include "pch.hpp"
#include "lib/di/soft_singleton.hpp"
#include "stubs/in_memory_logger.hpp"

using namespace boost::ut;

suite<"lib"> softSingletonTest = [] {
	test("SoftSingleton warns about multiple instances") = [] {
		InMemoryLogger logger{};
		SoftSingleton softSingleton{logger, "Test"};
		SoftSingletonGuard guard{softSingleton};
		SoftSingletonGuard guard2{softSingleton};
		softSingleton.increment();

		expect(eq(2, logger.logCount()));
		expect(eq(std::string{"warning"}, logger.logs[0].level) and eq(std::string{"2 instances created for Test. This is a soft singleton, you probably want to use g_test instead."}, logger.logs[0].message));
		expect(eq(std::string{"warning"}, logger.logs[1].level) and eq(std::string{"3 instances created for Test. This is a soft singleton, you probably want to use g_test instead."}, logger.logs[1].message));
	};

	test("SoftSingleton doesn't warn if instance was released") = [] {
		InMemoryLogger logger{};
		SoftSingleton softSingleton{logger, "Test"};

		[&softSingleton] { SoftSingletonGuard guard{softSingleton}; }();

		// Lambda scope, guard was destructed.
		[&softSingleton] { SoftSingletonGuard guard{softSingleton}; }();

		// Lambda scope, guard2 was destructed.
		softSingleton.increment();
		softSingleton.decrement();

		// Decrement resets the counter;
		softSingleton.increment();

		expect(eq(0, logger.logCount()));
	};
};
