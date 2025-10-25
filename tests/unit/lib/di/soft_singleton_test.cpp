/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <gtest/gtest.h>

#include "lib/di/container.hpp"
#include "lib/di/soft_singleton.hpp"
#include "lib/logging/in_memory_logger.hpp"

class SoftSingletonTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		previousContainer = DI::getTestContainer();
		DI::setTestContainer(&InMemoryLogger::install(injector));
		logger = &dynamic_cast<InMemoryLogger &>(DI::get<Logger>());
	}

	static void TearDownTestSuite() {
		DI::setTestContainer(previousContainer);
	}

	void SetUp() override {
		logger = &logger->reset();
	}

	static InMemoryLogger &testLogger() {
		return *logger;
	}

private:
	inline static di::extension::injector<> injector {};
	inline static di::extension::injector<>* previousContainer { nullptr };
	inline static InMemoryLogger* logger { nullptr };
};

TEST_F(SoftSingletonTest, WarnsAboutMultipleInstances) {
	SoftSingleton softSingleton { "Test" };
	SoftSingletonGuard guard { softSingleton };
	SoftSingletonGuard guard2 { softSingleton };
	softSingleton.increment();

	auto &logger = testLogger();
	ASSERT_EQ(2, logger.logCount());
	EXPECT_EQ(std::string { "warning" }, logger.logs[0].level);
	EXPECT_EQ(
		std::string { "2 instances created for Test. This is a soft singleton, you probably want to use g_test instead." },
		logger.logs[0].message
	);
	EXPECT_EQ(std::string { "warning" }, logger.logs[1].level);
	EXPECT_EQ(
		std::string { "3 instances created for Test. This is a soft singleton, you probably want to use g_test instead." },
		logger.logs[1].message
	);
}

TEST_F(SoftSingletonTest, DoesNotWarnIfInstanceReleased) {
	SoftSingleton softSingleton { "Test" };

	[&softSingleton] { SoftSingletonGuard guard { softSingleton }; }();
	[&softSingleton] { SoftSingletonGuard guard { softSingleton }; }();

	softSingleton.increment();
	softSingleton.decrement();
	softSingleton.increment();

	EXPECT_EQ(0, testLogger().logCount());
}
