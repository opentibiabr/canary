/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <gtest/gtest.h>

#include "account/account.hpp"
#include "utils/tools.hpp"
#include "injection_fixture.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_type.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_group_type.hpp"

using namespace std;
using enum CoinType;

namespace {
	inline void expectSetCoins(
		tests::InMemoryAccountRepository &repo,
		uint32_t id,
		CoinType coinType,
		uint32_t amount
	) {
		const auto result = repo.setCoins(id, coinType, amount);
		if (repo.failAddCoins) {
			EXPECT_FALSE(result);
		} else {
			EXPECT_TRUE(result);
		}
	}
}

template <typename T, typename U>
bool eqEnum(const T &lhs, const U &rhs) {
	if constexpr (std::is_enum_v<T> && std::is_enum_v<U>) {
		return enumToValue(lhs) == enumToValue(rhs);
	} else if constexpr (std::is_enum_v<T>) {
		return enumToValue(lhs) == rhs;
	} else if constexpr (std::is_enum_v<U>) {
		return lhs == enumToValue(rhs);
	} else {
		return lhs == rhs;
	}
}

class AccountTest : public ::testing::Test {
protected:
	static void SetUpTestSuite() {
		InMemoryLogger::install(injector);
		tests::InMemoryAccountRepository::install(injector);
		DI::setTestContainer(&injector);
		accountRepository = &dynamic_cast<tests::InMemoryAccountRepository &>(DI::get<AccountRepository>());
		logger = &dynamic_cast<InMemoryLogger &>(DI::get<Logger>());
	}

	void SetUp() override {
		ClearState();
	}

	void TearDown() override {
		ClearState();
	}

	static tests::InMemoryAccountRepository &repository() {
		return *accountRepository;
	}

	static InMemoryLogger &testLogger() {
		return *logger;
	}

private:
	static void ClearState() {
		if (accountRepository != nullptr) {
			accountRepository->reset();
		}
		if (logger != nullptr) {
			logger->logs.clear();
		}
	}

	inline static di::extension::injector<> injector {};
	inline static tests::InMemoryAccountRepository* accountRepository { nullptr };
	inline static InMemoryLogger* logger { nullptr };
};

TEST_F(AccountTest, DefaultConstructors) {
	auto byId = make_shared<Account>(1);
	auto byDescriptor = make_shared<Account>("canary@test.com");

	EXPECT_EQ(1, byId->getID());
	EXPECT_EQ(0, byDescriptor->getID());

	EXPECT_TRUE(byId->getDescriptor().empty());
	EXPECT_EQ(string { "canary@test.com" }, byDescriptor->getDescriptor());

	for (const auto &account : { byId, byDescriptor }) {
		EXPECT_EQ(0, account->getPremiumRemainingDays());
		EXPECT_EQ(0, account->getPremiumLastDay());
		EXPECT_TRUE(eqEnum(account->getAccountType(), AccountType::ACCOUNT_TYPE_NORMAL));
	}
}

TEST_F(AccountTest, LoadReturnsByIdIfExists) {
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	auto account = make_shared<Account>(1);
	EXPECT_TRUE(eqEnum(account->load(), AccountErrors_t::Ok));
}

TEST_F(AccountTest, LoadReturnsByDescriptorIfExists) {
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	auto account = make_shared<Account>("canary@test.com");
	EXPECT_TRUE(eqEnum(account->load(), AccountErrors_t::Ok));
}

TEST_F(AccountTest, LoadReturnsErrorIfIdInvalid) {
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	auto account = make_shared<Account>(2);
	EXPECT_TRUE(eqEnum(account->load(), AccountErrors_t::LoadingAccount));
}

TEST_F(AccountTest, LoadReturnsErrorIfDescriptorInvalid) {
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	auto account = make_shared<Account>("not@valid.com");
	EXPECT_TRUE(eqEnum(account->load(), AccountErrors_t::LoadingAccount));
}

TEST_F(AccountTest, ReloadReturnsErrorIfNotYetLoaded) {
	EXPECT_TRUE(eqEnum(Account { 1 }.reload(), AccountErrors_t::NotInitialized));
}

TEST_F(AccountTest, ReloadReloadsAccountInfo) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GOD));

	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GAMEMASTER });

	EXPECT_TRUE(eqEnum(acc.reload(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER));
}

TEST_F(AccountTest, SaveReturnsErrorIfNotYetLoaded) {
	EXPECT_TRUE(eqEnum(Account { 1 }.save(), AccountErrors_t::NotInitialized));
}

TEST_F(AccountTest, SaveReturnsErrorIfRepositoryFails) {
	Account acc { 1 };
	repository().failSave = true;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.save(), AccountErrors_t::Storage));
}

