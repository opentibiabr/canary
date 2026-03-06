#include "io/player_storage_repository_db.hpp"
#include "lib/logging/in_memory_logger.hpp"
#include "test_env.hpp"

namespace it_player_storage_repo_db {

	struct TestIds {
		uint32_t accountId;
		uint32_t playerId;
	};

	inline TestIds getTestIds() {
		static std::atomic<uint32_t> counter { 1 };
		// Use high-resolution clock to avoid collision between parallel processes
		// Mask with 0x3FFFFFFF to ensure positive signed 32-bit integer (max ~1 billion)
		// This prevents "Out of range value" errors in MySQL INT columns.
		static const uint32_t base = (static_cast<uint32_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) & 0x3FFFFFFF) + 10000000;
		auto idx = counter.fetch_add(1);
		return { base + idx, base + idx + 1 };
	}

	inline bool createPlayer(Database &db, uint32_t accountId, uint32_t playerId) {
		const auto accountInserted = db.executeQuery(
			fmt::format("INSERT INTO `accounts` (`id`,`name`,`password`,`email`) VALUES ({}, 'acc_{}', '', 'test@test.com')", accountId, accountId)
		);
		if (!accountInserted) {
			if (auto* logger = dynamic_cast<InMemoryLogger*>(&g_logger())) {
				for (const auto &log : logger->logs) {
					if (log.level == "error") {
						std::cerr << "DB Error (accounts): " << log.message << std::endl;
					}
				}
			}
		}

		const auto playerInserted = db.executeQuery(fmt::format("INSERT INTO `players` (`id`,`name`,`account_id`,`conditions`) VALUES ({}, 'player_{}', {}, '')", playerId, playerId, accountId));
		if (!playerInserted) {
			if (auto* logger = dynamic_cast<InMemoryLogger*>(&g_logger())) {
				for (const auto &log : logger->logs) {
					if (log.level == "error") {
						std::cerr << "DB Error (players): " << log.message << std::endl;
					}
				}
			}
		}

		return accountInserted && playerInserted;
	}

	inline bool hasRow(const std::vector<PlayerStorageRow> &rows, uint32_t key, int32_t value) {
		return std::ranges::any_of(rows, [key, value](const auto &r) { return r.key == key && r.value == value; });
	}

	class PlayerStorageRepositoryDBTest : public ::testing::Test { };

	TEST_F(PlayerStorageRepositoryDBTest, Load) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			auto ids = getTestIds();
			ASSERT_TRUE(createPlayer(db, ids.accountId, ids.playerId));
			ASSERT_TRUE(db.executeQuery(fmt::format("INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 100, 42), ({}, 200, 55)", ids.playerId, ids.playerId)));
			auto rows = repo.load(ids.playerId);
			ASSERT_EQ(2u, rows.size());
			EXPECT_TRUE(hasRow(rows, 100, 42));
			EXPECT_TRUE(hasRow(rows, 200, 55));
		})();
	}

	TEST_F(PlayerStorageRepositoryDBTest, DeleteKeys) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			auto ids = getTestIds();
			ASSERT_TRUE(createPlayer(db, ids.accountId, ids.playerId));
			ASSERT_TRUE(db.executeQuery(fmt::format("INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 1, 10), ({}, 2, 20), ({}, 3, 30)", ids.playerId, ids.playerId, ids.playerId)));
			EXPECT_TRUE(repo.deleteKeys(ids.playerId, { 1, 3 }));
			auto rows = repo.load(ids.playerId);
			ASSERT_EQ(1u, rows.size());
			EXPECT_EQ(2u, rows[0].key);
			EXPECT_EQ(20, rows[0].value);
		})();
	}

	TEST_F(PlayerStorageRepositoryDBTest, Upsert) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			auto ids = getTestIds();
			ASSERT_TRUE(createPlayer(db, ids.accountId, ids.playerId));
			EXPECT_TRUE(repo.upsert(ids.playerId, { { 1, 10 }, { 2, 20 } }));
			auto rows = repo.load(ids.playerId);
			EXPECT_EQ(2u, rows.size());
			EXPECT_TRUE(hasRow(rows, 1, 10));
			EXPECT_TRUE(hasRow(rows, 2, 20));
			EXPECT_TRUE(repo.upsert(ids.playerId, { { 1, 100 } }));
			auto rows2 = repo.load(ids.playerId);
			EXPECT_TRUE(hasRow(rows2, 1, 100));
			EXPECT_TRUE(hasRow(rows2, 2, 20));
		})();
	}

} // namespace it_player_storage_repo_db
