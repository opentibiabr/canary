#include <gtest/gtest.h>
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"

int main(int argc, char** argv) {
	::testing::InitGoogleTest(&argc, argv);

	static di::extension::injector<> injector {};
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);

	(void)g_logger();
	(void)g_configManager();
	(void)g_database();

	return RUN_ALL_TESTS();
}