TEST_F(AccountTest, SavePersistsAccountInfo) {
	Account acc { 1 };
	repository().failSave = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.save(), AccountErrors_t::Ok));
}

TEST_F(AccountTest, GetCoinsReturnsErrorIfNotYetLoaded) {
	auto [coins, error] = Account { 1 }.getCoins(Normal);
	(void)coins;
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::NotInitialized));
}

TEST_F(AccountTest, GetCoinsReturnsErrorIfRepositoryFails) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(0, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Storage));
}

TEST_F(AccountTest, GetCoinsReturnsCoins) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(100, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, GetCoinsReturnsCoinsForSpecifiedAccountOnly) {
	Account acc { 2 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	repository().addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 2, Normal, 33);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(33, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, GetCoinsReturnsCoinsForSpecifiedCoinTypeOnly) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);
	expectSetCoins(repository(), 1, Tournament, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));

	auto [normalCoins, normalError] = acc.getCoins(Normal);
	EXPECT_EQ(100, normalCoins);
	EXPECT_TRUE(eqEnum(normalError, AccountErrors_t::Ok));

	auto [tournamentCoins, tournamentError] = acc.getCoins(Tournament);
	EXPECT_EQ(100, tournamentCoins);
	EXPECT_TRUE(eqEnum(tournamentError, AccountErrors_t::Ok));
}

TEST_F(AccountTest, AddCoinsReturnsErrorIfNotYetLoaded) {
	EXPECT_TRUE(eqEnum(Account { 1 }.addCoins(Normal, 100), AccountErrors_t::NotInitialized));
}

TEST_F(AccountTest, AddCoinsReturnsErrorIfRepositoryFails) {
	Account acc { 1 };
	repository().failAddCoins = true;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.addCoins(Normal, 100), AccountErrors_t::Storage));
}

TEST_F(AccountTest, AddCoinsReturnsErrorIfGetCoinsFails) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.addCoins(Tournament, 100), AccountErrors_t::Storage));
}

TEST_F(AccountTest, AddCoinsAddsCoins) {
	Account acc { 1 };
	repository().failAddCoins = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.addCoins(Normal, 100), AccountErrors_t::Ok));

	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(200, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, AddCoinsAddsCoinsForSpecifiedAccountOnly) {
	Account acc { 2 };
	repository().failAddCoins = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	repository().addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 2, Normal, 33);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.addCoins(Normal, 100), AccountErrors_t::Ok));

	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(133, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, AddCoinsAddsCoinsForSpecifiedCoinTypeOnly) {
	Account acc { 1 };
	repository().failAddCoins = false;
	expectSetCoins(repository(), 1, Normal, 100);
	expectSetCoins(repository(), 1, Tournament, 57);
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.addCoins(Normal, 100), AccountErrors_t::Ok));

	auto [normalCoins, normalError] = acc.getCoins(Normal);
	EXPECT_EQ(200, normalCoins);
	EXPECT_TRUE(eqEnum(normalError, AccountErrors_t::Ok));

	auto [tournamentCoins, tournamentError] = acc.getCoins(Tournament);
	EXPECT_EQ(57, tournamentCoins);
	EXPECT_TRUE(eqEnum(tournamentError, AccountErrors_t::Ok));

	ASSERT_EQ(1u, repository().coinsTransactions_.size());
	ASSERT_EQ(1u, repository().coinsTransactions_[1].size());

	const auto &[type, coins, coinType, description] = repository().coinsTransactions_[1][0];
	EXPECT_EQ(100u, coins);
	EXPECT_TRUE(eqEnum(coinType, Normal));
	EXPECT_TRUE(eqEnum(type, CoinTransactionType::Add));
	EXPECT_EQ(string { "ADD Coins" }, description);
}

TEST_F(AccountTest, RemoveCoinsReturnsErrorIfNotYetLoaded) {
	EXPECT_TRUE(eqEnum(Account { 1 }.removeCoins(Normal, 100), AccountErrors_t::NotInitialized));
}

TEST_F(AccountTest, RemoveCoinsReturnsErrorIfRepositoryFails) {
	Account acc { 1 };
	repository().failAddCoins = true;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::Storage));
}

TEST_F(AccountTest, RemoveCoinsReturnsErrorIfGetCoinsFails) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Tournament, 100), AccountErrors_t::Storage));
}

TEST_F(AccountTest, RemoveCoinsRemovesCoins) {
	Account acc { 1 };
	repository().failAddCoins = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::Ok));

	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(0, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, RemoveCoinsRemovesCoinsForSpecifiedAccountOnly) {
	Account acc { 1 };
	repository().failAddCoins = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);

	repository().addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 2, Normal, 33);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::Ok));

	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(0, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
}

