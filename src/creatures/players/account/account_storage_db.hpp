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

#ifndef SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_DB_HPP
#define SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_DB_HPP

#include <vector>

#include "creatures/players/account/account_defines.hpp"
#include "creatures/players/account/account_storage.hpp"
#include "database/database.h"
#include "database/databasetasks.h"
#include "utils/definitions.h"


namespace account
{

/**
 * @brief Account class to handle account information storage
 *
 */
class AccountStorageDB : public AccountStorage
{
public:

    /***************************************************************************
     * Interfaces
     **************************************************************************/
    bool setDatabaseInterface(Database* database);

    /***************************************************************************
     * Account Load/Save
     **************************************************************************/
    bool loadAccountByID(const uint32_t& id, AccountInfo& acc) final;
    bool loadAccountByEMail(const std::string& email, AccountInfo& acc) final;

    bool saveAccount(const AccountInfo& accInfo) final;

    /***************************************************************************
     * Gets Methods
     **************************************************************************/
    bool getPassword(const uint32_t& id, std::string& password) final;

    /***************************************************************************
     * Coins Methods
     **************************************************************************/
    bool getCoins(
        const uint32_t& id, const CoinType& type, uint32_t& coins) final;
    bool setCoins(
        const uint32_t& id, const CoinType& type, const uint32_t& amount) final;
    bool registerCoinsTransaction(const uint32_t& id, CoinTransactionType type,
        uint32_t coins, const CoinType& coinType,
        const std::string& description) final;

private:
    bool loadAccountPlayers(AccountInfo& acc);

    Database* m_db = nullptr;
    DatabaseTasks* m_dbTasks = nullptr;
};

} // namespace account

#endif // SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_STORAGE_DB_HPP
