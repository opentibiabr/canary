#include <gtest/gtest.h>

#include <iostream>
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "items/item.hpp"

int main(int argc, char** argv) {
	::testing::InitGoogleTest(&argc, argv);

	static di::extension::injector<> injector {};
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);

	(void)g_logger();
	auto &config = g_configManager();
	config.setConfigFileLua("config.lua.dist");
	if (!config.load()) {
		std::cerr << "Failed to load config file." << std::endl;
		return 1;
	}
	if (!Item::items.loadFromXml()) {
		std::cerr << "Failed to load items." << std::endl;
		return 1;
	}
	(void)g_database();

	return RUN_ALL_TESTS();
}