TEST_F(AccountTest, RemoveCoinsRemovesCoinsForSpecifiedCoinTypeOnly) {
	Account acc { 1 };
	repository().failAddCoins = false;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	expectSetCoins(repository(), 1, Normal, 100);
	expectSetCoins(repository(), 1, Tournament, 57);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::Ok));

	auto [normalCoins, normalError] = acc.getCoins(Normal);
	EXPECT_EQ(0, normalCoins);
	EXPECT_TRUE(eqEnum(normalError, AccountErrors_t::Ok));

	auto [tournamentCoins, tournamentError] = acc.getCoins(Tournament);
	EXPECT_EQ(57, tournamentCoins);
	EXPECT_TRUE(eqEnum(tournamentError, AccountErrors_t::Ok));

	ASSERT_EQ(1u, repository().coinsTransactions_.size());
	ASSERT_EQ(1u, repository().coinsTransactions_[1].size());

	const auto &[type, coins, coinType, description] = repository().coinsTransactions_[1][0];
	EXPECT_EQ(100u, coins);
	EXPECT_TRUE(eqEnum(coinType, Normal));
	EXPECT_TRUE(eqEnum(type, CoinTransactionType::Remove));
	EXPECT_EQ(string { "REMOVE Coins" }, description);
}

TEST_F(AccountTest, RemoveCoinsReturnsErrorIfNotEnoughCoins) {
	Account acc { 1 };
	repository().failAddCoins = false;
	expectSetCoins(repository(), 1, Normal, 1);
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::RemoveCoins));

	expectSetCoins(repository(), 1, Normal, 50);
	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::RemoveCoins));

	expectSetCoins(repository(), 1, Normal, 100);
	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::Ok));

	ASSERT_EQ(1u, repository().coinsTransactions_.size());
	ASSERT_EQ(1u, repository().coinsTransactions_[1].size());

	const auto &[type, coins, coinType, description] = repository().coinsTransactions_[1][0];
	EXPECT_EQ(100u, coins);
	EXPECT_TRUE(eqEnum(coinType, Normal));
	EXPECT_TRUE(eqEnum(type, CoinTransactionType::Remove));
	EXPECT_EQ(string { "REMOVE Coins" }, description);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 100), AccountErrors_t::RemoveCoins));

	ASSERT_EQ(1u, repository().coinsTransactions_.size());
	ASSERT_EQ(1u, repository().coinsTransactions_[1].size());
}

TEST_F(AccountTest, RegisterCoinTransactionDoesNothingIfDetailIsEmpty) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	expectSetCoins(repository(), 1, Normal, 1);

	EXPECT_TRUE(eqEnum(acc.addCoins(Normal, 100, string {}), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.removeCoins(Normal, 80, string {}), AccountErrors_t::Ok));

	auto [coins, error] = acc.getCoins(Normal);
	EXPECT_EQ(21, coins);
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));

	acc.registerCoinTransaction(CoinTransactionType::Add, Normal, 100, "");
	acc.registerCoinTransaction(CoinTransactionType::Remove, Normal, 100, "");

	EXPECT_EQ(0u, repository().coinsTransactions_.size());
}

TEST_F(AccountTest, GetPasswordReturnsEmptyStringIfNotLoaded) {
	EXPECT_EQ(string {}, Account { 1 }.getPassword());
}

TEST_F(AccountTest, GetPasswordReturnsPassword) {
	Account acc { 1 };
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_EQ(string { "123456" }, acc.getPassword());
}

TEST_F(AccountTest, GetPasswordLogsErrorOnFailure) {
	Account acc { 1 };
	repository().failGetPassword = true;
	repository().addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_EQ(string {}, acc.getPassword());
	ASSERT_FALSE(testLogger().logs.empty());
	EXPECT_EQ(string { "error" }, testLogger().logs[0].level);
	EXPECT_EQ(string { "Failed to get password for account[1]!" }, testLogger().logs[0].message);
}

