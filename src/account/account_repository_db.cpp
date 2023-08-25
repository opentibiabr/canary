/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "pch.hpp"

#include "account/account_repository_db.hpp"

#include "utils/tools.hpp"

namespace account {
	bool AccountRepositoryDB::loadByID(const uint32_t &id, AccountInfo &acc) {
		auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday` FROM `accounts` WHERE `id` = {}", id);
		return load(query, acc);
	};

	bool AccountRepositoryDB::loadByEmail(const std::string &email, AccountInfo &acc) {
		auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday` FROM `accounts` WHERE `email` = {}", db.escapeString(email));
		return load(query, acc);
	};

	bool AccountRepositoryDB::authenticateFromSession(const std::string &sessionId) {
		auto query = fmt::format("SELECT `account_id`, `expires` FROM `account_sessions` WHERE `id` = ", db.escapeString(transformToSHA1(sessionId)));
		auto result = db.storeQuery(query);

		if (!result) {
			logger.error("Failed to validate session!");
			return false;
		}

		if (result->getNumber<uint64_t>("expires") < getTimeNow()) {
			logger.error("Session expired!");
			return false;
		}

		auto accountId = result->getNumber<uint32_t>("account_id");

		AccountInfo info;
		if (!loadByID(accountId, info)) {
			logger.error("Session found but id {} doesn't match any account!", accountId);
			return false;
		}

		return true;
	};

	bool AccountRepositoryDB::save(const AccountInfo &accInfo) {
		bool successful = db.executeQuery(
			fmt::format(
				"UPDATE `accounts` SET `type` = {}, `premdays` = {}, `lastday` = {} WHERE `id` = {}",
				static_cast<uint8_t>(accInfo.accountType),
				accInfo.premiumRemainingDays,
				accInfo.premiumLastDay,
				accInfo.id
			)
		);

		if (!successful) {
			logger.error("Failed to save account:[{}]", accInfo.id);
		}

		return successful;
	};

	bool AccountRepositoryDB::getPassword(const uint32_t &id, std::string &password) {
		auto result = db.storeQuery(fmt::format("SELECT * FROM `accounts` WHERE `id` = {}", id));
		if (!result) {
			logger.error("Failed to get account:[{}] password!", id);
			return false;
		}

		password = result->getString("password");
		return true;
	};

	bool AccountRepositoryDB::getCoins(const uint32_t &id, const CoinType &type, uint32_t &coins) {
		auto result = db.storeQuery(fmt::format(
			"SELECT `{}` FROM `accounts` WHERE `id` = {}",
			coinTypeToColumn.at(type),
			id
		));

		if (!result) {
			return false;
		}

		coins = result->getNumber<uint32_t>(coinTypeToColumn.at(type));

		return true;
	};

	bool AccountRepositoryDB::setCoins(const uint32_t &id, const CoinType &type, const uint32_t &amount) {
		bool successful = db.executeQuery(fmt::format(
			"UPDATE `accounts` SET `{}` = {} WHERE `id` = {}",
			coinTypeToColumn.at(type),
			amount,
			id
		));

		if (!successful) {
			logger.error("Error setting account[{}] coins to [{}]", id, amount);
		}

		return successful;
	};

	bool AccountRepositoryDB::registerCoinsTransaction(
		const uint32_t &id,
		CoinTransactionType type,
		uint32_t coins,
		const CoinType &coinType,
		const std::string &description
	) {
		bool successful = db.executeQuery(
			fmt::format(
				"INSERT INTO `coins_transactions` (`account_id`, `transaction_type`, `coin_type`, `coins`, `description`) VALUES ({}, {}, {}, {}, {})",
				id,
				static_cast<uint16_t>(type),
				static_cast<uint8_t>(coinType),
				coins,
				db.escapeString(description)
			)
		);

		if (!successful) {
			logger.error(
				"Error registering coin transaction! account_id:[{}], transaction_type:[{}], coin_type:[{}], coins:[{}], description:[{}]",
				id,
				static_cast<uint16_t>(type),
				static_cast<uint8_t>(coinType),
				coins,
				db.escapeString(description)
			);
		}

		return successful;
	};

	bool AccountRepositoryDB::loadAccountPlayers(AccountInfo &acc) {
		auto result = db.storeQuery(
			fmt::format("SELECT `name`, `deletion` FROM `players` WHERE `account_id` = {} ORDER BY `name` ASC", acc.id)
		);

		if (!result) {
			logger.error("Failed to load account[{}] players!", acc.id);
			return false;
		}

		do {
			if (result->getNumber<uint64_t>("deletion") != 0) {
				continue;
			}

			acc.players.try_emplace({ result->getString("name"), result->getNumber<uint64_t>("deletion") });
		} while (result->next());

		return true;
	}

	bool AccountRepositoryDB::load(const std::string &query, AccountInfo &acc) {
		auto result = db.storeQuery(query);

		if (result == nullptr) {
			return false;
		}

		acc.id = result->getNumber<uint32_t>("id");
		acc.accountType = static_cast<AccountType>(result->getNumber<int32_t>("type"));
		acc.premiumRemainingDays = result->getNumber<uint16_t>("premdays");
		acc.premiumLastDay = result->getNumber<time_t>("lastday");

		return loadAccountPlayers(acc);
	}

} // namespace account
