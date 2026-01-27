#include <gtest/gtest.h>

#include "account/account_repository_db.hpp"
#include "account/account_info.hpp"
#include "enums/account_type.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_env.hpp"
#include "utils/tools.hpp"

#include <exception>

namespace it_account_repo_db {

	class AccountRepositoryDBTest : public ::testing::Test {
	protected:
		static void SetUpTestSuite() {
			logger = &dynamic_cast<InMemoryLogger &>(g_logger());
		}

		static InMemoryLogger* logger;
	};

	InMemoryLogger* AccountRepositoryDBTest::logger = nullptr;

	inline void createAccount(Database &db) {
		auto lastDay = getTimeNow() + 11 * 86400;
		ASSERT_TRUE(db.executeQuery(fmt::format(
			"INSERT INTO `accounts` "
			"(`id`, `name`, `email`, `password`, `type`, `premdays`, `lastday`, `premdays_purchased`, `creation`, `house_bid_id`) "
			"VALUES(111, 'test', '@test', '', 3, 11, {}, 11, 42183281, 0)",
			lastDay
		)));

		ASSERT_TRUE(db.executeQuery(fmt::format(
			"INSERT INTO `account_sessions` (`id`, `account_id`, `expires`) "
			"VALUES ('{}', 111, 1337)",
			transformToSHA1("test")
		)));
		ASSERT_TRUE(db.executeQuery(fmt::format(
			"INSERT INTO `players` (`name`, `account_id`, `conditions`, `deletion`) "
			"VALUES ('deleted_test_player', 111, '', {})",
			getTimeNow() + 1
		)));
	}

	inline void assertAccountLoad(const AccountInfo &acc) {
		EXPECT_EQ(111, acc.id);
		EXPECT_EQ(AccountType::ACCOUNT_TYPE_SENIORTUTOR, acc.accountType);
		EXPECT_EQ(11, acc.premiumRemainingDays);
		EXPECT_NEAR(static_cast<double>(acc.premiumLastDay), static_cast<double>(getTimeNow() + 11 * 86400), 60.0);
		EXPECT_EQ(0u, acc.players.size());
		EXPECT_FALSE(acc.oldProtocol);
		EXPECT_EQ(11, acc.premiumDaysPurchased);
		EXPECT_NEAR(static_cast<double>(acc.creationTime), 42183281.0, 60.0 * 60.0 * 1000.0);
	}

	TEST_F(AccountRepositoryDBTest, LoadByID) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByID(111, acc));
			assertAccountLoad(*acc);
			EXPECT_EQ(0, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, LoadByEmailOrName) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByEmailOrName(false, "@test", acc));
			assertAccountLoad(*acc);
			EXPECT_EQ(0, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, LoadBySession) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			createAccount(db);
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadBySession("test", acc));
			assertAccountLoad(*acc);
			EXPECT_EQ(1337, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, PremiumDaysPurchasedSync) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			createAccount(db);
			AccountRepositoryDB accRepo {};
			auto acc = std::make_unique<AccountInfo>();

			ASSERT_TRUE(accRepo.loadByID(111, acc));
			acc->premiumLastDay = getTimeNow() + 10 * 86400;
			acc->premiumRemainingDays = 10;
			acc->premiumDaysPurchased = 0;

			ASSERT_TRUE(accRepo.save(acc));
			ASSERT_TRUE(accRepo.loadByID(111, acc));
			EXPECT_EQ(10, acc->premiumDaysPurchased);
		})();
	}

	TEST_F(AccountRepositoryDBTest, GetPassword) {
		auto &db = g_database();
		databaseTest(db, [] {
			AccountRepositoryDB accRepo {};
			std::string password {};
			EXPECT_TRUE(accRepo.getPassword(1, password));
			EXPECT_EQ(std::string { "21298df8a3277357ee55b01df9530b535cf08ec1" }, password);
		})();
	}

	TEST_F(AccountRepositoryDBTest, GetPasswordLogsOnFailure) {
		auto &db = g_database();
		databaseTest(db, [] {
			AccountRepositoryDB accRepo {};
			std::string password {};
			logger->logs.clear();
			EXPECT_FALSE(accRepo.getPassword(891237, password));
			EXPECT_FALSE(logger->logs.empty());
			EXPECT_EQ(std::string { "error" }, logger->logs.back().level);
			EXPECT_EQ(std::string { "Failed to get account:[891237] password!" }, logger->logs.back().message);
		})();
	}

	TEST_F(AccountRepositoryDBTest, Save) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			createAccount(db);
			AccountRepositoryDB accRepo {};
			auto acc = std::make_unique<AccountInfo>();

			ASSERT_TRUE(accRepo.loadByID(111, acc));
			acc->accountType = AccountType::ACCOUNT_TYPE_SENIORTUTOR;
			acc->premiumRemainingDays = 10;
			acc->premiumLastDay = getTimeNow() + acc->premiumRemainingDays * 86400;
			acc->houseBidId = 0;
			acc->creationTime = 42183281;

			logger->logs.clear();
			const bool ok = accRepo.save(acc);
			if (!ok) {
				for (const auto &l : logger->logs) {
					std::cerr << l.level << ": " << l.message << "\n";
				}
			}
			ASSERT_TRUE(ok);

			ASSERT_TRUE(accRepo.save(acc));

			auto acc2 = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByID(111, acc2));
			EXPECT_EQ(AccountType::ACCOUNT_TYPE_SENIORTUTOR, acc2->accountType);
			EXPECT_EQ(10, acc2->premiumRemainingDays);
			EXPECT_NEAR((double)acc2->premiumLastDay, (double)acc->premiumLastDay, 60.0);
		})();
	}

} // namespace it_account_repo_db
