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

suite<"account"> accountTest = [] {
	InjectionFixture injectionFixture {};
	test("Account::Account default constructors") = [] {
		Account byId { 1 }, byDescriptor { "canary@test.com" };

		expect(eq(byId.getID(), 1));
		expect(eq(byDescriptor.getID(), 0));

		expect(byId.getDescriptor().empty());
		expect(eq(byDescriptor.getDescriptor(), std::string { "canary@test.com" }));

		for (auto &account : { byId, byDescriptor }) {
			expect(
				eq(account.getPremiumRemainingDays(), 0) and
				eq(account.getPremiumLastDay(), 0) and
                eq(account.getAccountType(), AccountType::ACCOUNT_TYPE_NORMAL)
			);
		}
	};

	struct AccountLoadTestCase {
		std::string description;
		Account account;
		Errors expectedError;
	};

	std::vector<AccountLoadTestCase> accountLoadTestCases {
		{ "returns by id if exists", Account { 1 }, Errors::ERROR_NO },
		{ "returns by descriptor if exists", Account { "canary@test.com" }, Errors::ERROR_NO },
		{ "returns error if id is not valid", Account { 2 }, Errors::ERROR_LOADING_ACCOUNT },
		{ "returns error if descriptor is not valid", Account { "not@valid.com" }, Errors::ERROR_LOADING_ACCOUNT }
	};

	for (auto accountLoadTestCase : accountLoadTestCases) {
		test(accountLoadTestCase.description) = [&injectionFixture, &accountLoadTestCase] {
			auto [accountRepository] = injectionFixture.get<AccountRepository>();
			accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
			expect(eq(accountLoadTestCase.account.load(), accountLoadTestCase.expectedError)) << accountLoadTestCase.description;
		};
	}

	test("Account::reload returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.reload(), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::reload reloads account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GOD)
		);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GAMEMASTER });

		expect(
			eq(acc.reload(), Errors::ERROR_NO) and
			eq(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER)
		);
	};

	test("Account::save returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.save(), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::save returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eq(acc.load(), Errors::ERROR_NO and eq(acc.save(), Errors::ERROR_STORAGE)));
	};

	test("Account::save saves account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eq(acc.load(), Errors::ERROR_NO and eq(acc.save(), Errors::ERROR_NO)));
	};

	test("Account::getCoins returns error if not yet loaded") = [&injectionFixture] {
		expect(eq(std::get<1>(Account { 1 }.getCoins(CoinType::COIN)), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::getCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_STORAGE)
		);
	};

	test("Account::getCoins returns coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 100) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::getCoins returns coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::COIN, 33);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 33) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::getCoins returns coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);
		accountRepository.setCoins(1, CoinType::TOURNAMENT, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 100) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::TOURNAMENT)), 100) and
			eq(std::get<1>(acc.getCoins(CoinType::TOURNAMENT)), Errors::ERROR_NO)
		);
	};

	test("Account::addCoins returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.addCoins(CoinType::COIN, 100), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::addCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.addCoins(CoinType::COIN, 100), Errors::ERROR_STORAGE)
		);
	};

	test("Account::addCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.addCoins(CoinType::TOURNAMENT, 100), Errors::ERROR_STORAGE)
		);
	};

	test("Account::addCoins adds coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.addCoins(CoinType::COIN, 100), Errors::ERROR_NO)
			and eq(std::get<0>(acc.getCoins(CoinType::COIN)), 200) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::addCoins adds coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::COIN, 33);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.addCoins(CoinType::COIN, 100), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 133) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::addCoins adds coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
        accountRepository.setCoins(1, CoinType::COIN, 100);
        accountRepository.setCoins(1, CoinType::TOURNAMENT, 57);
        accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.addCoins(CoinType::COIN, 100), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 200) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::TOURNAMENT)), 57) and
			eq(std::get<1>(acc.getCoins(CoinType::TOURNAMENT)), Errors::ERROR_NO)
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(static_cast<uint8_t>(coinType), static_cast<uint8_t>(CoinType::COIN)) and
			eq(static_cast<uint8_t>(type), static_cast<uint8_t>(CoinTransactionType::ADD)) and
			eq(description, std::string { "ADD Coins" })
		);
	};

	test("Account::removeCoins returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.removeCoins(CoinType::COIN, 100), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::removeCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_STORAGE)
		);
	};

	test("Account::removeCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::TOURNAMENT, 100), Errors::ERROR_STORAGE)
		);
	};

	test("Account::removeCoins removes coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 0) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::removeCoins removes coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, CoinType::COIN, 33);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 0) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO)
		);
	};

	test("Account::removeCoins removes coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, CoinType::COIN, 100);
		accountRepository.setCoins(1, CoinType::TOURNAMENT, 57);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::COIN)), 0) and
			eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO) and
			eq(std::get<0>(acc.getCoins(CoinType::TOURNAMENT)), 57) and
			eq(std::get<1>(acc.getCoins(CoinType::TOURNAMENT)), Errors::ERROR_NO)
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(static_cast<uint8_t>(coinType), static_cast<uint8_t>(CoinType::COIN)) and
			eq(static_cast<uint8_t>(type), static_cast<uint8_t>(CoinTransactionType::REMOVE)) and
			eq(description, std::string { "REMOVE Coins" })
		);
	};

	test("Account::removeCoins returns error if account doesn't have enough coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.setCoins(1, CoinType::COIN, 1);
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(
			eq(acc.load(), Errors::ERROR_NO) and eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_REMOVE_COINS)
		);

		accountRepository.setCoins(1, CoinType::COIN, 50);
		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_REMOVE_COINS)
		);

		accountRepository.setCoins(1, CoinType::COIN, 100);
		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_NO)
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(static_cast<uint8_t>(coinType), static_cast<uint8_t>(CoinType::COIN)) and
			eq(static_cast<uint8_t>(type), static_cast<uint8_t>(CoinTransactionType::REMOVE)) and
			eq(description, std::string { "REMOVE Coins" })
		);

		expect(
			eq(acc.load(), Errors::ERROR_NO) and eq(acc.removeCoins(CoinType::COIN, 100), Errors::ERROR_REMOVE_COINS)
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);
	};

	test("Account::registerCoinTransaction does nothing if detail is empty") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(eq(acc.load(), Errors::ERROR_NO));
		accountRepository.setCoins(1, CoinType::COIN, 1);

		expect(eq(acc.addCoins(CoinType::COIN, 100, ""), Errors::ERROR_NO));
		expect(eq(acc.removeCoins(CoinType::COIN, 80, ""), Errors::ERROR_NO));

		expect(eq(std::get<0>(acc.getCoins(CoinType::COIN)), 21));
		expect(eq(std::get<1>(acc.getCoins(CoinType::COIN)), Errors::ERROR_NO));

		acc.registerCoinTransaction(CoinTransactionType::ADD, CoinType::COIN, 100, "");
		acc.registerCoinTransaction(CoinTransactionType::REMOVE, CoinType::COIN, 100, "");

		expect(eq(accountRepository.coinsTransactions_.size(), 0));
	};

	test("Account::getPassword returns empty string if not yet loaded") = [] {
		expect(eq(Account { 1 }.getPassword(), std::string { "" }));
	};

	test("Account::getPassword returns password") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(acc.getPassword(), std::string { "123456" })
		);
	};

	test("Account::getPassword returns logs error if it fails") = [&injectionFixture] {
		auto [logger, accountRepository] = injectionFixture.get<Logger, AccountRepository>();

		Account acc { 1 };
		accountRepository.failGetPassword = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), Errors::ERROR_NO) and
			eq(std::string{}, acc.getPassword()) and
			eq(std::string{"error"}, logger.logs[0].level) and
			eq(std::string{"Failed to get password for account[1]!"}, logger.logs[0].message)
		);
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

		expect(
			approx(acc.getPremiumLastDay(), getTimeNow() + (100 * 86400), 60 * 60 * 1000) and
			eq(acc.getPremiumRemainingDays(), 100)
		);
	};

	test("Account::addPremiumDays can reduce premium") = [] {
		Account acc { 1 };

		acc.setPremiumDays(50);
		acc.addPremiumDays(-30);

		expect(
			approx(acc.getPremiumLastDay(), getTimeNow() - (20 * 86400), 60 * 60 * 1000) and
			eq(acc.getPremiumRemainingDays(), 20)
		);
	};

	test("Account::setPremiumDays sets to 0 if day is negative") = [] {
		Account acc { 1 };
		acc.setPremiumDays(10);
		acc.setPremiumDays(-20);

		expect(
			eq(acc.getPremiumLastDay(), 0) and
			eq(acc.getPremiumLastDay(), 0)
		);
	};

	test("Account::setAccountType sets account type") = [] {
		Account acc { 1 };
		expect(
			eq(acc.setAccountType(AccountType::ACCOUNT_TYPE_GAMEMASTER), Errors::ERROR_NO) and
			eq(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER)
		);
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
		expect(eq(std::get<1>(Account { 1 }.getAccountPlayers()), Errors::ERROR_NOT_INITIALIZED));
	};

	test("Account::getAccountPlayer returns players") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"canary@test.com",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, {{ "Canary", 1 }, { "Canary2", 2 }} }
 		);

		expect(acc.load() == Errors::ERROR_NO);
		auto [players, error] = acc.getAccountPlayers();

		expect(
			eq(error, Errors::ERROR_NO) and
			eq(players.size(), 2) and
			eq(players["Canary"], 1) and
			eq(players["Canary2"], 2)
		);
	};

	test("Account::authenticate password using sha1") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"canary@test.com",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, { { "Canary", 1 }, { "Canary2", 2 } } }
		);

		expect(acc.load() == Errors::ERROR_NO);
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

		expect(acc.load() == Errors::ERROR_NO);
		expect(acc.authenticate());
	};
};
