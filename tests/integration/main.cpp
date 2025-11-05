#include <gtest/gtest.h>
#include <memory>
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "kv/in_memory_kv.hpp"
#include "lua/test_lua_environment.hpp"
#include "test_database.hpp"

int main(int argc, char** argv) {
	::testing::InitGoogleTest(&argc, argv);

	static auto injector = std::make_unique<di::extension::injector<>>();
	InMemoryLogger::install(*injector);
	KVMemory::install(*injector);
	TestLuaEnvironment::install(*injector);
	DI::setTestContainer(injector.get());

	TestDatabase::init();
	(void)g_logger();
	(void)g_configManager();
	(void)g_database();

	const auto result = RUN_ALL_TESTS();
	DI::setTestContainer(nullptr);
	return result;
}
