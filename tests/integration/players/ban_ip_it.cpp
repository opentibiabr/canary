/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <atomic>
#include <chrono>
#include <cstdint>
#include <string>
#include <system_error>

#include <asio/ip/address.hpp>
#include <fmt/format.h>
#include <gtest/gtest.h>

#include "creatures/players/management/ban.hpp"
#include "database/database.hpp"
#include "test_env.hpp"

namespace it_ip_ban {
	namespace {
		struct TestIds {
			uint32_t accountId;
			uint32_t playerId;
			std::string playerName;
		};

		TestIds getTestIds() {
			static std::atomic<uint32_t> counter { 1 };
			static const uint32_t base = (static_cast<uint32_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) & 0x3FFFFFFF) + 10000000;
			const auto idx = counter.fetch_add(1);
			const auto accountId = base + idx;
			const auto playerId = accountId + 100000;
			return { accountId, playerId, fmt::format("ip_ban_tester_{}", playerId) };
		}

		bool createBanOwner(Database &db, const TestIds &ids) {
			const auto accountInserted = db.executeQuery(fmt::format(
				"INSERT INTO `accounts` (`id`, `name`, `password`, `email`) VALUES ({}, 'acc_{}', '', 'test@test.com')",
				ids.accountId,
				ids.accountId
			));
			const auto playerInserted = db.executeQuery(fmt::format(
				"INSERT INTO `players` (`id`, `name`, `account_id`, `conditions`) VALUES ({}, '{}', {}, '')",
				ids.playerId,
				ids.playerName,
				ids.accountId
			));

			return accountInserted && playerInserted;
		}

		uint32_t legacyIPv4ForIpBan(const std::string &ipAddress, uint8_t ipFamily) {
			if (ipFamily != 4) {
				return 0;
			}

			std::error_code error;
			const auto address = asio::ip::make_address(ipAddress, error);
			return !error && address.is_v4() ? htonl(address.to_v4().to_uint()) : 0;
		}

		[[nodiscard]] int64_t unixNowSeconds() {
			return std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
		}

		bool insertIpBan(Database &db, const std::string &ipAddress, uint8_t ipFamily, const TestIds &ids, const std::string &reason) {
			const auto now = unixNowSeconds();
			const auto legacyIp = legacyIPv4ForIpBan(ipAddress, ipFamily);
			return db.executeQuery(fmt::format(
				"INSERT INTO `ip_bans` (`ip`, `ip_address`, `ip_family`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES ({}, {}, {}, {}, {}, {}, {})",
				legacyIp,
				db.escapeString(ipAddress),
				static_cast<uint16_t>(ipFamily),
				db.escapeString(reason),
				now,
				now + 3600,
				ids.playerId
			));
		}

		bool ipBanRowExists(Database &db, const std::string &ipAddress, uint8_t ipFamily) {
			const auto result = db.storeQuery(fmt::format(
				"SELECT 1 FROM `ip_bans` WHERE `ip` = {} AND `ip_family` = {} AND `ip_address` = {}",
				legacyIPv4ForIpBan(ipAddress, ipFamily),
				static_cast<uint16_t>(ipFamily),
				db.escapeString(ipAddress)
			));
			return result != nullptr;
		}
	} // namespace

	class IpBanIntegrationTest : public ::testing::Test { };

	TEST_F(IpBanIntegrationTest, DetectsIPv4BanByStoredAddressFamilyAndAddress) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestIds();
			const std::string ipAddress = "192.0.2.10";
			const std::string reason = "IPv4 ban regression test";

			ASSERT_TRUE(createBanOwner(db, ids));
			ASSERT_TRUE(insertIpBan(db, ipAddress, 4, ids, reason));
			ASSERT_TRUE(ipBanRowExists(db, ipAddress, 4));

			BanInfo banInfo;
			EXPECT_TRUE(IOBan::isIpBanned(ipAddress, banInfo));
			EXPECT_EQ(reason, banInfo.reason);
			EXPECT_EQ(ids.playerName, banInfo.bannedBy);
		})();
	}

	TEST_F(IpBanIntegrationTest, DetectsIPv6BanByStoredAddressFamilyAndAddress) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestIds();
			const std::string ipAddress = "2001:db8::10";
			const std::string reason = "IPv6 ban regression test";

			ASSERT_TRUE(createBanOwner(db, ids));
			ASSERT_TRUE(insertIpBan(db, ipAddress, 6, ids, reason));
			ASSERT_TRUE(ipBanRowExists(db, ipAddress, 6));

			BanInfo banInfo;
			EXPECT_TRUE(IOBan::isIpBanned(ipAddress, banInfo));
			EXPECT_EQ(reason, banInfo.reason);
			EXPECT_EQ(ids.playerName, banInfo.bannedBy);
		})();
	}
} // namespace it_ip_ban
