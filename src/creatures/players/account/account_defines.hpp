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

#ifndef SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_DEFINES_HPP_
#define SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_DEFINES_HPP_

#include <cstdint>
#include <map>
#include <string>

namespace account
{

enum Errors : uint8_t {
    ERROR_NO = 0,
    ERROR_STORAGE,
    ERROR_REMOVE_COINS,
    ERROR_INVALID_ACCOUNT_EMAIL,
    ERROR_INVALID_ACC_PASSWORD,
    ERROR_INVALID_ACC_TYPE,
    ERROR_INVALID_ID,
    ERROR_INVALID_LAST_DAY,
    ERROR_LOADING_ACCOUNT,
    ERROR_LOADING_ACCOUNT_PLAYERS,
    ERROR_NOT_INITIALIZED,
    ERROR_NULLPTR,
    ERROR_VALUE_NOT_ENOUGH_COINS,
    ERROR_VALUE_OVERFLOW,
    ERROR_PLAYER_NOT_FOUND
};

enum AccountType : uint8_t {
    ACCOUNT_TYPE_NORMAL = 1,
    ACCOUNT_TYPE_TUTOR = 2,
    ACCOUNT_TYPE_SENIORTUTOR = 3,
    ACCOUNT_TYPE_GAMEMASTER = 4,
    ACCOUNT_TYPE_GOD = 5
};

enum GroupType : uint8_t {
    GROUP_TYPE_NORMAL = 1,
    GROUP_TYPE_TUTOR = 2,
    GROUP_TYPE_SENIORTUTOR = 3,
    GROUP_TYPE_GAMEMASTER = 4,
    GROUP_TYPE_COMMUNITYMANAGER = 5,
    GROUP_TYPE_GOD = 6
};

enum CoinTransactionType : uint8_t { COIN_ADD = 1, COIN_REMOVE = 2 };

enum CoinType : uint8_t { COIN = 1, TOURNAMENT = 2 };

using AccountInfo = struct AccountInfo{
    uint32_t id = 0;
    uint32_t premiumRemainingDays = 0;
    time_t premiumLastDay = 0;
    AccountType accountType = ACCOUNT_TYPE_NORMAL;
    std::map<std::string, uint64_t> players;

#if defined(_MSC_VER)
};
#endif

#if defined(__GNUC__)
} __attribute__((aligned(128)));
#endif


} // namespace account

#endif // SRC_CREATURES_PLAYERS_ACCOUNT_ACCOUNT_DEFINES_HPP_
