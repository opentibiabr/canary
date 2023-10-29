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
		auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, 0 AS `expires` FROM `accounts` WHERE `id` = {}", id);
		return load(query, acc);
	};

	bool AccountRepositoryDB::loadByEmailOrName(bool oldProtocol, const std::string &emailOrName, AccountInfo &acc) {
		auto identifier = oldProtocol ? "name" : "email";
		auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, 0 AS `expires` FROM `accounts` WHERE `{}` = {}", identifier, db.escapeString(emailOrName));
		return load(query, acc);
	};

	bool AccountRepositoryDB::loadBySession(const std::string &sessionKey, AccountInfo &acc) {
		auto query = fmt::format(
			"SELECT `accounts`.`id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, `account_sessions`.`expires` "
			"FROM `accounts` "
			"INNER JOIN `account_sessions` ON `account_sessions`.`account_id` = `accounts`.`id` "
			"WHERE `account_sessions`.`id` = {}",
			db.escapeString(transformToSHA1(sessionKey))
		);
		return load(query, acc);
	};

	bool AccountRepositoryDB::save(const AccountInfo &accInfo) {
		bool successful = db.executeQuery(
			fmt::format(
				"UPDATE `accounts` SET `type` = {}, `premdays` = {}, `lastday` = {}, `creation` = {}, `premdays_purchased` = {} WHERE `id` = {}",
				static_cast<uint8_t>(accInfo.accountType),
				accInfo.premiumRemainingDays,
				accInfo.premiumLastDay,
				accInfo.creationTime,
				accInfo.premiumDaysPurchased,
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
				"INSERT INTO `coins_transactions` (`account_id`, `type`, `coin_type`, `amount`, `description`) VALUES ({}, {}, {}, {}, {})",
				id,
				static_cast<uint16_t>(type),
				static_cast<uint8_t>(coinType),
				coins,
				db.escapeString(description)
			)
		);

		if (!successful) {
			logger.error(
				"Error registering coin transaction! account_id:[{}], type:[{}], coin_type:[{}], coins:[{}], description:[{}]",
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
		acc.premiumRemainingDays = result->getNumber<uint32_t>("premdays");
		acc.premiumLastDay = result->getNumber<time_t>("lastday");
		acc.sessionExpires = result->getNumber<time_t>("expires");
		acc.premiumDaysPurchased = result->getNumber<uint32_t>("premdays_purchased");
		acc.creationTime = result->getNumber<uint32_t>("creation");

		setupLoyaltyInfo(acc);

		return loadAccountPlayers(acc);
	}

	void AccountRepositoryDB::setupLoyaltyInfo(account::AccountInfo &acc) {
		if (acc.premiumDaysPurchased >= acc.premiumRemainingDays && acc.creationTime != 0) {
			return;
		}

		if (acc.premiumDaysPurchased < acc.premiumRemainingDays) {
			acc.premiumDaysPurchased = acc.premiumRemainingDays;
		}

		if (acc.creationTime == 0) {
			acc.creationTime = getTimeNow();
		}

		save(acc);
	}

} // namespace account
