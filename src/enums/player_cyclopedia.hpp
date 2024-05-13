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
	#include <cstdint>
#endif

enum CyclopediaBadge_t : uint8_t {
	ACCOUNT_AGE = 1,
	LOYALTY,
	ACCOUNT_ALL_LEVEL,
	ACCOUNT_ALL_VOCATIONS,
	TOURNAMENT_PARTICIPATION,
	TOURNAMENT_POINTS,
};

enum CyclopediaTitle_t : uint8_t {
	NOTHING = 0,
	GOLD,
	MOUNTS,
	OUTFITS,
	LEVEL,
	HIGHSCORES,
	BESTIARY,
	BOSSTIARY,
	DAILY_REWARD,
	TASK,
	MAP,
	OTHERS,
};

enum Summary_t : uint8_t {
	BOOSTS = 1,
	PREY_SLOTS,
	PREY_WILDCARDS,
	INSTANT_REWARDS,
	CHARM_EXPANSIONS,
	HIRELINGS,
	HIRELING_JOBS,
	HIRELING_OUTFITS,
	HOUSE_ITEMS,
};
