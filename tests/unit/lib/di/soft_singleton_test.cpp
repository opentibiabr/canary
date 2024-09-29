/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <boost/ut.hpp>

#include "lib/di/container.hpp"
#include "lib/di/soft_singleton.hpp"
#include "lib/logging/in_memory_logger.hpp"

using namespace boost::ut;

suite<"lib"> softSingletonTest = [] {
	test("SoftSingleton warns about multiple instances") = [] {
		di::extension::injector<> injector {};
		DI::setTestContainer(&InMemoryLogger::install(injector));

		SoftSingleton softSingleton { "Test" };
		SoftSingletonGuard guard { softSingleton };
		SoftSingletonGuard guard2 { softSingleton };
		softSingleton.increment();

		auto &logger = dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());
		expect(eq(2, logger.logCount()) >> fatal);
		expect(
			eq(std::string { "warning" }, logger.logs[0].level) and eq(std::string { "2 instances created for Test. This is a soft singleton, you probably want to use g_test instead." }, logger.logs[0].message)
		);
		expect(
			eq(std::string { "warning" }, logger.logs[1].level) and eq(std::string { "3 instances created for Test. This is a soft singleton, you probably want to use g_test instead." }, logger.logs[1].message)
		);
	};

	test("SoftSingleton doesn't warn if instance was released") = [] {
		di::extension::injector<> injector {};
		DI::setTestContainer(&InMemoryLogger::install(injector));
		SoftSingleton softSingleton { "Test" };

		[&softSingleton] { SoftSingletonGuard guard { softSingleton }; }();

		// Lambda scope, guard was destructed.
		[&softSingleton] { SoftSingletonGuard guard { softSingleton }; }();

		// Lambda scope, guard2 was destructed.
		softSingleton.increment();
		softSingleton.decrement();

		// Decrement resets the counter;
		softSingleton.increment();

		auto &logger = dynamic_cast<InMemoryLogger &>(injector.create<Logger &>());
		expect(eq(0, logger.logCount()));
	};
};
