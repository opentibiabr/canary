#include <boost/ut.hpp>
#include "config/configmanager.hpp"
#include "database/database.hpp"
#include "lib/di/container.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_database.hpp"

using namespace boost::ut;

int main() {
	di::extension::injector<> injector {};
	InMemoryLogger::install(injector);
	DI::setTestContainer(&injector);

	TestDatabase::init();
	(void)g_logger();
	(void)g_configManager();
	(void)g_database();

	return cfg<>.run();
}
