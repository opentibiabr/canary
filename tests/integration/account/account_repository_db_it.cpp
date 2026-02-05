#include "account/account_repository_db.hpp"
#include "enums/account_type.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_env.hpp"
#include "utils/tools.hpp"

namespace it_account_repo_db {

	struct TestIds {
		uint32_t id;
		std::string name;
		std::string email;
	};

	inline TestIds getTestIds() {
		static std::atomic<uint32_t> counter { 1 };
		// Use high-resolution clock to avoid collision between parallel processes
		// Mask with 0x3FFFFFFF to ensure positive signed 32-bit integer (max ~1 billion)
		static const uint32_t base = (static_cast<uint32_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) & 0x3FFFFFFF) + 10000000;
		auto idx = counter.fetch_add(1);
		uint32_t id = base + idx;
		return { id, fmt::format("test_{}", id), fmt::format("{}@test.com", id) };
	}

	class AccountRepositoryDBTest : public ::testing::Test {
	public:
		static void SetUpTestSuite() {
			logger = &dynamic_cast<InMemoryLogger &>(g_logger());
		}

		static InMemoryLogger* logger;
	};

	InMemoryLogger* AccountRepositoryDBTest::logger = nullptr;

	inline void createAccount(Database &db, const TestIds &ids, const std::string &password = "") {
		if (AccountRepositoryDBTest::logger) {
			AccountRepositoryDBTest::logger->logs.clear();
		}
		auto lastDay = getTimeNow() + 11 * 86400;
		if (!db.executeQuery(fmt::format("INSERT INTO `accounts` "
		                                 "(`id`, `name`, `email`, `password`, `type`, `premdays`, `lastday`, `premdays_purchased`, `creation`) "
		                                 "VALUES({}, '{}', '{}', '{}', 3, 11, {}, 11, 42183281)",
		                                 ids.id, ids.name, ids.email, password, lastDay))) {
			for (const auto &log : AccountRepositoryDBTest::logger->logs) {
				if (log.level == "error") {
					std::cerr << "DB Error (accounts): " << log.message << std::endl;
				}
			}
			FAIL() << "Failed to insert account";
		}

		if (!db.executeQuery(fmt::format("INSERT INTO `account_sessions` (`id`, `account_id`, `expires`) "
		                                 "VALUES ('{}', {}, 1337)",
		                                 transformToSHA1(ids.name), ids.id))) {
			for (const auto &log : AccountRepositoryDBTest::logger->logs) {
				if (log.level == "error") {
					std::cerr << "DB Error (account_sessions): " << log.message << std::endl;
				}
			}
			FAIL() << "Failed to insert account_sessions";
		}

		if (!db.executeQuery(fmt::format("INSERT INTO `players` (`name`, `account_id`, `conditions`, `deletion`) "
		                                 "VALUES ('deleted_{}', {}, '', {})",
		                                 ids.name, ids.id, getTimeNow() + 1))) {
			for (const auto &log : AccountRepositoryDBTest::logger->logs) {
				if (log.level == "error") {
					std::cerr << "DB Error (players): " << log.message << std::endl;
				}
			}
			FAIL() << "Failed to insert players";
		}
	}

	inline void assertAccountLoad(const AccountInfo &acc, const TestIds &ids) {
		EXPECT_EQ(ids.id, acc.id);
		EXPECT_EQ(AccountType::ACCOUNT_TYPE_SENIORTUTOR, acc.accountType);
		EXPECT_EQ(11, acc.premiumRemainingDays);
		EXPECT_NEAR(static_cast<double>(acc.premiumLastDay), static_cast<double>(getTimeNow() + 11 * 86400), 60.0);
		EXPECT_EQ(0u, acc.players.size());
		EXPECT_FALSE(acc.oldProtocol);
		EXPECT_EQ(11, acc.premiumDaysPurchased);
		EXPECT_NEAR(static_cast<double>(acc.creationTime), 42183281.0, 1.0);
	}

	TEST_F(AccountRepositoryDBTest, LoadByID) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			createAccount(db, ids);
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByID(ids.id, acc));
			assertAccountLoad(*acc, ids);
			EXPECT_EQ(0, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, LoadByEmailOrName) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			ASSERT_NO_FATAL_FAILURE(createAccount(db, ids));
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByEmailOrName(false, ids.email, acc));
			assertAccountLoad(*acc, ids);
			EXPECT_EQ(0, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, LoadBySession) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			ASSERT_NO_FATAL_FAILURE(createAccount(db, ids));
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadBySession(ids.name, acc));
			assertAccountLoad(*acc, ids);
			EXPECT_EQ(1337, acc->sessionExpires);
		})();
	}

	TEST_F(AccountRepositoryDBTest, PremiumDaysPurchasedSync) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			ASSERT_NO_FATAL_FAILURE(createAccount(db, ids));
			auto acc = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByID(ids.id, acc));
			acc->premiumLastDay = getTimeNow() + 10 * 86400;
			acc->premiumRemainingDays = 10;
			acc->premiumDaysPurchased = 0;
			EXPECT_TRUE(accRepo.save(acc));
			ASSERT_TRUE(accRepo.loadByID(ids.id, acc));
			EXPECT_EQ(10, acc->premiumDaysPurchased);
		})();
	}

	TEST_F(AccountRepositoryDBTest, GetPassword) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			ASSERT_NO_FATAL_FAILURE(createAccount(db, ids, "21298df8a3277357ee55b01df9530b535cf08ec1"));
			std::string password {};
			EXPECT_TRUE(accRepo.getPassword(ids.id, password));
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
			AccountRepositoryDB accRepo {};
			auto ids = getTestIds();
			// We need an account to save, but Save() updates, it doesn't INSERT?
			// The original test set id=1. Save() likely does UPDATE.
			// Let's create account first.
			ASSERT_NO_FATAL_FAILURE(createAccount(db, ids));

			auto acc = std::make_unique<AccountInfo>();
			acc->id = ids.id;
			acc->accountType = AccountType::ACCOUNT_TYPE_SENIORTUTOR;
			acc->premiumRemainingDays = 10;
			acc->premiumLastDay = getTimeNow() + acc->premiumRemainingDays * 86400;
			acc->sessionExpires = 99999999;
			EXPECT_TRUE(accRepo.save(acc));
			auto acc2 = std::make_unique<AccountInfo>();
			ASSERT_TRUE(accRepo.loadByID(ids.id, acc2));
			EXPECT_EQ(ids.id, acc2->id);
			EXPECT_EQ(AccountType::ACCOUNT_TYPE_SENIORTUTOR, acc2->accountType);
			EXPECT_EQ(10, acc2->premiumRemainingDays);
			EXPECT_NEAR(static_cast<double>(acc2->premiumLastDay), static_cast<double>(acc->premiumLastDay), 60.0);
			EXPECT_EQ(0, acc2->sessionExpires);
		})();
	}

} // namespace it_account_repo_db
