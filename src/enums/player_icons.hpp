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

enum class PlayerIcon : uint8_t {
	Poison = 0,
	Burn = 1,
	Energy = 2,
	Drunk = 3,
	ManaShield = 4,
	Paralyze = 5,
	Haste = 6,
	Swords = 7,
	Drowning = 8,
	Freezing = 9,
	Dazzled = 10,
	Cursed = 11,
	PartyBuff = 12,
	RedSwords = 13,
	Pigeon = 14,
	Bleeding = 15,
	LesserHex = 16,
	IntenseHex = 17,
	GreaterHex = 18,
	Rooted = 19,
	Feared = 20,
	GoshnarTaint1 = 21,
	GoshnarTaint2 = 22,
	GoshnarTaint3 = 23,
	GoshnarTaint4 = 24,
	GoshnarTaint5 = 25,
	NewManaShield = 26,
	Agony = 27,
	Powerless = 28,

	// Must always be the last
	Count
};

enum class IconBakragore : uint8_t {
	None = 0,
	Taint1 = 1,
	Taint2 = 2,
	Taint3 = 3,
	Taint4 = 4,
	Taint5 = 5,
	Taint6 = 6,
	Taint7 = 7,
	Taint8 = 8,
	Taint9 = 9,
};
