/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "account/account_repository.hpp"
#include "database/database.hpp"
#include "lib/logging/logger.hpp"
#include "utils/definitions.hpp"

namespace account {
	class AccountRepositoryDB final : public AccountRepository {
	public:
		AccountRepositoryDB(Database &db, Logger &logger) :
			db(db), logger(logger) { }

		bool loadByID(const uint32_t &id, AccountInfo &acc) override;
		bool loadByEmailOrName(bool oldProtocol, const std::string &emailOrName, AccountInfo &acc) override;
		bool loadBySession(const std::string &esseionKey, AccountInfo &acc) override;
		bool save(const AccountInfo &accInfo) override;

		bool getPassword(const uint32_t &id, std::string &password) override;

		bool getCoins(const uint32_t &id, const CoinType &type, uint32_t &coins) override;
		bool setCoins(const uint32_t &id, const CoinType &type, const uint32_t &amount) override;
		bool registerCoinsTransaction(
			const uint32_t &id,
			CoinTransactionType type,
			uint32_t coins,
			const CoinType &coinType,
			const std::string &description
		) override;

	private:
		const std::map<CoinType, std::string> coinTypeToColumn = {
			{ CoinType::COIN, "coins" },
			{ CoinType::TOURNAMENT, "tournament_coins" },
			{ CoinType::TRANSFERABLE, "coins_transferable" }
		};
		Database &db;
		Logger &logger;

		bool load(const std::string &query, AccountInfo &acc);
		bool loadAccountPlayers(AccountInfo &acc);
		void setupLoyaltyInfo(AccountInfo &acc);
	};

} // namespace account
