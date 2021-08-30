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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "creatures/players/account/account.hpp"
#include "database/databasetasks.h"

#include <algorithm>
#include <limits>

namespace account
{

Account::Account()
{
    m_id = 0;
    m_email.clear();
    m_password.clear();
    m_premiumRemainingDays = 0;
    m_premiumLastDay = 0;
    m_coinBalance = 0;
    m_tournamentCoinBalance = 0;
    m_accountType = ACCOUNT_TYPE_NORMAL;
    m_db = &Database::getInstance();
    m_dbTasks = &g_databaseTasks;
}

Account::Account(uint32_t id)
{
    m_id = id;
    m_email.clear();
    m_password.clear();
    m_premiumRemainingDays = 0;
    m_premiumLastDay = 0;
    m_coinBalance = 0;
    m_tournamentCoinBalance = 0;
    m_accountType = ACCOUNT_TYPE_NORMAL;
    m_db = &Database::getInstance();
    m_dbTasks = &g_databaseTasks;
}

Account::Account(const std::string& email)
    : m_email(email)
{
    m_id = 0;
    m_password.clear();
    m_premiumRemainingDays = 0;
    m_premiumLastDay = 0;
    m_coinBalance = 0;
    m_tournamentCoinBalance = 0;
    m_accountType = ACCOUNT_TYPE_NORMAL;
    m_db = &Database::getInstance();
    m_dbTasks = &g_databaseTasks;
}


/*******************************************************************************
 * Interfaces
 ******************************************************************************/

error_t Account::setDatabaseInterface(Database* database)
{
    if (database == nullptr) {
        return ERROR_NULLPTR;
    }

    m_db = database;
    return ERROR_NO;
}

error_t Account::setDatabaseTasksInterface(DatabaseTasks* dbTasks)
{
    if (dbTasks == nullptr) {
        return ERROR_NULLPTR;
    }

    m_dbTasks = dbTasks;
    return ERROR_NO;
}


/*******************************************************************************
 * Coins Methods
 ******************************************************************************/

std::tuple<uint32_t, error_t> Account::getCoins()
{

    if (m_db == nullptr || m_id == 0) {
        return std::make_tuple(0, ERROR_NOT_INITIALIZED);
    }

    std::ostringstream query;
    query << "SELECT `coins` FROM `accounts` WHERE `id` = " << m_id;

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return std::make_tuple(0, ERROR_DB);
    }

    return std::make_tuple(result->getNumber<uint32_t>("coins"), ERROR_NO);
}

error_t Account::addCoins(const uint32_t& amount)
{

    if (m_dbTasks == nullptr) {
        return ERROR_NULLPTR;
    }

    if (amount == 0) {
        return ERROR_NO;
    }

    int result = 0;
    uint32_t current_coins = 0;

    if (auto [current_coins, result] = this->getCoins(); ERROR_NO == result) {
        if ((current_coins + amount) < current_coins) {
            return ERROR_VALUE_OVERFLOW;
        }
    } else {
        return ERROR_GET_COINS;
    }

    std::ostringstream query;
    query << "UPDATE `accounts` SET `coins` = " << (current_coins + amount)
          << " WHERE `id` = " << m_id;

    m_dbTasks->addTask(query.str());

    this->registerCoinsTransaction(COIN_ADD, amount, COIN, "");

    return ERROR_NO;
}

error_t Account::removeCoins(const uint32_t& amount)
{

    if (m_dbTasks == nullptr) {
        return ERROR_NULLPTR;
    }

    if (amount == 0) {
        return ERROR_NO;
    }

    int result = 0;
    uint32_t current_coins = 0;

    if (auto [current_coins, result] = this->getCoins(); ERROR_NO == result) {
        if ((current_coins - amount) > current_coins) {
            return ERROR_VALUE_NOT_ENOUGH_COINS;
        }
    } else {
        return ERROR_GET_COINS;
    }

    std::ostringstream query;
    query << "UPDATE `accounts` SET `coins` = " << (current_coins - amount)
          << " WHERE `id` = " << m_id;

    m_dbTasks->addTask(query.str());

    this->registerCoinsTransaction(COIN_REMOVE, amount, COIN, "");

    return ERROR_NO;
}

