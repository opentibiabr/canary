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
#include <climits>
#include <utility>


namespace account
{

Account::Account(const uint32_t& id)
{
    m_email.clear();
    m_account.id = id;
    m_account.premiumRemainingDays = 0;
    m_account.premiumLastDay = 0;
    m_account.accountType = ACCOUNT_TYPE_NORMAL;
}

Account::Account(std::string email)
    : m_email(std::move(email))
{
    m_account.id = 0;
    m_account.premiumRemainingDays = 0;
    m_account.premiumLastDay = 0;
    m_account.accountType = ACCOUNT_TYPE_NORMAL;
}

/*******************************************************************************
 * Interfaces
 ******************************************************************************/

error_t Account::setAccountStorageInterface(
    AccountStorage* account_storage_interface)
{
    if (account_storage_interface == nullptr) {
        return ERROR_NULLPTR;
    }

    m_storageInterface = account_storage_interface;
    return ERROR_NO;
}

/*******************************************************************************
 * Account Load/Save
 ******************************************************************************/

error_t Account::loadAccount()
{
    if (m_storageInterface == nullptr) {
        return ERROR_NULLPTR;
    }

    if ((m_account.id != 0 &&
            m_storageInterface->loadAccountByID(m_account.id, m_account)) ||
        (!m_email.empty() &&
            m_storageInterface->loadAccountByEMail(m_email, m_account))) {
        m_accLoaded = true;
    } else {
        m_accLoaded = false;
        return ERROR_LOADING_ACCOUNT;
    }

    return ERROR_NO;
}

error_t Account::reLoadAccount()
{
    if (!m_accLoaded) {
        return ERROR_NOT_INITIALIZED;
    }

    if (m_account.id != 0 &&
        m_storageInterface->loadAccountByID(m_account.id, m_account)) {
        m_accLoaded = true;
    } else {
        m_accLoaded = false;
        return ERROR_LOADING_ACCOUNT;
    }

    return ERROR_NO;
}

error_t Account::saveAccount()
{
    if (!m_accLoaded) {
        return ERROR_NOT_INITIALIZED;
    }

    if (!m_storageInterface->saveAccount(m_account)) {
        return ERROR_STORAGE;
    }

    return ERROR_NO;
}

/*******************************************************************************
 * Coins Methods
 ******************************************************************************/

std::tuple<uint32_t, error_t> Account::getCoins(const CoinType& type) const
{
    if (!m_accLoaded) {
        return { 0, ERROR_NOT_INITIALIZED };
    }

    uint32_t coins = 0;
    if (!m_storageInterface->getCoins(m_account.id, type, coins)) {
        return { 0, ERROR_STORAGE };
    }

    return { coins, ERROR_NO };
}

error_t Account::addCoins(const CoinType& type, const uint32_t& amount)
{

    if (!m_accLoaded) {
        return ERROR_NOT_INITIALIZED;
    }

    if (amount == 0) {
        return ERROR_NO;
    }

    uint32_t coins = 0;
    error_t result = ERROR_NO;
    std::tie(coins, result) = this->getCoins(type);
    if (ERROR_NO != result) {
        return result;
    }

    coins = coins + amount;
    if (!m_storageInterface->setCoins(m_account.id, type, coins)) {
        return ERROR_STORAGE;
    }

    if (!m_storageInterface->registerCoinsTransaction(
            m_account.id, COIN_ADD, amount, COIN, "ADD Coins")) {
        SPDLOG_ERROR(
            "Failed to register transaction: 'account:[{}], transaction "
            "type:[{}], coins:[{}], coin type:[{}], description:[ADD Coins]",
            m_account.id, COIN_ADD, amount, COIN);
    }

    return ERROR_NO;
}

error_t Account::removeCoins(const CoinType& type, const uint32_t& amount)
{
    if (!m_accLoaded) {
        return ERROR_NOT_INITIALIZED;
    }

    if (amount == 0) {
        return ERROR_NO;
    }

    uint32_t coins = 0;
    error_t result = ERROR_NO;
    std::tie(coins, result) = this->getCoins(type);
    if (ERROR_NO != result) {
        return result;
    }

    if (coins < amount) {
        SPDLOG_INFO("Account doesn't have enough coins! current[{}], remove:[{}]",
            coins, amount);
        return ERROR_REMOVE_COINS;
    }

    coins = coins - amount;
    if (!m_storageInterface->setCoins(m_account.id, type, coins)) {
        return ERROR_STORAGE;
    }

    if (!m_storageInterface->registerCoinsTransaction(m_account.id, COIN_REMOVE,
            amount, CoinType::COIN, "REMOVE Coins")) {
        SPDLOG_ERROR(
            "Failed to register transaction: 'account:[{}], transaction "
            "type:[{}], coins:[{}], coin type:[{}], description:[REMOVE Coins]",
            m_account.id, COIN_REMOVE, amount, COIN);
    }

    return ERROR_NO;
}

std::string Account::getPassword()
{
    if (!m_accLoaded) {
        return "";
    }

    std::string password;
    if (!m_storageInterface->getPassword(m_account.id, password)) {
        SPDLOG_ERROR("Failed to get account[{}] password!", m_account.id);
        password.clear();
        return password;
    }

    return password;
}


/*******************************************************************************
 * Setters and Getters
 ******************************************************************************/

error_t Account::setPremiumRemainingDays(const uint32_t& days)
{
    m_account.premiumRemainingDays = days;
    return ERROR_NO;
}

error_t Account::setPremiumLastDay(const time_t& lastDay)
{
    if (lastDay < 0) {
        return ERROR_INVALID_LAST_DAY;
    }
    m_account.premiumLastDay = lastDay;
    return ERROR_NO;
}

error_t Account::setAccountType(const AccountType& accountType)
{
    m_account.accountType = accountType;
    return ERROR_NO;
}

std::tuple<std::map<std::string, uint64_t>, error_t>
Account::getAccountPlayers()
{
    if (!m_accLoaded) {
        return { m_account.players, ERROR_NOT_INITIALIZED };
    }
    return { m_account.players, ERROR_NO };
}

} // namespace account
