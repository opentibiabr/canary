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

#ifndef SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_HPP
#define SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_HPP

#include <climits>
#include <string>
#include <vector>

#include "creatures/players/account/account_defines.hpp"
#include "creatures/players/account/account_storage.hpp"
#include "database/database.h"
#include "database/databasetasks.h"
#include "utils/definitions.h"

namespace account
{

/**
 * @brief Account class to handle account information
 *
 */
class Account
{
public:
    /**
     * @brief Construct a new Account object
     *
     * @param id Account ID
     */
    explicit Account(const uint32_t& id);

    /**
     * @brief Construct a new Account object
     *
     * @param name Account Name/E-Mail
     */
    explicit Account(std::string email);

    /***************************************************************************
     * Interfaces
     **************************************************************************/

    /**
     * @brief Set the Storage Interface used to get and set persisted
     * information.
     *
     * @param account_storage_interface Pointer to storage interface
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t setAccountStorageInterface(
        AccountStorage* account_storage_interface);

    /***************************************************************************
     * Coins Methods
     **************************************************************************/

    /** Coins
     * @brief Get the amount of coins that the account has from database.
     *
     * @param type Type of the coin
     *
     * @return uint32_t Number of coins
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    std::tuple<uint32_t, error_t> getCoins(const CoinType& type) const;

    /**
     * @brief Add coins to the account.
     *
     * @param type Type of the coin
     * @param amount Amount of coins to be added
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t addCoins(const CoinType& type, const uint32_t& amount);

    /**
     * @brief Removes coins from the account.
     *
     * @param type Type of the coin
     * @param amount Amount of coins to be removed
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t removeCoins(const CoinType& type, const uint32_t& amount);

    /***************************************************************************
     * Account Load/Save
     **************************************************************************/

    /**
     * @brief Save Account.
     *
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t saveAccount();

    /**
     * @brief Load Account Information.
     *
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t loadAccount();

    /**
     * @brief Re-Load Account Information to get update information(mainly the
     * players list).
     *
     * @return error_t ERROR_NO(0) Success, otherwise Fail.
     */
    error_t reLoadAccount();


    /***************************************************************************
     * Setters and Getters
     **************************************************************************/

    inline uint32_t getID() const
    {
        return m_account.id;
    };

    inline std::string getEmail()
    {
        return m_email;
    }

    std::string getPassword();

    error_t setPremiumRemainingDays(const uint32_t& days);
    inline uint32_t getPremiumRemainingDays() const
    {
        return m_account.premiumRemainingDays;
    }

    error_t setPremiumLastDay(const time_t& lastDay);
    inline time_t getPremiumLastDay() const
    {
        return m_account.premiumLastDay;
    }

    error_t setAccountType(const AccountType& accountType);
    inline AccountType getAccountType() const
    {
        return m_account.accountType;
    }

    std::tuple<std::map<std::string, uint64_t>, error_t> getAccountPlayers();

private:
    AccountStorage* m_storageInterface = nullptr;
    std::string m_email;
    AccountInfo m_account;
    bool m_accLoaded = false;
};

} // namespace account

#endif // SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_HPP_
