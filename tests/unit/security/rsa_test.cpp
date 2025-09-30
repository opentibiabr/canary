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

#include "lib/logging/in_memory_logger.hpp"
#include "security/rsa.hpp"

class RSATest : public ::testing::Test {
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

TEST_F(RSATest, StartLogsErrorForMissingPemFile) {
	DI::create<RSA &>().start();

	auto &logger = testLogger();

	ASSERT_EQ(1u, logger.logs.size());
	EXPECT_EQ(std::string { "error" }, logger.logs[0].level);
	EXPECT_EQ(
		std::string { "File key.pem not found or have problem on loading... Setting standard rsa key\n" },
		logger.logs[0].message
	);
}
