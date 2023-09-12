/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2022 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include <cstdint>

namespace account {
	enum Errors : uint8_t {
		ERROR_NO = 0,
		ERROR_STORAGE,
		ERROR_REMOVE_COINS,
		ERROR_INVALID_LAST_DAY,
		ERROR_LOADING_ACCOUNT,
		ERROR_NOT_INITIALIZED
	};

	enum AccountType : uint8_t {
		ACCOUNT_TYPE_NORMAL = 1,
		ACCOUNT_TYPE_TUTOR = 2,
		ACCOUNT_TYPE_SENIORTUTOR = 3,
		ACCOUNT_TYPE_GAMEMASTER = 4,
		ACCOUNT_TYPE_GOD = 5
	};

	enum GroupType : uint8_t {
		GROUP_TYPE_NONE = 0,
		GROUP_TYPE_NORMAL = 1,
		GROUP_TYPE_TUTOR = 2,
		GROUP_TYPE_SENIORTUTOR = 3,
		GROUP_TYPE_GAMEMASTER = 4,
		GROUP_TYPE_COMMUNITYMANAGER = 5,
		GROUP_TYPE_GOD = 6
	};

	enum class CoinTransactionType : uint8_t {
		ADD = 1,
		REMOVE = 2
	};

	enum class CoinType : uint8_t {
		COIN = 1,
		TOURNAMENT = 2,
		TRANSFERABLE = 3
	};

	struct AccountInfo {
		uint32_t id = 0;
		uint32_t premiumRemainingDays = 0;
		time_t premiumLastDay = 0;
		AccountType accountType = ACCOUNT_TYPE_NORMAL;
		phmap::flat_hash_map<std::string, uint64_t> players;
		bool oldProtocol = false;
		time_t sessionExpires = 0;
		uint32_t premiumDaysPurchased = 0;
		uint32_t creationTime = 0;
	};
} // namespace account
