/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019-2024 OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#ifndef USE_PRECOMPILED_HEADERS
	#include <parallel_hashmap/phmap.h>
	#include <cstdint>
#endif

#include "enums/account_type.hpp"

struct AccountInfo {
	~AccountInfo() = default;

	uint32_t id = 0;
	uint32_t premiumRemainingDays = 0;
	time_t premiumLastDay = 0;
	AccountType accountType = ACCOUNT_TYPE_NONE;
	phmap::flat_hash_map<std::string, uint64_t> players;
	bool oldProtocol = false;
	time_t sessionExpires = 0;
	uint32_t premiumDaysPurchased = 0;
	uint32_t creationTime = 0;
	uint32_t houseBidId = 0;
};
