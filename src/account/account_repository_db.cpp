/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include "account/account_repository_db.hpp"

#include "database/database.hpp"
#include "enums/account_coins.hpp"
#include "utils/definitions.hpp"
#include "utils/tools.hpp"

AccountRepositoryDB::AccountRepositoryDB() {
	coinTypeToColumn = {
		{ CoinType::Normal, "coins" },
		{ CoinType::Tournament, "coins_tournament" },
		{ CoinType::Transferable, "coins_transferable" }
	};
}

bool AccountRepositoryDB::loadByID(const uint32_t &id, std::unique_ptr<AccountInfo> &acc) {
	auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, 0 AS `expires` FROM `accounts` WHERE `id` = {}", id);
	return load(query, acc);
};

bool AccountRepositoryDB::loadByEmailOrName(bool oldProtocol, const std::string &emailOrName, std::unique_ptr<AccountInfo> &acc) {
	auto identifier = oldProtocol ? "name" : "email";
	auto query = fmt::format("SELECT `id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, 0 AS `expires` FROM `accounts` WHERE `{}` = {}", identifier, g_database().escapeString(emailOrName));
	return load(query, acc);
};

bool AccountRepositoryDB::loadBySession(const std::string &sessionKey, std::unique_ptr<AccountInfo> &acc) {
	auto query = fmt::format(
		"SELECT `accounts`.`id`, `type`, `premdays`, `lastday`, `creation`, `premdays_purchased`, `account_sessions`.`expires` "
		"FROM `accounts` "
		"INNER JOIN `account_sessions` ON `account_sessions`.`account_id` = `accounts`.`id` "
		"WHERE `account_sessions`.`id` = {}",
		g_database().escapeString(transformToSHA1(sessionKey))
	);
	return load(query, acc);
};

bool AccountRepositoryDB::save(const std::unique_ptr<AccountInfo> &accInfo) {
	bool successful = g_database().executeQuery(
		fmt::format(
			"UPDATE `accounts` SET `type` = {}, `premdays` = {}, `lastday` = {}, `creation` = {}, `premdays_purchased` = {}, `house_bid_id` = {} WHERE `id` = {}",
			accInfo->accountType,
			accInfo->premiumRemainingDays,
			accInfo->premiumLastDay,
			accInfo->creationTime,
			accInfo->premiumDaysPurchased,
			accInfo->houseBidId,
			accInfo->id
		)
	);

	if (!successful) {
		g_logger().error("Failed to save account:[{}]", accInfo->id);
	}

	return successful;
};

bool AccountRepositoryDB::getCharacterByAccountIdAndName(const uint32_t &id, const std::string &name) {
	auto result = g_database().storeQuery(fmt::format("SELECT `id` FROM `players` WHERE `account_id` = {} AND `name` = {}", id, g_database().escapeString(name)));
	if (!result) {
		g_logger().error("Failed to get character: [{}] from account: [{}]!", name, id);
		return false;
	}

	return result->countResults() == 1;
}

bool AccountRepositoryDB::getPassword(const uint32_t &id, std::string &password) {
	auto result = g_database().storeQuery(fmt::format("SELECT `password` FROM `accounts` WHERE `id` = {}", id));
	if (!result) {
		g_logger().error("Failed to get account:[{}] password!", id);
		return false;
	}

	password = result->getString("password");
	return true;
};

bool AccountRepositoryDB::getCoins(const uint32_t &id, CoinType coinType, uint32_t &coins) {
	auto it = coinTypeToColumn.find(coinType);
	if (it == coinTypeToColumn.end()) {
		g_logger().error("[{}] invalid coin type:[{}]", __FUNCTION__, coinType);
		return false;
	}

	auto column = it->second;

	const auto result = g_database().storeQuery(fmt::format(
		"SELECT `{}` FROM `accounts` WHERE `id` = {}",
		column,
		id
	));

	if (!result) {
		return false;
	}

	coins = result->getNumber<uint32_t>(column);

	return true;
};

bool AccountRepositoryDB::setCoins(const uint32_t &id, CoinType coinType, const uint32_t &amount) {
	auto it = coinTypeToColumn.find(coinType);
	if (it == coinTypeToColumn.end()) {
		g_logger().error("[{}]: invalid coin type:[{}]", __FUNCTION__, coinType);
		return false;
	}

	auto column = it->second;

	const bool successful = g_database().executeQuery(fmt::format(
		"UPDATE `accounts` SET `{}` = {} WHERE `id` = {}",
		column,
		amount,
		id
	));

	if (!successful) {
		g_logger().error("Error setting account[{}] coins to [{}]", id, amount);
	}

	return successful;
};

bool AccountRepositoryDB::registerCoinsTransaction(
	const uint32_t &id,
	CoinTransactionType type,
	uint32_t coins,
	CoinType coinType,
	const std::string &description
) {
	bool successful = g_database().executeQuery(
		fmt::format(
			"INSERT INTO `coins_transactions` (`account_id`, `type`, `coin_type`, `amount`, `description`) VALUES ({}, {}, {}, {}, {})",
			id,
			type,
			coinType,
			coins,
			g_database().escapeString(description)
		)
	);

	if (!successful) {
		g_logger().error(
			"Error registering coin transaction! account_id:[{}], type:[{}], coin_type:[{}], coins:[{}], description:[{}]",
			id,
			type,
			coinType,
			coins,
			g_database().escapeString(description)
		);
	}

	return successful;
};

bool AccountRepositoryDB::loadAccountPlayers(std::unique_ptr<AccountInfo> &acc) const {
	auto result = g_database().storeQuery(
		fmt::format("SELECT `name`, `deletion` FROM `players` WHERE `account_id` = {} ORDER BY `name` ASC", acc->id)
	);

	if (!result) {
		g_logger().error("Failed to load account[{}] players!", acc->id);
		return false;
	}

	do {
		if (result->getNumber<uint64_t>("deletion") != 0) {
			continue;
		}

		acc->players.try_emplace({ result->getString("name"), result->getNumber<uint64_t>("deletion") });
	} while (result->next());

	return true;
}

bool AccountRepositoryDB::load(const std::string &query, std::unique_ptr<AccountInfo> &acc) {
	auto result = g_database().storeQuery(query);

	if (result == nullptr) {
		return false;
	}

	acc->id = result->getNumber<uint32_t>("id");
	acc->accountType = result->getNumber<AccountType>("type");
	acc->premiumLastDay = result->getNumber<time_t>("lastday");
	acc->sessionExpires = result->getNumber<time_t>("expires");
	acc->premiumDaysPurchased = result->getNumber<uint32_t>("premdays_purchased");
	acc->creationTime = result->getNumber<uint32_t>("creation");
	acc->premiumRemainingDays = acc->premiumLastDay > getTimeNow() ? (acc->premiumLastDay - getTimeNow()) / 86400 : 0;

	setupLoyaltyInfo(acc);

	return loadAccountPlayers(acc);
}

void AccountRepositoryDB::setupLoyaltyInfo(std::unique_ptr<AccountInfo> &acc) {
	if (acc->premiumDaysPurchased >= acc->premiumRemainingDays && acc->creationTime != 0) {
		return;
	}

	if (acc->premiumDaysPurchased < acc->premiumRemainingDays) {
		acc->premiumDaysPurchased = acc->premiumRemainingDays;
	}

	if (acc->creationTime == 0) {
		acc->creationTime = getTimeNow();
	}

	save(acc);
}
