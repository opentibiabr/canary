/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2023 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#include "pch.hpp"

#include <boost/ut.hpp>

#include "account/account.hpp"
#include "utils/tools.hpp"
#include "injection_fixture.hpp"
#include "enums/account_coins.hpp"
#include "enums/account_type.hpp"
#include "enums/account_errors.hpp"
#include "enums/account_group_type.hpp"
#include "utils/tools.hpp"

using namespace boost::ut;
using namespace std;

template <typename T, typename U>
bool eqEnum(const T& lhs, const U& rhs) {
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

suite<"account"> accountTest = [] {
	InjectionFixture injectionFixture{};

	test("Account::Account default constructors") = [] {
		shared_ptr<Account> byId = make_shared<Account>(1);
		shared_ptr<Account> byDescriptor = make_shared<Account>("canary@test.com");

		expect(eq(byId->getID(), 1));
		expect(eq(byDescriptor->getID(), 0));

		expect(byId->getDescriptor().empty());
		expect(eq(byDescriptor->getDescriptor(), string{"canary@test.com"}));

		for (auto& account : { byId, byDescriptor }) {
			expect(eq(account->getPremiumRemainingDays(), 0));
			expect(eq(account->getPremiumLastDay(), 0));
			expect(eqEnum(account->getAccountType(), AccountType::ACCOUNT_TYPE_NORMAL));
		}
	};

	struct AccountLoadTestCase {
		string description;
		shared_ptr<Account> account;
		AccountErrors_t expectedError;
	};

	vector<AccountLoadTestCase> accountLoadTestCases{
		{"returns by id if exists", make_shared<Account>(1), AccountErrors_t::Ok},
		{"returns by descriptor if exists", make_shared<Account>("canary@test.com"), AccountErrors_t::Ok},
		{"returns error if id is not valid", make_shared<Account>(2), AccountErrors_t::LoadingAccount},
		{"returns error if descriptor is not valid", make_shared<Account>("not@valid.com"), AccountErrors_t::LoadingAccount}
	};

	for (auto& testCase : accountLoadTestCases) {
		test(testCase.description) = [&injectionFixture, &testCase] {
			auto [accountRepository] = injectionFixture.get<AccountRepository>();
			accountRepository.addAccount("canary@test.com", AccountInfo{1, 1, 1, AccountType::ACCOUNT_TYPE_GOD});
			expect(eqEnum(testCase.account->load(), testCase.expectedError)) << testCase.description;
		};
	}

	test("Account::reload returns error if not yet loaded") = [] {
		expect(eqEnum(Account { 1 }.reload(), AccountErrors_t::NotInitialized));
	};

	test("Account::reload reloads account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GOD));

		accountRepository.addAccount("canary2@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GAMEMASTER });

		expect(eqEnum(acc.reload(), AccountErrors_t::Ok));
		expect(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER));
	};

	test("Account::save returns error if not yet loaded") = [] {
		expect(eqEnum(Account { 1 }.save(), AccountErrors_t::NotInitialized));
	};

	test("Account::save returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.save(), AccountErrors_t::Storage));
	};

	test("Account::save saves account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.save(), AccountErrors_t::Ok));
	};

	test("Account::getCoins returns error if not yet loaded") = [&injectionFixture] {
		expect(eqEnum(std::get<1>(Account { 1 }.getCoins(CoinType::Normal)), AccountErrors_t::NotInitialized));
	};

	test("Account::getCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Storage));
	};

	test("Account::getCoins returns coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 100));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::getCoins returns coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::Normal, 33);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 33));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::getCoins returns coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);
		accountRepository.setCoins(1, CoinType::Tournament, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 100));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Tournament)), 100));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Tournament)), AccountErrors_t::Ok));
	};

	test("Account::addCoins returns error if not yet loaded") = [] {
		expect(eqEnum(Account { 1 }.addCoins(CoinType::Normal, 100), AccountErrors_t::NotInitialized));
	};

	test("Account::addCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.addCoins(CoinType::Normal, 100), AccountErrors_t::Storage));
	};

	test("Account::addCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.addCoins(CoinType::Tournament, 100), AccountErrors_t::Storage));
	};

	test("Account::addCoins adds coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.addCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 200));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::addCoins adds coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::Normal, 33);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.addCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 133));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::addCoins adds coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.setCoins(1, CoinType::Normal, 100);
		accountRepository.setCoins(1, CoinType::Tournament, 57);
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.addCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 200));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Tournament)), 57));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Tournament)), AccountErrors_t::Ok));

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(eq(coins, 100));
		expect(eqEnum(coinType, CoinType::Normal));
		expect(eqEnum(type, CoinTransactionType::Add));
		expect(eq(description, std::string { "ADD Coins" }));
	};

	test("Account::removeCoins returns error if not yet loaded") = [] {
		expect(eqEnum(Account { 1 }.removeCoins(CoinType::Normal, 100), AccountErrors_t::NotInitialized));
	};

	test("Account::removeCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::Storage));
	};

	test("Account::removeCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Tournament, 100), AccountErrors_t::Storage));
	};

	test("Account::removeCoins removes coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 0));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::removeCoins removes coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::Normal, 33);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 0));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
	};

	test("Account::removeCoins removes coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::Normal, 100);
		accountRepository.setCoins(1, CoinType::Tournament, 57);

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 0));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));
		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Tournament)), 57));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Tournament)), AccountErrors_t::Ok));

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(eq(coins, 100));
		expect(eqEnum(coinType, CoinType::Normal));
		expect(eqEnum(type, CoinTransactionType::Remove));
		expect(eq(description, std::string { "REMOVE Coins" }));
	};

	test("Account::removeCoins returns error if account doesn't have enough coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.setCoins(1, CoinType::Normal, 1);
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::RemoveCoins));

		accountRepository.setCoins(1, CoinType::Normal, 50);
		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::RemoveCoins));

		accountRepository.setCoins(1, CoinType::Normal, 100);
		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::Ok));

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(eq(coins, 100));
		expect(eqEnum(coinType,CoinType::Normal));
		expect(eqEnum(type, CoinTransactionType::Remove));
		expect(eq(description, std::string { "REMOVE Coins" }));

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 100), AccountErrors_t::RemoveCoins));

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);
	};

	test("Account::registerCoinTransaction does nothing if detail is empty") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		accountRepository.setCoins(1, CoinType::Normal, 1);

		expect(eqEnum(acc.addCoins(CoinType::Normal, 100, ""), AccountErrors_t::Ok));
		expect(eqEnum(acc.removeCoins(CoinType::Normal, 80, ""), AccountErrors_t::Ok));

		expect(eqEnum(std::get<0>(acc.getCoins(CoinType::Normal)), 21));
		expect(eqEnum(std::get<1>(acc.getCoins(CoinType::Normal)), AccountErrors_t::Ok));

		acc.registerCoinTransaction(CoinTransactionType::Add, CoinType::Normal, 100, "");
		acc.registerCoinTransaction(CoinTransactionType::Remove, CoinType::Normal, 100, "");

		expect(eq(accountRepository.coinsTransactions_.size(), 0));
	};

	test("Account::getPassword returns empty string if not yet loaded") = [] {
		expect(eqEnum(Account { 1 }.getPassword(), std::string { "" }));
	};

	test("Account::getPassword returns password") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eq(acc.getPassword(), std::string { "123456" }));
	};

	test("Account::getPassword returns logs error if it fails") = [&injectionFixture] {
		auto [logger, accountRepository] = injectionFixture.get<Logger, AccountRepository>();

		Account acc { 1 };
		accountRepository.failGetPassword = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eqEnum(acc.load(), AccountErrors_t::Ok));
		expect(eq(std::string{}, acc.getPassword()));
		expect(eq(std::string{"error"}, logger.logs[0].level));
		expect(eq(std::string{"Failed to get password for account[1]!"}, logger.logs[0].message));
	};

	test("Account::addPremiumDays sets premium remaining days") = [] {
		Account acc { 1 };
		acc.addPremiumDays(100);

		expect(eq(acc.getPremiumRemainingDays(), 100));
	};

	test("Account::addPremiumDays can increase premium") = [] {
		Account acc { 1 };

		acc.setPremiumDays(50);
		acc.addPremiumDays(50);

		expect(approx(acc.getPremiumLastDay(), getTimeNow() + (100 * 86400), 60 * 60 * 1000));
		expect(eq(acc.getPremiumRemainingDays(), 100));
	};

	test("Account::addPremiumDays can reduce premium") = [] {
		Account acc { 1 };

		acc.setPremiumDays(50);
		acc.addPremiumDays(-30);

		expect(approx(acc.getPremiumLastDay(), getTimeNow() - (20 * 86400), 60 * 60 * 1000));
		expect(eq(acc.getPremiumRemainingDays(), 20));
	};

	test("Account::setPremiumDays sets to 0 if day is negative") = [] {
		Account acc { 1 };
		acc.setPremiumDays(10);
		acc.setPremiumDays(-20);

		expect(eq(acc.getPremiumLastDay(), 0));
		expect(eq(acc.getPremiumLastDay(), 0));
	};

	test("Account::setAccountType sets account type") = [] {
		Account acc { 1 };
		expect(eqEnum(acc.setAccountType(AccountType::ACCOUNT_TYPE_GAMEMASTER), AccountErrors_t::Ok));
		expect(eqEnum(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER));
	};

	test("Account::updatePremiumTime sets premium remaining days to 0 if last day is in the past") = [] {
		Account acc { 1 };
		acc.setPremiumDays(-10);
		acc.updatePremiumTime();
		expect(eq(acc.getPremiumRemainingDays(), 0));
		expect(eq(acc.getPremiumLastDay(), 0));
	};

	test("Account::updatePremiumTime sets premium remaining days to 0 if last day is 0") = [] {
		Account acc { 1 };
		acc.setPremiumDays(0);
		acc.updatePremiumTime();
		expect(eq(acc.getPremiumLastDay(), 0));
		expect(eq(acc.getPremiumRemainingDays(), 0));
	};

	test("Account::updatePremiumTime sets premium remaining days to N if last day is in the future") = [] {
		Account acc { 1 };
		acc.setPremiumDays(8);
		acc.updatePremiumTime();

		auto remainingTime = (acc.getPremiumLastDay() - getTimeNow()) / 86400;
		expect(approx(remainingTime, 8, 0.1));
		expect(eq(acc.getPremiumRemainingDays(), 8));
	};

	test("Account::updatePremiumTime sets premium remaining days to 1 if last day is in less than a day from now") = [] {
		Account acc { 1 };
		acc.setPremiumDays(1);
		acc.updatePremiumTime();

		auto remainingTime = (acc.getPremiumLastDay() - getTimeNow()) / 86400;
		expect(approx(remainingTime, 1, 0.1));
		expect(eq(acc.getPremiumRemainingDays(), 1));
	};

	test("Account::getAccountPlayer returns error if not yet loaded") = [] {
		expect(eqEnum(std::get<1>(Account { 1 }.getAccountPlayers()), AccountErrors_t::NotInitialized));
	};

	test("Account::getAccountPlayer returns players") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"canary@test.com",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, {{ "Canary", 1 }, { "Canary2", 2 }} }
 		);

		expect(acc.load() == AccountErrors_t::Ok);
		auto [players, error] = acc.getAccountPlayers();

		expect(eqEnum(error, AccountErrors_t::Ok));
		expect(eq(players.size(), 2));
		expect(eq(players["Canary"], 1));
		expect(eq(players["Canary2"], 2));
	};

	test("Account::authenticate password using sha1") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"canary@test.com",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } } }
		);

		expect(acc.load() == AccountErrors_t::Ok);
		accountRepository.password_ = "7c4a8d09ca3762af61e59520943dc26494f8941b";
		expect(acc.authenticate("123456"));
	};

	test("Account::authenticate using sessions") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"session-key",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } }, false, getTimeNow() + 24 * 60 * 60 * 1000 }
		);

		expect(acc.load() == AccountErrors_t::Ok);
		expect(acc.authenticate());
	};

	test("Account::getCharacterByAccountIdAndName using an account with the given character.") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"session-key",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } }, false, getTimeNow() + 24 * 60 * 60 * 1000 }
		);

		const auto hasCharacter = accountRepository.getCharacterByAccountIdAndName(1, "Canary");

		expect(hasCharacter);
	};

	test("Account::getCharacterByAccountIdAndName using an account without the given character.") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"session-key",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } }, false, getTimeNow() + 24 * 60 * 60 * 1000 }
		);

		const auto hasCharacter = accountRepository.getCharacterByAccountIdAndName(1, "Invalid");

		expect(!hasCharacter);
	};
};
