/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */
#pragma once

#include <vector>
#include <string>
#include <utility>

#include "test_injection.hpp"
#include "lib/di/container.hpp"

#include "enums/account_coins.hpp"
#include "account/account_info.hpp"
#include "account/account_repository.hpp"

namespace di = boost::di;

namespace tests {
	class InMemoryAccountRepository : public AccountRepository {
	public:
		static di::extension::injector<> &install(di::extension::injector<> &injector) {
			injector.install(di::bind<AccountRepository>.to<InMemoryAccountRepository>().in(di::singleton));
			return injector;
		}

		void addAccount(const std::string &descriptor, const AccountInfo &acc) {
			phmap::erase_if(accounts, [&](const auto &entry) {
				return entry.second.id == acc.id;
			});
			accounts[descriptor] = acc;
		}

		bool loadByID(const uint32_t &id, std::unique_ptr<AccountInfo> &acc) final {
			for (const auto &account : accounts) {
				if (account.second.id == id) {
					acc = std::make_unique<AccountInfo>(account.second);
					return true;
				}
			}

			return false;
		}

		bool loadByEmailOrName(bool oldProtocol, const std::string &email, std::unique_ptr<AccountInfo> &acc) final {
			auto account = accounts.find(email);

			if (account == accounts.end()) {
				return false;
			}

			acc = std::make_unique<AccountInfo>(account->second);
			return true;
		}

		bool loadBySession(const std::string &sessionKey, std::unique_ptr<AccountInfo> &acc) final {
			auto account = accounts.find(sessionKey);

			if (account == accounts.end()) {
				return false;
			}

			acc = std::make_unique<AccountInfo>(account->second);
			return true;
		}

		bool save(const std::unique_ptr<AccountInfo> &accInfo) final {
			return !failSave;
		}

		bool getPassword(const uint32_t &id, std::string &password) final {
			password = password_;
			return !failGetPassword;
		}

		bool getCoins(const uint32_t &id, CoinType type, uint32_t &coins) final {
			auto accountCoins = coins_.find(id);

			if (accountCoins == coins_.end()) {
				return false;
			}

			auto coinsOfType = accountCoins->second.find(type);

			if (coinsOfType == accountCoins->second.end()) {
				return false;
			}

			coins = coinsOfType->second;
			return true;
		}

		bool setCoins(const uint32_t &id, CoinType type, const uint32_t &amount) final {
			auto accountCoins = coins_.find(id);

			if (accountCoins == coins_.end()) {
				coins_[id] = phmap::flat_hash_map<CoinType, uint32_t>();
			}

			coins_[id][type] = amount;
			return !failAddCoins;
		}

		bool registerCoinsTransaction(
			const uint32_t &id,
			CoinTransactionType type,
			uint32_t coins,
			CoinType coinType,
			const std::string &description
		) final {
			auto accountCoins = coinsTransactions_.find(id);

			if (accountCoins == coinsTransactions_.end()) {
				coinsTransactions_[id] = std::vector<std::tuple<CoinTransactionType, uint32_t, CoinType, std::string>>();
			}

			coinsTransactions_[id].emplace_back(type, coins, coinType, description);
			return true;
		}

		bool getCharacterByAccountIdAndName(const uint32_t &id, const std::string &name) final {
			for (auto it = accounts.begin(); it != accounts.end(); ++it) {
				if (it->second.id == id) {
					if (it->second.players.find(name) != it->second.players.end()) {
						return true;
					}
				}
			}
			return false;
		}

		InMemoryAccountRepository &reset() {
			accounts.clear();
			coins_.clear();
			coinsTransactions_.clear();
			failSave = false;
			failAddCoins = false;
			failGetPassword = false;
			failAuthenticateFromSession = false;
			password_ = "123456";

			return *this;
		}

		bool failSave = false;
		bool failAddCoins = false;
		bool failGetPassword = false;
		bool failAuthenticateFromSession = false;
		std::string password_ = "123456";
		phmap::flat_hash_map<std::string, AccountInfo> accounts;
		phmap::flat_hash_map<uint32_t, phmap::flat_hash_map<CoinType, uint32_t>> coins_;
		phmap::flat_hash_map<uint32_t, std::vector<std::tuple<CoinTransactionType, uint32_t, CoinType, std::string>>> coinsTransactions_;
	};
}

template <>
struct TestInjection<AccountRepository> {
	using type = tests::InMemoryAccountRepository;
};
