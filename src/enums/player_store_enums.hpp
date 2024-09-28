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

// XML
enum class OfferTypes_t : uint8_t {
	NONE = 0,
	ITEM = 1,
	STACKABLE = 2,
	CHARGES = 3,
	OUTFIT = 4,
	MOUNT = 5,
	NAMECHANGE = 6,
	SEXCHANGE = 7,
	HOUSE = 8,
	EXPBOOST = 9,
	PREYSLOT = 10,
	PREYBONUS = 11,
	TEMPLE = 12,
	BLESSINGS = 13,
	ALLBLESSINGS = 14,
	PREMIUM = 15,
	POUCH = 16,
	INSTANT_REWARD_ACCESS = 17,
	CHARM_EXPANSION = 18,
	HUNTINGSLOT = 19,
	HIRELING = 20,
	HIRELING_NAMECHANGE = 21,
	HIRELING_SEXCHANGE = 22,
	HIRELING_SKILL = 23,
	HIRELING_OUTFIT = 24,
	LOOKTYPE = 25
};

enum class States_t : uint8_t {
	NONE = 0,
	NEW = 1,
	SALE = 2,
	TIMED = 3
};

// Internal
enum class ConverType_t : uint8_t {
	NONE = 0,
	MOUNT = 1,
	LOOKTYPE = 2,
	ITEM = 3,
	OUTFIT = 4
};

enum class SubActions_t : uint8_t {
	PREY_THIRDSLOT_REAL = 0,
	PREY_WILDCARD = 1,
	INSTANT_REWARD = 2,
	BLESSING_TWIST = 3,
	BLESSING_SOLITUDE = 4,
	BLESSING_PHOENIX = 5,
	BLESSING_SUNS = 6,
	BLESSING_SPIRITUAL = 7,
	BLESSING_EMBRACE = 8,
	BLESSING_HEART = 9,
	BLESSING_BLOOD = 10,
	BLESSING_ALL_PVE = 11,
	BLESSING_ALL_PVP = 12,
	CHARM_EXPANSION = 13,
	TASKHUNTING_THIRDSLOT = 14,
	PREY_THIRDSLOT_REDIRECT = 15
};

enum class HistoryTypes_t : uint8_t {
	NONE = 0,
	GIFT = 1,
	REFUND = 2
};

enum class StoreDetailType : uint8_t {
	Finished = 0,
	Created = 1,
};

enum class StoreErrors_t : uint8_t {
	PURCHASE = 0,
	NETWORK = 1,
	HISTORY = 2,
	TRANSFER = 3,
	INFORMATION = 4
};

// Others
enum class ActionType_t : uint8_t {
	OPEN_HOME = 0,
	OPEN_PREMIUM_BOOST = 1,
	OPEN_CATEGORY = 2,
	OPEN_USEFUL_THINGS = 3,
	OPEN_OFFER = 4,
};
