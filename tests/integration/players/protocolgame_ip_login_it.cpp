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
#include <ctime>
#include <string>
#include <utility>

#include <asio/ip/address.hpp>
#include <fmt/format.h>
#include <gtest/gtest.h>

#include "creatures/players/management/ban.hpp"
#include "database/database.hpp"
#include "io/iologindata.hpp"
#include "test_env.hpp"
#include "utils/tools.hpp"

namespace it_protocolgame_ip_login {
	namespace {
		struct TestLoginIds {
			uint32_t accountId;
			uint32_t playerId;
			std::string accountName;
			std::string email;
			std::string playerName;
		};

		enum class LoginGateResult : uint8_t { Banned,
			                                   Authenticated,
			                                   AuthFailed };

		TestLoginIds getTestLoginIds() {
			static std::atomic<uint32_t> counter { 1 };
			static const uint32_t base = (static_cast<uint32_t>(std::chrono::high_resolution_clock::now().time_since_epoch().count()) & 0x3FFFFFFF) + 20000000;
			const auto idx = counter.fetch_add(1);
			const auto accountId = base + idx;
			const auto playerId = accountId + 100000;
			return {
				accountId,
				playerId,
				fmt::format("login_acc_{}", accountId),
				fmt::format("login_{}@test.local", accountId),
				fmt::format("login_player_{}", playerId)
			};
		}

		uint32_t legacyIPv4ForProtocol(const std::string &ipAddress) {
			const auto address = asio::ip::make_address(ipAddress);
			return address.is_v4() ? htonl(address.to_v4().to_uint()) : 0;
		}

		bool createLoginAccount(Database &db, const TestLoginIds &ids, const std::string &password) {
			const auto accountInserted = db.executeQuery(fmt::format(
				"INSERT INTO `accounts` (`id`, `name`, `password`, `email`) VALUES ({}, {}, {}, {})",
				ids.accountId,
				db.escapeString(ids.accountName),
				db.escapeString(transformToSHA1(password)),
				db.escapeString(ids.email)
			));
			const auto playerInserted = db.executeQuery(fmt::format(
				"INSERT INTO `players` (`id`, `name`, `account_id`, `conditions`) VALUES ({}, {}, {}, '')",
				ids.playerId,
				db.escapeString(ids.playerName),
				ids.accountId
			));

			return accountInserted && playerInserted;
		}

		bool insertIpBan(Database &db, const std::string &ipAddress, uint8_t ipFamily, const TestLoginIds &ids) {
			const auto now = static_cast<int64_t>(std::time(nullptr));
			const auto legacyIp = ipFamily == 4 ? legacyIPv4ForProtocol(ipAddress) : 0;
			return db.executeQuery(fmt::format(
				"INSERT INTO `ip_bans` (`ip`, `ip_address`, `ip_family`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES ({}, {}, {}, 'ProtocolGame login ban regression', {}, {}, {})",
				legacyIp,
				db.escapeString(ipAddress),
				static_cast<uint16_t>(ipFamily),
				now,
				now + 3600,
				ids.playerId
			));
		}

		LoginGateResult runProtocolGameLoginGateWithLegacyIPv4(const std::string &ipAddress, uint32_t legacyIPv4, const std::string &accountDescriptor, const std::string &password, std::string characterName, uint32_t &accountId) {
			BanInfo banInfo;
			if (IOBan::isIpBanned(ipAddress, banInfo)) {
				return LoginGateResult::Banned;
			}

			if (!IOLoginData::gameWorldAuthentication(accountDescriptor, password, characterName, accountId, false, legacyIPv4)) {
				return LoginGateResult::AuthFailed;
			}

			return LoginGateResult::Authenticated;
		}

		LoginGateResult runProtocolGameLoginGate(const std::string &ipAddress, const std::string &accountDescriptor, const std::string &password, std::string characterName, uint32_t &accountId) {
			return runProtocolGameLoginGateWithLegacyIPv4(ipAddress, legacyIPv4ForProtocol(ipAddress), accountDescriptor, password, std::move(characterName), accountId);
		}
	} // namespace

	class ProtocolGameIPLoginIntegrationTest : public ::testing::Test { };

	TEST_F(ProtocolGameIPLoginIntegrationTest, BlocksIPv4BanBeforeAuthentication) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestLoginIds();
			const std::string password = "test-password";
			const std::string ipAddress = "192.0.2.55";
			uint32_t accountId = 0;

			ASSERT_TRUE(createLoginAccount(db, ids, password));
			ASSERT_TRUE(insertIpBan(db, ipAddress, 4, ids));

			EXPECT_EQ(LoginGateResult::Banned, runProtocolGameLoginGate(ipAddress, ids.email, password, ids.playerName, accountId));
			EXPECT_EQ(0u, accountId);
		})();
	}

	TEST_F(ProtocolGameIPLoginIntegrationTest, AuthenticatesIPv4AfterBanCheckWhenNotBanned) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestLoginIds();
			const std::string password = "test-password";
			uint32_t accountId = 0;

			ASSERT_TRUE(createLoginAccount(db, ids, password));

			EXPECT_EQ(LoginGateResult::Authenticated, runProtocolGameLoginGate("192.0.2.56", ids.email, password, ids.playerName, accountId));
			EXPECT_EQ(ids.accountId, accountId);
		})();
	}

	TEST_F(ProtocolGameIPLoginIntegrationTest, BlocksIPv6BanBeforeAuthentication) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestLoginIds();
			const std::string password = "test-password";
			const std::string ipAddress = "2001:db8::55";
			uint32_t accountId = 0;

			ASSERT_TRUE(createLoginAccount(db, ids, password));
			ASSERT_TRUE(insertIpBan(db, ipAddress, 6, ids));

			EXPECT_EQ(LoginGateResult::Banned, runProtocolGameLoginGate(ipAddress, ids.email, password, ids.playerName, accountId));
			EXPECT_EQ(0u, accountId);
		})();
	}

	TEST_F(ProtocolGameIPLoginIntegrationTest, AuthenticatesIPv6AfterBanCheckWithLegacyIPv4Zero) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestLoginIds();
			const std::string password = "test-password";
			uint32_t accountId = 0;

			ASSERT_TRUE(createLoginAccount(db, ids, password));
			EXPECT_EQ(0u, legacyIPv4ForProtocol("2001:db8::56"));

			EXPECT_EQ(LoginGateResult::Authenticated, runProtocolGameLoginGate("2001:db8::56", ids.email, password, ids.playerName, accountId));
			EXPECT_EQ(ids.accountId, accountId);
		})();
	}

	TEST_F(ProtocolGameIPLoginIntegrationTest, AuthenticatesDualStackPathWithStringBanCheckAndLegacyIPv4AuthValue) {
		auto &db = g_database();
		databaseTest(db, [&db] {
			const auto ids = getTestLoginIds();
			const std::string password = "test-password";
			uint32_t accountId = 0;
			const auto legacyIPv4 = legacyIPv4ForProtocol("192.0.2.57");

			ASSERT_TRUE(createLoginAccount(db, ids, password));
			ASSERT_NE(0u, legacyIPv4);

			EXPECT_EQ(LoginGateResult::Authenticated, runProtocolGameLoginGateWithLegacyIPv4("2001:db8::57", legacyIPv4, ids.email, password, ids.playerName, accountId));
			EXPECT_EQ(ids.accountId, accountId);
		})();
	}
} // namespace it_protocolgame_ip_login
