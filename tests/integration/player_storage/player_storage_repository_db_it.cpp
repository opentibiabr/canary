#include <boost/ut.hpp>

#include "io/player_storage_repository_db.hpp"
#include "test_env.hpp"

#include <exception>
#include <functional>
#include <vector>
#include <fmt/format.h>

using namespace boost::ut;

namespace it_player_storage_repo_db {

	constexpr uint32_t ACCOUNT_ID = 600000000;
	constexpr uint32_t PLAYER_ID = 600000001;

	inline void createPlayer(Database &db) {
		db.executeQuery(fmt::format("INSERT INTO `accounts` (`id`,`name`,`password`) VALUES ({}, 'acc', '')", ACCOUNT_ID));
		db.executeQuery(fmt::format("INSERT INTO `players` (`id`,`name`,`account_id`,`conditions`) VALUES ({}, 'player', {}, '')", PLAYER_ID, ACCOUNT_ID));
	}

	inline bool hasRow(const std::vector<PlayerStorageRow> &rows, uint32_t key, int32_t value) {
		return std::ranges::any_of(rows, [key, value](const auto &r) {
			return r.key == key && r.value == value;
		});
	}

	inline void register_load(Database &db) {
		test("DbPlayerStorageRepository::load") = databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			createPlayer(db);
			db.executeQuery(fmt::format("INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 100, 42), ({}, 200, 55)", PLAYER_ID, PLAYER_ID));
			auto rows = repo.load(PLAYER_ID);
			expect(eq(rows.size(), 2_u));
			bool found100 = false;
			bool found200 = false;
			for (auto &r : rows) {
				if (r.key == 100 && r.value == 42) {
					found100 = true;
				}
				if (r.key == 200 && r.value == 55) {
					found200 = true;
				}
			}
			expect(found100);
			expect(found200);
		});
	}

	inline void register_deleteKeys(Database &db) {
		test("DbPlayerStorageRepository::deleteKeys") = databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			createPlayer(db);
			db.executeQuery(fmt::format("INSERT INTO `player_storage` (`player_id`,`key`,`value`) VALUES ({}, 1, 10), ({}, 2, 20), ({}, 3, 30)", PLAYER_ID, PLAYER_ID, PLAYER_ID));
			expect(repo.deleteKeys(PLAYER_ID, { 1, 3 }));
			auto rows = repo.load(PLAYER_ID);
			expect(eq(rows.size(), 1_u));
			expect(eq(rows[0].key, 2_u));
			expect(eq(rows[0].value, 20));
		});
	}

	inline void register_upsert(Database &db) {
		test("DbPlayerStorageRepository::upsert") = databaseTest(db, [&db] {
			DbPlayerStorageRepository repo {};
			createPlayer(db);
			expect(repo.upsert(PLAYER_ID, { { 1, 10 }, { 2, 20 } }));
			auto rows = repo.load(PLAYER_ID);
			expect(eq(rows.size(), 2_u));
			expect(hasRow(rows, 1, 10));
			expect(hasRow(rows, 2, 20));
			expect(repo.upsert(PLAYER_ID, { { 1, 100 } }));
			auto rows2 = repo.load(PLAYER_ID);
			expect(hasRow(rows2, 1, 100));
			expect(hasRow(rows2, 2, 20));
		});
	}

	inline suite<"DbPlayerStorageRepository"> suite_all = [] {
		auto &db = g_database();

		register_load(db);
		register_deleteKeys(db);
		register_upsert(db);
	};

} // namespace it_player_storage_repo_db