TEST_F(AccountTest, AddPremiumDaysSetsPremiumRemainingDays) {
	Account acc { 1 };
	acc.addPremiumDays(100);

	EXPECT_EQ(100, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, AddPremiumDaysCanIncreasePremium) {
	Account acc { 1 };

	acc.setPremiumDays(50);
	acc.addPremiumDays(50);

	EXPECT_NEAR(static_cast<double>(acc.getPremiumLastDay()), static_cast<double>(getTimeNow() + (100 * 86400)), 60.0 * 60.0 * 1000.0);
	EXPECT_EQ(100, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, AddPremiumDaysCanReducePremium) {
	Account acc { 1 };

	acc.setPremiumDays(50);
	acc.addPremiumDays(-30);

	EXPECT_NEAR(static_cast<double>(acc.getPremiumLastDay()), static_cast<double>(getTimeNow() - (20 * 86400)), 60.0 * 60.0 * 1000.0);
	EXPECT_EQ(20, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, SetPremiumDaysSetsToZeroIfNegative) {
	Account acc { 1 };
	acc.setPremiumDays(10);
	acc.setPremiumDays(-20);

	EXPECT_EQ(0, acc.getPremiumLastDay());
	EXPECT_EQ(0, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, SetAccountTypeSetsAccountType) {
	Account acc { 1 };
	EXPECT_TRUE(eqEnum(acc.setAccountType(AccountType::ACCOUNT_TYPE_GAMEMASTER), AccountErrors_t::Ok));
	EXPECT_TRUE(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER));
}

TEST_F(AccountTest, UpdatePremiumTimeSetsRemainingDaysToZeroWhenExpired) {
	Account acc { 1 };
	acc.setPremiumDays(-10);
	acc.updatePremiumTime();
	EXPECT_EQ(0, acc.getPremiumRemainingDays());
	EXPECT_EQ(0, acc.getPremiumLastDay());
}

TEST_F(AccountTest, UpdatePremiumTimeSetsRemainingDaysToZeroWhenLastDayIsZero) {
	Account acc { 1 };
	acc.setPremiumDays(0);
	acc.updatePremiumTime();
	EXPECT_EQ(0, acc.getPremiumLastDay());
	EXPECT_EQ(0, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, UpdatePremiumTimeKeepsFutureRemainingDays) {
	Account acc { 1 };
	acc.setPremiumDays(8);
	acc.updatePremiumTime();

	auto remainingTime = static_cast<double>(acc.getPremiumLastDay() - getTimeNow()) / 86400.0;
	EXPECT_NEAR(8.0, remainingTime, 0.1);
	EXPECT_EQ(8, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, UpdatePremiumTimeKeepsNearFutureRemainingDays) {
	Account acc { 1 };
	acc.setPremiumDays(1);
	acc.updatePremiumTime();

	auto remainingTime = static_cast<double>(acc.getPremiumLastDay() - getTimeNow()) / 86400.0;
	EXPECT_NEAR(1.0, remainingTime, 0.1);
	EXPECT_EQ(1, acc.getPremiumRemainingDays());
}

TEST_F(AccountTest, GetAccountPlayersReturnsErrorIfNotLoaded) {
	auto [players, error] = Account { 1 }.getAccountPlayers();
	EXPECT_TRUE(eqEnum(error, AccountErrors_t::NotInitialized));
	EXPECT_TRUE(players.empty());
}

TEST_F(AccountTest, GetAccountPlayersReturnsPlayers) {
	Account acc { 1 };
	repository().addAccount(
		"canary@test.com",
		AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } } }
	);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	auto [players, error] = acc.getAccountPlayers();

	EXPECT_TRUE(eqEnum(error, AccountErrors_t::Ok));
	ASSERT_EQ(2u, players.size());
	EXPECT_EQ(1, players["Canary"]);
	EXPECT_EQ(2, players["Canary2"]);
}

TEST_F(AccountTest, AuthenticatePasswordUsingSha1) {
	Account acc { 1 };
	repository().addAccount(
		"canary@test.com",
		AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } } }
	);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	repository().password_ = "7c4a8d09ca3762af61e59520943dc26494f8941b";
	EXPECT_TRUE(acc.authenticate("123456"));
}

TEST_F(AccountTest, AuthenticateUsingSessions) {
	Account acc { 1 };
	repository().addAccount(
		"session-key",
		AccountInfo {
			1,
			1,
			1,
			AccountType::ACCOUNT_TYPE_GOD,
			{ { "Canary", 1 }, { "Canary2", 2 } },
			false,
			getTimeNow() + 24 * 60 * 60 * 1000 }
	);

	EXPECT_TRUE(eqEnum(acc.load(), AccountErrors_t::Ok));
	EXPECT_TRUE(acc.authenticate());
}

TEST_F(AccountTest, GetCharacterByAccountIdAndNameFindsCharacter) {
	repository().addAccount(
		"session-key",
		AccountInfo {
			1,
			1,
			1,
			AccountType::ACCOUNT_TYPE_GOD,
			{ { "Canary", 1 }, { "Canary2", 2 } },
			false,
			getTimeNow() + 24 * 60 * 60 * 1000 }
	);

	EXPECT_TRUE(repository().getCharacterByAccountIdAndName(1, "Canary"));
}

TEST_F(AccountTest, GetCharacterByAccountIdAndNameReturnsFalseWhenMissing) {
	repository().addAccount(
		"session-key",
		AccountInfo {
			1,
			1,
			1,
			AccountType::ACCOUNT_TYPE_GOD,
			{ { "Canary", 1 }, { "Canary2", 2 } },
			false,
			getTimeNow() + 24 * 60 * 60 * 1000 }
	);

	EXPECT_FALSE(repository().getCharacterByAccountIdAndName(1, "Invalid"));
}
