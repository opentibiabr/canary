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

enum class ContainerSpecial_t : uint8_t {
	None = 0,
	LootContainer = 1,
	ContentCounter = 2,
	LootHighlight = 4,
	Obtain = 8,
	Manager = 9,
	QuiverLoot = 11,
};
