/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (C) 2021 OpenTibiaBR <opentibiabr@outlook.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <vector>

#include "creatures/players/account/account_storage_db.hpp"

namespace account
{

/***************************************************************************
 * Interfaces
 **************************************************************************/

bool AccountStorageDB::setDatabaseInterface(Database* database)
{
    if (database == nullptr) {
        return false;
    }

    m_db = database;
    return true;
}

/***************************************************************************
 * Account Load/Save
 **************************************************************************/
bool AccountStorageDB::loadAccountByID(const uint32_t& id, AccountInfo& acc)
{
    if (m_db == nullptr) {
        return false;
    }
    std::ostringstream query;
    query << "SELECT * FROM `accounts` WHERE `id` = " << id;

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return false;
    }

    acc.id = id;
    acc.accountType =
        static_cast<AccountType>(result->getNumber<int32_t>("type"));
    acc.premiumRemainingDays = result->getNumber<uint16_t>("premdays");
    acc.premiumLastDay = result->getNumber<time_t>("lastday");

    if (!loadAccountPlayers(acc)) {
        SPDLOG_ERROR("Failed to load account[{}] players!", acc.id);
        return false;
    }

    return true;
};

bool AccountStorageDB::loadAccountByEMail(
    const std::string& email, AccountInfo& acc)
{
    if (m_db == nullptr) {
        return false;
    }

    std::ostringstream query;
    query << "SELECT * FROM `accounts` WHERE `email` = "
          << m_db->escapeString(email);

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return false;
    }

    acc.id = result->getNumber<uint32_t>("id");
    acc.accountType =
        static_cast<AccountType>(result->getNumber<int32_t>("type"));
    acc.premiumRemainingDays = result->getNumber<uint16_t>("premdays");
    acc.premiumLastDay = result->getNumber<time_t>("lastday");

    if (!loadAccountPlayers(acc)) {
        SPDLOG_ERROR("Failed to load account[{}] players!", acc.id);
        return false;
    }

    return true;
};

bool AccountStorageDB::loadAccountPlayers(AccountInfo& acc)
{
    std::ostringstream query;

    query << "SELECT `name`, `deletion` FROM `players` WHERE `account_id` = "
          << acc.id << " ORDER BY `name` ASC";
    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return false;
    }

    do {
        if (result->getNumber<uint64_t>("deletion") == 0) {
            acc.players.insert({ result->getString("name"),
                result->getNumber<uint64_t>("deletion") });
        }
    } while (result->next());

    return true;
}

bool AccountStorageDB::saveAccount(const AccountInfo& accInfo)
{
    if (m_db == nullptr) {
        return false;
    }

    std::ostringstream query;

    query << "UPDATE `accounts` SET "
          << "`type` = " << accInfo.accountType << " , "
          << "`premdays` = " << accInfo.premiumRemainingDays << " , "
          << "`lastday` = " << accInfo.premiumLastDay
          << " WHERE `id` = " << accInfo.id;

    if (!m_db->executeQuery(query.str())) {
        SPDLOG_ERROR("Failed to save account:[{}]", accInfo.id);
        return false;
    }

    return true;
};

/***************************************************************************
 * Gets Methods
 **************************************************************************/
bool AccountStorageDB::getPassword(const uint32_t& id, std::string& password)
{
    if (m_db == nullptr) {
        return false;
    }

    std::ostringstream query;
    query << "SELECT * FROM `accounts` WHERE `id` = " << id;

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        SPDLOG_ERROR("Failed to get account:[{}] password!", id);
        return false;
    }

    password = result->getString("password");
    return true;
};

/***************************************************************************
 * Coins Methods
 **************************************************************************/
bool AccountStorageDB::getCoins(
    const uint32_t& id, const CoinType& type, uint32_t& coins)
{
    if (m_db == nullptr) {
        return false;
    }

    std::ostringstream query;
    query << "SELECT `coins` FROM `accounts` WHERE `id` = " << id;

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return false;
    }

    if (type == COIN) {
        coins = result->getNumber<uint32_t>("coins");
    } else {
        coins = 0;
    }

    return true;
};

bool AccountStorageDB::setCoins(
    const uint32_t& id, const CoinType& type, const uint32_t& amount)
{
    if (m_db == nullptr) {
        return false;
    }

    std::string coin_type;
    if (type == COIN) {
        coin_type = "coins";
    } else {
        coin_type = "";

    }

    std::ostringstream query;
    query << "UPDATE `accounts` SET `"<< coin_type <<"` = " << amount
          << " WHERE `id` = " << id;

    if (!m_db->executeQuery(query.str())) {
        SPDLOG_ERROR("Error setting account[{}] coins to [{}]", id, amount);
        return false;
    }

    return true;
};


bool AccountStorageDB::registerCoinsTransaction(const uint32_t& id,
    CoinTransactionType type, uint32_t coins, const CoinType& coinType,
    const std::string& description)
{
    if (m_db == nullptr) {
        return false;
    }

    std::ostringstream query;
    query << "INSERT INTO `coins_transactions` (`account_id`, "
             "`transaction_type`, `coin_type`, `coins`, `description`) VALUES ("
          << id << ", " << static_cast<uint16_t>(type) << ", " << coins << ", "
          << coinType << ", " << m_db->escapeString(description) << ")";

    if (!m_db->executeQuery(query.str())) {
        SPDLOG_ERROR("Error registering coin transaction! account_id:[{}], "
                     "transaction_type:[{}], coin_type:[{}], coins:[{}], "
                     "description:[{}]",
            id, type, coinType, coins, description);
        return false;
    }

    return true;
};

} // namespace account
