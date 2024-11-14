#include <boost/ut.hpp>

#include "account/account_repository_db.hpp"
#include "database/database.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "utils/tools.hpp"
#include "enums/account_type.hpp"
#include "account/account_info.hpp"

using namespace boost::ut;

auto databaseTest(Database &db, const std::function<void(void)> &load) {
	return [&db, load] {
		db.executeQuery("BEGIN");

		try {
			load();
		} catch (...) {
		}

		db.executeQuery("ROLLBACK");
	};
}

void createAccount(Database &db) {
	db.executeQuery(
		"INSERT INTO `accounts` "
		"(`id`, `name`, `email`, `password`, `type`, `premdays`, `lastday`, `premdays_purchased`, `creation`) "
		"VALUES(111, 'test', '@test', '', 3, 11, 1293912, 11, 42183281)"
	);

	db.executeQuery(fmt::format(
		"INSERT INTO `account_sessions` (`id`, `account_id`, `expires`) "
		"VALUES ('{}', 111, 1337)",
		transformToSHA1("test")
	));
}

void assertAccountLoad(AccountInfo acc) {
	expect(eq(acc.id, 111));
	expect(eq(acc.accountType, AccountType::ACCOUNT_TYPE_SENIORTUTOR));
	expect(eq(acc.premiumRemainingDays, 11));
	expect(eq(acc.premiumLastDay, 1293912));
	expect(eq(acc.players.size(), 0));
	expect(eq(acc.oldProtocol, false));
	expect(eq(acc.premiumDaysPurchased, 11));
	expect(approx(acc.creationTime, 42183281, 60 * 60 * 1000));
}

int main() {
	struct DbConfig {
	public:
		std::string host = "127.0.0.1";
		std::string user = "root";
		std::string password = "root";
		std::string database = "otservbr-global";
		uint32_t port = 3306;
		std::string sock;
    };
	Database db{};
	DbConfig dbConfig{};

	db.connect(
		&dbConfig.host,
		&dbConfig.user,
		&dbConfig.password,
		&dbConfig.database,
		dbConfig.port,
		&dbConfig.sock
	);

	test("AccountRepositoryDB::loadByID") = databaseTest(db, [&db] {
		InMemoryLogger logger{};
		AccountRepositoryDB accRepo{};
		createAccount(db);

		AccountInfo acc{};
		accRepo.loadByID(111, acc);
		assertAccountLoad(acc);
		expect(eq(acc.sessionExpires, 0));
	});

	test("AccountRepositoryDB::loadByEmailOrName") = databaseTest(db, [&db] {
		InMemoryLogger logger {};
		AccountRepositoryDB accRepo {};
		createAccount(db);

		AccountInfo acc {};
		accRepo.loadByEmailOrName(false, "@test", acc);
		assertAccountLoad(acc);
		expect(eq(acc.sessionExpires, 0));
	});

	test("AccountRepositoryDB::loadBySession") = databaseTest(db, [&db] {
		InMemoryLogger logger {};
		AccountRepositoryDB accRepo {};
		createAccount(db);

		AccountInfo acc {};
		accRepo.loadBySession("test", acc);

		assertAccountLoad(acc);
		expect(eq(acc.sessionExpires, 1337));
	});

	test("AccountRepositoryDB load sets premium day purchased = remaining days, if needed") = databaseTest(db, [&db] {
		InMemoryLogger logger{};
		AccountRepositoryDB accRepo{};

		AccountInfo acc{};
		accRepo.loadByID(1, acc);
		acc.premiumRemainingDays = 10;
		accRepo.save(acc);

		accRepo.loadByID(1, acc);

		expect(eq(acc.premiumDaysPurchased, 10));
	});

	test("AccountRepositoryDB::getPassword") = databaseTest(db, [&db] {
		InMemoryLogger logger {};
		AccountRepositoryDB accRepo {};

		std::string password;

		expect(accRepo.getPassword(1, password));
		expect(eq(password, std::string { "21298df8a3277357ee55b01df9530b535cf08ec1" }));
	});

	test("AccountRepositoryDB::getPassword logs on failure") = databaseTest(db, [&db] {
		InMemoryLogger logger {};
		AccountRepositoryDB accRepo {};

		std::string password;

		expect(!accRepo.getPassword(891237, password));
		expect(eq(logger.logs.size(), 1) >> fatal);
		expect(eq(logger.logs[0].level, std::string { "error" }));
		expect(eq(logger.logs[0].message, std::string { "Failed to get account:[891237] password!" }));
	});

	test("AccountRepositoryDB::save") = databaseTest(db, [&db] {
		InMemoryLogger logger {};
		AccountRepositoryDB accRepo {};

		AccountInfo acc {};
		acc.id = 1;
		acc.accountType = AccountType::ACCOUNT_TYPE_SENIORTUTOR;
		acc.premiumRemainingDays = 10;
		acc.premiumLastDay = 10;
		acc.sessionExpires = 99999999;
		expect(accRepo.save(acc));

		AccountInfo acc2 {};
		accRepo.loadByID(1, acc2);
		expect(eq(acc2.id, 1));
		expect(eq(acc2.accountType, AccountType::ACCOUNT_TYPE_SENIORTUTOR));
		expect(eq(acc2.premiumRemainingDays, 10));
		expect(eq(acc2.premiumLastDay, 10));
		// sessionExpires is not saved
		expect(eq(acc2.sessionExpires, 0));
	});
}
