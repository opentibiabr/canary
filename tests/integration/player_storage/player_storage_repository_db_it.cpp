#include <gtest/gtest.h>

#include "io/player_storage_repository_db.hpp"
#include "test_env.hpp"
#include <exception>
#include <functional>
#include <vector>
#include <fmt/format.h>

namespace it_player_storage_repo_db {

	constexpr uint32_t kTestPlayerId = 1;

	inline bool hasRow(const std::vector<PlayerStorageRow> &rows, uint32_t key, int32_t value) {
		return std::ranges::any_of(rows, [key, value](const auto &r) { return r.key == key && r.value == value; });
	}

	class PlayerStorageRepositoryDBTest : public ::testing::Test { };

	TEST_F(PlayerStorageRepositoryDBTest, Load) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			ASSERT_TRUE(db.executeQuery(fmt::format(
				"INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 100, 42), ({}, 200, 55)",
				kTestPlayerId,
				kTestPlayerId
			)));
			auto rows = repo.load(kTestPlayerId);
			ASSERT_EQ(2u, rows.size());
			EXPECT_TRUE(hasRow(rows, 100, 42));
			EXPECT_TRUE(hasRow(rows, 200, 55));
		})();
	}

	TEST_F(PlayerStorageRepositoryDBTest, DeleteKeys) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			ASSERT_TRUE(db.executeQuery(fmt::format(
				"INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 1, 10), ({}, 2, 20), ({}, 3, 30)",
				kTestPlayerId,
				kTestPlayerId,
				kTestPlayerId
			)));
			EXPECT_TRUE(repo.deleteKeys(kTestPlayerId, { 1, 3 }));
			auto rows = repo.load(kTestPlayerId);
			ASSERT_EQ(1u, rows.size());
			EXPECT_EQ(2u, rows[0].key);
			EXPECT_EQ(20, rows[0].value);
		})();
	}

	TEST_F(PlayerStorageRepositoryDBTest, Upsert) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			EXPECT_TRUE(repo.upsert(kTestPlayerId, { { 1, 10 }, { 2, 20 } }));
			auto rows = repo.load(kTestPlayerId);
			EXPECT_EQ(2u, rows.size());
			EXPECT_TRUE(hasRow(rows, 1, 10));
			EXPECT_TRUE(hasRow(rows, 2, 20));
			EXPECT_TRUE(repo.upsert(kTestPlayerId, { { 1, 100 } }));
			auto rows2 = repo.load(kTestPlayerId);
			EXPECT_TRUE(hasRow(rows2, 1, 100));
			EXPECT_TRUE(hasRow(rows2, 2, 20));
		})();
	}

} // namespace it_player_storage_repo_db
