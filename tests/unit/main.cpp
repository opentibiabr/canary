#include <boost/ut.hpp>
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "items/item.hpp"

using namespace boost::ut;

int main() {
	static const auto init = [] {
		di::extension::injector<> injector {};
		InMemoryLogger::install(injector);
		DI::setTestContainer(&injector);

		(void)g_logger();
		auto &config = g_configManager();
		config.setConfigFileLua("config.lua.dist");
		config.load();
		Item::items.loadFromXml();
		(void)g_database();
		return true;
	}();
	(void)init;

	return cfg<>.run();
}
