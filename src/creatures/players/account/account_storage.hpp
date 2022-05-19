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

#ifndef SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_HPP
#define SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_HPP

#include "creatures/players/account/account_defines.hpp"
#include <vector>


namespace account
{

/**
 * @brief Account class to handle account information storage
 *
 */
class AccountStorage
{
public:
    /***************************************************************************
     * Account Load/Save
     **************************************************************************/
    virtual bool loadAccountByID(const uint32_t& id, AccountInfo& acc) = 0;
    virtual bool loadAccountByEMail(
        const std::string& email, AccountInfo& acc) = 0;

    virtual bool saveAccount(const AccountInfo& accInfo) = 0;

    /***************************************************************************
     * Gets Methods
     **************************************************************************/
    virtual bool getPassword(const uint32_t& id, std::string& password) = 0;

    /***************************************************************************
     * Coins Methods
     **************************************************************************/
    virtual bool getCoins(
        const uint32_t& id, const CoinType& type, uint32_t& coins) = 0;
    virtual bool setCoins(
        const uint32_t& id, const CoinType& type, const uint32_t& amount) = 0;
    virtual bool registerCoinsTransaction(const uint32_t& id,
        CoinTransactionType type, uint32_t coins, const CoinType& coinType,
        const std::string& description) = 0;
};

} // namespace account

#endif // SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_HPP
