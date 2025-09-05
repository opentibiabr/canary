#include <boost/ut.hpp>

#include "account/account_repository_db.hpp"
#include "account/account_info.hpp"
#include "enums/account_type.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_env.hpp"
#include "utils/tools.hpp"

#include <exception>

using namespace boost::ut;

namespace it_account_repo_db {

	inline void createAccount(Database &db) {
		auto lastDay = getTimeNow() + 11 * 86400;
		db.executeQuery(fmt::format("INSERT INTO `accounts` "
		                            "(`id`, `name`, `email`, `password`, `type`, `premdays`, `lastday`, `premdays_purchased`, `creation`) "
		                            "VALUES(111, 'test', '@test', '', 3, 11, {}, 11, 42183281)",
		                            lastDay));
		db.executeQuery(fmt::format("INSERT INTO `account_sessions` (`id`, `account_id`, `expires`) "
		                            "VALUES ('{}', 111, 1337)",
		                            transformToSHA1("test")));
	}

	inline void assertAccountLoad(const AccountInfo &acc) {
		expect(eq(acc.id, 111));
		expect(eq(acc.accountType, AccountType::ACCOUNT_TYPE_SENIORTUTOR));
		expect(eq(acc.premiumRemainingDays, 11));
		expect(approx(acc.premiumLastDay, getTimeNow() + 11 * 86400, 60));
		expect(eq(acc.players.size(), 0u));
		expect(eq(acc.oldProtocol, false));
		expect(eq(acc.premiumDaysPurchased, 11));
		expect(approx(acc.creationTime, 42183281, 60 * 60 * 1000));
	}

	inline void register_loadByID(Database &db) {
		test("AccountRepositoryDB::loadByID") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			accRepo.loadByID(111, acc);
			assertAccountLoad(*acc);
			expect(eq(acc->sessionExpires, 0));
		});
	}

	inline void register_loadByEmailOrName(Database &db) {
		test("AccountRepositoryDB::loadByEmailOrName") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			accRepo.loadByEmailOrName(false, "@test", acc);
			assertAccountLoad(*acc);
			expect(eq(acc->sessionExpires, 0));
		});
	}

	inline void register_loadBySession(Database &db) {
		test("AccountRepositoryDB::loadBySession") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			accRepo.loadBySession("test", acc);
			assertAccountLoad(*acc);
			expect(eq(acc->sessionExpires, 1337));
		});
	}

	inline void register_premiumPurchasedSync(Database &db) {
		test("AccountRepositoryDB premiumDaysPurchased sync") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto acc = std::make_unique<AccountInfo>();
			accRepo.loadByID(1, acc);
			acc->premiumLastDay = getTimeNow() + 10 * 86400;
			acc->premiumRemainingDays = 10;
			acc->premiumDaysPurchased = 0;
			expect(accRepo.save(acc));
			accRepo.loadByID(1, acc);
			expect(eq(acc->premiumDaysPurchased, 10));
		});
	}

	inline void register_getPassword(Database &db) {
		test("AccountRepositoryDB::getPassword") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			std::string password {};
			expect(accRepo.getPassword(1, password));
			expect(eq(password, std::string { "21298df8a3277357ee55b01df9530b535cf08ec1" }));
		});
	}

	inline void register_getPassword_logs(Database &db, InMemoryLogger &logger) {
		test("AccountRepositoryDB::getPassword logs on failure") = databaseTest(db, [&db, &logger] {
			AccountRepositoryDB accRepo {};
			std::string password {};
			logger.logs.clear();
			expect(!accRepo.getPassword(891237, password));
			expect(logger.logs.size() >= 1_u);
			expect(eq(logger.logs.back().level, std::string { "error" }));
			expect(eq(logger.logs.back().message, std::string { "Failed to get account:[891237] password!" }));
		});
	}

	inline void register_save(Database &db) {
		test("AccountRepositoryDB::save") = databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto acc = std::make_unique<AccountInfo>();
			acc->id = 1;
			acc->accountType = AccountType::ACCOUNT_TYPE_SENIORTUTOR;
			acc->premiumRemainingDays = 10;
			acc->premiumLastDay = getTimeNow() + acc->premiumRemainingDays * 86400;
			acc->sessionExpires = 99999999;
			expect(accRepo.save(acc));
			auto acc2 = std::make_unique<AccountInfo>();
			accRepo.loadByID(1, acc2);
			expect(eq(acc2->id, 1));
			expect(eq(acc2->accountType, AccountType::ACCOUNT_TYPE_SENIORTUTOR));
			expect(eq(acc2->premiumRemainingDays, 10));
			expect(approx(acc2->premiumLastDay, acc->premiumLastDay, 60));
			expect(eq(acc2->sessionExpires, 0));
		});
	}

	inline suite<"AccountRepositoryDB"> suite_all = [] {
		auto &db = g_database();
		auto &logger = dynamic_cast<InMemoryLogger &>(g_logger());

		register_loadByID(db);
		register_loadByEmailOrName(db);
		register_loadBySession(db);
		register_premiumPurchasedSync(db);
		register_getPassword(db);
		register_getPassword_logs(db, logger);
		register_save(db);
	};

} // namespace it_account_repo_db
