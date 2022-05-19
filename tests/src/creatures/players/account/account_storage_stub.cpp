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

#include "account_storage_stub.hpp"

namespace account
{

/***************************************************************************
 * Account Load/Save
 **************************************************************************/
bool AccountStorageStub::loadAccountByID(const uint32_t& id, AccountInfo& acc)
{
    if (m_forceLoadError) {
        return false;
    }

    acc.id = id;
    acc.premiumRemainingDays = m_account.premiumRemainingDays;
    acc.premiumLastDay = m_account.premiumLastDay;
    acc.accountType = m_account.accountType;
    acc.players = m_account.players;

    return true;
};

bool AccountStorageStub::loadAccountByEMail(
    const std::string& email, AccountInfo& acc)
{
    if (m_forceLoadError) {
        return false;
    }

    acc.id = 122;
    acc.premiumRemainingDays = m_account.premiumRemainingDays;
    acc.premiumLastDay = m_account.premiumLastDay;
    acc.accountType = m_account.accountType;
    acc.players = m_account.players;

    return true;
};

bool AccountStorageStub::saveAccount(const AccountInfo& accInfo)
{
    if (m_forceSaveError) {
        return false;
    }

    m_account.id = accInfo.id;
    m_account.premiumRemainingDays = accInfo.premiumRemainingDays;
    m_account.premiumLastDay = accInfo.premiumLastDay;
    m_account.accountType = accInfo.accountType;
    m_account.players = accInfo.players;

    return true;
};

/***************************************************************************
 * Gets Methods
 **************************************************************************/
bool AccountStorageStub::getPassword(const uint32_t& id, std::string& password)
{
    if (m_forceGetPasswordError) {
        return false;
    }

    password = m_password;
    return true;
};

/***************************************************************************
 * Coins Methods
 **************************************************************************/
bool AccountStorageStub::getCoins(
    const uint32_t& id, const CoinType& type, uint32_t& coins)
{
    if (m_forceGetCoinsError) {
        return false;
    }
    coins = m_coins;
    return true;
};

bool AccountStorageStub::setCoins(
    const uint32_t& id, const CoinType& type, const uint32_t& amount)
{
    if (m_forceSetCoinsError) {
        return false;
    }
    m_coins = amount;
    return true;
};


bool AccountStorageStub::registerCoinsTransaction(const uint32_t& id,
    CoinTransactionType type, uint32_t coins, const CoinType& coinType,
    const std::string& description)
{
    if (m_forceRegisterError) {
        return false;
    }

    return true;
};

} // namespace account
