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
		AccountErrors_t expectedError;
	};

	std::vector<AccountLoadTestCase> accountLoadTestCases {
		{ "returns by id if exists", Account { 1 }, AccountErrors_t::Ok },
		{ "returns by descriptor if exists", Account { "canary@test.com" }, AccountErrors_t::Ok },
		{ "returns error if id is not valid", Account { 2 }, AccountErrors_t::LoadingAccount },
		{ "returns error if descriptor is not valid", Account { "not@valid.com" }, AccountErrors_t::LoadingAccount }
	};

	for (auto accountLoadTestCase : accountLoadTestCases) {
		test(accountLoadTestCase.description) = [&injectionFixture, &accountLoadTestCase] {
			auto [accountRepository] = injectionFixture.get<AccountRepository>();
			accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
			expect(eq(accountLoadTestCase.account.load(), enumToValue(accountLoadTestCase.expectedError))) << accountLoadTestCase.description;
		};
	}

	test("Account::reload returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.reload(), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::reload reloads account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GOD)
		);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GAMEMASTER });

		expect(
			eq(acc.reload(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.getAccountType(), AccountType::ACCOUNT_TYPE_GAMEMASTER)
		);
	};

	test("Account::save returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.save(), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::save returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eq(acc.load(), enumToValue(AccountErrors_t::Ok) and eq(acc.save(), enumToValue(AccountErrors_t::Storage))));
	};

	test("Account::save saves account info") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failSave = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(eq(acc.load(), enumToValue(AccountErrors_t::Ok) and eq(acc.save(), enumToValue(AccountErrors_t::Ok))));
	};

	test("Account::getCoins returns error if not yet loaded") = [&injectionFixture] {
		expect(eq(std::get<1>(Account { 1 }.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::getCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Storage))
		);
	};

	test("Account::getCoins returns coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 100) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::getCoins returns coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, enumToValue(CoinType::Normal), 33);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 33) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::getCoins returns coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);
		accountRepository.setCoins(1, enumToValue(CoinType::Tournament), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 100) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Tournament))), 100) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Tournament))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::addCoins returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.addCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::addCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.addCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Storage))
		);
	};

	test("Account::addCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.addCoins(enumToValue(CoinType::Tournament), 100), enumToValue(AccountErrors_t::Storage))
		);
	};

	test("Account::addCoins adds coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.addCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok))
			and eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 200) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::addCoins adds coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 2 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, enumToValue(CoinType::Normal), 33);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.addCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 133) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::addCoins adds coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
        accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);
        accountRepository.setCoins(1, enumToValue(CoinType::Tournament), 57);
        accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.addCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 200) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Tournament))), 57) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Tournament))), enumToValue(AccountErrors_t::Ok))
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(coinType, enumToValue(CoinType::Normal)) and
			eq(type, enumToValue(CoinTransactionType::Add)) and
			eq(description, std::string { "ADD Coins" })
		);
	};

	test("Account::removeCoins returns error if not yet loaded") = [] {
		expect(eq(Account { 1 }.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::removeCoins returns error if it fails") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Storage))
		);
	};

	test("Account::removeCoins returns error if get coins fail") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Tournament), 100), enumToValue(AccountErrors_t::Storage))
		);
	};

	test("Account::removeCoins removes coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 0) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::removeCoins removes coins for specified account only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);

		accountRepository.addAccount("canary2@test.com", AccountInfo { 2, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(2, enumToValue(CoinType::Normal), 33);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 0) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok))
		);
	};

	test("Account::removeCoins removes coins for specified coin type only") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);
		accountRepository.setCoins(1, enumToValue(CoinType::Tournament), 57);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 0) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok)) and
			eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Tournament))), 57) and
			eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Tournament))), enumToValue(AccountErrors_t::Ok))
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(coinType, enumToValue(CoinType::Normal)) and
			eq(type, enumToValue(CoinTransactionType::Remove)) and
			eq(description, std::string { "REMOVE Coins" })
		);
	};

	test("Account::removeCoins returns error if account doesn't have enough coins") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.failAddCoins = false;
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 1);
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::RemoveCoins))
		);

		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 50);
		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::RemoveCoins))
		);

		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 100);
		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::Ok))
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);

		auto [type, coins, coinType, description] = accountRepository.coinsTransactions_[1][0];
		expect(
			eq(coins, 100) and
			eq(coinType,enumToValue(CoinType::Normal)) and
			eq(type, enumToValue(CoinTransactionType::Remove)) and
			eq(description, std::string { "REMOVE Coins" })
		);

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and eq(acc.removeCoins(enumToValue(CoinType::Normal), 100), enumToValue(AccountErrors_t::RemoveCoins))
		);

		expect(eq(accountRepository.coinsTransactions_.size(), 1) >> fatal);
		expect(eq(accountRepository.coinsTransactions_[1].size(), 1) >> fatal);
	};

	test("Account::registerCoinTransaction does nothing if detail is empty") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });
		expect(eq(acc.load(), enumToValue(AccountErrors_t::Ok)));
		accountRepository.setCoins(1, enumToValue(CoinType::Normal), 1);

		expect(eq(acc.addCoins(enumToValue(CoinType::Normal), 100, ""), enumToValue(AccountErrors_t::Ok)));
		expect(eq(acc.removeCoins(enumToValue(CoinType::Normal), 80, ""), enumToValue(AccountErrors_t::Ok)));

		expect(eq(std::get<0>(acc.getCoins(enumToValue(CoinType::Normal))), 21));
		expect(eq(std::get<1>(acc.getCoins(enumToValue(CoinType::Normal))), enumToValue(AccountErrors_t::Ok)));

		acc.registerCoinTransaction(enumToValue(CoinTransactionType::Add), enumToValue(CoinType::Normal), 100, "");
		acc.registerCoinTransaction(enumToValue(CoinTransactionType::Remove), enumToValue(CoinType::Normal), 100, "");

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
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
			eq(acc.getPassword(), std::string { "123456" })
		);
	};

	test("Account::getPassword returns logs error if it fails") = [&injectionFixture] {
		auto [logger, accountRepository] = injectionFixture.get<Logger, AccountRepository>();

		Account acc { 1 };
		accountRepository.failGetPassword = true;
		accountRepository.addAccount("canary@test.com", AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD });

		expect(
			eq(acc.load(), enumToValue(AccountErrors_t::Ok)) and
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
			eq(acc.setAccountType(AccountType::ACCOUNT_TYPE_GAMEMASTER), enumToValue(AccountErrors_t::Ok)) and
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
		expect(eq(std::get<1>(Account { 1 }.getAccountPlayers()), enumToValue(AccountErrors_t::NotInitialized)));
	};

	test("Account::getAccountPlayer returns players") = [&injectionFixture] {
		auto [accountRepository] = injectionFixture.get<AccountRepository>();

		Account acc { 1 };
		accountRepository.addAccount(
			"canary@test.com",
			AccountInfo { 1, 1, 1, AccountType::ACCOUNT_TYPE_GOD, {{ "Canary", 1 }, { "Canary2", 2 }} }
 		);

		expect(acc.load() == enumToValue(AccountErrors_t::Ok));
		auto [players, error] = acc.getAccountPlayers();

		expect(
			eq(error, enumToValue(AccountErrors_t::Ok)) and
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

		expect(acc.load() == enumToValue(AccountErrors_t::Ok));
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

		expect(acc.load() == enumToValue(AccountErrors_t::Ok));
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
