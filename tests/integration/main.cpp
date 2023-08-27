#include <boost/ut.hpp>

#include "account/account_repository_db.hpp"
#include "lib/logging/in_memory_logger.hpp"

using namespace account;
using namespace boost::ut;

int main() {
	"test"_test = [] {
		Database db{};
        InMemoryLogger logger{};
        AccountRepositoryDB{db, logger};
    };
}