std::tuple<uint32_t, error_t> Account::getTournamentCoins()
{

    if (m_db == nullptr || m_id == 0) {
        return std::make_tuple(0, ERROR_NOT_INITIALIZED);
    }

    std::ostringstream query;
    query << "SELECT `tournament_coins` FROM `accounts` WHERE `id` = " << m_id;

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return std::make_tuple(0, ERROR_DB);
    }

    return std::make_tuple(
        result->getNumber<uint32_t>("tournament_coins"), ERROR_NO);
}

error_t Account::addTournamentCoins(const uint32_t& amount)
{

    if (m_dbTasks == nullptr) {
        return ERROR_NULLPTR;
    }
    if (amount == 0) {
        return ERROR_NO;
    }

    int result = 0;
    uint32_t current_tournament_coins = 0;

    if (auto [current_tournament_coins, result] = this->getTournamentCoins();
        ERROR_NO == result) {
        if ((current_tournament_coins + amount) < current_tournament_coins) {
            return ERROR_VALUE_OVERFLOW;
        }
    } else {
        return ERROR_GET_COINS;
    }

    std::ostringstream query;
    query << "UPDATE `accounts` SET `tournament_coins` = "
          << (current_tournament_coins + amount) << " WHERE `id` = " << m_id;

    m_dbTasks->addTask(query.str());

    this->registerCoinsTransaction(COIN_ADD, amount, TOURNAMENT, "");

    return ERROR_NO;
}

error_t Account::removeTournamentCoins(const uint32_t& amount)
{

    if (m_dbTasks == nullptr) {
        return ERROR_NULLPTR;
    }

    if (amount == 0) {
        return ERROR_NO;
    }

    int result = 0;
    uint32_t current_tournament_coins = 0;

    if (auto [current_tournament_coins, result] = this->getTournamentCoins();
        ERROR_NO == result) {
        if ((current_tournament_coins - amount) > current_tournament_coins) {
            return ERROR_VALUE_NOT_ENOUGH_COINS;
        }
    } else {
        return ERROR_GET_COINS;
    }

    std::ostringstream query;
    query << "UPDATE `accounts` SET `tournament_coins` = "
          << (current_tournament_coins - amount) << " WHERE `id` = " << m_id;

    m_dbTasks->addTask(query.str());

    this->registerCoinsTransaction(COIN_REMOVE, amount, TOURNAMENT, "");

    return ERROR_NO;
}

error_t Account::registerCoinsTransaction(CoinTransactionType type,
    uint32_t coins, CoinType coinType, const std::string& description)
{

    if (m_db == nullptr) {
        return ERROR_NULLPTR;
    }

    std::ostringstream query;
    query << "INSERT INTO `coins_transactions` (`account_id`, `type`, `amount`,"
             " `coin_type`, `description`) VALUES ("
          << m_id << ", " << static_cast<uint16_t>(type) << ", " << coins << ", "
          << static_cast<uint16_t>(coinType) << ", "
          << m_db->escapeString(description) << ")";

    if (!m_db->executeQuery(query.str())) {
        return ERROR_DB;
    }

    return ERROR_NO;
}

/*******************************************************************************
 * Database
 ******************************************************************************/

error_t Account::loadAccountDB()
{
    if (m_id != 0) {
        return this->loadAccountDB(m_id);
    } else if (!m_email.empty()) {
        return this->loadAccountDB(m_email);
    }

    return ERROR_NOT_INITIALIZED;
}

error_t Account::loadAccountDB(const std::string email)
{
    std::ostringstream query;
    query << "SELECT * FROM `accounts` WHERE `email` = "
          << m_db->escapeString(email);
    return this->loadAccountDB(query);
}

error_t Account::loadAccountDB(uint32_t id)
{
    std::ostringstream query;
    query << "SELECT * FROM `accounts` WHERE `id` = " << id;
    return this->loadAccountDB(query);
}

error_t Account::loadAccountDB(const std::ostringstream& query)
{
    if (m_db == nullptr) {
        return ERROR_NULLPTR;
    }

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return false;
    }

    this->setID(result->getNumber<uint32_t>("id"));
    this->setEmail(result->getString("email"));
    this->setAccountType(
        static_cast<AccountType>(result->getNumber<int32_t>("type")));
    this->setPassword(result->getString("password"));
    this->setPremiumRemaningDays(result->getNumber<uint16_t>("premdays"));
    this->setPremiumLastDay(result->getNumber<time_t>("lastday"));

    return ERROR_NO;
}

