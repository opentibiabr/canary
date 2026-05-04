#include <string_view>

#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "kv/in_memory_kv.hpp"
#include "lua/test_lua_environment.hpp"
#include "test_database.hpp"

namespace {
	bool isListingTests(int argc, char** argv) {
		for (int i = 1; i < argc; ++i) {
			if (std::string_view(argv[i]) == "--gtest_list_tests") {
				return true;
			}
		}
		return false;
	}
}

int main(int argc, char** argv) {
	const auto listingTests = isListingTests(argc, argv);
	::testing::InitGoogleTest(&argc, argv);
	if (listingTests) {
		return RUN_ALL_TESTS();
	}

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