std::tuple<Player, error_t> Account::loadAccountPlayerDB(
    const std::string& characterName)
{

    Player player;

    if (m_id == 0) {
        std::make_tuple(player, ERROR_NOT_INITIALIZED);
    }

    std::ostringstream query;
    query << "SELECT `name`, `deletion` FROM `players` WHERE `account_id` = "
          << m_id << " AND `name` = " << m_db->escapeString(characterName)
          << " ORDER BY `name` ASC";

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result || result->getNumber<uint64_t>("deletion") != 0) {
        return std::make_tuple(player, ERROR_PLAYER_NOT_FOUND);
    }

    player.name = result->getString("name");
    player.deletion = result->getNumber<uint64_t>("deletion");

    return std::make_tuple(player, ERROR_NO);
}

std::tuple<std::vector<Player>, error_t> Account::loadAccountPlayersDB()
{

    std::vector<Player> players;

    if (m_id == 0) {
        return std::make_tuple(players, ERROR_NOT_INITIALIZED);
    }

    std::ostringstream query;
    query << "SELECT `name`, `deletion` FROM `players` WHERE `account_id` = "
          << m_id << " ORDER BY `name` ASC";

    DBResult_ptr result = m_db->storeQuery(query.str());
    if (!result) {
        return std::make_tuple(players, ERROR_DB);
    }

    do {
        if (result->getNumber<uint64_t>("deletion") == 0) {
            Player new_player;
            new_player.name = result->getString("name");
            new_player.deletion = result->getNumber<uint64_t>("deletion");
            players.push_back(new_player);
        }
    } while (result->next());
    return std::make_tuple(players, ERROR_NO);
}

error_t Account::saveAccountDB()
{
    std::ostringstream query;

    query << "UPDATE `accounts` SET "
          << "`email` = " << m_db->escapeString(m_email) << " , "
          << "`type` = " << m_accountType << " , "
          << "`password` = " << m_db->escapeString(m_password) << " , "
          << "`coins` = " << m_coinBalance << " , "
          << "`tournament_coins` = " << m_tournamentCoinBalance << " , "
          << "`premdays` = " << m_premiumRemainingDays << " , "
          << "`lastday` = " << m_premiumLastDay;

    if (m_id != 0) {
        query << " WHERE `id` = " << m_id;
    } else if (!m_email.empty()) {
        query << " WHERE `email` = " << m_email;
    }

    if (!m_db->executeQuery(query.str())) {
        return ERROR_DB;
    }

    return ERROR_NO;
}

/*******************************************************************************
 * Setters and Getters
 ******************************************************************************/

error_t Account::setID(const uint32_t &id)
{
    if (id == 0) {
        return ERROR_INVALID_ID;
    }
    m_id = id;
    return ERROR_NO;
}

error_t Account::setEmail(const std::string &email)
{
    if (email.empty()) {
        return ERROR_INVALID_ACCOUNT_EMAIL;
    }
    m_email = email;
    return ERROR_NO;
}

error_t Account::setPassword(const std::string &password)
{
    if (password.empty()) {
        return ERROR_INVALID_ACC_PASSWORD;
    }
    m_password = password;
    return ERROR_NO;
}

error_t Account::setPremiumRemaningDays(const uint32_t &days)
{
    m_premiumRemainingDays = days;
    return ERROR_NO;
}

error_t Account::setPremiumLastDay(const time_t &lastDay)
{
    if (lastDay < 0) {
        return ERROR_INVALID_LAST_DAY;
    }
    m_premiumLastDay = lastDay;
    return ERROR_NO;
}

error_t Account::setAccountType(const AccountType &account_type)
{
    if (account_type > 5) {
        return ERROR_INVALID_ACC_TYPE;
    }
    m_accountType = account_type;
    return ERROR_NO;
}

std::tuple<Player, error_t> Account::getAccountPlayer(
    const std::string& characterName)
{

    Player player;
    int result;
    if (auto [player, result] = this->loadAccountPlayerDB(characterName);
        ERROR_NO == result) {
        return std::make_tuple(player, ERROR_NO);
    }

    return std::make_tuple(player, result);
}


std::tuple<std::vector<Player>, error_t> Account::getAccountPlayers()
{
    std::vector<Player> players;
    int result;
    if (auto [players, result] = this->loadAccountPlayersDB();
        ERROR_NO == result) {
        return std::make_tuple(players, ERROR_NO);
    } else {
        return std::make_tuple(players, result);
    }
}

} // namespace account
